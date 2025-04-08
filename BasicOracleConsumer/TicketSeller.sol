// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./RewardsOracleInterface.sol";
import "./RewardsOracleClientInterface.sol";

contract TicketSeller is RewardsOracleClientInterface {
    RewardsOracleInterface public rewardsOracle;
    uint256 public constant BASE_TICKET_PRICE = 0.1 ether;
    mapping(address => uint256) private rewards;

    // Event for tracking ticket purchases
    event TicketPurchased(address buyer, uint256 pricePaid);

    constructor(address _rewardsOracle) {
        require(_rewardsOracle != address(0), "Invalid oracle address");
        rewardsOracle = RewardsOracleInterface(_rewardsOracle);
    }

    // Callback function for the oracle to deliver rewards
    function rewardCallback(address buyer, uint256 reward) external override {
        require(msg.sender == address(rewardsOracle), "Caller is not the oracle");
        rewards[buyer] += reward;
    }

    // Buy a ticket, applying any available rewards
    function buyTicket() external payable {
        uint256 ticketPrice = getPrice(msg.sender);
        require(msg.value >= ticketPrice, "Insufficient payment");

        if (msg.value > ticketPrice) {
            payable(msg.sender).transfer(msg.value - ticketPrice); // Refund excess
        }

        if (rewards[msg.sender] >= ticketPrice) {
            rewards[msg.sender] -= ticketPrice;
        } else if (rewards[msg.sender] > 0) {
            rewards[msg.sender] = 0;
        }

        rewardsOracle.requestReward(msg.sender, address(this));
        emit TicketPurchased(msg.sender, ticketPrice);
    }

    // Calculate the ticket price based on available rewards
    function getPrice(address buyer) public view returns (uint256) {
        if (rewards[buyer] >= BASE_TICKET_PRICE) {
            return 0;
        } else if (rewards[buyer] > 0) {
            return BASE_TICKET_PRICE - rewards[buyer];
        }
        return BASE_TICKET_PRICE;
    }

    // View available rewards for a buyer
    function getRewards(address buyer) external view returns (uint256) {
        return rewards[buyer];
    }
}