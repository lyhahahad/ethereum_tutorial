# 🗃 NFT Minter Tutorial Starter Files<br>

This project contains the starter files for [Alchemy's NFT Minter tutorial](https://docs.alchemyapi.io/alchemy/tutorials/nft-minter), in which we teach you how to connect your smart contract to your React dApp project by building an NFT Minter using Metamask and Web3.<br>

### 구성요소<br>
-Minter.js = mint 페이지.<br>
-utils/interact.js = mint페이지에서 사용할 메서드, 지갑 connect, getCurrentWalletConnected 메서드가 있다. 전자는 지갑을 연결하는 메서드이고 후자는 연결된 지갑의 정보를 가져오는 메서드이다. 둘다 window.ethereum, 메타마스크에서 제공하는 api를 사용한다.<br>


# 에러 해결<br>
1.'RPC Error: Already processing eth_requestAccounts. Please wait.'+ 지갑 연결 메시지 안뜸.+지갑 없을 때 나와야 하는 페이지 안나옴.<br>
상황 : minter-utils/interact.js에 연결 메서드를 만들고 실행하려고 했는데 다음과 같은 에러가 발생함.<br>


