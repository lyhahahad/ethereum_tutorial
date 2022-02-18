import './App.css';
import { useState } from 'react';
import { ethers } from 'ethers'
import Greeter from './artifacts/contracts/Greeter.sol/Greeter.json'

// Update with the contract address logged out to the CLI when it was deployed 
const greeterAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"

function App() {
  // store greeting in local state
  const [greeting, setGreetingValue] = useState()

  // request access to the user's MetaMask account
  async function requestAccount() {
    //Use request to submit RPC requests to Ethereum via MetaMask. 
    //It returns a Promise that resolves to the result of the RPC method call.
    await window.ethereum.request({ method: 'eth_requestAccounts' });
  }

  // call the smart contract, read the current greeting value
  // 스마트컨트랙트 불러오고 현재 greeting value 읽기.
  async function fetchGreeting() {
  // window.ethereum은  MetaMask에서 사용자가 방문한 웹사이트에 주입한 글로벌 API이다.
  // 메타마스크가 없는 브라우저에서 실행하면 undefined가 나온다.
  // 메타마스크가 설치된 브라우저에서 실행되는지 체크하는 부분이라고 보면됨.
    if (typeof window.ethereum !== 'undefined') {
      //provider : MetaMask 플러그인은 Chrome 브라우저용 이더리움을 활성화하여 사람들이 새로운 생태계를 쉽게 시작할 수 있도록 하여 이더리움 네트워크를 표준 ​​Web3 공급자로 노출합니다
      //provider : 메타마스크를 제어하는 부분이라고 보면 된다.
      const provider = new ethers.providers.Web3Provider(window.ethereum)
      //constract는 소통할 컨트랙트 주소와 abi, 컨트랙트와 소통할 주소로 구성된다.
      const contract = new ethers.Contract(greeterAddress, Greeter.abi, provider)
      try {
        // 현재 해당 주소의 greet값 가져오기.
        const data = await contract.greet()
        console.log('data: ', data)
      } catch (err) {
        console.log("Error: ", err)
      }
    }    
  }

  // call the smart contract, send an update
  async function setGreeting() {
    //greeting 값이 없다면 굳이 컨트랙트를 진행할 필요없음.
    if (!greeting) return
    if (typeof window.ethereum !== 'undefined') {
      await requestAccount()
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      // 계정 가져오기.
      const signer = provider.getSigner()
      console.log(signer)
      const contract = new ethers.Contract(greeterAddress, Greeter.abi, signer)
      //트랜잭션 생성
      const transaction = await contract.setGreeting(greeting)
      //트랜잭션 진행
      await transaction.wait()
      fetchGreeting()
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <button onClick={fetchGreeting}>Fetch Greeting</button>
        <button onClick={setGreeting}>Set Greeting</button>
        <input onChange={e => setGreetingValue(e.target.value)} placeholder="Set greeting" />
      </header>
    </div>
  );
}

export default App;