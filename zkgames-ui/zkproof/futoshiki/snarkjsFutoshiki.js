import { exportCallDataGroth16 } from "../snarkjsZkproof";

export async function futoshikiCalldata(unsolved, solved, inequalities) {
  const input = {
    unsolved: unsolved,
    solved: solved,
    inequalities: inequalities,
  };

  let dataResult;

  try {
    dataResult = await exportCallDataGroth16(
      input,
      "/zkproof/futoshiki/futoshiki.wasm",
      "/zkproof/futoshiki/futoshiki_0001.zkey"
    );
  } catch (error) {
    // console.log(error);
    window.alert("Wrong answer");
  }

  return dataResult;
}
