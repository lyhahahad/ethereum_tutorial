# 목적 이더리움 개발 기초 다지기 <br>
이더리움은 가스비가 높기 때문에 낮은 가스비로 동작할 수 있는 스마트 컨트랙트를 짜는 것이 중요하다.<br> 또한 한 번 올리면 원칙적으로 수정이 불가하기 때문에(code is law) 제대로 감사하지 않으면 해킹으로 인해 큰 손실이 발생할 수 있다.<br> 즉 효율적으로 동작하면서 안전한 컨트랙트를 작성할 수 있어야 한다.<br> 그렇게 하기 위해서는 솔리디티, 이더리움, evm에 대한 깊은 이해가 필요하다.<br> 또한 협업을 위해서는 dapp의 아키텍쳐를 이해하고 있어야 한다.<br>
상기 목적을 달성하기 위해서 본 개발자가 학습해야 할 것은 다음과 같다.<br>
1. solidity 학습 및 기존 프로젝트 컨트랙트 분석(가독성과 효율성 중심으로 opcode참고)<br>
2. evm 학습<br>
3. audit관련 지식 습득<br>
4. full stack 튜토리얼 경험.<br>
핵심 정리<br>
frontend에서 블록체인과 소통하기 위해서는 web3.js 라이브러리를 사용한다.
contract abi와 contractaddress로 contract 사용을 위한 인터페이스 객체를 만든다.
tx는 from, to, nonce, gas, data 변수를 포함하는데 data 변수에 위에서 만든 객체를 통해 컨트랙트의 function에 접근할 수 있다.

### 1.solidity학습 참고 자료<br>
https://docs.soliditylang.org/en/v0.8.11/index.html<br>
https://eips.ethereum.org/EIPS/eip-721<br>
https://etherscan.io/token/0xbd4455da5929d5639ee098abfaa3241e9ae111af#balances<br>
https://ethereum.org/en/developers/docs/evm/opcodes/

### 2.evm 학습 참고 자료<br>
https://takenobu-hs.github.io/downloads/ethereum_evm_illustrated.pdf<br>

### 3.audit 학습 참고자료<br>
https://ethereum.org/en/developers/tutorials/guide-to-smart-contract-security-tools/

### 4.full stack 학습 참고 자료<br>
https://docs.alchemy.com/alchemy/tutorials/nft-minter<br>
https://dev.to/dabit3/building-scalable-full-stack-apps-on-ethereum-with-polygon-2cfb<br>
https://www.preethikasireddy.com/post/the-architecture-of-a-web-3-0-application<br>
https://ethereum.org/en/developers/tutorials/how-to-write-and-deploy-an-nft/<br>

+a<br>
테스트 및 디버깅 방법 by hardhat<br>
https://hardhat.org/tutorial/testing-contracts.html<br>