# 🗃 NFT Minter Tutorial<br>

### 구성요소<br>
-utils/interact.js = connectWallet, getCurrentWalletConnected, addWalletListener, mintNFT(pinJSONToIPFS use)<br>
-utils/pinata.js = pinJSONToIPFS<br>
-src/minter.js = interact.js us<br>
-contract를 블록체인에 create 후, web3.js를 통해 통신한다. 이때 contract, abi를 사용한다.<br>

# 에러 해결<br>
1.'RPC Error: Already processing eth_requestAccounts. Please wait.'+ 지갑 연결 메시지 안뜸.+지갑 없을 때 나와야 하는 페이지 안나옴.<br>
상황 : minter-utils/interact.js에 연결 메서드를 만들고 실행하려고 했는데 다음과 같은 에러가 발생함.<br>


