
# DAO

This project implements a decentralized autonomous organization (DAO) using a governance system built on Ethereum smart contracts. The DAO allows token holders to propose, vote on, and execute proposals, with a timelock mechanism to delay execution and a treasury for managing funds.

## Technology Stack & Tools
- **Solidity**: For writing smart contracts.
- **JavaScript (React & Testing)**: For interacting with the blockchain and testing scripts.
- **Web3.js**: For blockchain interactions.
- **Truffle**: Development framework for compiling, deploying, and testing smart contracts.
- **Ganache**: Local blockchain for development and testing.

## Smart Contracts Overview
1. **Governance.sol**:
   - Implements the core DAO governance logic using OpenZeppelin's `Governor` contract.
   - Supports voting, proposal creation, quorum requirements, and timelock integration.
   - Key parameters: voting delay, voting period, and quorum percentage.
   - Inherits:
     - `GovernorCountingSimple`: Simple majority voting.
     - `GovernorVotes`: Tracks voting power via an ERC20Votes token.
     - `GovernorVotesQuorumFraction`: Ensures quorum is met.
     - `GovernorTimelockControl`: Integrates with a timelock for delayed execution.

2. **Token.sol**:
   - An ERC20 token with voting capabilities (`ERC20Votes`).
   - Allows token holders to delegate their voting power.
   - Initial supply is minted to the deployer, who can distribute tokens.

3. **TimeLock.sol**:
   - A timelock controller that delays execution of successful proposals.
   - Configured with a minimum delay and lists of proposers and executors.
   - Ensures proposals cannot be executed immediately, adding a safety buffer.

4. **Treasury.sol**:
   - Manages DAO funds, initially funded during deployment.
   - Only the owner (Timelock contract) can release funds to a designated payee.
   - Tracks whether funds have been released.

5. **Migrations.sol**:
   - Tracks contract deployment progress for Truffle migrations.

## Prerequisites
- **Node.js**: Version below 16.5.0.
- **Truffle**: Version 5.4 recommended to avoid dependency issues.
  - Install globally: `npm i -g truffle`
  - Verify: `truffle version`
- **Ganache**: Local blockchain for testing.
  - Install Ganache CLI: `npm i -g ganache-cli` or use the Ganache GUI.
- **Git**: To clone the repository.

## Initial Setup
1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Install Dependencies**:
   ```bash
   npm install
   ```

3. **Configure Truffle**:
   - Ensure `truffle-config.js` is set to connect to Ganache:
     ```javascript
     networks: {
       development: {
         host: "127.0.0.1",
         port: 7545,
         network_id: "*"
       }
     }
     ```

## Deployment
1. **Start Ganache**:
   - Run Ganache CLI:
     ```bash
     ganache-cli -p 7545
     ```
   - This starts a local blockchain on port 7545. Note the accounts and private keys provided by Ganache.

2. **Migrate Contracts**:
   - In a new terminal, navigate to the project directory and run:
     ```bash
     truffle migrate --reset
     ```
   - This deploys all contracts (`Migrations`, `Token`, `Timelock`, `Governance`, `Treasury`) to the local blockchain.
   - The `2_deploy_contracts.js` script:
     - Deploys the `Token` with 1000 ether initial supply.
     - Distributes 50 ether to each of five voters.
     - Deploys `Timelock` with a minimum delay of 1 second.
     - Deploys `Governance` with a 5% quorum, 0-block voting delay, and 5-block voting period.
     - Deploys `Treasury` with 25 ether and transfers ownership to `Timelock`.

## Testing the Governance Process
The `1_create_proposal.js` script tests the full governance lifecycle: proposing, voting, queuing, and executing a proposal to release funds from the treasury.

### Step-by-Step Testing
1. **Ensure Ganache is Running**:
   ```bash
   ganache-cli -p 7545
   ```

2. **Verify Truffle Configuration**:
   - Confirm `truffle-config.js` points to `127.0.0.1:7545`.

3. **Deploy Contracts**:
   ```bash
   truffle migrate --reset
   ```
   - This resets and deploys all contracts to the local blockchain.

4. **Update Minimum Delay**:
   - In `2_deploy_contracts.js`, ensure `minDelay` is set to `0` (or a low value like `1` for testing):
     ```javascript
     const minDelay = 0
     ```
   - Redeploy contracts if changes are made:
     ```bash
     truffle migrate --reset
     ```

5. **Run the Proposal Script**:
   ```bash
   truffle exec scripts/1_create_proposal.js
   ```
   - This script:
     - Delegates voting power for five voters.
     - Checks the treasury's initial state (funds: 25 ETH, not released).
     - Creates a proposal to call `releaseFunds()` on the `Treasury` contract.
     - Logs the proposal ID, state (Pending), snapshot block, and deadline.
     - Casts votes (3 For, 1 Against, 1 Abstain).
     - Advances the block to end the voting period.
     - Logs vote counts and proposal state (Succeeded).
     - Queues the proposal.
     - Executes the proposal.
     - Verifies the treasury's final state (funds: 0 ETH, released).

### Expected Output
- Initial treasury state: 25 ETH, not released.
- Proposal created with a unique ID.
- Proposal state transitions: Pending → Active → Succeeded → Queued → Executed.
- Votes: 150 For, 50 Against, 50 Abstain (meets 5% quorum).
- Final treasury state: 0 ETH, released.

## Troubleshooting
- **Dependency Issues**: Ensure Truffle is version 5.4 and Node.js is below 16.5.0.
- **Ganache Connection**: Verify Ganache is running on port 7545 and `truffle-config.js` matches.
- **Gas Errors**: Increase gas limits in `truffle-config.js` if transactions fail.
- **Proposal State Issues**: Ensure `minDelay` is low (e.g., 0 or 1) for testing to avoid long waits.

## Additional Notes
- The governance system uses OpenZeppelin's contracts, ensuring security and modularity.
- The `Treasury` contract is owned by the `Timelock`, which is controlled by the `Governance` contract, ensuring only successful proposals can release funds.
- For production, increase `minDelay` (e.g., 1 day) and adjust `votingPeriod` and `quorum` for real-world use.

