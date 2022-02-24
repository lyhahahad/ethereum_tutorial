### building-scalable-full-stack-apps-on-ethereum-with-polygon <br>
https://dev.to/dabit3/building-scalable-full-stack-apps-on-ethereum-with-polygon-2cfb<br>

## 사용 툴 <br>
front - next.js<br>
solidity development environment - hardhat<br>
deploy - polygon testnet mumbai, local harhat node<br>
file storage - ipfs<br>
ethereum web client library - ethers.js<br>

## 개발 과정(환경 설정은 제외)<br>
# 1.hardhat.config.js 추가 <br>
local, mumbai네트워크 추가. 해당 파일에서 솔리티디 버전, 네트워크 연결 등 컨트랙트 배포에 대한 설정을 할 수 있다.<br>
# 2.smart contract NFT+NFTMARKET 작성 openzeppelin 활용.<br>
# 3.컨트랙트 test 파일 작성<br>
컨트랙트는 한 번 배포하면 원칙적으로 수정이 불가능하기 때문에 test가 필수이다.<br>
# 4.building front end<br>
ethers.js를 활용해 블록체인과 상호작용한다.<br>
# 5.smart contract deploy<br>
이때도 ethers.js를 활용해 블록체인과 상호작용한다.<br>
# 6.hardhat, mumbai에 배포하기.<br>
# 7.front 실행.<br>