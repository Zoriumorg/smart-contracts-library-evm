# BasicNFT Smart Contract

This README provides an overview of the BasicNFT smart contract, which implements an ERC721 Non-Fungible Token (NFT) with basic minting and URI storage functionality. It also includes instructions for testing the contract using Remix IDE.

## Contract Overview

The BasicNFT contract is a simple implementation of an ERC721 NFT that allows:
- Minting new NFTs with associated token URIs
- Storing and retrieving token URIs
- Basic ERC721 functionality (through inheritance)

### Key Components

1. **Dependencies**:
```solidity
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
```

2. **State Variables**:
- `_tokenIds`: Counter for tracking token IDs
- `_tokenURIs`: Mapping to store token URIs for each token ID

3. **Functions**:
- `constructor()`: Initializes the ERC721 token with name "BasicNFT" and symbol "BNFT"
- `mintNFT()`: Mints a new NFT to a recipient with a specified token URI
- `tokenURI()`: Returns the URI for a given token ID
- `_setTokenURI()`: Internal function to set token URI (called by mintNFT)

## Testing in Remix IDE

Follow these steps to test the BasicNFT contract in Remix IDE:

### 1. Setup

1. Open Remix IDE (https://remix.ethereum.org/)
2. Create a new file named `BasicNFT.sol`
3. Copy and paste the contract code into the file
4. In the "Solidity Compiler" tab:
   - Select compiler version 0.8.x
   - Enable "Auto compile" or click "Compile BasicNFT.sol"

### 2. Deploy the Contract

1. Go to the "Deploy & Run Transactions" tab
2. Select environment: "JavaScript VM" (for testing) or connect to a test network
3. Select "BasicNFT" contract from the dropdown
4. Click "Deploy"
5. Note the deployed contract address in the "Deployed Contracts" section

### 3. Test Scenarios

#### Test 1: Mint an NFT

1. In "Deployed Contracts" section, expand the BasicNFT contract
2. Find the `mintNFT` function
3. Input parameters:
   - recipient: Test address (e.g., use one of the default Remix VM accounts)
   - _tokenURI: Sample URI (e.g., "ipfs://QmTestURI123")
4. Click "transact"
5. Verify:
   - Transaction is successful
   - Function returns a token ID (should be 1 for first mint)

#### Test 2: Check Token URI

1. Use the `tokenURI` function
2. Input parameter:
   - tokenId: Use the ID returned from mintNFT (e.g., 1)
3. Click "call"
4. Verify:
   - Returns the same URI used during minting (e.g., "ipfs://QmTestURI123")

#### Test 3: Mint Another NFT

1. Repeat Test 1 with:
   - Same or different recipient address
   - Different _tokenURI (e.g., "ipfs://QmTestURI456")
2. Verify:
   - New token ID is incremental (e.g., 2)
   - Transaction is successful

#### Test 4: Error Cases

1. **Non-existent token URI**:
   - Call `tokenURI` with non-existent token ID (e.g., 999)
   - Should revert with "ERC721URIStorage: URI query for nonexistent token"

2. **Internal _setTokenURI validation**:
   - Note: This function is internal and can't be called directly
   - The contract prevents setting URIs for non-existent tokens through mintNFT flow

### 4. Verify Contract State

1. Use Remix's debugger to check:
   - `_tokenIds` counter value
   - `_tokenURIs` mapping contents
2. Use `ownerOf` (from ERC721) to verify token ownership:
   - Input: tokenId (e.g., 1)
   - Should return recipient address used during mint

## Additional Notes

- The contract uses OpenZeppelin's ERC721 implementation, which includes standard functions like:
  - `balanceOf()`
  - `ownerOf()`
  - `transferFrom()`
  - `safeTransferFrom()`
- Token URIs should follow a standard format (e.g., IPFS URIs) for metadata
- For production use, consider:
  - Adding access control (e.g., onlyOwner for minting)
  - Implementing burn functionality
  - Adding events for better tracking
  - Gas optimization

## Troubleshooting

- If compilation fails:
  - Check Solidity version compatibility
  - Ensure OpenZeppelin imports are available
- If deployment fails:
  - Verify sufficient gas
  - Check account balance in VM
- If functions revert:
  - Check error messages in Remix console
  - Verify input parameters are correct

