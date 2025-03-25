# StakingContractV1 - README

## Overview
`StakingContractV1` is a Solidity smart contract that combines an ERC-20 token with a staking mechanism. It allows users to stake tokens, earn time-based rewards, and withdraw their stakes after a minimum lockup period. The contract uses OpenZeppelin's `ERC20` and `Ownable` libraries for secure token functionality and administrative control.

### Key Features
- **Token**: An ERC-20 token named "StakeToken" (symbol: `STK`) with 18 decimals.
- **Staking**: Users can stake tokens and earn rewards based on the staked amount and duration.
- **Rewards**: Calculated dynamically using a reward rate (wei per second per token).
- **Lockup Period**: Minimum staking period of 1 day (86,400 seconds).
- **Ownership**: Only the owner can adjust the reward rate.

### Contract Details
- **License**: MIT
- **Solidity Version**: `^0.8.26`
- **Dependencies**: OpenZeppelin Contracts (`ERC20`, `Ownable`)

## Contract Structure
### State Variables
- `Stake` struct: Tracks each user's staked `amount` and `startTime`.
- `stakes`: Mapping of user addresses to their `Stake` details.
- `rewardRate`: Reward rate in wei per second per token (default: 100).
- `MIN_STAKE_PERIOD`: Constant 1-day lockup period (86,400 seconds).

### Events
- `Staked(address user, uint256 amount)`: Emitted when a user stakes tokens.
- `Unstaked(address user, uint256 amount, uint256 reward)`: Emitted when a user unstakes with their reward.

### Functions
- `constructor()`: Initializes the token, mints 10,000 STK to the deployer and 10,000 STK to the contract (reward pool).
- `stake(uint256 amount)`: Stakes tokens, claims existing rewards if any, and updates stake details.
- `unstake()`: Withdraws staked tokens and rewards after the lockup period.
- `calculateReward(address user)`: View function to calculate current rewards for a user.
- `setRewardRate(uint256 _rate)`: Owner-only function to update the reward rate.

## Deployment
1. **Prerequisites**:
   - Install OpenZeppelin contracts: `npm install @openzeppelin/contracts` (if using a local environment).
   - Use Remix (https://remix.ethereum.org/) for testing without local setup.

2. **Steps in Remix**:
   - Create a new file: `StakingContractV1.sol`.
   - Copy and paste the contract code.
   - Go to "Solidity Compiler" tab:
     - Select version `0.8.26`.
     - Enable "Auto compile" or click "Compile StakingContractV1.sol".
   - Go to "Deploy & Run Transactions" tab:
     - Environment: "JavaScript VM (London)".
     - Click "Deploy" (no constructor arguments needed).

3. **Initial State**:
   - Deployer receives 10,000 STK.
   - Contract holds 10,000 STK as the reward pool.

## Testing in Remix
### Setup
- **Environment**: Use Remix's JavaScript VM for testing.
- **Accounts**: Remix provides multiple test accounts (e.g., Account 0 is the deployer).
- **Token Units**: Amounts are in wei (1 STK = `1 * 10^18`).

### Test Cases
Below are specific test cases with line-by-line explanations for testing each function in Remix.

#### **Test Case 1: Deploy and Verify Initial State**
1. **Deploy the Contract**:
   - In "Deploy & Run Transactions", click "Deploy".
   - Note the contract address (e.g., `0x123...`).
2. **Verify Token Balances**:
   - Call `balanceOf(deployer)` (e.g., `0x5B38...`):
     - Input: Deployer address.
     - Expected Output: `10000 * 10^18` (10,000 STK).
   - Call `balanceOf(contract)`:
     - Input: Contract address.
     - Expected Output: `10000 * 10^18` (10,000 STK).
3. **Verify Token Details**:
   - Call `name()`: Expected Output: `"StakeToken"`.
   - Call `symbol()`: Expected Output: `"STK"`.
   - Call `decimals()`: Expected Output: `18`.

#### **Test Case 2: Stake Tokens**
1. **Approve the Contract**:
   - Function: `approve`.
   - Inputs:
     - `spender`: Contract address (e.g., `0x123...`).
     - `value`: `100 * 10^18` (100 STK).
   - Execute from: Deployer (e.g., `0x5B38...`).
   - Verify: Call `allowance(deployer, contract)` → Expected: `100 * 10^18`.
2. **Stake Tokens**:
   - Function: `stake`.
   - Input: `amount`: `100 * 10^18` (100 STK).
   - Execute from: Deployer.
   - Verify:
     - Call `stakes(deployer)` → Expected: `(100 * 10^18, current_timestamp)`.
     - Call `balanceOf(deployer)` → Expected: `9900 * 10^18` (10,000 - 100).
     - Call `balanceOf(contract)` → Expected: `10100 * 10^18` (10,000 + 100).
3. **Check Event**:
   - Check transaction logs for `Staked(deployer, 100 * 10^18)`.

#### **Test Case 3: Calculate Rewards**
1. **Stake First** (if not already done):
   - Follow Test Case 2.
2. **Advance Time**:
   - In Remix VM, click "Next Block" multiple times or use a time manipulation tool to advance ~1 day.
3. **Calculate Reward**:
   - Function: `calculateReward`.
   - Input: Deployer address.
   - Expected Output: `(100 * 10^18 * 86400 * 100) / 10^18 = 86400000` wei (after 1 day).
     - Formula: `(amount * duration * rewardRate) / 10^18`.
     - 100 STK * 86,400 seconds * 100 wei/s = 864,000,000 wei = 0.864 STK.
4. **Verify**: Reward increases with time.

#### **Test Case 4: Unstake Before Lockup (Should Fail)**
1. **Stake Tokens** (if not already done):
   - Follow Test Case 2.
2. **Attempt Unstake**:
   - Function: `unstake`.
   - Execute from: Deployer.
   - Expected: Transaction reverts with "Lockup period active".
3. **Verify**: Call `stakes(deployer)` → Stake still exists.

#### **Test Case 5: Unstake After Lockup**
1. **Stake Tokens** (if not already done):
   - Follow Test Case 2.
2. **Advance Time**:
   - Advance time by >1 day (e.g., 2 days).
3. **Unstake**:
   - Function: `unstake`.
   - Execute from: Deployer.
   - Verify:
     - Call `balanceOf(deployer)` → Expected: ~`9917.28 * 10^18` (9900 + 100 + ~17.28 reward for 2 days).
     - Call `stakes(deployer)` → Expected: `(0, 0)`.
     - Reward for 2 days: `(100 * 10^18 * 172800 * 100) / 10^18 = 17280000` wei = 0.01728 STK.
   - Check logs for `Unstaked(deployer, 100 * 10^18, reward)`.
4. **Check Contract Balance**:
   - Call `balanceOf(contract)` → Expected: ~`9982.72 * 10^18` (10100 - 100 - 0.01728).

#### **Test Case 6: Set Reward Rate (Owner Only)**
1. **Change Reward Rate**:
   - Function: `setRewardRate`.
   - Input: `_rate`: `200`.
   - Execute from: Deployer (owner).
   - Verify: Call `rewardRate` → Expected: `200`.
2. **Non-Owner Attempt**:
   - Switch to another account (e.g., `0xAb84...`).
   - Call `setRewardRate(300)` → Expected: Reverts with "Ownable: caller is not the owner".
3. **Stake and Verify New Rate**:
   - Stake 100 STK again.
   - Advance 1 day.
   - Call `calculateReward(deployer)` → Expected: `(100 * 10^18 * 86400 * 200) / 10^18 = 172800000` wei.

#### **Test Case 7: Stake Again (Accumulate Rewards)**
1. **Stake Initially**:
   - Approve and stake 100 STK (Test Case 2).
2. **Advance Time**: 1 day.
3. **Stake More**:
   - Approve: `50 * 10^18`.
   - Stake: `50 * 10^18`.
   - Verify:
     - Reward for first 100 STK (1 day): `0.864 STK` transferred to deployer.
     - `stakes(deployer)` → `(150 * 10^18, new_timestamp)`.
4. **Unstake After 1 More Day**:
   - Advance 1 day.
   - Unstake → Total staked: 150 STK, Reward: `(150 * 10^18 * 86400 * 100) / 10^18 = 1.296 STK`.

## Notes
- **Reward Pool**: Ensure the contract’s balance (`10,000 STK`) covers rewards. If depleted, `transfer` in `unstake` will fail.
- **Gas Costs**: Staking and unstaking are efficient with no loops.
- **Security**: Uses OpenZeppelin’s audited code, but test thoroughly for edge cases (e.g., reward overflow, though mitigated by Solidity 0.8+).

## Conclusion
This contract provides a simple, secure staking mechanism with time-based rewards. Test all cases in Remix to ensure functionality and adjust `rewardRate` or `MIN_STAKE_PERIOD` as needed for your use case.



