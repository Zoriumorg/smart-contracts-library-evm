// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract AMMPriceCalculator {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint256 public reserve0;
    uint256 public reserve1;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    // Update reserves
    function updateReserves(uint256 _reserve0, uint256 _reserve1) external {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    // Calculate price of token0 in terms of token1
    function getPriceToken0() external view returns (uint256) {
        require(reserve0 > 0 && reserve1 > 0, "Insufficient liquidity");
        // Price = reserve1 / reserve0
        return (reserve1 * 1e18) / reserve0;
    }

    // Calculate price of token1 in terms of token0
    function getPriceToken1() external view returns (uint256) {
        require(reserve0 > 0 && reserve1 > 0, "Insufficient liquidity");
        // Price = reserve0 / reserve1
        return (reserve0 * 1e18) / reserve1;
    }

    // Calculate amount out for a given amount in (with 0.3% fee)
    function getAmountOut(address _tokenIn, uint256 _amountIn) external view returns (uint256 amountOut) {
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "Invalid token");
        require(reserve0 > 0 && reserve1 > 0, "Insufficient liquidity");

        bool isToken0 = _tokenIn == address(token0);
        (uint256 reserveIn, uint256 reserveOut) = isToken0 ? (reserve0, reserve1) : (reserve1, reserve0);

        // Apply 0.3% fee
        uint256 amountInWithFee = (_amountIn * 997) / 1000;
        // Constant product formula: (reserveIn + amountInWithFee) * reserveOut = k
        amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);
    }

    // Calculate amount in required for a desired amount out (with 0.3% fee)
    function getAmountIn(address _tokenOut, uint256 _amountOut) external view returns (uint256 amountIn) {
        require(_tokenOut == address(token0) || _tokenOut == address(token1), "Invalid token");
        require(reserve0 > 0 && reserve1 > 0, "Insufficient liquidity");

        bool isTokenOut0 = _tokenOut == address(token0);
        (uint256 reserveIn, uint256 reserveOut) = isTokenOut0 ? (reserve1, reserve0) : (reserve0, reserve1);

        // Constant product formula rearranged to solve for amountIn
        // amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee)
        // Apply 0.3% fee backwards
        uint256 numerator = reserveIn * _amountOut * 1000;
        uint256 denominator = (reserveOut - _amountOut) * 997;
        amountIn = (numerator / denominator) + 1; // Ceiling to ensure sufficient input
    }
}