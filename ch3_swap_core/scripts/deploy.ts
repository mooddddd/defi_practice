import { ethers } from "hardhat";

async function main() {
  const [owner] = await ethers.getSigners()
  const factoryFactory = await ethers.getContractFactory("UniswapV2Factory")
  const factory = await factoryFactory.deploy(owner.address);

  await factory.deployed()

  console.log(`factory is deployed ${factory.address}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
