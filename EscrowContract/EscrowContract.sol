// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EscrowContract {
    // State variables
    address public buyer;
    address public seller;
    address public arbiter; // Trusted third party for dispute resolution
    uint256 public amount;
    bool public fundsDeposited = false;
    bool public transactionCompleted = false;
    bool public refundRequested = false;

    // Events
    event FundsDeposited(address indexed buyer, uint256 amount);
    event FundsReleased(address indexed seller, uint256 amount);
    event RefundRequested(address indexed buyer);
    event RefundApproved(address indexed arbiter);
    event DisputeResolved(address indexed resolver, bool releasedToSeller);

    // Modifiers
    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this function");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Only arbiter can call this function");
        _;
    }

    modifier onlyWhenNotCompleted() {
        require(!transactionCompleted, "Transaction already completed");
        _;
    }

    // Constructor to set initial parties
    constructor(address _seller, address _arbiter) {
        buyer = msg.sender; // The deployer is the buyer
        seller = _seller;
        arbiter = _arbiter;
    }

    // Buyer deposits funds into escrow
    function deposit() external payable onlyBuyer onlyWhenNotCompleted {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        require(!fundsDeposited, "Funds already deposited");
        
        amount = msg.value;
        fundsDeposited = true;
        emit FundsDeposited(msg.sender, msg.value);
    }

    // Buyer confirms delivery and releases funds to seller
    function releaseFunds() external onlyBuyer onlyWhenNotCompleted {
        require(fundsDeposited, "No funds to release");
        
        transactionCompleted = true;
        payable(seller).transfer(amount);
        emit FundsReleased(seller, amount);
    }

    // Buyer requests a refund
    function requestRefund() external onlyBuyer onlyWhenNotCompleted {
        require(fundsDeposited, "No funds to refund");
        refundRequested = true;
        emit RefundRequested(msg.sender);
    }

    // Arbiter resolves dispute (can release to seller or refund to buyer)
    function resolveDispute(bool _releaseToSeller) external onlyArbiter onlyWhenNotCompleted {
        require(fundsDeposited, "No funds to resolve");
        require(refundRequested, "Refund not requested");
        
        transactionCompleted = true;
        if (_releaseToSeller) {
            payable(seller).transfer(amount);
            emit FundsReleased(seller, amount);
        } else {
            payable(buyer).transfer(amount);
            emit RefundApproved(msg.sender);
        }
        emit DisputeResolved(msg.sender, _releaseToSeller);
    }

    // Get contract balance (for testing)
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}