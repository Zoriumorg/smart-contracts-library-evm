// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RandomNumberContract {
    // Function to generate a pseudo-random number
    function generateRandomNumber() public view returns (uint256) {
        // Use block timestamp, sender address, and block number as a seed
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    msg.sender,
                    block.number
                )
            )
        );
        return random;
    }

    // Function to generate a random number within a specific range (e.g., 1 to 100)
    function generateRandomNumberInRange(uint256 min, uint256 max) public view returns (uint256) {
        require(max > min, "Max must be greater than min");
        uint256 random = generateRandomNumber();
        // Modulo to fit within range, then shift to start at min
        return (random % (max - min + 1)) + min;
    }
}