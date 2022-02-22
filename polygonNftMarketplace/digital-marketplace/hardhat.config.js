
// require('dotenv').config();
// require("@nomiclabs/hardhat-ethers");
// const { API_URL, PRIVATE_KEY } = process.env;

/* hardhat.config.js */
require("@nomiclabs/hardhat-waffle")
require('dotenv').config();
const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337
    },
//  mumbai: {
//    url: "https://rpc-mumbai.maticvigil.com",
//    accounts: [PRIVATE_KEY]
//  }
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}