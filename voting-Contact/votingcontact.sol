// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {
    // Structure for candidate info
    struct Candidate {
        string name;
        uint voteCount;
    }
    
    // Array of candidates
    Candidate[] public candidates;
    
    // Mapping to track voters
    mapping(address => bool) public hasVoted;
    
    // Contract owner
    address public owner;
    
    // Voting period
    uint public votingStart;
    uint public votingEnd;
    bool public votingClosed;
    
    // Modifier to restrict to owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this!");
        _;
    }
    
    // Modifier to check voting period
    modifier onlyDuringVoting() {
        require(block.timestamp >= votingStart, "Voting has not started yet!");
        require(block.timestamp <= votingEnd, "Voting has ended!");
        require(!votingClosed, "Voting is closed!");
        _;
    }
    
    // Events for tracking
    event VoteCast(address indexed voter, uint candidateIndex);
    event CandidateAdded(string name);
    event VotingEnded();
    
    // Constructor
    constructor(string[] memory candidateNames, uint durationInMinutes) {
        owner = msg.sender;
        votingStart = block.timestamp;
        votingEnd = votingStart + (durationInMinutes * 1 minutes);
        votingClosed = false;
        
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({
                name: candidateNames[i],
                voteCount: 0
            }));
        }
    }
    
    // Add a candidate (owner only)
    function addCandidate(string memory name) public onlyOwner {
        require(!votingClosed, "Voting is closed!");
        candidates.push(Candidate({
            name: name,
            voteCount: 0
        }));
        emit CandidateAdded(name);
    }
    
    // Vote for a candidate
    function vote(uint candidateIndex) public onlyDuringVoting {
        require(!hasVoted[msg.sender], "You have already voted!");
        require(candidateIndex < candidates.length, "Invalid candidate index!");
        
        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount += 1;
        emit VoteCast(msg.sender, candidateIndex);
    }
    
    // End voting (owner only)
    function endVoting() public onlyOwner {
        require(!votingClosed, "Voting is already closed!");
        votingClosed = true;
        emit VotingEnded();
    }
    
    // Get candidate details
    function getCandidate(uint candidateIndex) public view returns (string memory name, uint voteCount) {
        require(candidateIndex < candidates.length, "Invalid candidate index!");
        Candidate memory candidate = candidates[candidateIndex];
        return (candidate.name, candidate.voteCount);
    }
    
    // Get total candidate count
    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }
    
    // Get all candidates
    function getAllCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }
    
    // Get the winner (only after voting ends)
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


// pragma solidity ^0.8.0;

// contract VotingContract {
//     // Structure to store candidate information
//     struct Candidate {
//         string name;
//         uint voteCount;
//     }
    
//     // Array to store all candidates
//     Candidate[] public candidates;
    
//     // Mapping to track if an address has voted
//     mapping(address => bool) public hasVoted;
    
//     // Address of the contract deployer/owner
//     address public owner;
    
//     // Constructor to initialize candidates
//     constructor(string[] memory candidateNames) {
//         owner = msg.sender;
        
//         // Initialize candidates with names and 0 votes
//         for (uint i = 0; i < candidateNames.length; i++) {
//             candidates.push(Candidate({
//                 name: candidateNames[i],
//                 voteCount: 0
//             }));
//         }
//     }
    
//     // Function to vote for a candidate
//     function vote(uint candidateIndex) public {
//         // Check if voter hasn't voted yet
//         require(!hasVoted[msg.sender], "You have already voted!");
//         // Check if candidate index is valid
//         require(candidateIndex < candidates.length, "Invalid candidate index!");
        
//         // Record the vote
//         hasVoted[msg.sender] = true;
//         candidates[candidateIndex].voteCount += 1;
//     }
    
//     // Function to get candidate details
//     function getCandidate(uint candidateIndex) public view returns (string memory name, uint voteCount) {
//         require(candidateIndex < candidates.length, "Invalid candidate index!");
//         Candidate memory candidate = candidates[candidateIndex];
//         return (candidate.name, candidate.voteCount);
//     }
    
//     // Function to get total number of candidates
//     function getCandidateCount() public view returns (uint) {
//         return candidates.length;
//     }
    
//     // Function to get all candidates (helpful for frontend)
//     function getAllCandidates() public view returns (Candidate[] memory) {
//         return candidates;
//     }
// }