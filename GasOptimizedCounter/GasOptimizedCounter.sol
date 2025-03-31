// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasOptimizedCounter {
    uint256 public count;  // Counter variable, default visibility is public
    
    // Event to track count changes
    event CountChanged(uint256 newCount);
    
    // Constructor initializes count to 0
    constructor() {
        count = 0;
    }
    
    // Increment function with gas optimization
    function increment() external {
        unchecked {
            count += 1;
        }
        emit CountChanged(count);
    }
    
    // Decrement function with gas optimization
    function decrement() external {
        unchecked {
            require(count > 0, "Counter cannot be negative");
            count -= 1;
        }
        emit CountChanged(count);
    }
    
    // Get current count (automatically generated getter due to public variable)
    // function getCount() external view returns (uint256) {
    //     return count;
    // }
}