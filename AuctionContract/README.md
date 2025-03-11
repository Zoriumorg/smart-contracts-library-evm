# AuctionContract - English Auction Smart Contract

## Overview

`AuctionContract` is a Solidity smart contract implementing a basic English auction (open ascending price auction) on the Ethereum blockchain. In this auction:
- Bidders place increasingly higher bids using ETH.
- The auction has a fixed duration, set during deployment.
- The highest bidder at the end of the auction wins the item.
- Outbid bidders can withdraw their funds.
- The auction owner can end the auction, and the highest bid is transferred to the owner.

This contract is designed for educational purposes and testing on Ethereum testnets (e.g., Sepolia). It includes basic security features but should be thoroughly audited before use in production.

The` AuctionContract `facilitates a decentralized English auction on Ethereum, where:

Bidders place bids by sending ETH to the contract.
Each bid must be higher than the current highest bid.
Outbid bidders can withdraw their funds (ETH) at any time.
The auction has a fixed duration, set when the contract is deployed.
The owner (the person who deployed the contract) can end the auction, and the highest bid is transferred to them.
The highest bidder at the end of the auction wins, but the item being auctioned (e.g., an NFT, physical item) is not handled by the contract—it must be managed off-chain or via integration with another contract.

---

## Contract Details

- **License**: MIT
- **Solidity Version**: ^0.8.0
- **Purpose**: Facilitate a transparent English auction where participants bid for an item, and the highest bidder wins.

### Key Features
- Fixed-duration auction set during deployment.
- Bidders can place bids, with automatic refunds for outbid participants.
- Outbid bidders can withdraw their funds.
- The auction owner can end the auction and receive the highest bid.
- View functions to check the highest bid, highest bidder, and auction end time.

---

## Contract Functions

### State Variables
- `owner`: Address of the auction creator (set during deployment).
- `auctionEndTime`: Timestamp when the auction ends (set during deployment).
- `highestBidder`: Address of the current highest bidder.
- `highestBid`: Current highest bid amount (in wei).
- `auctionEnded`: Boolean flag indicating if the auction has ended.
- `pendingReturns`: Mapping to store ETH amounts for outbid bidders to withdraw.

### Events
- `HighestBidIncreased(address bidder, uint amount)`: Emitted when a new highest bid is placed.
- `AuctionEnded(address winner, uint amount)`: Emitted when the auction ends.

### Constructor
- `constructor(uint _biddingTime)`:
  - Sets the auction owner as the deployer (`msg.sender`).
  - Sets the auction end time as `block.timestamp + _biddingTime` (in seconds).
  - Example: `_biddingTime = 3600` creates a 1-hour auction.

### Public Functions

1. **`bid() public payable`**
   - Allows users to place a bid by sending ETH.
   - Requirements:
     - Auction must not have ended (`block.timestamp <= auctionEndTime`).
     - Bid must be higher than the current highest bid (`msg.value > highestBid`).
   - Refunds the previous highest bidder by adding their bid to `pendingReturns`.
   - Updates `highestBidder` and `highestBid`.
   - Emits `HighestBidIncreased` event.

2. **`withdraw() public`**
   - Allows outbid bidders to withdraw their funds from `pendingReturns`.
   - Requirements:
     - Caller must have funds to withdraw (`pendingReturns[msg.sender] > 0`).
   - Resets the pending amount before transferring to prevent re-entrancy attacks.
   - Transfers the funds to the caller.

3. **`endAuction() public`**
   - Allows the owner to end the auction.
   - Requirements:
     - Auction must not have already ended (`!auctionEnded`).
     - Caller must be the owner (`msg.sender == owner`).
   - Marks the auction as ended (`auctionEnded = true`).
   - Transfers the highest bid to the owner (if there is a bid).
   - Emits `AuctionEnded` event.

### View Functions
- `getHighestBid() public view returns (uint)`: Returns the current highest bid (in wei).
- `getHighestBidder() public view returns (address)`: Returns the address of the current highest bidder.
- `getAuctionEndTime() public view returns (uint)`: Returns the timestamp when the auction ends.

---

## How to Use

### Prerequisites
- **Development Environment**: Use Remix Ethereum IDE ([remix.ethereum.org](https://remix.ethereum.org/)) for testing and deployment.
- **MetaMask**: Required for deploying on testnets (e.g., Sepolia).
- **Testnet ETH**: Get Sepolia ETH from a faucet (e.g., [Sepolia Faucet](https://sepoliafaucet.com/)) for testing.

---

### Deployment Instructions

#### Deploying in Remix
1. **Open Remix IDE**
   - Go to [Remix Ethereum IDE](https://remix.ethereum.org/).
   - Create a new file named `AuctionContract.sol` and paste the contract code.

2. **Compile the Contract**
   - Go to the "Solidity Compiler" tab.
   - Select compiler version `0.8.0` or higher.
   - Click "Compile AuctionContract.sol".

3. **Deploy on JavaScript VM (Local Testing)**
   - Go to the "Deploy & Run Transactions" tab.
   - Select "JavaScript VM (London)" as the environment.
   - Enter the `_biddingTime` parameter in the constructor (e.g., `3600` for 1 hour), `_biddingTime = 86400 (1 day)`.
   - Click "Deploy".
   - The contract will appear in the "Deployed Contracts" section.

4. **Deploy on a Testnet (e.g., Sepolia)**
   - Set up MetaMask and connect to the Sepolia testnet.
   - In Remix, select "Injected Provider - MetaMask" as the environment.
   - MetaMask will prompt you to connect.
   - Enter `_biddingTime` (e.g., `3600`) and click "Deploy".
   - Confirm the transaction in MetaMask and pay the gas fee.
   - Wait for the transaction to be confirmed; the contract address will appear in Remix.

---

### Interacting with the Contract

#### Using Remix
1. **Place a Bid**
   - Switch to a bidder account in Remix (top dropdown in "Deploy & Run Transactions").
   - In the `bid` function, enter a value in the "Value" box (e.g., `1000000000000000000` for 1 ETH).
   - Click "bid".
   - Check logs for the `HighestBidIncreased` event.

2. **Withdraw Funds (Outbid Bidders)**
   - Switch to an outbid bidder’s account.
   - Click "withdraw" to reclaim funds.
   - Verify the account balance in Remix.

3. **End the Auction (Owner Only)**
   - Switch to the owner account (the deployer).
   - Click "endAuction".
   - Check logs for the `AuctionEnded` event.
   - Verify the owner’s balance for the highest bid.

4. **View Auction Details**
   - Call `getHighestBid`, `getHighestBidder`, and `getAuctionEndTime` to check the auction state.

---

### Testing Scenarios

#### Test Case 1: Place Bids
- Deploy the contract with `_biddingTime = 3600`.
- Bidder 1 bids 1 ETH (`1000000000000000000` wei).
- Bidder 2 bids 2 ETH (`2000000000000000000` wei).
- Verify Bidder 1’s funds are in `pendingReturns`.

#### Test Case 2: Withdraw Funds
- Bidder 1 calls `withdraw` to reclaim their 1 ETH.
- Verify Bidder 1’s balance is updated.

#### Test Case 3: End the Auction
- Owner calls `endAuction`.
- Verify the highest bid (2 ETH) is transferred to the owner.
- Verify `auctionEnded = true`.

#### Test Case 4: Error Testing
- Try bidding after the auction ends (should fail).
- Try ending the auction with a non-owner account (should fail).
- Try withdrawing with no pending funds (should fail).

---

## Security Considerations

- **Re-entrancy**: The `withdraw` function resets `pendingReturns` before transferring ETH to prevent re-entrancy attacks.
- **ETH Transfers**: Uses `transfer` for ETH transfers, which is safe but may fail for certain contracts. Consider using `call` for production.
- **Modifiers**: Add modifiers (e.g., `onlyOwner`) for cleaner and more secure code.
- **Minimum Bid Increment**: Consider adding a minimum bid increment to prevent spam bids.
- **Audit**: This contract is for educational purposes. Conduct a professional audit before using it in production.

---

## Additional Notes

- **Gas Costs**: Test gas costs in Remix before deploying on mainnet.
- **Contract Verification**: Verify the contract on Etherscan (Sepolia) for transparency.
- **Improvements**:
  - Add a description of the auction item (e.g., string or IPFS hash).
  - Add a reserve price (minimum bid).
  - Allow the owner to cancel the auction before it starts.

---

## License

This project is licensed under the MIT License. See the `SPDX-License-Identifier` in the contract for details.

