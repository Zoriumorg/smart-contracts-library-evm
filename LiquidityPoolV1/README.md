
# LiquidityPoolV1 and TestToken Contracts

This repository contains two Solidity smart contracts: `LiquidityPoolV1`, a Uniswap V2-style Automated Market Maker (AMM) liquidity pool, and `TestToken`, a simple ERC-20 token implementation for testing purposes. The contracts are designed to work together to facilitate token swaps, liquidity provision, and liquidity removal.

## Table of Contents
- [LiquidityPoolV1 and TestToken Contracts](#liquiditypoolv1-and-testtoken-contracts)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Contract Details](#contract-details)
    - [TestToken](#testtoken)
    - [LiquidityPoolV1](#liquiditypoolv1)
  - [Deploying on Remix](#deploying-on-remix)
    - [Step-by-Step Deployment](#step-by-step-deployment)
  - [Testing on Remix](#testing-on-remix)
    - [Test Scenarios](#test-scenarios)
      - [1. Approve Token Transfers](#1-approve-token-transfers)
      - [2. Add Liquidity](#2-add-liquidity)
      - [3. Swap Tokens](#3-swap-tokens)
      - [4. Remove Liquidity](#4-remove-liquidity)
      - [5. Update Fee (Optional)](#5-update-fee-optional)
    - [Notes for Testing](#notes-for-testing)
  - [Security Considerations](#security-considerations)
  - [License](#license)

## Overview
- **TestToken**: An ERC-20 token contract that mints an initial supply of tokens to the deployer. Used as a token pair in the liquidity pool.
- **LiquidityPoolV1**: A Uniswap V2-style AMM liquidity pool that supports:
  - Adding liquidity to the pool.
  - Removing liquidity from the pool.
  - Swapping tokens with a 0.3% default fee.
  - Price impact protection (max 10%).
  - Reentrancy protection using OpenZeppelin's `ReentrancyGuard`.

## Prerequisites
To deploy and test these contracts, you need:
- **Remix IDE**: Access Remix at [remix.ethereum.org](https://remix.ethereum.org/).
- **MetaMask**: A browser extension wallet for interacting with Ethereum networks.
- **Testnet ETH**: For deployment on a test network (e.g., Sepolia, Goerli).
- **Solidity Compiler**: Remix supports Solidity ^0.8.20.
- **OpenZeppelin Contracts**: The contracts use OpenZeppelin's ERC20, ReentrancyGuard, and Math libraries.

## Contract Details

### TestToken
- **Purpose**: A simple ERC-20 token for testing the liquidity pool.
- **Key Features**:
  - Constructor accepts `name`, `symbol`, and `initialSupply`.
  - Mints `initialSupply * 10^decimals()` tokens to the deployer.
- **File**: `TestToken.sol`

### LiquidityPoolV1
- **Purpose**: A decentralized AMM liquidity pool for swapping two ERC-20 tokens.
- **Key Features**:
  - Supports token pairs with automatic sorting (`token0` < `token1` by address).
  - Liquidity provision with proportional token amounts to maintain the pool ratio.
  - Liquidity removal with proportional token withdrawals.
  - Token swaps with a configurable fee (default 0.3%).
  - Price impact protection (max 10%).
  - Events for liquidity addition/removal, swaps, and fee updates.
- **File**: `LiquidityPoolV1.sol`

## Deploying on Remix

### Step-by-Step Deployment
1. **Open Remix IDE**:
   - Go to [remix.ethereum.org](https://remix.ethereum.org/).

2. **Set Up the Environment**:
   - In the **Deploy & Run Transactions** tab, select **Injected Provider - MetaMask** as the environment.
   - Connect MetaMask to a test network (e.g., Sepolia) and ensure you have testnet ETH.

3. **Create Contract Files**:
   - In the **File Explorer** tab, create two files:
     - `TestToken.sol`: Copy and paste the `TestToken` contract code.
     - `LiquidityPoolV1.sol`: Copy and paste the `LiquidityPoolV1` contract code.

4. **Install OpenZeppelin Dependencies**:
   - Remix automatically fetches OpenZeppelin contracts from npm when you compile. Ensure your contracts include the correct import paths:
     ```solidity
     import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
     import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
     import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
     import "@openzeppelin/contracts/utils/math/Math.sol";
     ```

5. **Compile the Contracts**:
   - Go to the **Solidity Compiler** tab.
   - Select compiler version `0.8.20` (or compatible).
   - Compile `TestToken.sol` and `LiquidityPoolV1.sol`. Ensure no errors appear.

6. **Deploy TestToken Contracts**:
   - In the **Deploy & Run Transactions** tab, select `TestToken` from the contract dropdown.
   - Provide constructor parameters:
     - `name`: e.g., "Token A"
     - `symbol`: e.g., "TKA"
     - `initialSupply`: e.g., `1000000` (1 million tokens)
   - Click **Deploy** and confirm the transaction in MetaMask.
   - Repeat for a second token (e.g., "Token B", "TKB", `1000000`).
   - Note the deployed contract addresses for both tokens.

7. **Deploy LiquidityPoolV1**:
   - Select `LiquidityPoolV1` from the contract dropdown.
   - Provide constructor parameters:
     - `_tokenA`: Address of the first token (e.g., Token A).
     - `_tokenB`: Address of the second token (e.g., Token B).
   - Click **Deploy** and confirm the transaction in MetaMask.
   - Note the deployed `LiquidityPoolV1` contract address.

## Testing on Remix

### Test Scenarios
Below are steps to test the core functionalities of `LiquidityPoolV1` using Remix.

#### 1. Approve Token Transfers
- **Why**: The liquidity pool requires users to approve token transfers before adding liquidity or swapping.
- **Steps**:
  - In Remix, select the `TestToken` contract (e.g., Token A).
  - Use the `approve` function:
    - `spender`: The `LiquidityPoolV1` contract address.
    - `amount`: e.g., `1000000000000000000000` (1000 tokens, adjusted for 18 decimals).
  - Repeat for the second token (e.g., Token B).
  - Confirm transactions in MetaMask.

#### 2. Add Liquidity
- **Why**: Test liquidity provision and minting of liquidity tokens.
- **Steps**:
  - Select the `LiquidityPoolV1` contract in Remix.
  - Call the `addLiquidity` function:
    - `amount0Desired`: e.g., `100000000000000000000` (100 tokens of token0).
    - `amount1Desired`: e.g., `100000000000000000000` (100 tokens of token1).
  - Confirm the transaction in MetaMask.
  - Verify:
    - Check the `LiquidityAdded` event in the transaction logs.
    - Call `balanceOf` with your address to see minted liquidity tokens.
    - Call `getReserves` to confirm updated reserves.

#### 3. Swap Tokens
- **Why**: Test token swapping with fee and slippage protection.
- **Steps**:
  - Approve additional tokens for swapping (if needed) using the `approve` function.
  - Call the `swap` function:
    - `tokenIn`: Address of the input token (e.g., Token A).
    - `amountIn`: e.g., `10000000000000000000` (10 tokens).
    - `minAmountOut`: e.g., `9500000000000000000` (9.5 tokens, accounting for 0.3% fee and slippage).
  - Confirm the transaction in MetaMask.
  - Verify:
    - Check the `Swap` event in the transaction logs.
    - Call `getReserves` to confirm updated reserves.
    - Check your wallet balance for the output token.

#### 4. Remove Liquidity
- **Why**: Test liquidity removal and token withdrawals.
- **Steps**:
  - Call the `removeLiquidity` function:
    - `liquidity`: Amount of liquidity tokens to burn (e.g., half of your `balanceOf`).
  - Confirm the transaction in MetaMask.
  - Verify:
    - Check the `LiquidityRemoved` event in the transaction logs.
    - Check your wallet balance for withdrawn tokens.
    - Call `getReserves` to confirm updated reserves.

#### 5. Update Fee (Optional)
- **Why**: Test the fee update functionality (admin-only in a production environment).
- **Steps**:
  - Call the `setFee` function:
    - `newFee`: e.g., `50` (0.5%).
  - Confirm the transaction in MetaMask.
  - Verify:
    - Check the `FeeUpdated` event in the transaction logs.
    - Perform a swap to confirm the new fee is applied.

### Notes for Testing
- **Decimals**: Ensure token amounts account for 18 decimals (e.g., `1 token = 1e18 wei`).
- **Gas Costs**: Testnet transactions require ETH. Monitor gas usage in MetaMask.
- **Errors**: If transactions fail, check for:
  - Insufficient token approvals.
  - Invalid token addresses or amounts.
  - Slippage or price impact violations.

## Security Considerations
- **Reentrancy**: The contract uses `ReentrancyGuard` to prevent reentrancy attacks.
- **Price Impact**: Swaps are limited to a 10% price impact to protect against manipulation.
- **Fee Limits**: The fee is capped at 1% to prevent abuse.
- **Admin Control**: The `setFee` function lacks access control (e.g., Ownable). In production, restrict it to an admin.
- **Dust Attacks**: Initial liquidity requires at least 1000 tokens to prevent dust attacks.
- **Testing**: Thoroughly test on testnets before mainnet deployment.
- **Audits**: For production, conduct a professional security audit.

## License
The contracts are licensed under the MIT License. See the `SPDX-License-Identifier` in the contract files.
