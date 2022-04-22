import { exportCallDataGroth16 } from "../snarkjsZkproof";

export async function skyscrapersCalldata(unsolved, solved, skyscrapersAmount) {
  const input = {
    unsolved: unsolved,
    solved: solved,
    skyscrapersAmount: skyscrapersAmount,
  };

  let dataResult;

  try {
    dataResult = await exportCallDataGroth16(
      input,
      "/zkproof/skyscrapers/skyscrapers.wasm",
      "/zkproof/skyscrapers/skyscrapers_0001.zkey"
    );
  } catch (error) {
    // console.log(error);
    window.alert("Wrong answer");
  }

  return dataResult;
}
