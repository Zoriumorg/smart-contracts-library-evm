# MyToken ERC721 Contract

This README provides an overview of the `MyToken` smart contract, which is an ERC721 non-fungible token (NFT) implementation, and instructions on how to test it using Remix IDE.

## Contract Overview

The `MyToken` contract is an ERC721 token with the following features:

- Inherits from OpenZeppelin's ERC721, ERC721URIStorage, ERC721Burnable, and Ownable contracts
- Allows the owner to safely mint new tokens with associated metadata URIs
- Supports token burning (destroying) functionality
- Implements required override functions for token URI and interface support

### Contract Details

- **Name**: MyToken
- **Symbol**: MTK
- **Solidity Version**: ^0.8.20
- **Dependencies**:
  - @openzeppelin/contracts@5.0.0/token/ERC721/ERC721.sol
  - @openzeppelin/contracts@5.0.0/token/ERC721/extensions/ERC721URIStorage.sol
  - @openzeppelin/contracts@5.0.0/token/ERC721/extensions/ERC721Burnable.sol
  - @openzeppelin/contracts@5.0.0/access/Ownable.sol

### Functions

1. **Constructor**
   - Parameters: `initialOwner` (address)
   - Sets the initial owner of the contract
   - Initializes the ERC721 token with name "MyToken" and symbol "MTK"

2. **safeMint**
   - Parameters:
     - `to` (address): Recipient of the minted token
     - `tokenId` (uint256): Unique identifier for the token
     - `uri` (string): Metadata URI for the token
   - Access: Only callable by the contract owner
   - Mints a new token and sets its metadata URI

3. **tokenURI** (override)
   - Parameters: `tokenId` (uint256)
   - Returns: string (metadata URI for the specified token)
   - View function to retrieve token metadata

4. **supportsInterface** (override)
   - Parameters: `interfaceId` (bytes4)
   - Returns: bool (whether the contract supports the specified interface)
   - View function for interface detection

## Testing in Remix IDE

Follow these steps to test the `MyToken` contract using Remix IDE:

### 1. Setup

1. Open Remix IDE in your browser: https://remix.ethereum.org/
2. Create a new file named `MyToken.sol` and paste the contract code
3. Compile the contract:
   - Go to the "Solidity Compiler" tab
   - Select compiler version 0.8.20
   - Click "Compile MyToken.sol"

### 2. Deployment

1. Go to the "Deploy & Run Transactions" tab
2. Select environment: "Remix VM (Shanghai)"
3. In the "Deploy" section:
   - Enter an initial owner address (or use the default account)
   - Click "Deploy"
4. The deployed contract will appear under "Deployed Contracts"

### 3. Testing Scenarios

#### Test Case 1: Mint a New Token

1. Expand the deployed contract interface
2. Find the `safeMint` function
3. Enter parameters:
   - `to`: Address to receive the token (e.g., another Remix VM account)
   - `tokenId`: 1 (or any unique number)
   - `uri`: "https://example.com/token/1" (or any valid URI)
4. Click "transact" using the owner account
5. Verify:
   - Check transaction status in Remix console
   - Use `ownerOf(1)` to verify token ownership
   - Use `tokenURI(1)` to verify metadata

#### Test Case 2: Transfer Token

1. Use the `transferFrom` function:
   - `from`: Current owner address
   - `to`: New owner address
   - `tokenId`: 1
2. Click "transact"
3. Verify:
   - Use `ownerOf(1)` to confirm new owner
   - Check balances using `balanceOf` for both addresses

#### Test Case 3: Burn Token

1. Use the `burn` function:
   - `tokenId`: 1
2. Click "transact" using the token owner or approved account
3. Verify:
   - Attempt to call `ownerOf(1)` (should revert)
   - Check balance using `balanceOf` for owner address

#### Test Case 4: Test Access Control

1. Try calling `safeMint` with a non-owner account:
   - Switch to a different account in Remix
   - Attempt to mint a new token
2. Verify:
   - Transaction should revert with "Ownable: caller is not the owner"

### 4. Additional Testing Tips

- Test edge cases:
  - Mint with duplicate tokenId (should fail)
  - Burn non-existent token (should fail)
  - Query URI for non-existent token (should fail)
- Use Remix's debugger to step through transactions
- Monitor gas costs for different operations
- Test with multiple accounts to verify access control

## Security Considerations

- Only the owner can mint new tokens
- Token URIs should be valid and point to immutable metadata
- Be cautious with token burning as it's irreversible
- Regularly audit the contract for vulnerabilities
- Consider adding additional access controls or pausability if needed

## License

This contract is licensed under the MIT License (see SPDX identifier in the contract).

