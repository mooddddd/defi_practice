import { ethers } from "hardhat";

async function main() {
  const whaleToken = "0x15308179057A1d5e56C61a612b1EADfA5F669Aad"
  const factory = "0x90B06a1B5920E45c5f0aC3D701728669527bF275"

  const [deployer] = await ethers.getSigners()
  const chefFactory = await ethers.getContractFactory("MasterChef");
  const chef = await chefFactory.deploy(whaleToken, factory);

  await chef.deployed();

  console.log(`Chef is deployed ${chef.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
