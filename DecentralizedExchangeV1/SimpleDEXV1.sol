// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleDEXV1 {
    // Token addresses
    IERC20 public tokenA;
    IERC20 public tokenB;

    // Reserves for each token
    uint256 public reserveA;
    uint256 public reserveB;

    // Total liquidity shares
    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;

    // Fee (0.3%)
    uint256 public constant FEE = 3; // 0.3% = 3/1000
    uint256 public constant FEE_DENOMINATOR = 1000;

    // Events
    event Swap(address indexed user, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);
    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB, uint256 liquidity);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB, uint256 liquidity);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // Add liquidity to the pool
    function addLiquidity(uint256 amountA, uint256 amountB) external returns (uint256 liquidityShare) {
        require(amountA > 0 && amountB > 0, "Invalid amounts");

        // Transfer tokens to the contract
        require(tokenA.transferFrom(msg.sender, address(this), amountA), "Token A transfer failed");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "Token B transfer failed");

        // Calculate liquidity shares
        if (totalLiquidity == 0) {
            liquidityShare = sqrt(amountA * amountB); // Initial liquidity
        } else {
            liquidityShare = min(
                (amountA * totalLiquidity) / reserveA,
                (amountB * totalLiquidity) / reserveB
            );
        }

        require(liquidityShare > 0, "Zero liquidity");
        liquidity[msg.sender] += liquidityShare;
        totalLiquidity += liquidityShare;

        // Update reserves
        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityAdded(msg.sender, amountA, amountB, liquidityShare);
    }

    // Remove liquidity from the pool
    function removeLiquidity(uint256 _liquidity) external returns (uint256 amountA, uint256 amountB) {
        require(_liquidity > 0 && liquidity[msg.sender] >= _liquidity, "Insufficient liquidity");

        // Calculate amounts to return
        amountA = (_liquidity * reserveA) / totalLiquidity;
        amountB = (_liquidity * reserveB) / totalLiquidity;

        require(amountA > 0 && amountB > 0, "Zero amounts");

        // Update state
        liquidity[msg.sender] -= _liquidity;
        totalLiquidity -= _liquidity;
        reserveA -= amountA;
        reserveB -= amountB;

        // Transfer tokens back
        require(tokenA.transfer(msg.sender, amountA), "Token A transfer failed");
        require(tokenB.transfer(msg.sender, amountB), "Token B transfer failed");

        emit LiquidityRemoved(msg.sender, amountA, amountB, _liquidity);
    }

    // Swap tokens
    function swap(address tokenIn, uint256 amountIn) external returns (uint256 amountOut) {
        require(amountIn > 0, "Invalid amount");
        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "Invalid token");

        bool isTokenA = tokenIn == address(tokenA);
        (IERC20 tokenInContract, IERC20 tokenOutContract, uint256 reserveIn, uint256 reserveOut) = isTokenA
            ? (tokenA, tokenB, reserveA, reserveB)
            : (tokenB, tokenA, reserveB, reserveA);

        // Transfer input tokens
        require(tokenInContract.transferFrom(msg.sender, address(this), amountIn), "Transfer failed");

        // Calculate amount out with fee (0.3%)
        uint256 amountInWithFee = (amountIn * (FEE_DENOMINATOR - FEE)) / FEE_DENOMINATOR;
        amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);

        require(amountOut > 0, "Insufficient output");

        // Update reserves
        if (isTokenA) {
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            reserveB += amountIn;
            reserveA -= amountOut;
        }

        // Transfer output tokens
        require(tokenOutContract.transfer(msg.sender, amountOut), "Transfer failed");

        emit Swap(msg.sender, tokenIn, amountIn, address(tokenOutContract), amountOut);
    }

    // Helper functions
    function sqrt(uint256 y) private pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }
}