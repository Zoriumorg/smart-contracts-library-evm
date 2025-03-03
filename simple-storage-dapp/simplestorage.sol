// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private storedValue;

    // Event to emit when value is updated
    event ValueUpdated(uint256 newValue);

    // Store a new value
    function setValue(uint256 _value) public {
        storedValue = _value;
        emit ValueUpdated(_value);
    }

    // Retrieve the stored value
    function getValue() public view returns (uint256) {
        return storedValue;
    }
}