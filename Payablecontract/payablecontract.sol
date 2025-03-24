// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PayableContract {
    address payable public owner;
    mapping(address => uint256) public balances;
    
    event Deposit(address indexed sender, uint256 amount, uint256 timestamp);
    event Withdrawal(address indexed receiver, uint256 amount, uint256 timestamp);
    
    // Constructor is NOT payable, no Ether accepted during deployment
    constructor() {
        owner = payable(msg.sender);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    // Fallback function to receive Ether after deployment
    receive() external payable {
        deposit();
    }
    
    // Function to deposit Ether after deployment
    function deposit() public payable {
        require(msg.value > 0, "Must send some Ether");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }
    
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds to withdraw");
        
        (bool sent, ) = owner.call{value: contractBalance}("");
        require(sent, "Failed to send Ether");
        
        emit Withdrawal(owner, contractBalance, block.timestamp);
    }
    
    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}