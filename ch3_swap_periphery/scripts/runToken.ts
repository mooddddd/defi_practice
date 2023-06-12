import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners()
  const token = await ethers.getContractAt("WhaleToken", "0x15308179057A1d5e56C61a612b1EADfA5F669Aad");

  // transfer minter to chef
  // await token.transferMinter("");

  // mint token
  // await token.mint(deployer.address, ethers.utils.parseUnits('500'))

  console.log(`token minter is ${await token.minter()}`);
  console.log(`token owner is ${await token.owner()}`);
  console.log(`token amount is ${await token.balanceOf(deployer.address)}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
