export default function Cell({
  value,
  col,
  row,
  setSelectedPosition,
  futoshikiBoolInitial,
  selectedPosition,
}) {
  const positionClick = () => {
    if (selectedPosition.length > 0) {
      document
        .getElementById(
          selectedPosition[0].toString() + selectedPosition[1].toString()
        )
        .classList.toggle("bg-indigo-800");
    }
    document
      .getElementById(row.toString() + col.toString())
      .classList.toggle("bg-indigo-800");
    let position = [];
    position = [row, col];
    console.log("Position", position);
    setSelectedPosition(position);
  };

  const renderCell = () => {
    if (futoshikiBoolInitial[row][col]) {
      if (value === 0) {
        return <span className="">{""}</span>;
      } else {
        return <span>{value}</span>;
      }
    } else {
      return <span className="text-indigo-400">{value}</span>;
    }
  };

  return (
    <div
      id={row.toString() + col.toString()}
      className="flex select-none cursor-pointer justify-center items-center text-2xl h-10 w-10 md:h-14 md:w-14 border-2 border-slate-300"
      onClick={positionClick}
    >
      {renderCell()}
    </div>
  );
}
