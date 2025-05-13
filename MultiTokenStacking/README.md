# MultiTokenStaking and TestToken Contracts README

This README provides a comprehensive guide for deploying and testing the `MultiTokenStaking` and `TestToken` contracts using Remix IDE on the Ethereum Sepolia testnet. It includes contract details, step-by-step deployment and testing instructions, test cases, potential errors, and their solutions.

## Contract Details

### TestToken Contract
- **Purpose**: An ERC-20 token contract used for staking in the `MultiTokenStaking` contract.
- **Functionality**:
  - Implements standard ERC-20 functions (`transfer`, `transferFrom`, `approve`, `balanceOf`, etc.).
  - Allows minting an initial supply during deployment.
- **Deployment Details**:
  - **TokenA**: Deployed at `0xd8b...33fa8` (replace with full address).
    - Name: `TokenA`, Symbol: `TKA`, Initial Supply: `1000 * 10^18` tokens.
  - **TokenB**: Deployed at `0xf8e81D47203A594245E36C48e151709F0C19fBe8`.
    - Name: `TokenB`, Symbol: `TBB`, Initial Supply: `1000 * 10^18` tokens.
- **Key Functions**:
  - `approve(spender, value)`: Allows the staking contract to transfer tokens.
  - `balanceOf(account)`: Returns the token balance of an account.
  - `name()`: Returns the token name (e.g., `TokenB`).

### MultiTokenStaking Contract
- **Purpose**: A staking contract that supports multiple ERC-20 tokens with tiered reward levels based on staked amounts.
- **Functionality**:
  - Allows the contract owner to add supported tokens with minimum stake amounts and reward rates for three levels.
  - Users can stake supported tokens, earn rewards based on stake amount and duration, and unstake with rewards.
  - Tracks stakes per user per token and calculates rewards using the formula: `(amount * rate * duration) / (365 days * 100)`.
- **Deployment Details**:
  - Deployed at: `0xd9145CCE52D386f254917e481eB44e9943F39138`.
  - Owner: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
- **Key Functions**:
  - `addSupportedToken(tokenAddress, levelOneMin, levelTwoMin, levelThreeMin, rateOne, rateTwo, rateThree)`: Adds a token with staking level parameters (owner-only).
  - `stake(tokenAddress, amount)`: Stakes a specified amount of a supported token.
  - `calculateReward(staker, tokenAddress)`: Returns total rewards for a user’s stakes for a token.
  - `unstake(tokenAddress, index)`: Unstakes a specific stake and transfers the amount plus rewards.
  - `unstakeAll(tokenAddress)`: Unstakes all stakes for a token and transfers the total amount plus rewards.
  - `getContractBalance(tokenAddress)`: Returns the contract’s balance of a token.
  - Mappings: `supportedTokens`, `stakes`, `rewardRates`, `levelMinAmounts` for configuration and state tracking.

## Prerequisites
- **Tools**:
  - Remix IDE ([remix.ethereum.org](https://remix.ethereum.org)).
  - MetaMask browser extension connected to the Sepolia testnet.
- **Setup**:
  - MetaMask account: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
  - Testnet ETH: Obtain from a Sepolia faucet (e.g., Infura, Alchemy).
  - Gas Limit: Set to `3000000` (adjust based on Remix estimates).
  - Value: `0 Wei` for all transactions.
- **Files**:
  - `TestToken.sol`: ERC-20 token contract.
  - `MultiTokenStaking.sol`: Staking contract.

## Deployment Steps

### Step 1: Set Up Remix Environment
1. Open Remix IDE at [remix.ethereum.org](https://remix.ethereum.org).
2. In the **File Explorers** tab, ensure the following files are present:
   - `TestToken.sol`
   - `MultiTokenStaking.sol`
3. Go to the **Solidity Compiler** tab:
   - Set compiler version to `0.8.24`.
   - Select EVM version: `cancun`.
   - Enable optimization (optional, for gas efficiency).
4. Compile both contracts:
   - Click **Compile TestToken.sol**.
   - Click **Compile MultiTokenStaking.sol**.
   - Ensure no compilation errors.

### Step 2: Deploy TestToken Contracts
1. Go to the **Deploy & Run Transactions** tab.
2. Set **Environment** to **Injected Provider - MetaMask**.
3. Ensure MetaMask is connected to Sepolia with account `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` and has testnet ETH.
4. Deploy `TestToken` (if not already deployed):
   - Select `TestToken` in the **Contract** dropdown.
   - Input constructor parameters:
     - `name`: `TokenB`
     - `symbol`: `TBB`
     - `initialSupply`: `1000000000000000000000` (1000 tokens with 18 decimals)
   - Click **Deploy** and confirm in MetaMask (gas limit: `3000000`).
   - Note the deployed address (e.g., `0xf8e81D47203A594245E36C48e151709F0C19fBe8` for TokenB).
   - Repeat for `TokenA` (address: `0xd8b...33fa8`, replace with full address).
5. If contracts are already deployed, load them:
   - Click **Load contract from Address**.
   - Enter addresses: `0xf8e81D47203A594245E36C48e151709F0C19fBe8` (TokenB), `0xd8b...33fa8` (TokenA).

### Step 3: Deploy MultiTokenStaking Contract
1. In the **Deploy & Run Transactions** tab, select `MultiTokenStaking`.
2. No constructor arguments are needed (owner is set to `msg.sender`).
3. Click **Deploy** and confirm in MetaMask (gas limit: `3000000`).
4. Note the deployed address (e.g., `0xd9145CCE52D386f254917e481eB44e9943F39138`).
5. If already deployed, load the contract using **Load contract from Address** with the above address.

### Step 4: Configure Supported Tokens
1. In the **Deployed Contracts** section, expand `MultiTokenStaking`.
2. Call `addSupportedToken` to add `TokenB`:
   - Parameters:
     - `tokenAddress`: `0xf8e81D47203A594245E36C48e151709F0C19fBe8`
     - `levelOneMin`: `10000000000000000000` (10 tokens)
     - `levelTwoMin`: `20000000000000000000` (20 tokens)
     - `levelThreeMin`: `50000000000000000000` (50 tokens)
     - `rateOne`: `5` (5% annual reward)
     - `rateTwo`: `10` (10% annual reward)
     - `rateThree`: `15` (15% annual reward)
   - Confirm in MetaMask.
3. Repeat for `TokenA` with similar parameters (replace `tokenAddress` with `0xd8b...33fa8`).
4. Verify:
   - Call `supportedTokens(tokenAddress)` to confirm it returns `true`.
   - Call `rewardRates(tokenAddress, level)` for levels `1`, `2`, `3` (should return `5`, `10`, `15`).
   - Call `levelMinAmounts(tokenAddress, level)` for levels `1`, `2`, `3` (should return `10 * 10^18`, `20 * 10^18`, `50 * 10^18`).

## Testing Steps

### Step 1: Approve Tokens
1. In the **Deployed Contracts** section, expand `TestToken` at `0xf8e81D47203A594245E36C48e151709F0C19fBe8` (TokenB).
2. Call `approve`:
   - `spender`: `0xd9145CCE52D386f254917e481eB44e9943F39138` (staking contract)
   - `value`: `1000000000000000000000` (1000 tokens)
   - Confirm in MetaMask.
3. Repeat for `TokenA` at `0xd8b...33fa8`.
4. Verify:
   - Call `allowance(owner, spender)` with:
     - `owner`: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
     - `spender`: `0xd9145CCE52D386f254917e481eB44e9943F39138`
   - Expected: `1000000000000000000000`.

### Step 2: Test Staking
1. Call `stake` on `MultiTokenStaking`:
   - `tokenAddress`: `0xf8e81D47203A594245E36C48e151709F0C19fBe8`
   - `amount`: Test multiple amounts:
     - `15000000000000000000` (15 tokens, level 1)
     - `30000000000000000000` (30 tokens, level 2)
     - `60000000000000000000` (60 tokens, level 3)
   - Confirm each transaction in MetaMask.
2. Verify:
   - Call `stakes(user, tokenAddress, index)` with:
     - `user`: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
     - `tokenAddress`: `0xf8e81D47203A594245E36C48e151709F0C19fBe8`
     - `index`: `0`, `1`, etc.
     - Expected: Returns stake details (amount, startTime, level, tokenAddress).
   - Call `getContractBalance(tokenAddress)`:
     - Expected: Sum of staked amounts (e.g., `45000000000000000000` for 15 + 30 tokens).

### Step 3: Test Reward Calculation
1. Wait a few minutes to simulate staking duration (or use a local testnet like Hardhat to advance block time).
2. Call `calculateReward`:
   - `staker`: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
   - `tokenAddress`: `0xf8e81D47203A594245E36C48e151709F0C19fBe8`
3. Expected:
   - Reward = `(amount * rate * duration) / (365 days * 100)`.
   - Example: For 30 tokens (level 2, 10% rate) staked for 60 seconds:
     - `reward = (30 * 10^18 * 10 * 60) / (365 * 24 * 3600 * 100) ≈ 5707 wei`.
   - Your data shows `6183409436834` wei, indicating a short duration. Verify with actual `startTime`.
4. Repeat for `TokenA` stakes.

### Step 4: Test Unstaking
1. **Unstake Specific Stake**:
   - Call `unstake`:
     - `tokenAddress`: `0xf8e81D47203A594245E36C48e151709F0C19fBe8`
     - `index`: `0` (first stake)
   - Confirm in MetaMask.
   - Verify:
     - User’s token balance increases by `amount + reward`.
     - Call `stakes(user, tokenAddress, 0)` to confirm the stake is removed.
     - Call `getContractBalance(tokenAddress)` to confirm the balance decreases.
2. **Unstake All**:
   - Call `unstakeAll`:
     - `tokenAddress`: `0xf8e81D47203A594245E36C48e151709F0C19fBe8`
   - Confirm in MetaMask.
   - Verify:
     - All stakes are removed (`stakes` returns empty array).
     - User receives total staked amount + rewards.
     - Contract balance decreases accordingly.

### Step 5: Test Mappings
1. **supportedTokens**:
   - Call `supportedTokens(tokenAddress)` with:
     - `tokenAddress`: `0xf8e81D47203A594245E36C48e151709F0C19fBe8`
     - Expected: `true`
     - Test with `0x0000000000000000000000000000000000000000`:
       - Expected: `false`
2. **rewardRates**:
   - Call `rewardRates(tokenAddress, level)` with:
     - `tokenAddress`: `0xf8e81D47203A594245E36C48e151709F0C19fBe8`
     - `level`: `1`, `2`, `3`
     - Expected: `5`, `10`, `15`
3. **levelMinAmounts**:
   - Call `levelMinAmounts(tokenAddress, level)` with:
     - `tokenAddress`: `0xf8e81D47203A594245E36C48e151709F0C19fBe8`
     - `level`: `1`, `2`, `3`
     - Expected: `10000000000000000000`, `20000000000000000000`, `50000000000000000000`
4. **stakes**:
   - Call `stakes(user, tokenAddress, index)` to inspect stake details (as done in Step 2).

## Test Cases and Expected Outcomes
1. **Test Case: Add Supported Token (Owner)**
   - Action: Call `addSupportedToken` with valid parameters.
   - Expected: Token is added, `supportedTokens` returns `true`.
   - Error: Non-owner calls `addSupportedToken`.
     - Reason: `Only owner can call this function`.
     - Solution: Use the owner account (`0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`).
   - Error: Invalid token address (`0x0`).
     - Reason: `Invalid token address`.
     - Solution: Use a valid ERC-20 contract address.
   - Error: Token already supported.
     - Reason: `Token already supported`.
     - Solution: Check `supportedTokens` before adding.

2. **Test Case: Stake Tokens**
   - Action: Stake `15 * 10^18`, `30 * 10^18`, `60 * 10^18` tokens.
   - Expected: Stakes are recorded with correct levels (1, 2, 3).
   - Error: `Amount must be greater than 0` (e.g., `amount = 0`).
     - Solution: Use a non-zero amount.
   - Error: `Token not supported`.
     - Solution: Add the token using `addSupportedToken`.
   - Error: `Transfer failed` (insufficient balance or allowance).
     - Solution: Approve sufficient tokens and ensure user balance is adequate.

3. **Test Case: Calculate Rewards**
   - Action: Call `calculateReward` after staking.
   - Expected: Returns correct reward based on stake amount, level, and duration.
   - Error: `Token not supported`.
     - Solution: Use a supported token.
   - Error: `No active stakes`.
     - Solution: Stake tokens first.

4. **Test Case: Unstake Specific Stake**
   - Action: Call `unstake` with valid `index`.
   - Expected: Stake is removed, user receives `amount + reward`.
   - Error: `Invalid index`.
     - Solution: Use a valid index (check `stakes` array length).
   - Error: `Token not supported`.
     - Solution: Use a supported token.
   - Error: `Transfer failed` (insufficient contract balance).
     - Solution: Ensure the contract has enough tokens (see below).

5. **Test Case: Unstake All**
   - Action: Call `unstakeAll`.
   - Expected: All stakes are removed, user receives total `amount + rewards`.
   - Error: `No active stakes`.
     - Solution: Stake tokens first.
   - Error: `Transfer failed`.
     - Solution: Ensure the contract has sufficient token balance.

## Common Errors and Solutions
1. **Error: "Invalid index"**
   - Cause: Calling `unstake` with an index greater than or equal to the stakes array length.
   - Solution: Check the stakes array length using `stakes(user, tokenAddress, index)` with increasing indices until it fails.
   - Example: Your data shows an `unstake` attempt failed with this error.

2. **Error: "ERC20InsufficientBalance"**
   - Cause: The contract tried to transfer more tokens than its balance (e.g., `needed: 30000076579147640791`, `balance: 30000000000000000000`).
   - Solution: The contract must hold sufficient tokens to pay rewards. Modify the contract to:
     - Fund the contract with reward tokens (add a `depositRewards` function).
     - Or, pay rewards in a different token or limit rewards to available balance.
   - Temporary Fix: Unstake with smaller amounts or reduce reward rates.

3. **Error: "Transfer failed"**
   - Cause: Insufficient allowance, user balance, or contract balance.
   - Solution:
     - Approve sufficient tokens using `approve`.
     - Ensure the user has enough tokens (`balanceOf`).
     - Fund the contract for rewards (see above).

4. **Error: "Transaction reverted due to insufficient gas"**
   - Cause: Gas limit too low (e.g., below `3000000`).
   - Solution: Increase gas limit in MetaMask or Remix (check **Gas Estimates** in Remix).

5. **Error: "No active stakes"**
   - Cause: Calling `calculateReward` or `unstakeAll` without stakes.
   - Solution: Stake tokens first using `stake`.

## Additional Notes
- **Reset State**: To reset the contract state, redeploy `MultiTokenStaking` or call `unstakeAll` to clear stakes.
- **Gas Optimization**: Enable the Solidity optimizer in Remix and monitor gas costs in the **Solidity Compiler** tab.
- **Testing Duration**: Rewards depend on staking duration. Use a local testnet (e.g., Hardhat) to advance block time for accurate reward testing.
- **Security**: Audit the contract before mainnet deployment to prevent vulnerabilities (e.g., reentrancy, overflow).

## Conclusion
This README provides a complete guide to deploy and test the `MultiTokenStaking` and `TestToken` contracts in Remix IDE on the Sepolia testnet. By following the steps and test cases, you can verify the contract’s functionality, inspect its state, and handle errors effectively.
