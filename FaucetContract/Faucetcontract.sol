// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FaucetContract {
    address public owner;
    uint256 public withdrawalAmount = 0.1 ether; // Amount to distribute per request
    uint256 public lockTime = 1 days; // Cooldown period between requests
    mapping(address => uint256) public nextAccessTime; // Tracks when a user can request again

    event Withdrawal(address indexed to, uint256 amount);
    event Deposit(address indexed from, uint256 amount);

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
    }

    // Function to allow users to request funds
    function requestTokens() public {
        require(msg.sender != address(0), "Invalid address");
        require(address(this).balance >= withdrawalAmount, "Faucet is out of funds");
        require(block.timestamp >= nextAccessTime[msg.sender], "Cooldown period active");

        // Update the next access time for the user
        nextAccessTime[msg.sender] = block.timestamp + lockTime;

        // Send the funds
        (bool sent, ) = msg.sender.call{value: withdrawalAmount}("");
        require(sent, "Failed to send Ether");

        emit Withdrawal(msg.sender, withdrawalAmount);
    }

    // Function to allow anyone to deposit Ether into the faucet
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        emit Deposit(msg.sender, msg.value);
    }

    // Function for the owner to withdraw all funds (optional safety feature)
    function withdrawAll() public {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = address(this).balance;
        (bool sent, ) = owner.call{value: balance}("");
        require(sent, "Failed to withdraw Ether");
    }

    // Fallback function to accept Ether deposits
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Function to check contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}