import { ethers } from "hardhat";

async function main() {
  const [owner] = await ethers.getSigners()
  const factory = await ethers.getContractAt("UniswapV2Factory", "")

  // set chef
  // await factory.setChef("")

  // creation code
  // console.log(`creationCode: ${await factory.pairCodeHash()}`)

  // console.log(`set MasterChef ${await factory.chef()}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
