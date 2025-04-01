// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdvancedGasOptimizedCounter {
    // State variables
    address public owner;                    // Contract owner
    bool public paused;                      // Pause state
    uint256 public totalCount;               // Global counter
    mapping(address => uint256) public userCounts;  // User-specific counters
    
    // Events
    event CountChanged(address indexed user, uint256 newCount, uint256 totalCount);
    event Paused(address indexed owner);
    event Unpaused(address indexed owner);
    event Reset(address indexed owner);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract paused");
        _;
    }

    // Constructor
    constructor() {
        owner = msg.sender;
        paused = false;
        totalCount = 0;
    }

    // Increment user's counter by 1
    function increment() external whenNotPaused {
        unchecked {
            userCounts[msg.sender] += 1;
            totalCount += 1;
        }
        emit CountChanged(msg.sender, userCounts[msg.sender], totalCount);
    }

    // Increment user's counter by a custom amount
    function incrementBy(uint256 amount) external whenNotPaused {
        require(amount > 0, "Amount must be positive");
        unchecked {
            userCounts[msg.sender] += amount;
            totalCount += amount;
        }
        emit CountChanged(msg.sender, userCounts[msg.sender], totalCount);
    }

    // Decrement user's counter by 1
    function decrement() external whenNotPaused {
        unchecked {
            require(userCounts[msg.sender] > 0, "User count cannot be negative");
            userCounts[msg.sender] -= 1;
            totalCount -= 1;
        }
        emit CountChanged(msg.sender, userCounts[msg.sender], totalCount);
    }

    // Owner-only: Reset all counters
    function resetAll() external onlyOwner {
        totalCount = 0;
        // Note: Mapping reset requires off-chain tracking or a list of users
        emit Reset(msg.sender);
    }

    // Owner-only: Pause the contract
    function pause() external onlyOwner {
        require(!paused, "Already paused");
        paused = true;
        emit Paused(msg.sender);
    }

    // Owner-only: Unpause the contract
    function unpause() external onlyOwner {
        require(paused, "Not paused");
        paused = false;
        emit Unpaused(msg.sender);
    }

    // View user's count (explicit getter for clarity)
    function getUserCount(address user) external view returns (uint256) {
        return userCounts[user];
    }
}