// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

// ERC721URIStorage는 ERC721을 상속하는 변수이기 때문에 ERC721URIStorage을 상속하면 ERC721까지 상속받을 수 있다.
// 스토리지 기반의 토큰 URI를 관리한다.
contract NFT is ERC721URIStorage {
    // counter는 토큰 아이디로 쓰는데 활용한다.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;

    // marketplaceAddress를 받아서 토큰 이동이 가능하게 승인해 둔다.
    constructor(address marketplaceAddress) ERC721("Metaverse Tokens", "METT") {
        contractAddress = marketplaceAddress;
    }

    function createToken(string memory tokenURI) public returns (uint) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        setApprovalForAll(contractAddress, true);
        return newItemId;
    }
}