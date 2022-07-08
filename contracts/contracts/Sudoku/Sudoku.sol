//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

// import "hardhat/console.sol";

// Import the OpenZeppelin Contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

interface IVerifier {
    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[81] memory input
    ) external view returns (bool);
}

// Inherit the OpenZeppelin contract imported so we can have access to the inherited contract methods
contract Sudoku is ERC721URIStorage {
    address public verifierAddr;

    uint8[9][9][3] sudokuBoardList = [
        [
            [1, 2, 7, 5, 8, 4, 6, 9, 3],
            [8, 5, 6, 3, 7, 9, 1, 2, 4],
            [3, 4, 9, 6, 2, 1, 8, 7, 5],
            [4, 7, 1, 9, 5, 8, 2, 3, 6],
            [2, 6, 8, 7, 1, 3, 5, 4, 9],
            [9, 3, 5, 4, 6, 2, 7, 1, 8],
            [5, 8, 3, 2, 9, 7, 4, 6, 1],
            [7, 1, 4, 8, 3, 6, 9, 5, 2],
            [6, 9, 2, 1, 4, 5, 3, 0, 7]
        ],
        [
            [0, 2, 7, 5, 0, 4, 0, 0, 0],
            [0, 0, 0, 3, 7, 0, 0, 0, 4],
            [3, 0, 0, 0, 0, 0, 8, 0, 0],
            [4, 7, 0, 9, 5, 8, 0, 3, 6],
            [2, 6, 8, 7, 1, 0, 0, 4, 9],
            [0, 0, 0, 0, 0, 2, 0, 1, 8],
            [0, 8, 3, 0, 9, 0, 4, 0, 0],
            [7, 1, 0, 0, 0, 0, 9, 0, 2],
            [0, 0, 0, 0, 0, 5, 0, 0, 7]
        ],
        [
            [0, 0, 0, 0, 0, 6, 0, 0, 0],
            [0, 0, 7, 2, 0, 0, 8, 0, 0],
            [9, 0, 6, 8, 0, 0, 0, 1, 0],
            [3, 0, 0, 7, 0, 0, 0, 2, 9],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [4, 0, 0, 5, 0, 0, 0, 7, 0],
            [6, 5, 0, 1, 0, 0, 0, 0, 0],
            [8, 0, 1, 0, 5, 0, 3, 0, 0],
            [7, 9, 2, 0, 0, 0, 0, 0, 4]
        ]
    ];

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string svgSudokuNft =
        '<svg width="350" height="350" viewBox="0 0 350 350" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="a" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#9333ea"/><stop offset="1" stop-color="#4f46e5" stop-opacity=".99"/></linearGradient></defs><rect width="100%" height="100%" fill="url(#a)"/><text x="80%" y="95%" style="fill:#0f172a;font-family:serif;font-size:15px">zkGames</text><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" style="fill:#e2e8f0;font-family:serif;font-size:30px">Sudoku</text></svg>';

    constructor(address _verifierAddr) ERC721("SudokuNFT", "SkuzkGames") {
        verifierAddr = _verifierAddr;
    }

    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[81] memory input
    ) public view returns (bool) {
        return IVerifier(verifierAddr).verifyProof(a, b, c, input);
    }

    function verifySudokuBoard(uint256[81] memory board)
        private
        view
        returns (bool)
    {
        bool isEqual = true;
        for (uint256 i = 0; i < sudokuBoardList.length; ++i) {
            isEqual = true;
            for (uint256 j = 0; j < sudokuBoardList[i].length; ++j) {
                for (uint256 k = 0; k < sudokuBoardList[i][j].length; ++k) {
                    if (board[9 * j + k] != sudokuBoardList[i][j][k]) {
                        isEqual = false;
                        break;
                    }
                }
            }
            if (isEqual == true) {
                return isEqual;
            }
        }
        return isEqual;
    }

    function verifySudoku(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[81] memory input
    ) public view returns (bool) {
        require(verifySudokuBoard(input), "This board does not exist");
        require(verifyProof(a, b, c, input), "Failed proof check");
        return true;
    }

    function pickRandomBoard(string memory stringTime)
        private
        view
        returns (uint8[9][9] memory)
    {
        uint256 randPosition = uint256(
            keccak256(
                abi.encodePacked(
                    block.difficulty,
                    block.timestamp,
                    msg.sender,
                    stringTime
                )
            )
        ) % sudokuBoardList.length;
        return sudokuBoardList[randPosition];
    }

    function generateSudokuBoard(string memory stringTime)
        public
        view
        returns (uint8[9][9] memory)
    {
        return pickRandomBoard(stringTime);
    }

    function mintSudokuNft() private {
        uint256 newItemId = _tokenIds.current();

        // Get all the JSON metadata in place and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // Set the title of the NFT
                        "Sudoku",
                        '", "description": "Solved Sudoku on zkGames.", "image": "data:image/svg+xml;base64,',
                        // Add data:image/svg+xml;base64 and then append the base64 encoding of the svg
                        Base64.encode(bytes(svgSudokuNft)),
                        '"}'
                    )
                )
            )
        );

        // Prepend data:application/json;base64, to the data
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        // console.log("\n--------------------");
        // console.log(
        //     string(
        //         abi.encodePacked(
        //             "https://nftpreview.0xdev.codes/?code=",
        //             finalTokenUri
        //         )
        //     )
        // );
        // console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        // Update the URI!!!
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        // console.log(
        //     "An NFT w/ ID %s has been minted to %s",
        //     newItemId,
        //     msg.sender
        // );
    }

    function verifySudokuAndMintNft(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[81] memory input
    ) public {
        require(verifySudokuBoard(input), "This board does not exist");
        require(verifyProof(a, b, c, input), "Failed proof check");
        mintSudokuNft();
    }
}
