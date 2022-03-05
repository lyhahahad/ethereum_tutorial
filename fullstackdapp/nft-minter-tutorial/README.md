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


