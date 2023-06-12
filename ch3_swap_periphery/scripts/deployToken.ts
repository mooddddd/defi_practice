import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners()
  const tokenFactory = await ethers.getContractFactory("WhaleToken");
  const token = await tokenFactory.deploy();

  await token.deployed();

  console.log(`token is deployed ${token.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
