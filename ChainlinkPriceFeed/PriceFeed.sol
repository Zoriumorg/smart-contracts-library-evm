
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceFeedConsumer {
    AggregatorV3Interface internal priceFeed;

    // Store the latest price and timestamp
    int256 public latestPrice;
    uint256 public latestTimestamp;

    // Event to log price updates
    event PriceFetched(uint256 price, uint256 timestamp);

    // Constructor initializes the price feed contract address
    constructor(address _priceFeedAddress) {
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    // Fetches and stores the latest ETH/USD price
    function getLatestPrice() public returns (int256) {
        (
            , // roundId
            int256 price, // price
            , // startedAt
            uint256 updatedAt, // updatedAt
            // answeredInRound
        ) = priceFeed.latestRoundData();

        // Ensure the price is positive and data is recent
        require(price > 0, "Invalid price data");
        require(updatedAt > 0, "Stale data");

        // Store the price and timestamp
        latestPrice = price;
        latestTimestamp = updatedAt;

        // Emit event with price and timestamp
        emit PriceFetched(uint256(price), updatedAt);

        return price; // Price is returned with 8 decimals
    }

    // View function to read the stored price without a transaction
    function readLatestPrice() public view returns (int256, uint256) {
        return (latestPrice, latestTimestamp);
    }

    // Returns the price adjusted for decimals (human-readable)
    function getFormattedPrice() public view returns (uint256) {
        uint8 decimals = priceFeed.decimals();
        return uint256(latestPrice) / (10 ** decimals);
    }

    // Returns the number of decimals for the price feed
    function getDecimals() public view returns (uint8) {
        return priceFeed.decimals();
    }
}
