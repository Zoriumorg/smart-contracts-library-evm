# AdvancedRandomNumberContract README

## Overview
`AdvancedRandomNumberContract` is a Solidity smart contract that leverages Chainlink VRF (Verifiable Random Function) to generate cryptographically secure random numbers on the Ethereum blockchain (Sepolia testnet). It supports requesting multiple random numbers and retrieving them either by request ID or by user address. The contract also includes an ETH fee mechanism for requests and withdrawal functionality for the owner.

- **Solidity Version**: `^0.8.19`
- **License**: MIT
- **Network**: Sepolia testnet (configured with Chainlink VRF parameters)
- **Dependencies**: Chainlink VRF v2+ contracts

### Features
- **Request Random Numbers**: Request 1–10 random numbers with a custom range (currently mapped to 1–100 in `fulfillRandomWords`).
- **Secure Randomness**: Uses Chainlink VRF for verifiable, tamper-proof randomness.
- **Fee System**: Requires 0.001 ETH per request, withdrawable by the owner.
- **Event Logging**: Emits events for request and fulfillment tracking.

## Prerequisites
- **Remix IDE**: Use Remix (https://remix.ethereum.org/) for deployment and testing.
- **MetaMask**: Connected to Sepolia testnet with Sepolia ETH and LINK tokens.
- **Chainlink Subscription**: A funded VRF subscription on Sepolia (created at `vrf.chain.link`).
- **Test Funds**:
  - Sepolia ETH (from a faucet like https://sepoliafaucet.com/).
  - Sepolia LINK (from https://faucets.chain.link/sepolia).

## Deployment Instructions
1. **Set Up Remix**:
   - Open Remix (https://remix.ethereum.org/).
   - Create a new file named `AdvancedRandomNumberContract.sol` and paste the contract code.

2. **Compile the Contract**:
   - In the "Solidity Compiler" tab, select version `0.8.19`.
   - Enable "Auto compile" or click "Compile AdvancedRandomNumberContract.sol".

3. **Configure Chainlink Subscription**:
   - Go to `vrf.chain.link`, log in, and create a new VRF v2+ subscription on Sepolia.
   - Fund it with at least 5 LINK (testnet LINK from the faucet).
   - Note your `subscriptionId` (e.g., `1234`).

4. **Deploy the Contract**:
   - In the "Deploy & Run Transactions" tab:
     - Environment: Select "Injected Provider - MetaMask" and connect to Sepolia.
     - Contract: Choose `AdvancedRandomNumberContract`.
     - Constructor: Enter your `subscriptionId` (e.g., `1234`) in the field next to "Deploy".
     - Click "Deploy" and confirm the transaction in MetaMask.
   - After deployment, copy the contract address from Remix.

5. **Add Contract to Subscription**:
   - Go back to `vrf.chain.link`, find your subscription, and add the deployed contract address as a consumer.

## Testing in Remix
### Setup
- Ensure MetaMask is connected to Sepolia with sufficient ETH (e.g., 0.01 ETH) and LINK in your subscription.
- Deploy the contract as described above.
- Use the "Deployed Contracts" section in Remix to interact with the contract.

### Functions
1. **`requestRandomNumbers(uint32 _numWords, uint256 min, uint256 max)`**
   - **Input**:
     - `_numWords`: Number of random values to request (1–10).
     - `min`: Minimum value (must be less than `max`).
     - `max`: Maximum value (currently hardcoded to 1–100 in `fulfillRandomWords`).
   - **Output**: `uint256` (request ID)
   - **Cost**: 0.001 ETH + LINK from subscription
   - **Description**: Requests random numbers from Chainlink VRF.

2. **`getRandomNumbers(uint256 requestId)`**
   - **Input**: `requestId` from a previous request.
   - **Output**: `uint256[]` (array of random numbers)
   - **Description**: Retrieves random numbers for a specific request (only requester or owner).

3. **`getLastRandomNumbers(address user)`**
   - **Input**: User address.
   - **Output**: `uint256[]` (array of random numbers from the last request)
   - **Description**: Retrieves the last fulfilled request for a user.

4. **`withdraw()`**
   - **Description**: Allows the owner to withdraw collected ETH fees.

### Test Cases
Below are test cases to verify the contract’s behavior in Remix on Sepolia.

#### Test Case 1: Request a Single Random Number
- **Objective**: Verify that a single random number request works.
- **Steps**:
  1. Call `requestRandomNumbers(1, 1, 100)` with 0.001 ETH (paste `1000000000000000` wei in the "Value" field).
  2. Note the `requestId` from the Remix logs or return value.
  3. Wait 3–5 blocks (check Sepolia Etherscan for confirmation).
  4. Call `getRandomNumbers(requestId)` with the noted ID.
- **Expected Result**:
  - `requestRandomNumbers` emits a `RandomRequested` event.
  - `getRandomNumbers` returns an array with one number (e.g., `[42]`), between 1 and 100.
- **Notes**: Ensure subscription has LINK; check Remix logs for `RandomFulfilled`.

#### Test Case 2: Request Multiple Random Numbers
- **Objective**: Test requesting multiple random numbers.
- **Steps**:
  1. Call `requestRandomNumbers(3, 1, 100)` with 0.001 ETH.
  2. Record the `requestId`.
  3. Wait for fulfillment (monitor logs or Etherscan).
  4. Call `getLastRandomNumbers(your_address)` with your MetaMask address.
- **Expected Result**:
  - Returns an array with 3 numbers (e.g., `[15, 67, 92]`), all between 1 and 100.
- **Notes**: If callback fails, increase `callbackGasLimit` to `200000` and redeploy.

#### Test Case 3: Invalid Number of Words
- **Objective**: Ensure invalid `_numWords` reverts.
- **Steps**:
  1. Call `requestRandomNumbers(0, 1, 100)` with 0.001 ETH.
  2. Call `requestRandomNumbers(11, 1, 100)` with 0.001 ETH.
- **Expected Result**:
  - Both calls revert with `"Request between 1 and 10 numbers"`.
- **Notes**: Check Remix console for revert messages.

#### Test Case 4: Invalid Range
- **Objective**: Verify range validation.
- **Steps**:
  1. Call `requestRandomNumbers(1, 10, 10)` with 0.001 ETH.
  2. Call `requestRandomNumbers(1, 20, 10)` with 0.001 ETH.
- **Expected Result**:
  - Both revert with `"Max must be greater than min"`.
- **Notes**: Current range logic is hardcoded; update `fulfillRandomWords` for dynamic ranges.

#### Test Case 5: Unauthorized Access
- **Objective**: Test access control for random number retrieval.
- **Steps**:
  1. Deploy from Account A.
  2. Call `requestRandomNumbers(1, 1, 100)` from Account A and note `requestId`.
  3. Switch to Account B in Remix/MetaMask.
  4. Call `getRandomNumbers(requestId)` from Account B.
- **Expected Result**:
  - Reverts with `"Not authorized"` unless called by Account A or the owner.
- **Notes**: Owner (deployer) can always access results.

#### Test Case 6: Withdraw ETH Fees
- **Objective**: Verify owner can withdraw ETH.
- **Steps**:
  1. Deploy from Account A (owner).
  2. Call `requestRandomNumbers(1, 1, 100)` with 0.001 ETH from Account B.
  3. Call `withdraw()` from Account A.
  4. Check Account A’s balance in MetaMask.
- **Expected Result**:
  - Balance increases by ~0.001 ETH (minus gas fees).
- **Notes**: Non-owner calls to `withdraw()` revert with `"Only owner"`.

## Troubleshooting
- **Revert on Request**: Ensure subscription has LINK and the contract is added as a consumer.
- **Callback Fails**: Increase `callbackGasLimit` (e.g., to `200000`) and redeploy.
- **No Result**: Wait 3–5 blocks after requesting; check Etherscan for callback transaction.
- **Import Errors**: Use exact Chainlink import paths or fetch from GitHub if Remix fails to resolve.

## Limitations
- **Range Hardcoding**: `fulfillRandomWords` currently maps to 1–100 regardless of `min`/`max`. Add a mapping to store ranges per request for dynamic adjustment.
- **Cost**: Requires ETH and LINK, limiting Remix VM testing (use Sepolia).
- **Network Dependency**: Only works on Chainlink-supported networks (e.g., Sepolia).

## Future Enhancements
- Store `min` and `max` per request for true range mapping.
- Add a thematic output function (e.g., map numbers to names like `VRFD20`).
- Support payment in Sepolia ETH by setting `nativePayment: true`.

