// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface RewardsOracleInterface {
    event Request(uint256 requestId, address buyer);

    function requestReward(address buyer, address seller) external;
    function responseCallback(uint256 requestId, address buyer, uint256 reward) external;
}