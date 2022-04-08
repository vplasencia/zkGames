import React, { useEffect, useState } from "react";
import sudokuImage from "../assets/sudoku.png";
import GameCard from "./gameCard";

export default function GameList() {
  const [gameList, setGameList] = useState([
    {
      nameGame: "Sudoku",
      imageGame: sudokuImage,
      urlGame: "/sudoku",
    },
  ]);

  return (
    <div className="flex flex-wrap justify-center items-center place-items-center gap-10">
      {gameList.map((game, index) => {
        return (
          <GameCard
            nameGame={game.nameGame}
            imageGame={game.imageGame}
            urlGame={game.urlGame}
            key={index}
          />
        );
      })}
    </div>
  );
}
