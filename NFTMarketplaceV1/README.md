# NFT Marketplace V1

This project implements an NFT Marketplace (`NFTMarketplaceV1`) smart contract that allows users to buy and sell ERC-721 tokens. It is paired with a simple `TestNFT` contract for testing purposes. The contracts are deployed and tested using Remix IDE in the JavaScript VM environment.

## Table of Contents
- [Overview](#overview)
- [Contracts](#contracts)
  - [NFTMarketplaceV1](#nftmarketplacev1)
  - [TestNFT](#testnft)
- [Setup in Remix](#setup-in-remix)
- [Step-by-Step Testing Guide](#step-by-step-testing-guide)
- [Contract Improvements](#contract-improvements)
- [Troubleshooting](#troubleshooting)

## Overview
The `NFTMarketplaceV1` contract enables:
- Listing ERC-721 NFTs for sale with a fixed listing fee of 0.025 ETH.
- Purchasing listed NFTs by paying the specified price.
- Viewing unsold items, purchased NFTs, and items listed by a user.
- Secure transactions with reentrancy protection.

The `TestNFT` contract is a basic ERC-721 implementation for minting NFTs to test the marketplace.

## Setup in Remix

1. **Open Remix IDE**: Go to [https://remix.ethereum.org](https://remix.ethereum.org).
2. **Create Files**:
   - Create `NFTMarketplaceV1.sol` and paste the updated contract code.
   - Create `TestNFT.sol` and paste the provided code.
3. **Install OpenZeppelin Dependencies**:
   - In Remix’s **File Explorer**, create a folder `.deps/OpenZeppelin`.
   - Import the following from `@openzeppelin/contracts` (use Remix’s import feature or copy from [OpenZeppelin GitHub](https://github.com/OpenZeppelin/openzeppelin-contracts)):
     - `token/ERC721/IERC721.sol`
     - `token/ERC721/ERC721.sol`
     - `security/ReentrancyGuard.sol`
     - `utils/Counters.sol`
4. **Compile Contracts**:
   - Go to the **Solidity Compiler** tab.
   - Select compiler version `0.8.20`.
   - Compile `TestNFT.sol` and `NFTMarketplaceV1.sol`. Ensure no errors.
5. **Set Environment**:
   - In the **Deploy & Run Transactions** tab, select **JavaScript VM (Cancun)** as the environment.
   - Ensure the **Account** is set to the default account (e.g., `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`) with 100 ETH.
   - Set **Gas Limit** to `3000000`.

## Step-by-Step Testing Guide

Below is a detailed guide to test all functions of `NFTMarketplaceV1` in Remix, including inputs, expected outputs, and verification steps. The steps assume you’re starting fresh.

### Step 1: Deploy TestNFT
1. **Select TestNFT**:
   - In **Deploy & Run Transactions**, select `TestNFT` from the contract dropdown.
2. **Deploy**:
   - Click **Deploy**.
   - Verify the contract appears under **Deployed Contracts** (e.g., at `0xd9145CCE52D386f254917e481eB44e9943F39138`).
3. **Mint NFTs**:
   - Function: `mint(address to, uint256 tokenId)`.
   - Inputs:
     - `to`: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` (your account).
     - `tokenId`: `1`.
   - Click **mint**.
   - Repeat for `tokenId: 2` and `tokenId: 3`.
   - **Verification**:
     - Check transaction receipts in the **Terminal** for `status: true`.
     - Call `ownerOf(uint256 tokenId)` with `tokenId: 1`, `2`, `3`. Expect `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.

### Step 2: Deploy NFTMarketplaceV1
1. **Select NFTMarketplaceV1**:
   - Select `NFTMarketplaceV1` from the contract dropdown.
2. **Deploy**:
   - Click **Deploy**.
   - Verify the contract appears under **Deployed Contracts** (e.g., at `0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8`).
3. **Verify Owner**:
   - Call `getOwner()`.
   - Expect `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.

### Step 3: Approve Marketplace
The marketplace needs permission to transfer NFTs.

1. **Select TestNFT**:
   - Select `TestNFT` at its deployed address.
2. **Call setApprovalForAll**:
   - Function: `setApprovalForAll(address operator, bool approved)`.
   - Inputs:
     - `operator`: `0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8` (marketplace address).
     - `approved`: `true`.
   - Click **setApprovalForAll**.
   - **Verification**:
     - Call `isApprovedForAll(address owner, address operator)`:
       - `owner`: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
       - `operator`: `0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8`.
     - Expect `true`.

### Step 4: Test getListingFee
1. **Select NFTMarketplaceV1**:
   - Select `NFTMarketplaceV1` at its deployed address.
2. **Call getListingFee**:
   - Function: `getListingFee()`.
   - Click **getListingFee**.
   - **Verification**:
     - Expect `25000000000000000` (0.025 ETH in wei).

### Step 5: Test createMarketItem
List an NFT for sale. This step addresses your previous error ("Must pay listing fee").

1. **Select NFTMarketplaceV1**:
   - Ensure `NFTMarketplaceV1` is selected.
2. **Set Transaction Value**:
   - In the **Value** field (top of Deploy & Run tab), enter:
     - `0.025`
     - Select `Ether` (converts to `25000000000000000` wei).
3. **Call createMarketItem**:
   - Function: `createMarketItem(address nftContract, uint256 tokenId, uint256 price)`.
   - Inputs:
     - `nftContract`: `0xd9145CCE52D386f254917e481eB44e9943F39138` (TestNFT address).
     - `tokenId`: `1`.
     - `price`: `1000000000000000000` (1 ETH in wei).
   - Click **createMarketItem**.
   - **Verification**:
     - Check the transaction receipt for `status: true`.
     - Look for the `MarketItemCreated` event in the **Terminal** logs:
       - `itemId: 1`.
       - `nftContract: 0xd9145CCE52D386f254917e481eB44e9943F39138`.
       - `tokenId: 1`.
       - `seller: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
       - `owner: 0x0000000000000000000000000000000000000000`.
       - `price: 1000000000000000000`.
       - `sold: false`.
     - In `TestNFT`, call `ownerOf(1)`:
       - Expect `0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8` (marketplace address).

### Step 6: Test fetchMarketItems
1. **Call fetchMarketItems**:
   - Function: `fetchMarketItems()`.
   - Click **fetchMarketItems**.
   - **Verification**:
     - Expect an array with one `MarketItem`:
       - `itemId: 1`.
       - `nftContract: 0xd9145CCE52D386f254917e481eB44e9943F39138`.
       - `tokenId: 1`.
       - `seller: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
       - `owner: 0x0000000000000000000000000000000000000000`.
       - `price: 1000000000000000000`.
       - `sold: false`.

### Step 7: Test createMarketSale
Purchase the listed NFT with a different account.

1. **Switch Account**:
   - In the **Account** dropdown, select the second account (e.g., `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`).
2. **Set Transaction Value**:
   - In the **Value** field, enter:
     - `1`
     - Select `Ether` (matches the 1 ETH price).
3. **Call createMarketSale**:
   - Function: `createMarketSale(address nftContract, uint256 itemId)`.
   - Inputs:
     - `nftContract`: `0xd9145CCE52D386f254917e481eB44e9943F39138`.
     - `itemId`: `1`.
   - Click **createMarketSale**.
   - **Verification**:
     - Check the transaction receipt for `status: true`.
     - Look for the `MarketItemSold` event:
       - `itemId: 1`.
       - `buyer: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`.
     - In `TestNFT`, call `ownerOf(1)`:
       - Expect `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`.
     - Call `fetchMarketItems`:
       - Expect an empty array (item sold).

### Step 8: Test fetchMyNFTs
1. **Call fetchMyNFTs**:
   - Function: `fetchMyNFTs(address user)`.
   - Input:
     - `user`: `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2` (buyer).
   - Click **fetchMyNFTs**.
   - **Verification**:
     - Expect an array with one `MarketItem`:
       - `itemId: 1`.
       - `owner: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`.
       - `sold: true`.

### Step 9: Test fetchItemsCreated
1. **Call fetchItemsCreated**:
   - Function: `fetchItemsCreated(address user)`.
   - Input:
     - `user`: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` (seller).
   - Click **fetchItemsCreated**.
   - **Verification**:
     - Expect an array with one `MarketItem`:
       - `itemId: 1`.
       - `seller: 0x5B38Da6a701c568545dCfcB875f56beddC4`.
       - `sold: true`.

### Step 10: Test Edge Cases
Use token ID 2 for additional tests.

1. **Invalid Listing Fee**:
   - Select `NFTMarketplaceV1`, account `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
   - Set **Value**: `0 Ether`.
   - Call `createMarketItem`:
     - `nftContract`: `0xd9145CCE52D386f254917e481eB44e9943F39138`.
     - `tokenId`: `2`.
     - `price`: `1000000000000000000`.
   - **Verification**:
     - Expect revert: “Must pay listing fee”.

2. **Non-Owner Listing**:
   - Switch to `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`.
   - Set **Value**: `0.025 Ether`(this converts to 25000000000000000 wei).
   - Call `createMarketItem` (same inputs).
   - **Verification**:
     - Expect revert: “Not the token owner”.

3. **Unapproved NFT**:
   - Switch to `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
   - In `TestNFT`, call `setApprovalForAll`:
     - `operator`: `0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8`.
     - `approved`: `false`.
   - Call `createMarketItem` (same inputs).
   - **Verification**:
     - Expect revert: “Marketplace not approved”.

4. **Incorrect Purchase Price**:
   - Re-approve (`setApprovalForAll`, `approved: true`).
   - List token ID 2 (same inputs, **Value**: `0.025 Ether`(this converts to 25000000000000000 wei)).
   - Switch to `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`.
   - Call `createMarketSale`:
     - `nftContract`: `0xd9145CCE52D386f254917e481eB44e9943F39138`.
     - `itemId`: `2`.
     - **Value**: `0.5 Ether`.
   - **Verification**:
     - Expect revert: “Please submit the asking price”.

5. **Already Sold Item**:
   - Complete the sale of item ID 2 (**Value**: `1 Ether`).
   - Call `createMarketSale` again (same inputs).
   - **Verification**:
     - Expect revert: “Item already sold”.

### Step 11: Verify Balances
1. **Seller’s Balance**:
   - Check `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` in **Account** dropdown.
   - Expect ~0.975 ETH increase (1 ETH sale - 0.025 ETH fee, minus gas).
2. **Buyer’s Balance**:
   - Check `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`.
   - Expect ~1 ETH decrease (sale price, minus gas).
3. **Owner’s Balance**:
   - Listing fee (0.025 ETH)(this converts to 25000000000000000 wei) goes to `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` (included in seller’s balance).

## Contract Improvements
Potential future improvements:
- Add a function to cancel listings.
- Support royalties for NFT creators.
- Optimize gas usage in `fetch` functions for large datasets.

## Troubleshooting
- **"Must pay listing fee" Error**:
  - Ensure **Value** is `0.025 Ether`(this converts to 25000000000000000 wei) in `createMarketItem`.
  - Previous attempts failed due to `0` or `1 ETH`.
- **NFT Not Owned**:
  - Verify token ownership with `ownerOf` in `TestNFT`.
  - If an NFT was transferred, use another token ID (e.g., 2 or 3).
- **Gas Issues**:
  - Increase **Gas Limit** to `4000000` if transactions fail.
- **State Issues**:
  - Click **Environment Reset State**, redeploy contracts, and restart testing.
- **Logs**:
  - Check **Terminal** for transaction receipts and event logs to debug failures.



