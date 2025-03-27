// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityDonationContract {
    address public owner;                    // Contract creator/owner
    uint256 public totalDonations;          // Track total donations received
    mapping(address => uint256) public donations;  // Track individual donations
    
    // Events for logging activities
    event DonationReceived(address indexed donor, uint256 amount);
    event FundsDistributed(address indexed recipient, uint256 amount);
    
    // Constructor sets the deployer as owner
    constructor() {
        owner = msg.sender;
    }
    
    // Modifier to restrict access to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    // Function to receive donations
    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;
        
        emit DonationReceived(msg.sender, msg.value);
    }
    
    // Function to distribute funds to a recipient
    function distributeFunds(address payable recipient, uint256 amount) 
        public onlyOwner {
        require(amount <= address(this).balance, "Insufficient contract balance");
        
        recipient.transfer(amount);
        emit FundsDistributed(recipient, amount);
    }
    
    // Function to check contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // Function to allow owner to withdraw remaining funds
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner).transfer(balance);
    }
    
    // Fallback function to receive Ether
    receive() external payable {
        donate();
    }
}