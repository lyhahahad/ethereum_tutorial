// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//컨트랙트 기본 구조
//1.활용 라이브러리
//2.변수
//3.생성자
//4.메서드

//활용 라이브러리 역할 분석
// 1.ERC721 : erc721 표준 구현
// https://docs.openzeppelin.com/contracts/4.x/api/token/erc721

// 2.ERC721Enumerable : erc721 추가 확장 구현

// 3.Ownable : 특정 기능에 대한 독점 액세스 권한을 부여할 수 있는 계정(소유자)이 있는 기본 액세스 제어 메커니즘을 제공하는 계약 모듈.
// https://docs.openzeppelin.com/contracts/2.x/api/ownership#Ownable
// -modifier 
// onlyOwner() : 토큰 소유자가 아니라면 에러 발생
// -functions 
// owner() : 현재 소유자의 계정 return
// isOwner() : caller가 현재 소유자라면 true return
// renounceOwnership() : 소유권 포기. onlyOwner사용 불가해짐. 오직 소유자만 호출할 수 있는 함수.
// transferOwnership(newOwner) : 새로운 소유자에게 소유권 이전. public
// _transferOwnership(newOwner) : 계약 소유권을 새 계정으로 이전. private

// 4.SafeMath : 오버플로 검사가 추가된 Solidity의 산술 연산에 대한 래퍼.
// add, sub, mul, div, mod
// https://docs.openzeppelin.com/contracts/2.x/api/math

// 5.ECDSA : 이더리움 계정 ECDSA 서명을 복구하고 관리하기 위한 기능을 제공한다.
// https://docs.openzeppelin.com/contracts/2.x/utilities
// https://hackernoon.com/a-closer-look-at-ethereum-signatures-5784c14abecc

// 6.ReentrancyGuard : 보안과 관련된 모듈로 함수에 대한 재진입 호출을 방지하는 데 도움이 되는 계약 모듈이다.
// https://docs.openzeppelin.com/contracts/4.x/api/security
// https://cryptomarketpool.com/reentrancy-attack-in-a-solidity-smart-contract/
// 재진입 호출에 대한 내용.

//아래 코드의 장점
//변수도 mintrelated ,world data로 나누었고 
//메서드 역시 Metadata, Mint, whitelist, security로 나누어 각각의 function들이 어떤 동작에 쓰이는지 구분이 잘 돼있다.
//컨트랙트 작성시 이와 같이 구분해서 쓰면 훨씬 코드 파악이 쉬울 것 같다.

// Compile with optimizer on, otherwise exceeds size limit.
//openzeppelin 100%활용.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTWorlds is ERC721Enumerable, Ownable, ReentrancyGuard {
  using SafeMath for uint256;
  using ECDSA for bytes32;

  /**
   * @dev Mint Related
   * */
  
  string public ipfsGateway = "https://ipfs.nftworlds.com/ipfs/";
  bool public mintEnabled = false;
  uint public totalMinted = 0;
  uint public mintSupplyCount;
  uint private ownerMintReserveCount;
  uint private ownerMintCount;
  uint private maxMintPerAddress;
  uint private whitelistExpirationTimestamp;
  mapping(address => uint16) private addressMintCount;

  uint public whitelistAddressCount = 0;
  uint public whitelistMintCount = 0;
  uint private maxWhitelistCount = 0;
  mapping(address => bool) private whitelist;

  /**
   * @dev World Data
   */
// 각 world는 아래의 속성이 있다.
  string[] densityStrings = ["Very High", "High", "Medium", "Low", "Very Low"];

  string[] biomeStrings = ["Forest","River","Swamp","Birch Forest","Savanna Plateau","Savanna","Beach","Desert","Plains","Desert Hills","Sunflower Glade","Gravel Strewn Mountains","Mountains","Wooded Mountains","Ocean","Deep Ocean","Swampy Hills","Evergreen Forest","Cursed Forest","Cold Ocean","Warm Ocean","Frozen Ocean","Stone Shore","Desert Lakes","Forest Of Flowers","Jungle","Badlands","Wooded Badlands Plateau","Evergreen Forest Mountains","Giant Evergreen Forest","Badlands Plateau","Dark Forest Hills","Snowy Tundra","Snowy Evergreen Forest","Frozen River","Snowy Beach","Snowy Mountains","Mushroom Shoreside Glades","Mushroom Glades","Frozen Fields","Bamboo Jungle","Destroyed Savanna","Eroded Badlands"];

  string[] featureStrings = ["Ore Mine","Dark Trench","Ore Rich","Ancient Forest","Drought","Scarce Freshwater","Ironheart","Multi-Climate","Wild Cows","Snow","Mountains","Monsoons","Abundant Freshwater","Woodlands","Owls","Wild Horses","Monolith","Heavy Rains","Haunted","Salmon","Sunken City","Oil Fields","Dolphins","Sunken Ship","Town","Reefs","Deforestation","Deep Caverns","Aquatic Life Haven","Ancient Ocean","Sea Monsters","Buried Jems","Giant Squid","Cold Snaps","Icebergs","Witch's Hut","Heat Waves","Avalanches","Poisonous Bogs","Deep Water","Oasis","Jungle Ruins","Rains","Overgrowth","Wildflower Fields","Fishing Grounds","Fungus Patch","Vultures","Giant Spider Nests","Underground City","Calm Waters","Tropical Fish","Mushrooms","Large Lake","Pyramid","Rich Oil Veins","Cave Of Ancients","Island Volcano","Paydirt","Whales","Undersea Temple","City Beneath The Waves","Pirate's Grave","Wildlife Haven","Wild Bears","Rotting Earth","Blizzards","Cursed Wildlife","Lightning Strikes","Abundant Jewels","Dark Summoners","Never-Ending Winter","Bandit Camp","Vast Ocean","Shroom People","Holy River","Bird's Haven","Shapeshifters","Spawning Grounds","Fairies","Distorted Reality","Penguin Colonies","Heavenly Lights","Igloos","Arctic Pirates","Sunken Treasure","Witch Tales","Giant Ice Squid","Gold Veins","Polar Bears","Quicksand","Cats","Deadlands","Albino Llamas","Buried Treasure","Mermaids","Long Nights","Exile Camp","Octopus Colony","Chilled Caves","Dense Jungle","Spore Clouds","Will-O-Wisp's","Unending Clouds","Pandas","Hidden City Of Gold","Buried Idols","Thunder Storms","Abominable Snowmen","Floods","Centaurs","Walking Mushrooms","Scorched","Thunderstorms","Peaceful","Ancient Tunnel Network","Friendly Spirits","Giant Eagles","Catacombs","Temple Of Origin","World's Peak","Uninhabitable","Ancient Whales","Enchanted Earth","Kelp Overgrowth","Message In A Bottle","Ice Giants","Crypt Of Wisps","Underworld Passage","Eskimo Settlers","Dragons","Gold Rush","Fountain Of Aging","Haunted Manor","Holy","Kraken"];

  struct WorldData {
    uint24[5] geographyData; // landAreaKm2, waterAreaKm2, highestPointFromSeaLevelM, lowestPointFromSeaLevelM, annualRainfallMM,
    uint16[9] resourceData; // lumberPercent, coalPercent, oilPercent, dirtSoilPercent, commonMetalsPercent, rareMetalsPercent, gemstonesPercent, freshWaterPercent, saltWaterPercent,
    uint8[3] densities; // wildlifeDensity, aquaticLifeDensity, foliageDensity
    uint8[] biomes;
    uint8[] features;
  }

  mapping(uint => int32) private tokenSeeds;
  mapping(uint => string) public tokenMetadataIPFSHashes;
  mapping(string => uint) private ipfsHashTokenIds;
  mapping(uint => WorldData) private tokenWorldData;

  /**
   * @dev Contract Methods
   */
// 생성자 사용시 openzepplin의 ERC721을 활용해 토큰을 생성한다.
// ERC721 생성자는 토큰 이름과 심볼을 입력으로 받는다.
// NFTWORLDS 컨트랙트는 아래 5가지 입력을 받아 컨트랙트를 만든다.
// 각각의 변수의 SETTER를 확인해보면 변경 가능한지 알 수 있다.
// 해당 변수들은 모두 변경이 불가능하다.
// etherscan에서 어떤 값을 입력했는지 확인할 수 있다.
// -----Decoded View---------------
// Arg [0] : _mintSupplyCount (uint256): 10000
// Arg [1] : _ownerMintReserveCount (uint256): 100
// Arg [2] : _whitelistExpirationTimestamp (uint256): 1633676340
// Arg [3] : _maxWhitelistCount (uint256): 4000
// Arg [4] : _maxMintPerAddress (uint256): 2

  constructor(
    uint _mintSupplyCount,
    uint _ownerMintReserveCount,
    uint _whitelistExpirationTimestamp,
    uint _maxWhitelistCount,
    uint _maxMintPerAddress
  ) ERC721("NFT Worlds", "NFT Worlds") {
    mintSupplyCount = _mintSupplyCount;
    ownerMintReserveCount = _ownerMintReserveCount;
    whitelistExpirationTimestamp = _whitelistExpirationTimestamp;
    maxWhitelistCount = _maxWhitelistCount;
    maxMintPerAddress = _maxMintPerAddress;
  }

  /************
   * Metadata *
   ************/
  /**
  getter
  기능 : 토큰의 uri를 get하는 함수
  참조 전역 변수 : 
  tokenMetadataIPFSHashes = 토큰id -> ipfs 해시
  에러 : 
  해당 토큰id의 uri가 존재하는가?
  */
  function tokenURI(uint _tokenId) override public view returns (string memory) {
    require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");

    return string(abi.encodePacked(ipfsGateway, tokenMetadataIPFSHashes[_tokenId]));
  }

  /*
  setter
  기능 : ipfsGateway주소를 바꿔주는 setter.
   */
  function emergencySetIPFSGateway(string memory _ipfsGateway) external onlyOwner {
     ipfsGateway = _ipfsGateway;
  }

  /* 
  setter
  기능 : 토큰id에 대한 ipfs 주소를 바꿀 수 있다.
  참조 전역 변수 : 
  tokenMetadataIPFSHashes = 토큰 id -> ipfs 해시
  ipfsHashTokenIds = ipfs 해시 -> 토큰 id
  에러 : 
  1.msgsender가 해당 토큰 id의 owner가 아니면
  2.ipfs 해시가 이미 다른 id에 배정된 경우.
  */
  function updateMetadataIPFSHash(uint _tokenId, string calldata _tokenMetadataIPFSHash) tokenExists(_tokenId) external {
    require(_msgSender() == ownerOf(_tokenId), "You are not the owner of this token.");
    require(ipfsHashTokenIds[_tokenMetadataIPFSHash] == 0, "This IPFS hash has already been assigned.");

    tokenMetadataIPFSHashes[_tokenId] = _tokenMetadataIPFSHash;
    ipfsHashTokenIds[_tokenMetadataIPFSHash] = _tokenId;
  }

  function getSeed(uint _tokenId) tokenExists(_tokenId) external view returns (int32) {
    require(_msgSender() == ownerOf(_tokenId), "You are not the owner of this token.");

    return tokenSeeds[_tokenId];
  }

  function getGeography(uint _tokenId) tokenExists(_tokenId) external view returns (uint24[5] memory) {
    return tokenWorldData[_tokenId].geographyData;
  }

  function getResources(uint _tokenId) tokenExists(_tokenId) external view returns (uint16[9] memory) {
    return tokenWorldData[_tokenId].resourceData;
  }

  function getDensities(uint _tokenId) tokenExists(_tokenId) external view returns (string[3] memory) {
    uint totalDensities = 3;
    string[3] memory _densitiesStrings = ["", "", ""];

    for (uint i = 0; i < totalDensities; i++) {
        string memory _densityString = densityStrings[tokenWorldData[_tokenId].densities[i]];
        _densitiesStrings[i] = _densityString;
    }

    return _densitiesStrings;
  }

  function getBiomes(uint _tokenId) tokenExists(_tokenId) external view returns (string[] memory) {
    uint totalBiomes = tokenWorldData[_tokenId].biomes.length;
    string[] memory _biomes = new string[](totalBiomes);

    for (uint i = 0; i < totalBiomes; i++) {
        string memory _biomeString = biomeStrings[tokenWorldData[_tokenId].biomes[i]];
        _biomes[i] = _biomeString;
    }

    return _biomes;
  }

  function getFeatures(uint _tokenId) tokenExists(_tokenId) external view returns (string[] memory) {
    uint totalFeatures = tokenWorldData[_tokenId].features.length;
    string[] memory _features = new string[](totalFeatures);

    for (uint i = 0; i < totalFeatures; i++) {
        string memory _featureString = featureStrings[tokenWorldData[_tokenId].features[i]];
        _features[i] = _featureString;
    }

    return _features;
  }

  modifier tokenExists(uint _tokenId) {
    require(_exists(_tokenId), "This token does not exist.");
    _;
  }

  /********
   * Mint *
   ********/

  struct MintData {
    uint _tokenId;
    int32 _seed;
    WorldData _worldData;
    string _tokenMetadataIPFSHash;
  }

  function mintWorld(
    MintData calldata _mintData,
    bytes calldata _signature // prevent alteration of intended mint data
  ) external nonReentrant {
    require(verifyOwnerSignature(keccak256(abi.encode(_mintData)), _signature), "Invalid Signature");

    require(_mintData._tokenId > 0 && _mintData._tokenId <= mintSupplyCount, "Invalid token id.");
    require(mintEnabled, "Minting unavailable");
    require(totalMinted < mintSupplyCount, "All tokens minted");

    require(_mintData._worldData.biomes.length > 0, "No biomes");
    require(_mintData._worldData.features.length > 0, "No features");
    require(bytes(_mintData._tokenMetadataIPFSHash).length > 0, "No ipfs");

    if (_msgSender() != owner()) {
        require(
          addressMintCount[_msgSender()] < maxMintPerAddress,
          "You cannot mint more."
        );

        require(
          totalMinted + (ownerMintReserveCount - ownerMintCount) < mintSupplyCount,
          "Available tokens minted"
        );

        // make sure remaining mints are enough to cover remaining whitelist.
        require(
          (
            block.timestamp > whitelistExpirationTimestamp ||
            whitelist[_msgSender()] ||
            (
              totalMinted +
              (ownerMintReserveCount - ownerMintCount) +
              ((whitelistAddressCount - whitelistMintCount) * 2)
              < mintSupplyCount
            )
          ),
          "Only whitelist tokens available"
        );
    } else {
        require(ownerMintCount < ownerMintReserveCount, "Owner mint limit");
    }

    tokenWorldData[_mintData._tokenId] = _mintData._worldData;

    tokenMetadataIPFSHashes[_mintData._tokenId] = _mintData._tokenMetadataIPFSHash;
    ipfsHashTokenIds[_mintData._tokenMetadataIPFSHash] = _mintData._tokenId;
    tokenSeeds[_mintData._tokenId] = _mintData._seed;

    addressMintCount[_msgSender()]++;
    totalMinted++;

    if (whitelist[_msgSender()]) {
      whitelistMintCount++;
    }

    if (_msgSender() == owner()) {
        ownerMintCount++;
    }

    _safeMint(_msgSender(), _mintData._tokenId);
  }

  function setMintEnabled(bool _enabled) external onlyOwner {
    mintEnabled = _enabled;
  }

  /*************
   * Whitelist *
   *************/

  function joinWhitelist(bytes calldata _signature) public {
    require(verifyOwnerSignature(keccak256(abi.encode(_msgSender())), _signature), "Invalid Signature");
    require(!mintEnabled, "Whitelist is not available");
    require(whitelistAddressCount < maxWhitelistCount, "Whitelist is full");
    require(!whitelist[_msgSender()], "Your address is already whitelisted");

    whitelistAddressCount++;

    whitelist[_msgSender()] = true;
  }

  /************
   * Security *
   ************/

  function verifyOwnerSignature(bytes32 hash, bytes memory signature) private view returns(bool) {
    return hash.toEthSignedMessageHash().recover(signature) == owner();
  }
}