require("dotenv").config()
const API_URL = process.env.API_URL
const { createAlchemyWeb3 } = require("@alch/alchemy-web3")
const web3 = createAlchemyWeb3(API_URL)
const contract = require("../artifacts/contracts/MyNFT.sol/MyNFT.json")
console.log(JSON.stringify(contract.abi))

const contractAddress = "0xcc184594d90eAc2acDd05036986c7E6eF451fA3a"

const nftContract = new web3.eth.Contract(contract.abi, contractAddress)
