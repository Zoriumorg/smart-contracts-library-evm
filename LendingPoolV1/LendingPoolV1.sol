// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LendingPoolV1 {
    IERC20 public token;
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public borrows;
    uint256 public totalDeposits;

    event Deposited(address indexed user, uint256 amount);
    event Borrowed(address indexed user, uint256 amount);
    event Repaid(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        deposits[msg.sender] += amount;
        totalDeposits += amount;
        emit Deposited(msg.sender, amount);
    }

    function borrow(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= totalDeposits, "Insufficient liquidity");
        require(token.transfer(msg.sender, amount), "Transfer failed");
        borrows[msg.sender] += amount;
        totalDeposits -= amount;
        emit Borrowed(msg.sender, amount);
    }

    function repay(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(borrows[msg.sender] >= amount, "Repay amount exceeds borrow");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        borrows[msg.sender] -= amount;
        totalDeposits += amount;
        emit Repaid(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(deposits[msg.sender] >= amount, "Insufficient deposit");
        require(totalDeposits >= amount, "Insufficient liquidity");
        deposits[msg.sender] -= amount;
        totalDeposits -= amount;
        require(token.transfer(msg.sender, amount), "Transfer failed");
        emit Withdrawn(msg.sender, amount);
    }

    function getUserBalance(address user) external view returns (uint256 deposit, uint256 borrow) {
        return (deposits[user], borrows[user]);
    }
}