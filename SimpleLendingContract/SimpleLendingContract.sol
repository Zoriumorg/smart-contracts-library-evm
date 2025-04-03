// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLendingContract {
    // State variables
    address public lender;
    address public borrower;
    uint256 public amount;          // Amount in wei
    uint256 public deadline;       // Timestamp for repayment deadline
    bool public isRepaid;          // Track repayment status
    bool public isFunded;          // Track if loan is funded
    
    // Events
    event LoanFunded(address indexed lender, address indexed borrower, uint256 amount);
    event LoanRepaid(address indexed borrower, uint256 amount);
    event FundsWithdrawn(address indexed lender, uint256 amount);
    
    // Modifiers
    modifier onlyLender() {
        require(msg.sender == lender, "Only lender can call this function");
        _;
    }
    
    modifier onlyBorrower() {
        require(msg.sender == borrower, "Only borrower can call this function");
        _;
    }
    
    // Constructor - Initialize loan terms
    constructor(address _borrower, uint256 _daysUntilDeadline) {
        lender = msg.sender;
        borrower = _borrower;
        deadline = block.timestamp + (_daysUntilDeadline * 1 days);
        isRepaid = false;
        isFunded = false;
    }
    
    // Lender funds the loan
    function fundLoan() external payable onlyLender {
        require(!isFunded, "Loan already funded");
        require(msg.value > 0, "Must send some Ether");
        
        amount = msg.value;
        isFunded = true;
        
        emit LoanFunded(lender, borrower, amount);
    }
    
    // Borrower repays the loan
    function repayLoan() external payable onlyBorrower {
        require(isFunded, "Loan not yet funded");
        require(!isRepaid, "Loan already repaid");
        require(msg.value >= amount, "Insufficient repayment amount");
        require(block.timestamp <= deadline, "Repayment deadline passed");
        
        isRepaid = true;
        
        emit LoanRepaid(borrower, amount);
    }
    
    // Lender withdraws funds after repayment
    function withdrawFunds() external onlyLender {
        require(isRepaid, "Loan not yet repaid");
        
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        (bool sent, ) = lender.call{value: balance}("");
        require(sent, "Failed to send Ether");
        
        emit FundsWithdrawn(lender, balance);
    }
    
    // View function to check contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // View function to check remaining time
    function getTimeRemaining() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }
}