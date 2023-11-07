// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; //contract for NFT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Cricketers is ERC721, ERC721URIStorage {
    uint256 private _nextTokenId = 0;
    address public contracts_Owner;
    uint256 public royalityfees = 5;
    using Strings for uint256;

    mapping(uint256 => address) Owner;
    mapping(uint256 => uint256) cost;
    mapping(uint256 => bool) listed;

    constructor() ERC721("Cricketers", "Bat") {
        contracts_Owner = msg.sender;
    }

    function Minting(string memory _uri, uint256 setSalePrice) public {
        uint256 tokenId = ++_nextTokenId; // increasing the _nextTokenId
        _mint(msg.sender, tokenId); // calling minting function
        Owner[tokenId] = msg.sender; // storing owner with token id using mapping
        _setTokenURI(tokenId, _uri); // setting tokenURI
        listForSale(tokenId, setSalePrice * 10**18); //callling listForSale function
    }

    function update_royalityfeesInPercentage(
        uint256 _royalityfees // only contract owner can change the royality percentage
    ) public {
        require(msg.sender == contracts_Owner, "you cannot change this");
        royalityfees = _royalityfees;
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(
        uint256 tokenId // getting tokenURI only owner of token can check this
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function listForSale(uint256 tokenId, uint256 _amount) internal {
        // calling internally for setting price for selling NFT
        require(
            msg.sender == Owner[tokenId],
            "you are not owner you cannot list the price for this NFT"
        );
        cost[tokenId] = _amount;
        listed[tokenId] = true;
    }

    function buyNFT(uint256 tokenId) public payable {
        // person will come and can buy NFT. Owner cannot buy NFT
        require(
            listed[tokenId] == true,
            "this token Id is not listed for sale"
        );
        require(msg.sender != Owner[tokenId], "you are owner");
        require(msg.value == cost[tokenId], "pay to buy");
        uint256 royality = (msg.value * royalityfees) / 100;
        payTo(contracts_Owner, royality); // transfering money to contract owner
        payTo(Owner[tokenId], (msg.value - royality)); // transfering money to owner of NFT from customer
        _transfer(Owner[tokenId], msg.sender, tokenId); // after money recieved ownership is transfered
        Owner[tokenId] = msg.sender; // updating Owner in mapping
    }

    function payTo(address to, uint256 amount) internal {
        // payTo function is used to transfer money
        (bool success, ) = payable(to).call{value: amount}("");
        require(success);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
