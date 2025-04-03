# GovernanceProposalContract

## Overview
The `GovernanceProposalContract` is a Solidity smart contract designed to facilitate decentralized governance. It allows users to:
- Submit governance proposals with a description.
- Vote on active proposals (yes/no).
- Close proposals (restricted to the proposer).
- View proposal details.

This contract is built with Solidity `^0.8.0` and is intended for deployment on Ethereum-compatible blockchains.

### Features
- **Proposal Submission**: Anyone can submit a proposal.
- **Voting**: One vote per address per proposal (yes or no).
- **Proposal Closure**: Only the proposer can close a proposal, determining if it passes (more yes votes than no votes).
- **Transparency**: Events are emitted for proposal creation, voting, and closure.

---

## Prerequisites
- **Remix IDE**: Access [Remix](https://remix.ethereum.org/) in your browser.
- **MetaMask** (optional): For deployment on testnets like Sepolia or Ropsten.
- **Basic Solidity Knowledge**: Understanding of structs, mappings, events, and modifiers.

---

## How to Deploy in Remix

### Step 1: Set Up the Environment
1. Open [Remix IDE](https://remix.ethereum.org/).
2. In the **File Explorer** tab, click the "+" button to create a new file.
3. Name it `GovernanceProposalContract.sol` and paste the contract code provided above.

### Step 2: Compile the Contract
1. Navigate to the **Solidity Compiler** tab (left sidebar).
2. Select the compiler version `0.8.0` (or higher).
3. Click **Compile GovernanceProposalContract.sol**.
4. Ensure no errors appear in the console.

### Step 3: Deploy the Contract
1. Go to the **Deploy & Run Transactions** tab.
2. Choose an environment:
   - **JavaScript VM (London)**: For local testing (recommended for this guide).
   - **Injected Web3**: For testnet deployment (requires MetaMask and test ETH).
3. In the contract dropdown, select `GovernanceProposalContract`.
4. Click **Deploy**.
   - If using MetaMask, confirm the transaction in the popup.
5. Once deployed, the contract address appears under **Deployed Contracts**.

---

## How to Test Line-by-Line in Remix

### Testing Workflow
We’ll test the contract using Remix’s JavaScript VM, which provides multiple test accounts. Follow these steps to interact with the contract and verify its functionality.

#### 1. Submit a Proposal
- **Function**: `submitProposal(string memory _description)`
- **Steps**:
  1. In the **Deployed Contracts** section, expand the deployed contract.
  2. Find `submitProposal` and enter a description (e.g., `"Increase funding"`).
  3. Click the button to submit.
  4. Check the Remix console for the `ProposalCreated` event with the proposal ID, proposer address, and description.
  5. Call `getProposal(0)` to verify the proposal details (ID: 0, proposer: your address, description: "Increase funding", yesVotes: 0, noVotes: 0, active: true).

#### 2. Vote on the Proposal
- **Function**: `vote(uint _proposalId, bool _support)`
- **Steps**:
  1. Switch to a different account in the **Account** dropdown (e.g., second address).
  2. Call `vote` with `_proposalId: 0` and `_support: true`.
  3. Check the console for the `VoteCast` event.
  4. Switch to another account and call `vote` with `_proposalId: 0` and `_support: false`.
  5. Call `getProposal(0)` to confirm `yesVotes: 1` and `noVotes: 1`.

#### 3. Close the Proposal
- **Function**: `closeProposal(uint _proposalId)`
- **Steps**:
  1. Switch back to the proposer’s account (the one that submitted the proposal).
  2. Call `closeProposal` with `_proposalId: 0`.
  3. Check the console for the `ProposalClosed` event (passed: false, since yesVotes = noVotes).
  4. Call `getProposal(0)` to confirm `active: false`.

#### 4. View Proposal Details
- **Function**: `getProposal(uint _proposalId)`
- **Steps**:
  1. Call `getProposal(0)` from any account.
  2. Verify the returned struct matches the expected state.

---

## Test Cases

Below are specific test cases to ensure the contract works as intended. Use Remix’s JavaScript VM to execute these.

### Test Case 1: Successful Proposal Submission
- **Precondition**: Contract is deployed.
- **Action**: Call `submitProposal("Reduce taxes")` from Account 1.
- **Expected Result**:
  - `proposalCount` increments to 1.
  - `proposals[0]` contains ID: 0, proposer: Account 1, description: "Reduce taxes", yesVotes: 0, noVotes: 0, active: true.
  - `ProposalCreated` event emitted.

### Test Case 2: Voting on a Proposal
- **Precondition**: Proposal 0 exists and is active.
- **Action**:
  1. Call `vote(0, true)` from Account 2.
  2. Call `vote(0, false)` from Account 3.
- **Expected Result**:
  - `proposals[0].yesVotes` = 1, `proposals[0].noVotes` = 1.
  - `hasVoted[0][Account 2]` = true, `hasVoted[0][Account 3]` = true.
  - Two `VoteCast` events emitted.

### Test Case 3: Double Voting Prevention
- **Precondition**: Account 2 has voted on Proposal 0.
- **Action**: Call `vote(0, false)` from Account 2 again.
- **Expected Result**:
  - Transaction reverts with "You have already voted".
  - Vote counts remain unchanged.

### Test Case 4: Closing a Proposal (Proposer Only)
- **Precondition**: Proposal 0 exists, Account 1 is the proposer.
- **Action**:
  1. Call `closeProposal(0)` from Account 2 (non-proposer).
  2. Call `closeProposal(0)` from Account 1 (proposer).
- **Expected Result**:
  - Step 1 reverts with "Only proposer can close".
  - Step 2 succeeds: `proposals[0].active` = false, `ProposalClosed` event emitted with `passed` based on vote counts.

### Test Case 5: Voting on a Closed Proposal
- **Precondition**: Proposal 0 is closed (`active: false`).
- **Action**: Call `vote(0, true)` from Account 4.
- **Expected Result**:
  - Transaction reverts with "Proposal is not active".
  - Vote counts remain unchanged.

### Test Case 6: Invalid Proposal ID
- **Precondition**: `proposalCount` = 1.
- **Action**: Call `vote(1, true)` or `getProposal(1)`.
- **Expected Result**:
  - Transaction reverts with "Proposal does not exist".

---

## How It Works
1. **Proposal Creation**: `submitProposal` increments `proposalCount` and stores a new `Proposal` struct in the `proposals` mapping.
2. **Voting**: `vote` checks if the proposal is valid and the user hasn’t voted, then updates vote counts and emits an event.
3. **Closing**: `closeProposal` ensures only the proposer can close it, sets `active` to false, and determines if it passed.
4. **Viewing**: `getProposal` retrieves a proposal’s details for transparency.

---

## Troubleshooting
- **Compilation Errors**: Ensure the Solidity version matches your compiler.
- **Transaction Failures**: Check the console for revert reasons (e.g., invalid proposal ID).
- **Gas Costs**: Monitor gas usage in the Remix console for optimization.

---

## Future Enhancements
- Add a voting deadline using `block.timestamp`.
- Restrict voting to token holders (e.g., integrate an ERC20 token).
- Allow anyone to close a proposal after a deadline.

For questions or contributions, feel free to reach out!

