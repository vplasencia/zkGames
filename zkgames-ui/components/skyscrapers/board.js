import Cell from "./cell";

export default function Board({
  skyscrapersAmountInitial,
  skyscrapers,
  setSelectedPosition,
  skyscrapersBoolInitial,
  selectedPosition,
}) {
  const renderArrowRowLeft = () => {
    let subset = skyscrapersAmountInitial.slice(0, 5);

    return (
      <div className="grid grid-cols-1">
        {subset.map((value, i) => (
          <div
            className="flex select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14 md:space-x-2"
            key={i}
          >
            <div>{value !== 0 && value}</div>
            {value !== 0 && (
              <div>
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
                  className="feather feather-arrow-right"
                >
                  <line x1="5" y1="12" x2="19" y2="12"></line>
                  <polyline points="12 5 19 12 12 19"></polyline>
                </svg>
              </div>
            )}
          </div>
        ))}
      </div>
    );
  };
  const renderArrowRowRight = () => {
    let subset = skyscrapersAmountInitial.slice(5, 10);

    return (
      <div className="grid grid-cols-1">
        {subset.map((value, i) => (
          <div
            key={i}
            className="flex select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14 md:space-x-2"
          >
            {value !== 0 && (
              <div>
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
                  className="feather feather-arrow-left"
                >
                  <line x1="19" y1="12" x2="5" y2="12"></line>
                  <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
              </div>
            )}

            <div>{value !== 0 && value}</div>
          </div>
        ))}
      </div>
    );
  };
  const renderArrowColTop = () => {
    let subset = skyscrapersAmountInitial.slice(10, 15);

    return (
      <div className="flex justify-center items-center">
        {subset.map((value, i) => (
          <div
            key={i}
            className="grid grid-cols-1 select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14 mb-5 md:mb-4 md:space-y-2"
          >
            <div className="flex justify-center items-center">
              {value !== 0 && value}
            </div>
            {value !== 0 && (
              <div className="flex justify-center items-center">
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
                  className="feather feather-arrow-down"
                >
                  <line x1="12" y1="5" x2="12" y2="19"></line>
                  <polyline points="19 12 12 19 5 12"></polyline>
                </svg>
              </div>
            )}
          </div>
        ))}
      </div>
    );
  };
  const renderArrowColBottom = () => {
    let subset = skyscrapersAmountInitial.slice(15, 20);

    return (
      <div className="flex justify-center items-center">
        {subset.map((value, i) => (
          <div
            key={i}
            className="grid grid-cols-1 select-none justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14 mt-1 md:mt-2 md:space-y-2"
          >
            {value !== 0 && (
              <div className="flex justify-center items-center">
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
                  className="feather feather-arrow-up"
                >
                  <line x1="12" y1="19" x2="12" y2="5"></line>
                  <polyline points="5 12 12 5 19 12"></polyline>
                </svg>
              </div>
            )}

            <div className="flex justify-center items-center">
              {value !== 0 && value}
            </div>
          </div>
        ))}
      </div>
    );
  };
  return (
    <div>
      {renderArrowColTop()}
      <div className="flex justify-center items-center">
        {renderArrowRowLeft()}
        <div>
          {skyscrapers.map((row, i) => {
            return (
              <div
                className="grid grid-cols-5 justify-center items-center"
                key={i}
              >
                {row.map((col, j) => {
                  return (
                    <div key={j}>
                      <div>
                        <div className="flex">
                          <Cell
                            value={col}
                            col={j}
                            row={i}
                            setSelectedPosition={setSelectedPosition}
                            skyscrapersBoolInitial={skyscrapersBoolInitial}
                            selectedPosition={selectedPosition}
                          />
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            );
          })}
        </div>
        {renderArrowRowRight()}
      </div>
      {renderArrowColBottom()}
    </div>
  );
}
