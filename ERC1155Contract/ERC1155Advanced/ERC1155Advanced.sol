// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import necessary OpenZeppelin contracts
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Define contract, inherit from ERC1155 (token standard),
// ERC1155Burnable (allows tokens to be destroyed),
// and Ownable (restricts certain functions to the contract owner)
contract DEMOPOP is ERC1155, ERC1155Burnable, Ownable {
    // Define constant token IDs for ease of use
    uint256 public constant POP = 0;
    uint256 public constant LuckyNFT = 2;

    // Constructor function runs once when the contract is deployed
    // It sets the base URI for token metadata and mints some initial tokens
    constructor() 
        ERC1155(
            "https://ipfs.io/ipfs/bafybeiejh623dkrr77b5thr3xo75ptwmurcmb6zzln5wyimfpwvltoewci/{id}.json"
        ) 
        Ownable(msg.sender)  // Initialize Ownable with deployer as owner
    {
        _mint(msg.sender, POP, 100, "");
        _mint(msg.sender, LuckyNFT, 1, "");
    }

    // Override the URI function to provide token-specific metadata
    function uri(uint256 tokenId) public pure override returns (string memory) {
        return string(
            abi.encodePacked(
                "https://ipfs.io/ipfs/bafybeiejh623dkrr77b5thr3xo75ptwmurcmb6zzln5wyimfpwvltoewci/",
                Strings.toString(tokenId),
                ".json"
            )
        );
    }

    // Provide a URI for the entire contract
    function contractURI() public pure returns (string memory) {
        return "https://ipfs.io/ipfs/bafybeiejh623dkrr77b5thr3xo75ptwmurcmb6zzln5wyimfpwvltoewci/collection.json";
    }

    // Owner can distribute tokens to a list of addresses
    function airdrop(uint256 tokenId, address[] calldata recipients) external onlyOwner {
        for (uint256 i = 0; i < recipients.length; i++) {
            _safeTransferFrom(msg.sender, recipients[i], tokenId, 1, "");
            
            // If the balance of POP and LuckyNFT meets certain criteria, transfer a LuckyNFT as well
            if (
                balanceOf(owner(), POP) == 90 &&
                balanceOf(owner(), LuckyNFT) == 1
            ) {
                _safeTransferFrom(msg.sender, recipients[i], LuckyNFT, 1, "");
            }
        }
    }

    // Override this function to enforce custom rules before any token transfer
    // In this case, the rule is: only the contract owner can transfer tokens, or tokens can be burned
    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155) {
        super._update(from, to, ids, values);
        require(
            msg.sender == owner() || to == address(0),
            "Token cannot be transferred, only be burned"
        );
    }
}