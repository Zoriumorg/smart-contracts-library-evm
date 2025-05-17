# ERC4907 NFT Rental Contract

## Overview
This project implements an ERC4907 contract, an extension of the ERC721 standard, which introduces a rental mechanism for NFTs. It allows NFT owners to set a temporary user for an NFT with an expiration timestamp. The user can utilize the NFT until the rental period expires, after which control reverts to the owner. The contract includes an interface (IERC4907) defining the rental functionality and the main contract (ERC4907) implementing it.

## Prerequisites
- Basic understanding of Ethereum, Solidity, and ERC721.
- Access to the [Remix IDE](https://remix.ethereum.org/).
- A wallet (e.g., MetaMask) with testnet ETH for deployment and testing.
- Familiarity with OpenZeppelin contracts.

## Contract Explanation
- **IERC4907 Interface**: Defines the standard for NFT rental, including events and functions to set and retrieve temporary users and their expiration timestamps.
- **ERC4907 Contract**: Extends ERC721 and implements IERC4907. It includes:
  - A structure to store user information (address and expiration).
  - Functions to set a user, check the current user, and retrieve expiration details.
  - Logic to clear user data on token transfer.
  - A simple mint function for creating NFTs.
  - Support for interface detection.

## Deployment in Remix

### Step 1: Set Up Remix
1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create two new files in the Remix file explorer:
   - `IERC4907.sol` for the interface.
   - `ERC4907.sol` for the main contract.
3. Copy the respective contract code into each file (not included in this README).

### Step 2: Import OpenZeppelin Dependency
- The ERC4907 contract depends on OpenZeppelin's ERC721 contract.
- In Remix, go to the **File Explorer** and create a new file named `.deps/ERC721.sol`.
- Copy the ERC721 contract code from [OpenZeppelin's GitHub](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol) or use Remix's built-in OpenZeppelin import:
  - In `ERC4907.sol`, ensure the import statement is:
    ```solidity
    import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
    ```
  - Remix will automatically fetch the contract from npm if connected to the internet.

### Step 3: Compile the Contracts
1. Go to the **Solidity Compiler** tab in Remix.
2. Select the compiler version `0.8.x` (ensure it matches `pragma solidity ^0.8.0`).
3. Enable **Auto-compile** or click **Compile ERC4907.sol**.
4. Ensure no compilation errors appear. Fix any issues (e.g., missing imports).

### Step 4: Deploy the Contract
1. Go to the **Deploy & Run Transactions** tab.
2. Select the **JavaScript VM (London)** environment for testing or connect to a testnet (e.g., Sepolia) via MetaMask for real deployment.
3. In the **Contract** dropdown, select `ERC4907`.
4. Provide constructor arguments:
   - `name_`: The name of the NFT collection (e.g., "RentalNFT").
   - `symbol_`: The symbol of the NFT collection (e.g., "RNFT").
5. Click **Deploy**.
6. Confirm the transaction in MetaMask (if using a testnet).
7. Note the deployed contract address in the **Deployed Contracts** section.

## Testing in Remix

### Step 1: Mint an NFT
1. In the **Deployed Contracts** section, expand the deployed `ERC4907` contract.
2. Call the `mint` function:
   - Input a `tokenId` (e.g., `1`).
   - Click **transact**.
   - Verify the transaction is successful.
3. Call `ownerOf` with `tokenId` (e.g., `1`) to confirm the NFT is owned by the caller’s address.

### Step 2: Set a User (Rent the NFT)
1. Call the `setUser` function:
   - `tokenId`: The NFT ID (e.g., `1`).
   - `user`: The address of the temporary user (e.g., another test account from Remix’s JavaScript VM).
   - `expires`: A UNIX timestamp in seconds (e.g., current time + 3600 for 1 hour). Use the `time` function to get the current timestamp.
2. Click **transact** and confirm the transaction.
3. Verify the `UpdateUser` event in the transaction logs.

### Step 3: Check User and Expiration
1. Call `userOf` with `tokenId` (e.g., `1`) to retrieve the current user address.
   - If the expiration is valid, it returns the user address.
   - If expired, it returns the owner’s address.
2. Call `userExpires` with `tokenId` (e.g., `1`) to check the expiration timestamp.
   - If valid, it returns the set timestamp.
   - If expired, it returns a large number.

### Step 4: Transfer the NFT
1. Call `transferFrom` or `safeTransferFrom` to transfer the NFT to another address.
2. Verify that the user data is cleared:
   - Call `userOf` and `userExpires` to confirm the user is reset to the zero address and expiration is cleared.
   - Check the `UpdateUser` event in the transaction logs.

### Step 5: Test Edge Cases
- Try setting a user for a non-existent `tokenId` (should fail).
- Try setting a user as a non-owner or non-approved address (should fail).
- Test with an expired timestamp to ensure `userOf` returns the owner.

## Deployment to a Testnet
1. Connect MetaMask to a testnet (e.g., Sepolia).
2. Fund your wallet with testnet ETH from a faucet.
3. In Remix, switch the environment to **Injected Provider - MetaMask**.
4. Deploy the contract as described above.
5. Interact with the contract on the testnet using Remix or ethers.js/hardhat for advanced testing.

## Notes
- Ensure sufficient gas when deploying or interacting on a testnet/mainnet.
- The `mint` function is basic and may need restrictions (e.g., onlyOwner) for production.
- Test thoroughly before deploying to mainnet, as the contract allows user rentals without additional access controls.

## Troubleshooting
- **Compilation Errors**: Check import paths and Solidity version compatibility.
- **Transaction Failures**: Ensure the caller is the owner/approved for `setUser`, and verify gas limits.
- **Event Not Emitted**: Confirm the function executed successfully and check Remix’s transaction logs.

## License
The contracts are licensed under CC0-1.0, allowing free use and modification.

