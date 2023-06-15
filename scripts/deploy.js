const { ethers } = require("hardhat");
// 0x79bB35f3A01c209b38240eD1c3d41Ff27661f060 SEPOLIA
async function main(){
  const deployedContract = await ethers.deployContract('SimpleToken',['Awesome Mintable Token','AMT',100000]);
  await deployedContract.waitForDeployment();

  console.log("Your token has been deployed to: ",await deployedContract.getAddress());
}

main().catch((error)=>{
  console.log(error);
  process.exitCode=1;
});