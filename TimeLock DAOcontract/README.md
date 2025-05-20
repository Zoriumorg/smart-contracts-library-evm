
# TimeLock Contract Testing Guide

## Overview
The `TimeLock` contract is a Solidity smart contract designed to queue, execute, and cancel transactions with a time delay mechanism. It ensures that transactions can only be executed after a specified timestamp, within a defined grace period, and only by the contract owner. This guide provides step-by-step instructions to test the `TimeLock` contract using Remix IDE, leveraging two helper contracts: `TimestampHelper` (to retrieve the current block timestamp) and `SimpleTarget` (to test function calls during execution).

### Prerequisites
- **Remix IDE**: Access [Remix](https://remix.ethereum.org/) in a web browser.
- **Contract Files**: Ensure you have the following Solidity files in Remix’s File Explorer:
  - `TimeLock.sol`: The main contract to test.
  - `TimestampHelper.sol`: A helper contract to get the current block timestamp.
  - `SimpleTarget.sol`: A target contract with a `setValue(uint256)` function for testing execution.
- **Basic Knowledge**: Familiarity with Remix, Solidity, and Ethereum transactions.
- **Environment**: Use Remix VM (Cancun) for testing in a simulated blockchain.

## Contract Explanation
The `TimeLock` contract allows the owner to:
- **Queue** transactions to be executed later, specifying a target address, ETH value, function signature, data, and execution timestamp.
- **Execute** queued transactions after the specified timestamp, within a grace period.
- **Cancel** queued transactions before execution.
- **Key Features**:
  - Only the owner can queue, execute, or cancel transactions.
  - Transactions must have a timestamp between `MIN_DELAY` (10 seconds) and `MAX_DELAY` (1000 seconds) from the current block timestamp.
  - Executable transactions must be within `GRACE_PERIOD` (1000 seconds) after the specified timestamp.
  - Events (`Queue`, `Execute`, `Cancel`) are emitted for tracking.
- **Helper Contracts**:
  - `TimestampHelper`: Provides `getCurrentTimestamp()` to fetch the current `block.timestamp`, aiding in setting valid timestamps.
  - `SimpleTarget`: A simple contract with a `setValue(uint256)` function to verify state changes during execution.

## Setup Instructions

### 1. Load Contracts in Remix
- Open Remix IDE at [remix.ethereum.org](https://remix.ethereum.org/).
- In the File Explorer, ensure the following files are present:
  - `TimeLock.sol`
  - `TimestampHelper.sol`
  - `SimpleTarget.sol`
- If files are missing, confirm they are correctly uploaded or created.

### 2. Compile Contracts
- Go to the **Solidity Compiler** tab (left sidebar).
- Select compiler version `0.8.26` (or compatible with your contract’s `pragma`).
- Compile each file:
  - Click `TimeLock.sol` and press "Compile TimeLock.sol".
  - Repeat for `TimestampHelper.sol` and `SimpleTarget.sol`.
- Ensure no compilation errors appear.

### 3. Deploy Contracts
- Go to the **Deploy & Run Transactions** tab.
- Set the environment to **Remix VM (Cancun)**.
- Select the account (e.g., `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`) as the deployer (this becomes the `TimeLock` owner).
- Deploy each contract:
  - Select `TimestampHelper` from the contract dropdown and click **Deploy**. Note the deployed address (e.g., `0xd8b...33fa8`).
  - Select `SimpleTarget` and click **Deploy**. Note the address (e.g., `0xf8e...9fBe8`).
  - Select `TimeLock` and click **Deploy**. Note the address (e.g., `0xd91...39138`).
- Verify deployments in the **Deployed Contracts** section.

### 4. Get Current Timestamp
- Expand `TimestampHelper` in **Deployed Contracts**.
- Call `getCurrentTimestamp()` by clicking the button.
- Note the returned value (e.g., `1747037890`). This is the current `block.timestamp` in seconds since the Unix epoch.
- Use this to calculate valid timestamps for `queue`:
  - **Minimum**: `current_timestamp + MIN_DELAY` (e.g., `1747037890 + 10 = 1747037900`).
  - **Maximum**: `current_timestamp + MAX_DELAY` (e.g., `1747037890 + 1000 = 1747038890`).

## Testing the TimeLock Contract

This section provides detailed steps to test the `queue`, `execute`, and `cancel` functions, along with error cases and edge cases. Each test includes verification steps to confirm correct behavior.

### Test 1: Queue a Transaction
**Goal**: Queue a transaction to call `SimpleTarget.setValue(200)`.

- **Parameters**:
  - `_target`: `SimpleTarget` address (e.g., `0xf8e...9fBe8`).
  - `_value`: `0` (no ETH sent).
  - `_func`: `setValue(uint256)`.
  - `_data`: `0x00000000000000000000000000000000000000000000000000000000000000C8` (hex for 200).
  - `_timestamp`: Current timestamp + 10 (e.g., `1747037900` if current is `1747037890`).
- **Steps**:
  1. In **Deploy & Run Transactions**, expand `TimeLock` at its address.
  2. Find the `queue` function.
  3. Enter the parameters above in the input fields.
  4. Click the orange **transact** button.
- **Verification**:
  - Check the Remix terminal for the transaction receipt.
  - Look for the `Queue` event in the logs, confirming the correct `txId`, `_target`, `_value`, `_func`, `_data`, and `_timestamp`.
  - Call `getTxId` with the same parameters to get the `txId` (e.g., `0x123...456`).
  - Call `queued` with the `txId` and confirm it returns `true`.

### Test 2: Execute a Transaction
**Goal**: Execute the queued transaction to update `SimpleTarget.value` to `200`.

- **Check Timestamp**:
  - Ensure `block.timestamp >= _timestamp` (e.g., `1747037900`). Call `TimestampHelper.getCurrentTimestamp()` to confirm.
  - If the current timestamp is less, wait a few seconds or queue a new transaction with a closer `_timestamp` (e.g., current + 5).
- **Steps**:
  1. In `TimeLock`, find the `execute` function.
  2. Enter the same parameters as in Test 1:
     - `_target`: `SimpleTarget` address.
     - `_value`: `0`.
     - `_func`: `setValue(uint256)`.
     - `_data`: `0x00000000000000000000000000000000000000000000000000000000000000C8`.
     - `_timestamp`: `1747037900`.
  3. Click **transact**.
- **Verification**:
  - Check the terminal for the `Execute` event with the correct `txId` and parameters.
  - Call `queued` with the `txId` (from `getTxId`) and confirm it returns `false`.
  - Expand `SimpleTarget` in **Deployed Contracts**.
  - Call `value` and confirm it returns `200`.

### Test 3: Cancel a Transaction
**Goal**: Queue a new transaction and cancel it.

- **Queue a New Transaction**:
  - Parameters:
    - `_target`: `SimpleTarget` address.
    - `_value`: `0`.
    - `_func`: `setValue(uint256)`.
    - `_data`: `0x000000000000000000000000000000000000000000000000000000000000012C` (hex for 300).
    - `_timestamp`: Current timestamp + 20 (e.g., `1747037910`).
  - Follow Test 1 steps to queue the transaction.
  - Call `getTxId` to get the `txId` (e.g., `0x789...abc`).
  - Verify `queued(txId)` returns `true`.
- **Cancel**:
  1. In `TimeLock`, find the `cancel` function.
  2. Enter `_txId`: The `txId` from `getTxId`.
  3. Click **transact**.
- **Verification**:
  - Check the terminal for the `Cancel` event with the correct `txId`.
  - Call `queued` with the `txId` and confirm it returns `false`.
  - Call `SimpleTarget.value` to ensure it remains `200` (no change).

### Test 4: Error Cases
**Goal**: Test reverts for invalid operations to ensure contract robustness.

- **Non-Owner Access**:
  1. In the **Deploy & Run Transactions** tab, change the account to a non-owner (e.g., `0xAb8...12345`).
  2. Try calling `queue`, `execute`, or `cancel` with any parameters.
  3. Expect a revert with `NotOwnerError` in the terminal.
  4. Switch back to the owner account.

- **Invalid Timestamp (Too Early)**:
  1. Queue a transaction with `_timestamp = current_timestamp` (e.g., `1747037890`).
  2. Use the same parameters as Test 1, but adjust `_timestamp`.
  3. Expect a revert with `TimestampNotInRangeError`.

- **Invalid Timestamp (Too Late)**:
  1. Queue with `_timestamp = current_timestamp + 2000` (e.g., `1747039890`).
  2. Expect a revert with `TimestampNotInRangeError`.

- **Execute Before Timestamp**:
  1. Queue a transaction with `_timestamp = current_timestamp + 60` (e.g., `1747037950`).
  2. Immediately try `execute` with the same parameters.
  3. Expect a revert with `TimestampNotPassedError`.

- **Execute After Grace Period**:
  1. Queue a transaction with an earlier `_timestamp` (e.g., `1747036890`, if available from earlier `TimestampHelper` calls).
  2. Ensure `block.timestamp > _timestamp + GRACE_PERIOD` (e.g., `1747036890 + 1000 = 1747037890`).
  3. Try `execute`. Expect a revert with `TimestampExpiredError`.
  4. Note: This may require redeploying `TimeLock` with an earlier timestamp due to Remix VM limitations.

- **Non-Queued Transaction**:
  1. Try `execute` or `cancel` with a fake `txId` (e.g., `0x000...000`).
  2. Expect a revert with `NotQueuedError`.

- **Invalid Function Call**:
  1. Queue a transaction with `_func: "nonExistent()"`, `_data: 0x00`.
  2. After `_timestamp`, try `execute`.
  3. Expect a revert with `TxFailedError`.

### Test 5: Edge Cases
**Goal**: Test boundary conditions for timestamps and grace periods.

- **Queue at Minimum Delay**:
  1. Queue with `_timestamp = current_timestamp + MIN_DELAY` (e.g., `1747037900`).
  2. Verify successful queuing.

- **Queue at Maximum Delay**:
  1. Queue with `_timestamp = current_timestamp + MAX_DELAY` (e.g., `1747038890`).
  2. Verify successful queuing.

- **Execute at Exact Timestamp**:
  1. Queue with `_timestamp` close to current (e.g., `current + 5`).
  2. Wait until `block.timestamp >= _timestamp` and execute.
  3. Verify success.

- **Execute at Grace Period Boundary**:
  1. Queue with an earlier `_timestamp`.
  2. Execute when `block.timestamp = _timestamp + GRACE_PERIOD - 1`.
  3. Verify success.

## Handling Time Manipulation in Remix VM
Remix VM doesn’t allow direct time advancement, posing challenges for testing time-based logic. Use these workarounds:
- **Near-Future Timestamps**: Queue transactions with `_timestamp` close to the current timestamp (e.g., `current + 10`) for immediate testing of `execute`.
- **Redeploy for Past Timestamps**: To test `TimestampExpiredError`, redeploy `TimeLock` and use an earlier `_timestamp` (e.g., from previous `TimestampHelper` calls).
- **Log Timestamps**: Call `TimestampHelper.getCurrentTimestamp()` before each test to ensure accurate `_timestamp` calculations.
- **Local Testnet (Optional)**: For precise control, use Hardhat or Foundry to manipulate `block.timestamp` via `evm_increaseTime`.

## Advanced Testing (Optional)
To automate and streamline testing:
- **JavaScript Tests**:
  - Create a file (e.g., `testTimeLock.js`) in Remix.
  - Use `web3.js` or `ethers.js` to script test cases.
  - Example: Queue a transaction, wait, execute, and check `SimpleTarget.value`.
  - Run with `remix.execute()` in the terminal.
- **Gas Optimization**:
  - Monitor gas usage in the terminal. If transactions fail, increase the gas limit (e.g., from `3000000` to `5000000`).
- **Reset State**:
  - If the contract state becomes cluttered, click **EnvironmentReset State** in Remix to redeploy fresh contracts.

## Troubleshooting
- **Transaction Reverts**:
  - Check the terminal for error details (e.g., `NotOwnerError`, `TimestampNotInRangeError`).
  - Ensure correct parameters, valid timestamps, and sufficient gas.
- **Function Mismatch**:
  - If `execute` fails with `TxFailedError`, verify `_func` matches a function in `SimpleTarget` (e.g., `setValue(uint256)`).
- **Timestamp Issues**:
  - Always use `TimestampHelper` to get the current timestamp before queuing.
  - Recalculate `_timestamp` if tests fail due to time mismatches.
- **AlreadyQueuedError**:
  - If queuing fails, check if the `txId` is already queued. Cancel it or use different parameters.

## Conclusion
This guide enables thorough testing of the `TimeLock` contract in Remix, covering all functions, error cases, and edge cases. By using `TimestampHelper` for accurate timestamps and `SimpleTarget` for state verification, you can confirm the contract’s functionality. For advanced testing or time manipulation, consider local testnets or JavaScript automation. If issues arise, refer to the troubleshooting section or consult the Remix terminal logs for detailed error messages.


