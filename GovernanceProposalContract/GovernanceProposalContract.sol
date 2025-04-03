// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GovernanceProposalContract {
    // Struct to define a Proposal
    struct Proposal {
        uint id;                // Unique ID for the proposal
        address proposer;       // Address of the user who submitted the proposal
        string description;     // Description of the proposal
        uint yesVotes;          // Count of yes votes
        uint noVotes;           // Count of no votes
        bool active;            // Whether the proposal is still open for voting
        bool executed;          // Whether the proposal has been executed
    }

    // Mapping to store all proposals
    mapping(uint => Proposal) public proposals;
    uint public proposalCount; // Tracks the number of proposals

    // Mapping to track if an address has voted on a proposal
    mapping(uint => mapping(address => bool)) public hasVoted;

    // Event to notify when a proposal is created
    event ProposalCreated(uint id, address proposer, string description);
    // Event to notify when a vote is cast
    event VoteCast(uint id, address voter, bool support);
    // Event to notify when a proposal is closed
    event ProposalClosed(uint id, bool passed);

    // Modifier to check if proposal exists and is active
    modifier validProposal(uint _proposalId) {
        require(_proposalId < proposalCount, "Proposal does not exist");
        require(proposals[_proposalId].active, "Proposal is not active");
        _;
    }

    // Function to submit a new proposal
    function submitProposal(string memory _description) public {
        proposalCount++;
        proposals[proposalCount - 1] = Proposal({
            id: proposalCount - 1,
            proposer: msg.sender,
            description: _description,
            yesVotes: 0,
            noVotes: 0,
            active: true,
            executed: false
        });

        emit ProposalCreated(proposalCount - 1, msg.sender, _description);
    }

    // Function to vote on a proposal
    function vote(uint _proposalId, bool _support) public validProposal(_proposalId) {
        require(!hasVoted[_proposalId][msg.sender], "You have already voted");

        hasVoted[_proposalId][msg.sender] = true;
        if (_support) {
            proposals[_proposalId].yesVotes++;
        } else {
            proposals[_proposalId].noVotes++;
        }

        emit VoteCast(_proposalId, msg.sender, _support);
    }

    // Function to close a proposal (only proposer can close it)
    function closeProposal(uint _proposalId) public validProposal(_proposalId) {
        require(proposals[_proposalId].proposer == msg.sender, "Only proposer can close");
        
        proposals[_proposalId].active = false;
        bool passed = proposals[_proposalId].yesVotes > proposals[_proposalId].noVotes;
        
        emit ProposalClosed(_proposalId, passed);
    }

    // Function to view a proposal's details
    function getProposal(uint _proposalId) public view returns (Proposal memory) {
        require(_proposalId < proposalCount, "Proposal does not exist");
        return proposals[_proposalId];
    }
}