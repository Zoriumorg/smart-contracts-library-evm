// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CrowdsaleContract {
    address public owner;               // Contract deployer
    IERC20 public token;                // ERC20 token being sold
    uint256 public rate;                // Tokens per ETH (e.g., 100 tokens = 1 ETH)
    uint256 public weiRaised;           // Total ETH raised
    bool public saleActive;             // Toggle sale on/off

    event TokensPurchased(address buyer, uint256 amountETH, uint256 amountTokens);

    constructor(address _token, uint256 _rate) {
        owner = msg.sender;
        token = IERC20(_token);
        rate = _rate;
        saleActive = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Buy tokens by sending ETH
    function buyTokens() public payable {
        require(saleActive, "Sale is not active");
        uint256 weiAmount = msg.value;              // Amount of ETH sent
        require(weiAmount > 0, "Send some ETH");

        uint256 tokensToBuy = weiAmount * rate;     // Calculate tokens
        require(token.balanceOf(address(this)) >= tokensToBuy, "Not enough tokens in contract");

        weiRaised += weiAmount;                     // Track ETH raised
        require(token.transfer(msg.sender, tokensToBuy), "Token transfer failed");

        emit TokensPurchased(msg.sender, weiAmount, tokensToBuy);
    }

    // Owner can withdraw ETH
    function withdrawETH() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner).transfer(balance);
    }

    // Owner can toggle sale
    function toggleSale() public onlyOwner {
        saleActive = !saleActive;
    }

    // Owner can recover unsold tokens
    function withdrawTokens() public onlyOwner {
        uint256 remainingTokens = token.balanceOf(address(this));
        require(token.transfer(owner, remainingTokens), "Token withdrawal failed");
    }
}