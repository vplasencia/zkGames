const main = async () => {
  // --------- Sudoku ---------------------

  const contractFactorySudokuVerifier = await hre.ethers.getContractFactory(
    "SudokuVerifier"
  );
  const contractSudokuVerifier = await contractFactorySudokuVerifier.deploy();
  await contractSudokuVerifier.deployed();
  console.log(
    "SudokuVerifier Contract deployed to:",
    contractSudokuVerifier.address
  );

  const contractFactorySudoku = await hre.ethers.getContractFactory("Sudoku");
  const contractSudoku = await contractFactorySudoku.deploy(
    contractSudokuVerifier.address
  );
  await contractSudoku.deployed();
  console.log("Sudoku Contract deployed to:", contractSudoku.address);

  // --------- Futoshiki ---------------------

  const contractFactoryFutoshikiVerifier = await hre.ethers.getContractFactory(
    "FutoshikiVerifier"
  );
  const contractFutoshikiVerifier =
    await contractFactoryFutoshikiVerifier.deploy();
  await contractFutoshikiVerifier.deployed();
  console.log(
    "FutoshikiVerifier deployed to:",
    contractFutoshikiVerifier.address
  );

  const contractFactoryFutoshiki = await hre.ethers.getContractFactory(
    "Futoshiki"
  );
  const contractFutoshiki = await contractFactoryFutoshiki.deploy(
    contractFutoshikiVerifier.address
  );
  await contractFutoshiki.deployed();
  console.log("Futoshiki deployed to:", contractFutoshiki.address);
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
