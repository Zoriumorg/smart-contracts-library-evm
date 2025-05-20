// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract TimestampHelper {
    // Returns the current block timestamp
    function getCurrentTimestamp() public view returns (uint256) {
        return block.timestamp;
    }
}