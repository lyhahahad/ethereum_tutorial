async function main() {
    // ethers.js의 ContractFactory는 새로운 스마트 계약을 배포하는 데 사용되는 추상화이므로 여기에서 MyNFT는 NFT 계약의 인스턴스를 위한 팩토리입니다. 
    // hardhat-ethers 플러그인을 사용할 때 ContractFactory 및 Contract 인스턴스는 기본적으로 첫 번째 서명자에 연결됩니다.
    const MyNFT = await ethers.getContractFactory("MyNFT")
  
    //ContractFactory에서 deploy()를 호출하면 배포가 시작되고 계약으로 확인되는 Promise가 반환됩니다. 
    //이것은 각 스마트 계약 기능에 대한 메서드가 있는 개체입니다.
    // Start deployment, returning a promise that resolves to a contract object
    const myNFT = await MyNFT.deploy()
    await myNFT.deployed()
    console.log("Contract deployed to address:", myNFT.address)
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })
  