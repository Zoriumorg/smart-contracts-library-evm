// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiStorageContract {
    // Mapping to store address => integer values
    mapping(address => uint256) public addressToValue;
    
    // Mapping to store address => string values
    mapping(address => string) public addressToString;
    
    // Declare events
    event ValueStored(address indexed user, uint256 value);
    event StringStored(address indexed user, string value);
    
    // Store an integer value
    function storeValue(uint256 _value) public {
        addressToValue[msg.sender] = _value;
        emit ValueStored(msg.sender, _value);  // Now this works
    }
    
    // Store a string value
    function storeString(string memory _str) public {
        addressToString[msg.sender] = _str;
        emit StringStored(msg.sender, _str);   // Now this works
    }
    
    // Get stored integer value for an address
    function getValue(address _addr) public view returns (uint256) {
        return addressToValue[_addr];
    }
    
    // Get stored string value for an address
    function getString(address _addr) public view returns (string memory) {
        return addressToString[_addr];
    }
}