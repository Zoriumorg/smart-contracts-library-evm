// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./RewardsOracleInterface.sol";
import "./RewardsOracleClientInterface.sol";

contract RewardsOracle is Ownable, RewardsOracleInterface {
    uint256 public requestId = 0;
    mapping(uint256 => address) private requests;

    constructor(address initialOwner) Ownable(initialOwner) {
    }

    function requestReward(address buyer, address seller) external override {
        requests[requestId] = seller;
        emit Request(requestId, buyer);
        requestId++;
    }

    function responseCallback(uint256 _requestId, address buyer, uint256 reward) external override onlyOwner {
        address seller = requests[_requestId];
        require(seller != address(0), "Invalid request ID");
        RewardsOracleClientInterface(seller).rewardCallback(buyer, reward);
        delete requests[_requestId];
    }
}