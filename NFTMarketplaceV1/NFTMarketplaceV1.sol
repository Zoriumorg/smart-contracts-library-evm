// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMarketplaceV1 is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;// Tracks total listed items
    Counters.Counter private _itemsSold;// Tracks sold items

address payable public owner; // Contract owner who receives listing fees
uint256 public constant listingFee = 0.025 ether; // Fixed listing fee (0.025 ETH)

// Struct to store market item details
struct MarketItem {
    uint256 itemId; // Unique ID for the market item
    address nftContract; // Address of the ERC-721 contract
    uint256 tokenId; // NFT token ID
    address payable seller; // Address of the seller
    address payable owner; // Current owner (zero address if for sale)
    uint256 price; // Sale price in wei
    bool sold; // Whether the item is sold
}

// Mapping from item ID to MarketItem
mapping(uint256 => MarketItem) private idToMarketItem;

// Event emitted when an NFT is listed
event MarketItemCreated (
    uint256 indexed itemId,
    address indexed nftContract,
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
);

// Event emitted when an NFT is sold
event MarketItemSold (
    uint256 indexed itemId,
    address buyer
);

// Constructor sets the contract deployer as owner
constructor() {
    owner = payable(msg.sender);
}

// Get the contract owner
function getOwner() public view returns (address) {
    return owner;
}

// List an NFT for sale
function createMarketItem(
    address nftContract,
    uint256 tokenId,
    uint256 price
) public payable nonReentrant {
    require(price > 0, "Price must be at least 1 wei");
    require(msg.value == listingFee, "Must pay listing fee");
    require(IERC721(nftContract).ownerOf(tokenId) == msg.sender, "Not the token owner");
    require(
        IERC721(nftContract).isApprovedForAll(msg.sender, address(this)) ||
        IERC721(nftContract).getApproved(tokenId) == address(this),
        "Marketplace not approved"
    );

    _itemIds.increment();
    uint256 itemId = _itemIds.current();

    idToMarketItem[itemId] = MarketItem(
        itemId,
        nftContract,
        tokenId,
        payable(msg.sender),
        payable(address(0)),
        price,
        false
    );

    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

    emit MarketItemCreated(
        itemId,
        nftContract,
        tokenId,
        msg.sender,
        address(0),
        price,
        false
    );
}

// Buy a listed NFT
function createMarketSale(
    address nftContract,
    uint256 itemId
) public payable nonReentrant {
    MarketItem storage item = idToMarketItem[itemId];
    require(item.itemId == itemId && item.itemId != 0, "Item does not exist");
    require(!item.sold, "Item already sold");
    require(msg.value == item.price, "Please submit the asking price");
    require(item.owner == address(0), "Item not for sale");

    item.seller.transfer(msg.value);
    IERC721(nftContract).transferFrom(address(this), msg.sender, item.tokenId);
    item.owner = payable(msg.sender);
    item.sold = true;
    _itemsSold.increment();

    payable(owner).transfer(listingFee);

    emit MarketItemSold(itemId, msg.sender);
}

// Fetch all unsold market items
function fetchMarketItems() public view returns (MarketItem[] memory) {
    uint256 itemCount = _itemIds.current();
    uint256 unsoldItemCount = itemCount - _itemsSold.current();
    MarketItem[] memory items = new MarketItem[](unsoldItemCount);
    uint256 currentIndex = 0;

    for (uint256 i = 1; i <= itemCount; i++) {
        if (idToMarketItem[i].owner == address(0) && !idToMarketItem[i].sold) {
            items[currentIndex] = idToMarketItem[i];
            currentIndex++;
        }
    }
    return items;
}

// Fetch NFTs purchased by a user
function fetchMyNFTs(address user) public view returns (MarketItem[] memory) {
    uint256 totalItemCount = _itemIds.current();
    uint256 itemCount = 0;
    uint256 currentIndex = 0;

    for (uint256 i = 1; i <= totalItemCount; i++) {
        if (idToMarketItem[i].owner == user) {
            itemCount++;
        }
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint256 i = 1; i <= totalItemCount; i++) {
        if (idToMarketItem[i].owner == user) {
            items[currentIndex] = idToMarketItem[i];
            currentIndex++;
        }
    }
    return items;
}

// Fetch NFTs listed by a user
function fetchItemsCreated(address user) public view returns (MarketItem[] memory) {
    uint256 totalItemCount = _itemIds.current();
    uint256 itemCount = 0;
    uint256 currentIndex = 0;

    for (uint256 i = 1; i <= totalItemCount; i++) {
        if (idToMarketItem[i].seller == user) {
            itemCount++;
        }
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint256 i = 1; i <= totalItemCount; i++) {
        if (idToMarketItem[i].seller == user) {
            items[currentIndex] = idToMarketItem[i];
            currentIndex++;
        }
    }
    return items;
}

// Get the listing fee
function getListingFee() public view returns (uint256) {
    return listingFee;
}
}