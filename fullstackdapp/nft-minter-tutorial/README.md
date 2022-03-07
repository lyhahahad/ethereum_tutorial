# 🗃 NFT Minter Tutorial<br>
### full stack<br>
![20220305123526](https://user-images.githubusercontent.com/96465753/156866219-252b0f6f-997e-4ec8-be1b-1f87b08629b7.png)<br>

### front 구성 요소<br>
![20220304105152](https://user-images.githubusercontent.com/96465753/156683966-677af707-c024-47b5-a327-7bf92dd29041.png)<br>
-utils/interact.js = connectWallet, getCurrentWalletConnected, addWalletListener, mintNFT(pinJSONToIPFS use)<br>
-utils/pinata.js = pinJSONToIPFS<br>
-src/minter.js = interact.js us<br>
-contract를 블록체인에 create 후, web3.js를 통해 통신한다. 이때 contract, abi를 사용한다.<br>

# 에러 해결<br>
1.'RPC Error: Already processing eth_requestAccounts. Please wait.'+ 지갑 연결 메시지 안뜸.+지갑 없을 때 나와야 하는 페이지 안나옴.<br>
상황 : minter-utils/interact.js에 연결 메서드를 만들고 실행하려고 했는데 다음과 같은 에러가 발생함.<br>

# 기타 자료 학습<br>
https://ethereum.org/en/developers/tutorials/how-to-write-and-deploy-an-nft/<br>
스마트 컨트랙트 작성하고 배포하기.<br>
1.hardhat - smartcontract compile, deploy, test, debug tool hardhat.config.js를 통해 관리<br>
어떤 네트워크를 사용할지 설정할 수 있다. apiurl, 프라이빗키가 필요하다. env를 통해 apiurl과 프라이빗키 보호.<br>
2.write smartcontract - openzeppelin<br>
3.ethers.js - connect ethereum blockchain (=web3.js ethers가 좀더 가볍다. 하지만 패키지 용량을 조절하는 경우가 아니라면 굳이 ethers.js를 사용할 필요는 없다.)<br>
https://ethereum.org/en/developers/tutorials/how-to-mint-an-nft/<br>
배포한 컨트랙트 주소에 트랜잭션 보내기.<br>
transaction : 프라이빗, 퍼블릭 키, contract주소, 컨트랙트 abi로 메서드 호출, web3.js 사용.<br>