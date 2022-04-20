import Cell from "./cell";

export default function Board({
  futoshikiInequalitiesInitial,
  futoshiki,
  setSelectedPosition,
  futoshikiBoolInitial,
  selectedPosition,
}) {
  const renderInequalitiesRow = (inequality) => {
    if (inequality === 1) {
      return (
        <div className="flex select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14">
          &#x276C;
        </div>
      );
    } else if (inequality === 2) {
      return (
        <div className="flex select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14">
         &#x276D;
        </div>
      );
    } else {
      return (
        <div className="flex select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14"></div>
      );
    }
  };
  const renderInequalitiesCol = (inequality) => {
    if (inequality === 1) {
      return (
        <div className="flex rotate-90 select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14">
          &#x276C;
        </div>
      );
    } else if (inequality === 2) {
      return (
        <div className="flex rotate-90 select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14">
         &#x276D;
        </div>
      );
    } else {
      return (
        <div className="flex select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14"></div>
      );
    }
  };

  return (
    <>
      {futoshiki.map((row, i) => {
        return (
          <div className="grid grid-cols-4" key={i}>
            {row.map((col, j) => {
              return (
                <div key={j}>
                  <div className="flex">
                    <Cell
                      value={col}
                      col={j}
                      row={i}
                      setSelectedPosition={setSelectedPosition}
                      futoshikiBoolInitial={futoshikiBoolInitial}
                      selectedPosition={selectedPosition}
                    />
                    {j !== row.length - 1 && (
                      renderInequalitiesRow(futoshikiInequalitiesInitial[i*(row.length - 1)+j])
                    )}
                  </div>
                  {i !== row.length - 1 && (
                   renderInequalitiesCol(futoshikiInequalitiesInitial[12 + (i*row.length+j)])
                  )}
                </div>
              );
            })}
          </div>
        );
      })}
    </>
  );
}
