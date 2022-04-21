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
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="feather feather-chevron-left w-8 h-8"
          >
            <polyline points="15 18 9 12 15 6"></polyline>
          </svg>
        </div>
      );
    } else if (inequality === 2) {
      return (
        <div className="flex select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="feather feather-chevron-right w-8 h-8"
          >
            <polyline points="9 18 15 12 9 6"></polyline>
          </svg>
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
        <div className="flex select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="feather feather-chevron-up w-8 h-8"
          >
            <polyline points="18 15 12 9 6 15"></polyline>
          </svg>
        </div>
      );
    } else if (inequality === 2) {
      return (
        <div className="flex select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="feather feather-chevron-down w-8 h-8"
          >
            <polyline points="6 9 12 15 18 9"></polyline>
          </svg>
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
                    {j !== row.length - 1 &&
                      renderInequalitiesRow(
                        futoshikiInequalitiesInitial[i * (row.length - 1) + j]
                      )}
                  </div>
                  {i !== row.length - 1 &&
                    renderInequalitiesCol(
                      futoshikiInequalitiesInitial[12 + (i * row.length + j)]
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
