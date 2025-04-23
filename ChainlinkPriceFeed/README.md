# PriceFeedConsumer Smart Contract

## Overview

The `PriceFeedConsumer` smart contract is designed to fetch real-world price data for ETH/USD using Chainlink’s decentralized price feed oracles on the Polygon Mumbai testnet. This contract demonstrates how to integrate Chainlink Data Feeds to retrieve accurate, tamper-proof price data for use in decentralized applications (dApps). Key features include:

- Fetching the latest ETH/USD price with validation for data integrity.
- Storing price and timestamp for later access.
- Emitting events for price updates.
- Providing human-readable price formatting and decimal information.

### Use Case
This contract is ideal for dApps requiring reliable price data, such as:
- Decentralized finance (DeFi) protocols for asset pricing.
- Stablecoin pegging mechanisms.
- Automated trading or arbitrage systems.

### Contract Details
- **Network**: Polygon Mumbai Testnet (Chain ID: 80001)
- **Price Feed**: ETH/USD (Address: `0x0715A7794a1dc8e42615F059dD6e406A6594651A`)
- **Solidity Version**: `^0.8.20`
- **Dependencies**: Chainlink’s `AggregatorV3Interface` ([Chainlink Contracts](https://github.com/smartcontractkit/chainlink))

For more information on Chainlink Data Feeds, refer to the [Chainlink Documentation](https://docs.chain.link/docs/data-feeds/).

## Prerequisites

To deploy and test the `PriceFeedConsumer` contract, you need:

1. **MetaMask**:
   - Install [MetaMask](https://metamask.io/) browser extension.
   - Configure the Polygon Mumbai testnet:
     - **Network Name**: Polygon Mumbai
     - **RPC URL**: `https://rpc-mumbai.maticvigil.com`
     - **Chain ID**: 80001
     - **Currency Symbol**: MATIC
     - **Block Explorer**: `https://mumbai.polygonscan.com`
   - Fund your wallet with testnet MATIC using the [Polygon Faucet](https://faucet.polygon.technology/) (select Mumbai network).

2. **Remix IDE**:
   - Access [Remix IDE](https://remix.ethereum.org/) for writing, compiling, and deploying the contract.

3. **Basic Solidity Knowledge**:
   - Familiarity with Solidity syntax, contract deployment, and interacting with smart contracts.

4. **Polygon Mumbai Price Feed**:
   - The contract uses the ETH/USD price feed at `0x0715A7794a1dc8e42615F059dD6e406A6594651A`. Verify its status in the [Chainlink Price Feeds Documentation](https://docs.chain.link/docs/matic-addresses/).

## Setup Instructions

### Step 1: Configure MetaMask
1. Add the Polygon Mumbai testnet to MetaMask using the details above.
2. Request testnet MATIC from the [Polygon Faucet](https://faucet.polygon.technology/).
3. Verify your wallet has at least 0.1 MATIC for gas fees.

### Step 2: Set Up Remix
1. Open [Remix IDE](https://remix.ethereum.org/).
2. Ensure the `PriceFeedConsumer.sol` contract is in the `contracts` folder (already provided in the repository).
3. In the **Deploy & Run Transactions** tab:
   - Set **Environment** to **Injected Provider - MetaMask**.
   - Connect MetaMask to Remix and confirm it’s on the Polygon Mumbai network (Chain ID: 80001).

## Deployment Instructions

### Step 1: Compile the Contract
1. Go to the **Solidity Compiler** tab in Remix.
2. Select compiler version `0.8.20` (or compatible with `^0.8.20`).
3. Click **Compile PriceFeedConsumer.sol**.
4. Check for compilation errors. If the Chainlink import (`@chainlink/contracts/...`) fails:
   - Ensure an internet connection for GitHub access.
   - Alternatively, copy `AggregatorV3Interface.sol` from [Chainlink’s GitHub](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol).

### Step 2: Deploy the Contract
1. Go to the **Deploy & Run Transactions** tab.
2. Select `PriceFeedConsumer` from the **Contract** dropdown.
3. In the constructor input field, enter the ETH/USD price feed address: `0x0715A7794a1dc8e42615F059dD6e406A6594651A`.
4. Click **Deploy**.
5. MetaMask will prompt for confirmation. Set:
   - **Gas Price**: 30–50 Gwei (check [Polygon Gas Station](https://gasstation.polygon.technology/mumbai)).
   - **Gas Limit**: ~1,000,000 (for contract deployment).
6. Approve the transaction and wait for confirmation (5–30 seconds on Mumbai).

### Step 3: Verify Deployment
- After deployment, the contract appears under **Deployed Contracts** in Remix.
- Copy the contract address and verify it on [Polygonscan](https://mumbai.polygonscan.com/) or [Blockscout](https://polygon.blockscout.com/).
- **Deployment Transaction**:
  - **Hash**: `0x6291c7a67a41c8794c59e03bec6ff59d4b4c9acb8e074ddd5ec3e10de013561d`
  - **Blockscout Link**: [View Transaction](https://polygon.blockscout.com/tx/0x6291c7a67a41c8794c59e03bec6ff59d4b4c9acb8e074ddd5ec3e10de013561d)
- **Screenshot**: See `./deployment.png` for the deployed contract in Remix (to be added).

## Testing Instructions

### Overview
The contract provides the following functions for testing:
- `getLatestPrice()`: Fetches and stores the latest ETH/USD price, emits `PriceFetched` event.
- `readLatestPrice()`: Returns the stored price and timestamp (view function, no gas).
- `getFormattedPrice()`: Returns the price in human-readable format (without decimals).
- `getDecimals()`: Returns the price feed’s decimal places (typically 8).

### Step-by-Step Testing
1. **Expand the Deployed Contract**:
   - In Remix’s **Deployed Contracts** section, expand the `PriceFeedConsumer` contract to access its functions.

2. **Test `getDecimals`**:
   - Click the `getDecimals` button.
   - **Expected Output**: `8` (the number of decimals for the ETH/USD feed).
   - **Purpose**: Confirms the price feed’s decimal configuration.

3. **Test `getLatestPrice`**:
   - Click the `getLatestPrice` button.
   - MetaMask will prompt for a gas fee (minimal, as it’s a state-changing call).
   - **Expected Output**: A positive integer (e.g., `305000000000` for 3050 USD, with 8 decimals).
   - **Note**: The price is scaled by `10^8`. Divide by `10^8` for human-readable value (e.g., `305000000000 / 10^8 = 3050` USD).
   - **Event**: Check the transaction logs in Remix for the `PriceFetched` event, containing the price and timestamp.
   - **Transaction**:
     - **Hash**: `0x9ceff5b0b9a45642f5dd7e2e78e27249ff25b32852c82f2a38035075e47002f3`
     - **Blockscout Link**: [View Transaction](https://polygon.blockscout.com/tx/0x9ceff5b0b9a45642f5dd7e2e78e27249ff25b32852c82f2a38035075e47002f3)

4. **Test `readLatestPrice`**:
   - Click the `readLatestPrice` button.
   - **Expected Output**: A tuple `(price, timestamp)` (e.g., `(305000000000, 1739981234)`).
   - **Purpose**: Verifies the stored price and timestamp without a transaction.

5. **Test `getFormattedPrice`**:
   - Click the `getFormattedPrice` button.
   - **Expected Output**: A human-readable price (e.g., `3050` for 3050 USD).
   - **Purpose**: Simplifies price display by removing decimals.

6. **Test State Variables**:
   - Click `latestPrice` and `latestTimestamp`.
   - **Expected Outputs**:
     - `latestPrice`: Matches the last `getLatestPrice` result (e.g., `305000000000`).
     - `latestTimestamp`: Matches the timestamp from `readLatestPrice` (e.g., `1739981234`).

7. **Repeat Tests**:
   - Call `getLatestPrice` multiple times to ensure consistent price updates.
   - Verify `latestPrice` and `latestTimestamp` update accordingly.
   - **Screenshot**: See `screenshots/testing.png` for the tested contract in Remix (to be added).

### Example Test Case
- **getDecimals**: Returns `8`.
- **getLatestPrice**: Returns `305000000000`, emits `PriceFetched(305000000000, 1739981234)`.
- **readLatestPrice**: Returns `(305000000000, 1739981234)`.
- **getFormattedPrice**: Returns `3050`.
- **latestPrice**: Returns `305000000000`.
- **latestTimestamp**: Returns `1739981234`.

## Pending Transactions

The following transactions were reported as pending:
1. **Deployment**:
   - **Hash**: `0xc26...7ba93` (block: 70612988, txIndex: 42)
   - **Status**: Check on [Polygon Blockscout](https://polygon.blockscout.com/tx/0xc26...7ba93).
   - **Resolution**:
     - If pending, speed up in MetaMask (increase gas price to 50 Gwei).
     - If failed, redeploy with sufficient gas (limit: 1,000,000) and MATIC.
2. **getLatestPrice Call**:
   - **Hash**: `0x0dd...cfe94` (block: 70612997, txIndex: 52)
   - **Status**: Check on [Polygon Blockscout](https://polygon.blockscout.com/tx/0x0dd...cfe94).
   - **Resolution**:
     - Speed up or cancel in MetaMask.
     - Retry the call after confirming sufficient MATIC.

To prevent pending transactions:
- Use a gas price of 30–50 Gwei (check [Polygon Gas Station](https://gasstation.polygon.technology/mumbai)).
- Ensure your wallet has >0.1 MATIC.
- Verify the nonce in MetaMask (each transaction should increment the nonce).

## Troubleshooting

- **Transaction Pending/Failed**:
  - Check gas price and limit. Increase to 50 Gwei and 1,000,000 if needed.
  - Fund your wallet with MATIC via [Polygon Faucet](https://faucet.polygon.technology/).
  - Cancel stuck transactions by sending a 0 MATIC transaction with the same nonce.
- **Wrong Network**:
  - Ensure MetaMask is on Polygon Mumbai (Chain ID: 80001, not 137).
- **Price Feed Reverts**:
  - Verify the price feed address (`0x0715A7794a1dc8e42615F059dD6e406A6594651A`).
  - Check feed activity on [Polygonscan](https://mumbai.polygonscan.com/address/0x0715A7794a1dc8e42615F059dD6e406A6594651A).
  - **Screenshot**: See `./contract.png` 
- **Import Errors**:
  - Manually copy `AggregatorV3Interface.sol` if the GitHub import fails.
- **No Price Returned**:
  - Ensure the Mumbai testnet is active and the price feed is operational.
  - Call `getDecimals` to confirm feed connectivity.

## Screenshots

- **Deployment**: `screenshots/deployment.png` shows the contract deployed in Remix with the constructor input (`0x0715A7794a1dc8e42615F059dD6e406A6594651A`) and the contract address displayed. (Add this screenshot from your Remix interface.)
- **Testing**: `screenshots/testing.png` shows the Remix interface with function calls (`getLatestPrice`, `readLatestPrice`, etc.) and their outputs (e.g., price: `305000000000`, decimals: `8`). (Add this screenshot from your Remix interface.)

## Chainlink Resources

- [Chainlink Data Feeds](https://docs.chain.link/docs/data-feeds/): Overview of price feeds and their usage.
- [Polygon Price Feeds](https://docs.chain.link/docs/matic-addresses/): List of price feed addresses for Polygon networks.
- [Chainlink GitHub](https://github.com/smartcontractkit/chainlink): Source code for `AggregatorV3Interface`.

## Notes

- **Chainlink Price Feeds**: Free to read (no LINK tokens required) as data is on-chain.
- **Polygon Mumbai**: Suitable for testing but transitioning to Amoy testnet. For mainnet, use Polygon Mainnet (Chain ID: 137) with the appropriate price feed address.
- **Security**: The contract includes basic validation (`require` statements). For production, add checks for round completeness and stale data timeouts.
- **Repository**: The `PriceFeedConsumer.sol` contract is in the `contracts` folder. Do not modify it unless extending functionality.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.



