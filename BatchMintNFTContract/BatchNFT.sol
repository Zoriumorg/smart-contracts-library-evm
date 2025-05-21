// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BatchMintNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 public constant MAX_SUPPLY = 17; // Maximum 17 NFTs for abstract paintings

    constructor(address initialOwner) ERC721("AbstractNFT", "ANFT") Ownable(initialOwner) {}

    /// @notice Mints multiple NFTs to different recipients with unique metadata URIs
    /// @param recipients Array of addresses to receive the NFTs
    /// @param tokenURIs Array of IPFS metadata URIs for each NFT
    function batchMint(address[] calldata recipients, string[] calldata tokenURIs) external onlyOwner {
        require(recipients.length == tokenURIs.length, "Arrays length mismatch");
        require(recipients.length <= 17, "Batch size exceeds limit");
        require(_tokenIdCounter.current() + recipients.length <= MAX_SUPPLY, "Exceeds max supply");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            uint256 newTokenId = _tokenIdCounter.current();
            _safeMint(recipients[i], newTokenId);
            _setTokenURI(newTokenId, tokenURIs[i]);
            _tokenIdCounter.increment();
        }
    }

    /// @notice Mints multiple NFTs to the caller with unique metadata URIs
    /// @param tokenURIs Array of IPFS metadata URIs for each NFT
    function batchMintToSender(string[] calldata tokenURIs) external onlyOwner {
        require(tokenURIs.length > 0, "No URIs provided");
        require(tokenURIs.length <= 17, "Batch size exceeds limit");
        require(_tokenIdCounter.current() + tokenURIs.length <= MAX_SUPPLY, "Exceeds max supply");

        for (uint256 i = 0; i < tokenURIs.length; i++) {
            uint256 newTokenId = _tokenIdCounter.current();
            _safeMint(msg.sender, newTokenId);
            _setTokenURI(newTokenId, tokenURIs[i]);
            _tokenIdCounter.increment();
        }
    }

    /// @notice Returns the total number of NFTs minted
    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    /// @notice Allows the owner to withdraw any ETH sent to the contract
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(msg.sender).transfer(balance);
    }
}