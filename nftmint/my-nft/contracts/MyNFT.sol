//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// openzeppelin은 주요 erc 표준을 구현하기 쉽게하는 라이브러리를 제공한다.

// https://eips.ethereum.org/EIPS/eip-721 해당 표준을 만족하는 erc721 컨트랙트를 가져온다.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// 1만큼만 증가 또는 감소할 수 있는 카운터를 제공합니다. 
// 스마트 계약은 카운터를 사용하여 생성된 총 NFT 수를 추적하고 새로운 NFT에 고유 ID를 설정합니다.
// 고유id를 설정하기 위한 카운터
import "@openzeppelin/contracts/utils/Counters.sol";

//스마트 계약에 대한 액세스 제어 를 설정 하므로 스마트 계약 소유자(귀하)만 NFT를 발행할 수 있습니다.
import "@openzeppelin/contracts/access/Ownable.sol";

//ERC721 token with storage based token URI management.
//uri를 관리하는 erc721 토큰 스토리지. 
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

//ERC721URIStorage,ownable 상속.
//ownable을 상속하면 컨트랙트 생성자만이 nft를 발행할 수 있다.
contract MyNFT is ERC721URIStorage, Ownable {
    //상태변수
    //counters 라이브러리를 counter변수들이 쉽게 사용할 수 있도록 한다.
    using Counters for Counters.Counter;
    //counter를 이용해 tokenids를 설정한다. 
    Counters.Counter private _tokenIds;

    //생성자
    constructor() public ERC721("MyNFT", "NFT") {}

    // mint 메서드, nft를 수신받을 주소와 토큰 메타데이터에 기록한 uri를 가져온다.
    //다수의 사람이 발행할 수 있도록 하기 위해서는 onlyOwner라는 단어를 제거하면 된다.
    function mintNFT(address recipient, string memory tokenURI)
        public onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        // _mint함수는 openzeppelin-erc721 파일에 이미 구현돼 있다.
        _mint(recipient, newItemId);
        // ERC721URIStorage에 구현돼 있다.
        //tokenurl의 경우 메타데이터를 담은 json문서로 해석되어야 한다.
        _setTokenURI(newItemId, tokenURI);

        //새로운 아이템의 id를 return한다.
        return newItemId;
    }
}
