/** @type import('hardhat/config').HardhatUserConfig */

require("dotenv").config();
require("@nomicfoundation/hardhat-verify");
require("@nomicfoundation/hardhat-ethers");
const { API_URL, PRIVATE_KEY,API_KEY } = process.env;
module.exports = {
 solidity: "0.8.20",
 defaultNetwork: "mumbai",
 networks: {
   hardhat: {},
   mumbai: {
     url: API_URL,
     accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: API_KEY 
    }
  }
};
