import React, { useEffect, useState } from "react";
import GameCard from "./gameCard";
import sudokuImage from "../assets/sudoku.png";
import futoshikiImage from "../assets/futoshiki.png";
import skyscrapersImage from "../assets/skyscrapers.png";

export default function GameList() {
  const [gameList, setGameList] = useState([
    {
      nameGame: "Sudoku",
      imageGame: sudokuImage,
      urlGame: "/sudoku",
    },
    {
      nameGame: "Futoshiki",
      imageGame: futoshikiImage,
      urlGame: "/futoshiki",
    },
    {
      nameGame: "Skyscrapers",
      imageGame: skyscrapersImage,
      urlGame: "/skyscrapers",
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
