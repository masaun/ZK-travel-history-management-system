//const hre = require("hardhat");
import hre from 'hardhat';

async function main() {
  // const accounts = await hre.ethers.getSigners();

  // for (const account of accounts) {
  //   console.log(account.address);
  // }
  console.log("Hardhat script is successfully running!!"); /// @dev - Successfully running!! 
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});