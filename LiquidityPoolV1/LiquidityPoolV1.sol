// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

/**
 * @title LiquidityPoolV1
 * @dev A Uniswap V2-style AMM liquidity pool for a pair of ERC-20 tokens.
 * Supports adding/removing liquidity and swapping tokens with a configurable fee.
 */
contract LiquidityPoolV1 is ReentrancyGuard {
    using Math for uint256;

    // Immutable token addresses (sorted: token0 < token1)
    address public immutable token0;
    address public immutable token1;

    // Pool reserves
    uint256 public reserve0;
    uint256 public reserve1;

    // Liquidity token supply and balances
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    // Trading fee (0.3% = 30 basis points)
    uint256 public fee = 30; // 30/10000 = 0.3%
    uint256 public constant FEE_DENOMINATOR = 10000;

    // Maximum price impact for swaps (e.g., 10%)
    uint256 public constant MAX_PRICE_IMPACT = 1000; // 1000/10000 = 10%

    // Events
    event LiquidityAdded(
        address indexed provider,
        uint256 amount0,
        uint256 amount1,
        uint256 liquidity
    );
    event LiquidityRemoved(
        address indexed provider,
        uint256 amount0,
        uint256 amount1,
        uint256 liquidity
    );
    event Swap(
        address indexed user,
        address indexed tokenIn,
        uint256 amountIn,
        address indexed tokenOut,
        uint256 amountOut
    );
    event FeeUpdated(uint256 oldFee, uint256 newFee);

    /**
     * @dev Constructor sorts tokens and initializes the pool.
     * @param _tokenA First token address.
     * @param _tokenB Second token address.
     */
    constructor(address _tokenA, address _tokenB) {
        require(_tokenA != _tokenB, "Tokens must be different");
        require(_tokenA != address(0) && _tokenB != address(0), "Invalid token address");

        // Sort tokens: token0 < token1
        (token0, token1) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA);
    }

    /**
     * @dev Adds liquidity to the pool.
     * @param amount0Desired Amount of token0 to add.
     * @param amount1Desired Amount of token1 to add.
     * @return liquidity Number of liquidity tokens minted.
     */
    function addLiquidity(
        uint256 amount0Desired,
        uint256 amount1Desired
    ) external nonReentrant returns (uint256 liquidity) {
        require(amount0Desired > 0 && amount1Desired > 0, "Invalid amounts");

        // Adjust amounts to maintain pool ratio
        (uint256 amount0, uint256 amount1) = _calculateLiquidityAmounts(
            amount0Desired,
            amount1Desired
        );

        // Transfer tokens to the contract
        _safeTransferFrom(token0, msg.sender, address(this), amount0);
        _safeTransferFrom(token1, msg.sender, address(this), amount1);

        // Calculate liquidity tokens
        if (totalSupply == 0) {
            liquidity = Math.sqrt(amount0 * amount1); // Initial liquidity
            require(liquidity >= 1000, "Initial liquidity too low"); // Prevent dust attacks
        } else {
            liquidity = Math.min(
                (amount0 * totalSupply) / reserve0,
                (amount1 * totalSupply) / reserve1
            );
        }
        require(liquidity > 0, "Insufficient liquidity minted");

        // Update state
        balanceOf[msg.sender] += liquidity;
        totalSupply += liquidity;
        _updateReserves(amount0, amount1, true);

        emit LiquidityAdded(msg.sender, amount0, amount1, liquidity);
        return liquidity;
    }

    /**
     * @dev Removes liquidity from the pool.
     * @param liquidity Amount of liquidity tokens to burn.
     * @return amount0 Amount of token0 withdrawn.
     * @return amount1 Amount of token1 withdrawn.
     */
    function removeLiquidity(
        uint256 liquidity
    ) external nonReentrant returns (uint256 amount0, uint256 amount1) {
        require(liquidity > 0 && balanceOf[msg.sender] >= liquidity, "Insufficient liquidity");

        // Calculate token amounts
        amount0 = (liquidity * reserve0) / totalSupply;
        amount1 = (liquidity * reserve1) / totalSupply;
        require(amount0 > 0 && amount1 > 0, "Invalid amounts");

        // Update state
        balanceOf[msg.sender] -= liquidity;
        totalSupply -= liquidity;
        _updateReserves(amount0, amount1, false);

        // Transfer tokens back
        _safeTransfer(token0, msg.sender, amount0);
        _safeTransfer(token1, msg.sender, amount1);

        emit LiquidityRemoved(msg.sender, amount0, amount1, liquidity);
        return (amount0, amount1);
    }

    /**
     * @dev Swaps tokens with slippage and price impact protection.
     * @param tokenIn Input token address.
     * @param amountIn Input token amount.
     * @param minAmountOut Minimum output amount (slippage protection).
     * @return amountOut Output token amount.
     */
    function swap(
        address tokenIn,
        uint256 amountIn,
        uint256 minAmountOut
    ) external nonReentrant returns (uint256 amountOut) {
        require(tokenIn == token0 || tokenIn == token1, "Invalid token");
        require(amountIn > 0, "Invalid amount");

        bool isToken0 = tokenIn == token0;
        (uint256 reserveIn, uint256 reserveOut, address tokenOut) = isToken0
            ? (reserve0, reserve1, token1)
            : (reserve1, reserve0, token0);

        // Calculate amountOut with fee
        amountOut = getAmountOut(amountIn, reserveIn, reserveOut);
        require(amountOut >= minAmountOut, "Slippage too high");

        // Check price impact
        uint256 priceImpact = (amountIn * FEE_DENOMINATOR) / reserveIn;
        require(priceImpact <= MAX_PRICE_IMPACT, "Price impact too high");

        // Transfer tokens
        _safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
        _safeTransfer(tokenOut, msg.sender, amountOut);

        // Update reserves
        if (isToken0) {
            _updateReserves(amountIn, amountOut, true);
        } else {
            _updateReserves(amountOut, amountIn, false);
        }

        emit Swap(msg.sender, tokenIn, amountIn, tokenOut, amountOut);
        return amountOut;
    }

    /**
     * @dev Returns the current reserves.
     * @return reserveA Reserve of token0.
     * @return reserveB Reserve of token1.
     */
    function getReserves() external view returns (uint256 reserveA, uint256 reserveB) {
        return (reserve0, reserve1);
    }

    /**
     * @dev Calculates output amount for a swap.
     * @param amountIn Input amount.
     * @param reserveIn Input reserve.
     * @param reserveOut Output reserve.
     * @return amountOut Output amount.
     */
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) public view returns (uint256 amountOut) {
        require(amountIn > 0 && reserveIn > 0 && reserveOut > 0, "Invalid reserves");
        uint256 amountInWithFee = amountIn * (FEE_DENOMINATOR - fee);
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = (reserveIn * FEE_DENOMINATOR) + amountInWithFee;
        return numerator / denominator;
    }

    /**
     * @dev Updates the fee (only callable by admin in a real implementation).
     * @param newFee New fee in basis points (e.g., 30 = 0.3%).
     */
    function setFee(uint256 newFee) external {
        // In a real implementation, add admin control (e.g., Ownable)
        require(newFee <= 100, "Fee too high"); // Max 1%
        uint256 oldFee = fee;
        fee = newFee;
        emit FeeUpdated(oldFee, newFee);
    }

    /**
     * @dev Calculates liquidity amounts to maintain pool ratio.
     */
    function _calculateLiquidityAmounts(
        uint256 amount0Desired,
        uint256 amount1Desired
    ) private view returns (uint256 amount0, uint256 amount1) {
        if (reserve0 == 0 && reserve1 == 0) {
            return (amount0Desired, amount1Desired);
        }

        uint256 amount1Optimal = (amount0Desired * reserve1) / reserve0;
        if (amount1Optimal <= amount1Desired) {
            return (amount0Desired, amount1Optimal);
        } else {
            uint256 amount0Optimal = (amount1Desired * reserve0) / reserve1;
            return (amount0Optimal, amount1Desired);
        }
    }

    /**
     * @dev Updates reserves.
     * @param amount0 Amount of token0 to add/remove.
     * @param amount1 Amount of token1 to add/remove.
     * @param isAdd True if adding, false if removing.
     */
    function _updateReserves(uint256 amount0, uint256 amount1, bool isAdd) private {
        if (isAdd) {
            reserve0 += amount0;
            reserve1 += amount1;
        } else {
            reserve0 -= amount0;
            reserve1 -= amount1;
        }
    }

    /**
     * @dev Safe token transferFrom.
     */
    function _safeTransferFrom(address token, address from, address to, uint256 amount) private {
        bool success = IERC20(token).transferFrom(from, to, amount);
        require(success, "TransferFrom failed");
    }

    /**
     * @dev Safe token transfer.
     */
    function _safeTransfer(address token, address to, uint256 amount) private {
        bool success = IERC20(token).transfer(to, amount);
        require(success, "Transfer failed");
    }
}