import { ethers } from "hardhat";

async function main() {
  const factory = '0x90B06a1B5920E45c5f0aC3D701728669527bF275'
  const wklay = '0x043c471bee060e00a56ccd02c0ca286808a5a436'
  const [deployer] = await ethers.getSigners()
  const routerFactory = await ethers.getContractFactory("UniswapV2Router01");
  const router = await routerFactory.deploy(factory, wklay);

  await router.deployed();

  console.log(`router is deployed ${router.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
