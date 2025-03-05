// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockContract {
    address public owner;           // The contract deployer
    address public beneficiary;     // Who can withdraw the funds
    uint256 public releaseTime;     // Timestamp when funds can be released
    uint256 public lockedAmount;    // Amount of Ether locked

    // Events for logging
    event FundsLocked(address indexed sender, uint256 amount, uint256 releaseTime);
    event FundsWithdrawn(address indexed beneficiary, uint256 amount);

    // Constructor to set beneficiary and release time
    constructor(address _beneficiary, uint256 _releaseTime) payable {
        require(_beneficiary != address(0), "Beneficiary cannot be zero address");
        require(_releaseTime > block.timestamp, "Release time must be in the future");
        require(msg.value > 0, "Must send some Ether to lock");

        owner = msg.sender;
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
        lockedAmount = msg.value;

        emit FundsLocked(msg.sender, msg.value, _releaseTime);
    }

    // Function to withdraw funds after release time
    function withdraw() external {
        require(msg.sender == beneficiary, "Only beneficiary can withdraw");
        require(block.timestamp >= releaseTime, "Funds are still locked");
        require(lockedAmount > 0, "No funds to withdraw");

        uint256 amount = lockedAmount;
        lockedAmount = 0; // Prevent re-entrancy

        (bool success, ) = beneficiary.call{value: amount}("");
        require(success, "Withdrawal failed");

        emit FundsWithdrawn(beneficiary, amount);
    }

    // Function to check contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Function to check remaining time
    function timeRemaining() public view returns (uint256) {
        if (block.timestamp >= releaseTime) {
            return 0;
        }
        return releaseTime - block.timestamp;
    }
}