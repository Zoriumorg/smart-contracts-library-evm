// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract SyntheticAssetToken is ERC20, Ownable, Pausable {
    AggregatorV3Interface public priceFeed;
    uint256 public peggedValue;
    uint8 public priceFeedDecimals;
    event PegUpdated(uint256 newPeggedValue);
    event PriceFeedUpdated(address newPriceFeed);

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply,
        address initialPriceFeed,
        uint8 _priceFeedDecimals
    ) ERC20(name_, symbol_) Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
        priceFeed = AggregatorV3Interface(initialPriceFeed);
        priceFeedDecimals = _priceFeedDecimals;
        peggedValue = getLatestPeggedValue();
    }

    function updatePriceFeed(address newPriceFeed) external onlyOwner {
        require(newPriceFeed != address(0), "Invalid price feed address");
        priceFeed = AggregatorV3Interface(newPriceFeed);
        emit PriceFeedUpdated(newPriceFeed);
    }

    function updatePeggedValue() external whenNotPaused returns (uint256) {
        peggedValue = getLatestPeggedValue();
        emit PegUpdated(peggedValue);
        return peggedValue;
    }

    function getLatestPeggedValue() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        require(price > 0, "Invalid price from oracle");
        return uint256(price) * 10 ** (decimals() - priceFeedDecimals);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _update(address from, address to, uint256 amount) internal override whenNotPaused {
        super._update(from, to, amount);
    }
}