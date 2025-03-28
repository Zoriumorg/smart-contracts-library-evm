// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ValueTrackerV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 public trackedValue;
    uint256 public incrementCount; // New feature in V2

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
        trackedValue = 0;
        incrementCount = 0;
    }

    function setValue(uint256 newValue) public onlyOwner {
        trackedValue = newValue;
    }

    function getValue() public view returns (uint256) {
        return trackedValue;
    }

    function incrementValue() public onlyOwner {
        trackedValue += 1;
        incrementCount += 1;
    }

    function getIncrementCount() public view returns (uint256) {
        return incrementCount;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}