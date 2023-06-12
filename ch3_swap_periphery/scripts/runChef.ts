import { ethers } from "hardhat";

// @ts-ignore
const toUnit = (amount) => ethers.utils.parseUnits(amount.toString())

async function main() {
  const factory = '0x90B06a1B5920E45c5f0aC3D701728669527bF275'
  const wklay = '0x043c471bee060e00a56ccd02c0ca286808a5a436'
  const whale = '0x15308179057A1d5e56C61a612b1EADfA5F669Aad'
  const [deployer] = await ethers.getSigners()
  const chef = await ethers.getContractAt("MasterChef", "0x2b4D1963d976D9bAaBe00Be43aC5858922A4116f");
  
  const poolInfo = await chef.poolInfo(0)
  console.log(`poolInfo[0] is ${poolInfo}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
