
# Simple Flash Loan using Aave V3

This project demonstrates how to implement a flash loan using Aave V3 on the Polygon Mumbai Testnet. The smart contract (`SimpleFlashLoan.sol`) enables borrowing assets via Aave's flash loan feature, which allows users to borrow funds without collateral, provided the loan is repaid within the same transaction.

The implementation is based on the guide [How to Make a Flash Loan using Aave](https://www.quicknode.com/guides/defi/how-to-make-a-flash-loan-using-aave). Refer to the guide for a detailed explanation of flash loans and Aave V3.

## Prerequisites

Before proceeding, ensure you have the following:

- **MetaMask**: Installed and configured in your browser ([MetaMask](https://metamask.io/)).
- **Polygon Mumbai Testnet Endpoint**: Added to MetaMask via a provider like [QuickNode](https://www.quicknode.com/) or another RPC provider.
- **REMIX IDE**: Access to [Remix IDE](https://remix.ethereum.org/) for compiling and deploying the smart contract.
- **Testnet Funds**: MATIC for gas fees and USDC for paying flash loan fees on the Polygon Mumbai Testnet.
- **Aave V3 Testnet Addresses**: Familiarity with Aave V3 contract addresses for Polygon Mumbai, available at [Aave V3 Testnet Addresses](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses).

## Smart Contract Overview

The `SimpleFlashLoan.sol` contract:
- Inherits from Aave V3's `FlashLoanSimpleReceiverBase` to handle flash loan operations.
- Implements the `fn_RequestFlashLoan` function to initiate a flash loan.
- Includes the `executeOperation` function to process the borrowed funds and repay the loan (including the premium).
- Uses OpenZeppelin's `IERC20` interface for token interactions and Aave's `IPoolAddressesProvider` for pool access.

**Note**: The provided contract is a basic example. You may need to add custom logic in the `executeOperation` function to perform meaningful operations with the borrowed funds (e.g., arbitrage, liquidations).

## Setup and Deployment Steps

### Step 1: Setting Up the Smart Contract in Remix IDE

1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create a new file named `SimpleFlashLoan.sol`.
3. Copy and paste the provided `SimpleFlashLoan.sol` code into the file.
4. Ensure the contract imports are accessible. The contract uses external dependencies from Aave V3 and OpenZeppelin, hosted on GitHub.
5. Compile the contract using a compatible Solidity compiler (e.g., `^0.8.0`).

### Step 2: Deploying the Smart Contract

1. In Remix, switch to the **Deploy & Run Transactions** tab.
2. Select the **Injected Provider - MetaMask** environment and connect MetaMask to the Polygon Mumbai Testnet.
3. Obtain the `PoolAddressesProvider` address for Polygon Mumbai from [Aave V3 Testnet Addresses](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses).
4. Deploy the `SimpleFlashLoan` contract by providing the `PoolAddressesProvider` address as the constructor parameter.
5. Confirm the deployment transaction in MetaMask.

### Step 3: Funding the Contract

To execute a flash loan, the contract needs USDC to cover the flash loan premium (a small fee charged by Aave).

1. Obtain testnet USDC:
   - Visit the [Aave Testnet Faucet](https://staging.aave.com/faucet/).
   - Connect your MetaMask wallet, select the Polygon Mumbai market, and request USDC.
2. Transfer USDC to the deployed contract:
   - In MetaMask, send a small amount of USDC (e.g., 1-10 USDC) to the contract’s address. This will be used to pay the flash loan premium.
3. Verify the contract’s USDC balance using a block explorer like [Mumbai Polygonscan](https://mumbai.polygonscan.com/).

### Step 4: Requesting a Flash Loan

1. In Remix, locate the deployed contract under the **Deployed Contracts** section.
2. Expand the `fn_RequestFlashLoan` function.
3. Provide the following inputs:
   - `_token`: The USDC reserve address on Polygon Mumbai, available at [Aave V3 Testnet Addresses](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses).
   - `_amount`: The amount of USDC to borrow, adjusted for decimals (USDC has 6 decimals, so 10 USDC = `10000000`).
4. Click **Transact** and confirm the transaction in MetaMask.
5. After the transaction is processed, copy the transaction hash and check its status on [Mumbai Polygonscan](https://mumbai.polygonscan.com/).

### Step 5: Verifying the Flash Loan

- On Mumbai Polygonscan, review the transaction details to confirm the flash loan was executed.
- The transaction should show interactions with the Aave V3 Pool, including borrowing and repaying the loan amount plus the premium.
- If successful, the contract will have repaid the loan, and any custom logic in `executeOperation` will have been executed.

## Important Notes

- **Flash Loan Logic**: The provided `executeOperation` function is minimal and only handles loan repayment. Add custom logic (e.g., swapping tokens, arbitrage) to make the flash loan useful. Ensure the logic executes within a single transaction and repays the loan plus the premium.
- **Gas Costs**: Flash loans on Polygon Mumbai require MATIC for gas. Ensure your wallet has sufficient MATIC.
- **Security**: The contract lacks access controls (e.g., restricting `fn_RequestFlashLoan` to the owner). In a production environment, add `onlyOwner` modifiers or similar mechanisms.
- **Testing**: Always test on a testnet before deploying to mainnet. Flash loans are complex and can lead to financial loss if implemented incorrectly.
- **Aave Premium**: Aave charges a small premium (e.g., 0.05% of the borrowed amount) for flash loans. Ensure the contract has enough tokens to cover this fee.

# Make a Flash Loan using Aave V3

This project is based on the guide, [How to Make a Flash Loan using Aave](https://www.quicknode.com/guides/defi/how-to-make-a-flash-loan-using-aave?utm_source=qn-github&utm_campaign=flash_loan&utm_content=sign-up&utm_medium=generic), follow the guide to understand how the smart contract works.

#### Prerequisites
- [MetaMask](https://metamask.io/) installed.
- [QuickNode Polygon Mumbai Testnet endpoint](https://www.quicknode.com/?utm_source=qn-github&utm_campaign=aave_flash_loan&utm_content=sign-up&utm_medium=generic) added to MetaMask.
- [REMIX IDE](https://remix.ethereum.org/)

---
### Step 1️⃣ - Adding the smart contract to REMIX IDE.

Copy the [FlashLoan.sol](https://github.com/quiknode-labs/qn-guide-examples/blob/main/ethereum/aave-flash-loan/FlashLoan.sol) file, create a new file with same name in REMIX IDE.

---
### Step 2️⃣ - Deploying the smart contract.

Deploy the contract with `PoolAddressesProvider-Polygon` value from [Aave docs](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses) as parameter.

![2](https://user-images.githubusercontent.com/41318044/221353771-f2ea1233-ca98-46cb-b087-bdb340d72db4.png)
![3](https://user-images.githubusercontent.com/41318044/221353772-7fa5c127-f64a-432e-ba92-12092fe8b2bb.png)

---
### Step 3️⃣ - Funding the Flash loan. 

We will perform a flash loan to get USDC on Polygon Mumbai Testnet. But first our contract will need some USDC on Polygon Mumbai Testnet to pay as interest fee.
Get some Polygon Mumbai Testnet USDC from [Aave faucet](https://staging.aave.com/faucet/). Connect your wallet, select Polygon Market and Faucet some USDC,

![5](https://user-images.githubusercontent.com/41318044/221354039-ccac56c9-c4fa-4ff1-8955-e91877309d9c.png)

After receiving the USDC send some to the deployed smart contract, this USDC in your contract will be used to pay the interest fee.

---
### Step 4️⃣ - Perform the Flash loan.

Go to [Aave V3 doc's Testnet Addresses page](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses), select Polygon Mumbai, and copy the address of USDC reserve.

![6](https://user-images.githubusercontent.com/41318044/221354212-922675fb-b725-4496-831e-84b819d30b63.png)

Go back to your REMIX IDE tab then expand the smart contract under the Deployed Contracts section and expand the **fn_RequestFlashLoan** function button. Paste the USDC reserve’s address in the **_token** field and enter the amount of USDC to be borrowed (10 in this case) in the **_amount** field. When entering the number of ERC20 tokens in Solidity, we also need to mention the decimals of that ERC20 token. The decimals of USDC is six, so 10 USDC will be 10000000. Click the **transact** button.

![7](https://user-images.githubusercontent.com/41318044/221354253-d651e5e0-8f49-4be4-a5d0-98dcfb08f463.png)

Copy the transaction hash and check it on on [Mumbai Polygonscan](https://mumbai.polygonscan.com/). It will look like this🔽

![8](https://user-images.githubusercontent.com/41318044/221354364-bb219ed0-1a39-4f38-80df-fa80d2a8581f.png)

You have successfully performed a Flash loan using Aave V3