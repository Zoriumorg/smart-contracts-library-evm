# VotingContract

This repository contains two versions of a decentralized voting system implemented as Solidity smart contracts: a **Simple VotingContract** and an **Enhanced VotingContract**. Both are designed for educational purposes and can be deployed and tested using [Remix IDE](https://remix.ethereum.org/).

## Overview

### Simple VotingContract
A basic voting system where:
- Candidates are set during deployment.
- Each Ethereum address can vote once for a candidate.
- Results are publicly viewable.

### Enhanced VotingContract
An extended version with additional features:
- Time-restricted voting period.
- Owner-only controls for adding candidates and ending voting.
- Events for tracking actions.
- A function to determine the winner after voting ends.

## Comparison of Features

| Feature                  | Simple Version                  | Enhanced Version                       |
|--------------------------|---------------------------------|----------------------------------------|
| **Candidate Setup**      | Fixed at deployment            | Fixed at deployment + owner can add    |
| **Voting Period**        | No time restriction            | Defined duration + manual end option   |
| **Access Control**       | None                           | Owner-only functions                   |
| **Events**               | None                           | Vote cast, candidate added, voting end |
| **Winner Declaration**   | Not available                  | Available after voting ends            |
| **Security**             | Basic (single vote per address)| Enhanced (time limits, owner control)  |

## Prerequisites

- **Remix IDE**: Access to [Remix](https://remix.ethereum.org/).
- **Solidity Knowledge**: Basic understanding of Solidity and Ethereum smart contracts.
- **Browser**: A modern web browser to run Remix.

## Simple VotingContract

### Code
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {
    struct Candidate {
        string name;
        uint voteCount;
    }
    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;
    address public owner;
    
    constructor(string[] memory candidateNames) {
        owner = msg.sender;
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({name: candidateNames[i], voteCount: 0}));
        }
    }
    
    function vote(uint candidateIndex) public {
        require(!hasVoted[msg.sender], "You have already voted!");
        require(candidateIndex < candidates.length, "Invalid candidate index!");
        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount += 1;
    }
    
    function getCandidate(uint candidateIndex) public view returns (string memory name, uint voteCount) {
        require(candidateIndex < candidates.length, "Invalid candidate index!");
        return (candidates[candidateIndex].name, candidates[candidateIndex].voteCount);
    }
    
    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }
    
    function getAllCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }
}
```

### How It Works
- **Deployment**: Candidates are provided as an array (e.g., `["Alice", "Bob"]`) in the constructor.
- **Voting**: Anyone can call `vote()` with a candidate index (e.g., `0` for Alice). Each address can vote once.
- **Viewing Results**: Use `getAllCandidates()` or `getCandidate()` to see vote counts.

### Setup and Usage
1. **Open Remix**: Go to [Remix IDE](https://remix.ethereum.org/).
2. **Create File**: In "File Explorer", create `SimpleVotingContract.sol` and paste the code.
3. **Compile**: In "Solidity Compiler", select version `0.8.0+` and compile.
4. **Deploy**: In "Deploy & Run Transactions", select "JavaScript VM", enter `["Alice", "Bob"]`, and deploy.
5. **Interact**:
   - Call `vote(0)` to vote for Alice.
   - Call `getAllCandidates()` to see results.

## Enhanced VotingContract

### Code
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {
    struct Candidate {
        string name;
        uint voteCount;
    }
    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;
    address public owner;
    uint public votingStart;
    uint public votingEnd;
    bool public votingClosed;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this!");
        _;
    }
    
    modifier onlyDuringVoting() {
        require(block.timestamp >= votingStart, "Voting has not started yet!");
        require(block.timestamp <= votingEnd, "Voting has ended!");
        require(!votingClosed, "Voting is closed!");
        _;
    }
    
    event VoteCast(address indexed voter, uint candidateIndex);
    event CandidateAdded(string name);
    event VotingEnded();
    
    constructor(string[] memory candidateNames, uint durationInMinutes) {
        owner = msg.sender;
        votingStart = block.timestamp;
        votingEnd = votingStart + (durationInMinutes * 1 minutes);
        votingClosed = false;
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({name: candidateNames[i], voteCount: 0}));
        }
    }
    
    function addCandidate(string memory name) public onlyOwner {
        require(!votingClosed, "Voting is closed!");
        candidates.push(Candidate({name: name, voteCount: 0}));
        emit CandidateAdded(name);
    }
    
    function vote(uint candidateIndex) public onlyDuringVoting {
        require(!hasVoted[msg.sender], "You have already voted!");
        require(candidateIndex < candidates.length, "Invalid candidate index!");
        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount += 1;
        emit VoteCast(msg.sender, candidateIndex);
    }
    
    function endVoting() public onlyOwner {
        require(!votingClosed, "Voting is already closed!");
        votingClosed = true;
        emit VotingEnded();
    }
    
    function getCandidate(uint candidateIndex) public view returns (string memory name, uint voteCount) {
        require(candidateIndex < candidates.length, "Invalid candidate index!");
        return (candidates[candidateIndex].name, candidates[candidateIndex].voteCount);
    }
    
    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }
    
    function getAllCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }
    
    function getWinner() public view returns (string memory winnerName, uint winnerVotes) {
        require(votingClosed, "Voting is still ongoing!");
        require(candidates.length > 0, "No candidates available!");
        uint highestVotes = 0;
        uint winningIndex = 0;
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winningIndex = i;
            }
        }
        return (candidates[winningIndex].name, candidates[winningIndex].voteCount);
    }
}
```

### How It Works
- **Deployment**: Requires candidate names and a voting duration (e.g., `["Alice", "Bob"], 10` for 10 minutes).
- **Voting Period**: Votes are only accepted between `votingStart` and `votingEnd`, unless closed early by the owner.
- **Owner Control**: Only the owner (deployer) can add candidates or end voting.
- **Events**: Actions like voting or adding candidates emit events for tracking.
- **Results**: After voting ends, `getWinner()` identifies the candidate with the most votes.

### Setup and Usage
1. **Open Remix**: Go to [Remix IDE](https://remix.ethereum.org/).
2. **Create File**: In "File Explorer", create `EnhancedVotingContract.sol` and paste the code.
3. **Compile**: In "Solidity Compiler", select version `0.8.0+` and compile.
4. **Deploy**: In "Deploy & Run Transactions", select "JavaScript VM", enter `["Alice", "Bob"], 10`, and deploy.
5. **Interact**:
   - Call `addCandidate("Charlie")` (owner only).
   - Call `vote(0)` to vote for Alice (within 10 minutes).
   - Call `endVoting()` (owner only) to close voting early.
   - Call `getWinner()` after voting ends to see the winner.

## Key Changes Between Versions
1. **Constructor**: Enhanced version adds `durationInMinutes` parameter.
2. **Time Control**: Added `votingStart`, `votingEnd`, and `votingClosed` with a modifier.
3. **Owner Functions**: Added `onlyOwner` modifier and functions like `addCandidate` and `endVoting`.
4. **Events**: Introduced for better tracking in the enhanced version.
5. **Winner Logic**: Added `getWinner()` to compute results post-voting.

## Testing Tips
- Use multiple accounts in Remix’s "Account" dropdown to simulate voters.
- In the enhanced version, test time restrictions by waiting or manually ending voting.
- Check event logs in Remix’s console after actions like voting.

## Limitations
- **Simple Version**: No time limits or owner control; basic functionality only.
- **Enhanced Version**: No vote delegation or tie handling in `getWinner`; still simplified for production use.

## Potential Improvements
- Add vote delegation or candidate removal.
- Handle ties in `getWinner`.
- Implement a reset function for reuse.

## License
Both contracts are licensed under the MIT License (see `SPDX-License-Identifier` in the code).

## Contributing
Feel free to fork, experiment, and suggest improvements if hosted in a repository!

---

This `README.md` provides a clear, detailed guide for both contracts, explaining their functionality, differences, and how to use them in Remix. Let me know if you’d like to adjust or add more sections!