// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface RewardsOracleClientInterface {
    function rewardCallback(address buyer, uint256 reward) external;
}