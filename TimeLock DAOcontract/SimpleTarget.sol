// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimpleTarget {
    uint256 public value;

    function setValue(uint256 _value) external {
        value = _value;
    }
}