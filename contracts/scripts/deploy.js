const main = async () => {
  const contractFactoryVerifier = await hre.ethers.getContractFactory(
    "Verifier"
  );
  const contractVerifier = await contractFactoryVerifier.deploy();
  await contractVerifier.deployed();
  console.log("Contract deployed to:", contractVerifier.address);

  const contractFactory = await hre.ethers.getContractFactory("Sudoku");
  const contract = await contractFactory.deploy(contractVerifier.address);
  await contract.deployed();
  console.log("Contract deployed to:", contract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
