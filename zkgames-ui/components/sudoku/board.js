import Cell from "./cell";

export default function Board({ sudoku, setSelectedPosition, sudokuBoolInitial, selectedPosition }) {
  return (
    <>
      {sudoku.map((row, i) => {
        return (
          <div className="grid grid-cols-9" key={i}>
            {row.map((col, j) => {
              return <Cell value={col} col={j} row={i} setSelectedPosition={setSelectedPosition} sudokuBoolInitial={sudokuBoolInitial} selectedPosition={selectedPosition} key={j}/>;
            })}
          </div>
        );
      })}
    </>
  );
}
