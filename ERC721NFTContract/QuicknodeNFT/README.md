# BasicNFT - ERC721 NFT Contract

## Overview

BasicNFT is a simple ERC721 non-fungible token (NFT) implementation that allows:

- Minting of NFTs with custom token URIs
- Storing and retrieving token metadata (URIs)
- Basic ERC721 functionality (ownership, transfers, etc.)

This contract is built using:

- OpenZeppelin's ERC721 implementation
- OpenZeppelin's Counters utility for token ID tracking

## Contract Details

- **Name**: BasicNFT
- **Symbol**: BNFT
- **License**: MIT
- **Solidity Version**: ^0.8.0

### Features

1. Mint NFTs with custom metadata (token URI)
2. Store and retrieve token URIs for each NFT
3. Track token IDs using Counters
4. Inherits standard ERC721 functionality:
   - Ownership tracking
   - Transfer capabilities
   - Approval mechanisms

## Installation Prerequisites

To deploy and test this contract, you'll need:

### For Remix Testing

1. Web browser with MetaMask extension
2. Access to Remix IDE (<https://remix.ethereum.org>)
3. ETH in MetaMask wallet (for test networks)

### For Local Development

1. Node.js (v14 or higher)
2. Hardhat or Truffle (optional)
3. MetaMask
4. Test ETH (for testnet deployment)

## Deployment

### Deploying on Remix

1. Open Remix IDE (<https://remix.ethereum.org>)
2. Create a new file named `BasicNFT.sol`
3. Copy and paste the contract code
4. In the "Solidity Compiler" tab:
   - Select compiler version 0.8.x
   - Enable optimization (optional)
5. Click "Compile"
6. In the "Deploy & Run Transactions" tab:
   - Select "Injected Web3" environment
   - Connect MetaMask to desired network (e.g., Sepolia testnet)
   - Click "Deploy"
   - Confirm transaction in MetaMask

### Local Deployment (Using Hardhat)

Initialize Hardhat project:

```bash
npm init -y
npm install --save-dev hardhat
npx hardhat

### Prerequisites for Testing
1. Compiled contract in Remix
2. Connected MetaMask wallet
3. Selected appropriate network (e.g., Sepolia testnet)
4. Deployed contract instance

### Testing and Minting in Remix

#### 1. Mint NFT
- In "Deploy & Run Transactions" tab, select deployed contract
- Find the `mintNFT` function (orange button)
- Input parameters:
  ```bash
  recipient: "0xYourMetaMaskAddressHere"  // Your MetaMask wallet address
  _tokenURI: "ipfs://QmSampleHash123"     // Sample IPFS URI for metadata
  ```bash
- Click "Transact" and confirm in MetaMask
- Note the returned token ID (starts at 1 and increments)

#### 2. Check Token URI
- Find the `tokenURI` function (blue button)
- Input parameters:
  ```bash
  tokenId: 1  // Use the token ID from minting
  ```

- Click "Call"
- Verify the returned URI matches what you input during minting
- Expected output: "ipfs://QmSampleHash123"

#### 3. Test Ownership

- Find the `ownerOf` function (blue button, inherited from ERC721)
- Input parameters:

  ```bash
  tokenId: 1  // Use the token ID from minting
  ```bash- Click "Call"
- Verify the returned address matches the recipient address
- Expected output: "0xYourMetaMaskAddressHere"

#### 4. Test Transfer

- First, connect a second MetaMask account for testing
- Find the `transferFrom` function (orange button)
- Input parameters:

   ```bash
  from: "0xYourMetaMaskAddressHere"       // Original owner
  to: "0xSecondTestAddress"              // Second MetaMask address
  tokenId: 1                             // Token ID to transfer
  ```bash
- Click "Transact" and confirm in MetaMask
- Use `ownerOf` to verify the new owner

#### 5. Test Error Cases

- Try getting URI for non-existent token:
  - Call `tokenURI` with:

    ```bash
    tokenId: 999  // Non-existent token ID

  ```bash
  - Expected error: "ERC721URIStorage: URI query for nonexistent token"

- Try setting URI for non-existent token (through direct call):
  - This is internal, but you can test indirect effects by attempting invalid operations

### Sample Test Values

```
# Valid Inputs
recipient: "0xYourMetaMaskAddressHere"
_tokenURI: "ipfs://QmSampleHash123"
tokenId: 1  // After first mint

# Invalid Inputs (for error testing)
tokenId: 999  // Non-existent token
recipient: "0x0000000000000000000000000000000000000000"  // Zero address
_tokenURI: ""  // Empty URI
  ```bash

### Testing Tips
- Always start with fresh deployment for clean testing
- Use Remix's "Gas Estimate" to check transaction costs
- Monitor MetaMask for transaction confirmations
- Use Remix's debug tools to inspect failed transactions
- Test with multiple accounts to verify transfers


### Minting NFTs
```solidity
// Mint new NFT
uint256 tokenId = basicNFT.mintNFT(
    recipientAddress, // address
    "ipfs://Qm..."    // token URI
);
```


### Local Deployment (Using Hardhat)

Initialize Hardhat project:

```bash
npm init -y
npm install --save-dev hardhat
npx hardhat
```
