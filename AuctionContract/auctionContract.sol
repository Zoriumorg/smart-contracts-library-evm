// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuctionContract {
    // Auction parameters
    address public owner; // The address of the auction creator
    uint public auctionEndTime; // Timestamp when the auction ends
    address public highestBidder; // Address of the current highest bidder
    uint public highestBid; // Current highest bid amount
    bool public auctionEnded; // Flag to indicate if the auction has ended

    // Mapping to store pending withdrawals for bidders
    mapping(address => uint) public pendingReturns;

    // Events to log auction activities
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // Constructor to set auction duration and owner
    constructor(uint _biddingTime) {
        owner = msg.sender;
        auctionEndTime = block.timestamp + _biddingTime; // Auction ends after _biddingTime seconds
    }

    // Function to place a bid
    function bid() public payable {
        // Check if the auction has ended
        require(block.timestamp <= auctionEndTime, "Auction already ended.");
        // Check if the bid is higher than the current highest bid
        require(msg.value > highestBid, "There is already a higher bid.");

        // Refund the previous highest bidder
        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        // Update the highest bid and bidder
        highestBidder = msg.sender;
        highestBid = msg.value;

        // Emit event for the new highest bid
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    // Function for bidders to withdraw their outbid funds
    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw.");

        // Reset the pending amount before transferring to prevent re-entrancy
        pendingReturns[msg.sender] = 0;

        // Transfer the funds
        payable(msg.sender).transfer(amount);
    }

    // Function for the owner to end the auction
    function endAuction() public {
        // Check if the auction has already ended
        require(!auctionEnded, "Auction already ended.");
        // Check if the caller is the owner
        require(msg.sender == owner, "Only the owner can end the auction.");
        // Check if the auction time has passed (optional, owner can end early)
        // require(block.timestamp >= auctionEndTime, "Auction not yet ended.");

        // Mark the auction as ended
        auctionEnded = true;

        // Emit event for auction end
        emit AuctionEnded(highestBidder, highestBid);

        // Transfer the highest bid to the owner
        if (highestBid > 0) {
            payable(owner).transfer(highestBid);
        }
    }

    // Function to get the current highest bid
    function getHighestBid() public view returns (uint) {
        return highestBid;
    }

    // Function to get the current highest bidder
    function getHighestBidder() public view returns (address) {
        return highestBidder;
    }

    // Function to get the auction end time
    function getAuctionEndTime() public view returns (uint) {
        return auctionEndTime;
    }
}