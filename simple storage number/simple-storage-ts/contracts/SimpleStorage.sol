// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 public storedNumber; // This is the "box" that holds a number

    function setNumber(uint256 _number) public { // This lets you put a new number in the box
        storedNumber = _number;
    }

    function getNumber() public view returns (uint256) { // This shows you the number in the box
        return storedNumber;
    }
}