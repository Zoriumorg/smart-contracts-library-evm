// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSwapContract is Ownable {
    // State variables
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public exchangeRate; // How many tokenB per tokenA (with 18 decimals)
    bool public swapEnabled;
    
    // Events
    event TokensSwapped(
        address indexed user,
        address indexed fromToken,
        address indexed toToken,
        uint256 amountIn,
        uint256 amountOut
    );
    
    event ExchangeRateUpdated(uint256 newRate);
    event SwapStatusChanged(bool enabled);

    // Constructor
    constructor(
        address _tokenA,
        address _tokenB,
        uint256 _exchangeRate,
        address initialOwner
    ) Ownable(initialOwner) {
        require(_tokenA != address(0), "TokenA address cannot be zero");
        require(_tokenB != address(0), "TokenB address cannot be zero");
        require(_exchangeRate > 0, "Exchange rate must be greater than 0");
        
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        exchangeRate = _exchangeRate;
        swapEnabled = true;
    }

    // Swap tokenA for tokenB
    function swapTokenAtoB(uint256 amountIn) external {
        require(swapEnabled, "Swapping is disabled");
        require(amountIn > 0, "Amount must be greater than 0");
        
        // Calculate amount out based on exchange rate
        uint256 amountOut = (amountIn * exchangeRate) / 1e18;
        require(amountOut > 0, "Output amount too small");
        
        // Check contract balance
        require(tokenB.balanceOf(address(this)) >= amountOut, "Insufficient contract balance");
        
        // Transfer tokenA from user to contract
        require(
            tokenA.transferFrom(msg.sender, address(this), amountIn),
            "Transfer of tokenA failed"
        );
        
        // Transfer tokenB to user
        require(
            tokenB.transfer(msg.sender, amountOut),
            "Transfer of tokenB failed"
        );
        
        emit TokensSwapped(msg.sender, address(tokenA), address(tokenB), amountIn, amountOut);
    }

    // Swap tokenB for tokenA
    function swapTokenBtoA(uint256 amountIn) external {
        require(swapEnabled, "Swapping is disabled");
        require(amountIn > 0, "Amount must be greater than 0");
        
        // Calculate amount out based on exchange rate
        uint256 amountOut = (amountIn * 1e18) / exchangeRate;
        require(amountOut > 0, "Output amount too small");
        
        // Check contract balance
        require(tokenA.balanceOf(address(this)) >= amountOut, "Insufficient contract balance");
        
        // Transfer tokenB from user to contract
        require(
            tokenB.transferFrom(msg.sender, address(this), amountIn),
            "Transfer of tokenB failed"
        );
        
        // Transfer tokenA to user
        require(
            tokenA.transfer(msg.sender, amountOut),
            "Transfer of tokenA failed"
        );
        
        emit TokensSwapped(msg.sender, address(tokenB), address(tokenA), amountIn, amountOut);
    }

    // Owner functions
    function setExchangeRate(uint256 newRate) external onlyOwner {
        require(newRate > 0, "Rate must be greater than 0");
        exchangeRate = newRate;
        emit ExchangeRateUpdated(newRate);
    }

    function toggleSwapEnabled() external onlyOwner {
        swapEnabled = !swapEnabled;
        emit SwapStatusChanged(swapEnabled);
    }

    function withdrawTokens(address token, uint256 amount) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be greater than 0");
        require(IERC20(token).transfer(msg.sender, amount), "Withdrawal failed");
    }
}