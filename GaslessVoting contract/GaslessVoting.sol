// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";

contract GaslessVoting is Context {
    address public immutable trustedForwarder;
    mapping(address => bool) public hasVoted;
    mapping(uint256 => uint256) public votes; // Proposal ID => Vote count
    uint256 public proposalCount;

    constructor(address _trustedForwarder) {
        trustedForwarder = _trustedForwarder;
    }

    // Override _msgSender to support meta-transactions
    function _msgSender() internal view override returns (address) {
        if (msg.sender == trustedForwarder) {
            // Extract the original sender from the data
            return address(bytes20(msg.data[msg.data.length - 20:]));
        }
        return msg.sender;
    }

    function createProposal() external returns (uint256) {
        proposalCount++;
        return proposalCount;
    }

    function vote(uint256 proposalId) external {
        address voter = _msgSender();
        require(proposalId <= proposalCount, "Invalid proposal ID");
        require(!hasVoted[voter], "Already voted");
        hasVoted[voter] = true;
        votes[proposalId]++;
    }

    function getVoteCount(uint256 proposalId) external view returns (uint256) {
        return votes[proposalId];
    }
}