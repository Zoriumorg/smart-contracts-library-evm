// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

/// @title ERC1155WithRoyalties
/// @notice ERC1155 contract with royalty support via ERC2981
contract ERC1155WithRoyalties is ERC1155, Ownable, ERC1155Burnable, IERC2981 {
    // Royalty percentage in basis points (e.g., 1000 = 10%)
    uint256 private _royaltyBps;
    // Royalty recipient address
    address private _royaltyRecipient;
    // Token name
    string public name;
    // Token symbol
    string public symbol;
    // Total supply tracking for each token ID
    mapping(uint256 => uint256) private _totalSupply;

    constructor(
        string memory uri_,
        string memory name_,
        string memory symbol_,
        address royaltyRecipient_,
        uint256 royaltyBps_
    ) ERC1155(uri_) Ownable(msg.sender) {
        name = name_;
        symbol = symbol_;
        _royaltyRecipient = royaltyRecipient_;
        require(royaltyBps_ <= 10000, "Royalty too high");
        _royaltyBps = royaltyBps_;
    }

    /// @notice Mint a single token
    /// @param to Recipient address
    /// @param id Token ID
    /// @param amount Amount to mint
    /// @param data Additional data
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(to, id, amount, data);
        _totalSupply[id] += amount;
    }

    /// @notice Mint multiple tokens
    /// @param to Recipient address
    /// @param ids Array of token IDs
    /// @param amounts Array of amounts
    /// @param data Additional data
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
        for (uint256 i = 0; i < ids.length; i++) {
            _totalSupply[ids[i]] += amounts[i];
        }
    }

    /// @notice Set a new URI for token metadata
    /// @param newuri New URI
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /// @notice Get total supply of a token
    /// @param id Token ID
    /// @return Total supply
    function totalSupply(uint256 id) public view returns (uint256) {
        return _totalSupply[id];
    }

    /// @notice ERC2981 royalty info
    /// @param tokenId Token ID
    /// @param salePrice Sale price
    /// @return receiver Royalty recipient
    /// @return royaltyAmount Royalty amount
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        receiver = _royaltyRecipient;
        royaltyAmount = (salePrice * _royaltyBps) / 10000;
    }

    /// @notice Update royalty recipient and percentage
    /// @param recipient New recipient
    /// @param royaltyBps New royalty percentage in basis points
    function setRoyaltyInfo(address recipient, uint256 royaltyBps) public onlyOwner {
        require(royaltyBps <= 10000, "Royalty too high");
        require(recipient != address(0), "Invalid recipient");
        _royaltyRecipient = recipient;
        _royaltyBps = royaltyBps;
    }

    /// @notice Check supported interfaces (ERC165)
    /// @param interfaceId Interface ID to check
    /// @return True if supported
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC2981).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}