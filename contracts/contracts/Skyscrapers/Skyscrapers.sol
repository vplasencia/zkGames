//SPDX-License-Identifier: Unlicensed
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
        uint256[45] memory input
    ) external view returns (bool);
}

// Inherit the OpenZeppelin contract imported so we can have access to the inherited contract methods
contract Skyscrapers is ERC721URIStorage {
    address public verifierAddr;

    uint8[5][5][4] skyscrapersBoardList = [
        [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
        ],
        [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
        ],
        [
            [3, 1, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 3, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
        ],
        [
            [3, 1, 5, 2, 4],
            [4, 5, 2, 3, 1],
            [2, 4, 3, 1, 5],
            [1, 3, 4, 5, 2],
            [5, 2, 1, 4, 0]
        ]
    ];

    uint8[20][4] skyscrapersAmountList = [
        [4, 4, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 2, 1, 0, 2, 0, 1, 0, 0],
        [4, 3, 1, 2, 4, 2, 2, 3, 3, 1, 3, 3, 2, 1, 2, 3, 2, 4, 2, 1],
        [2, 2, 3, 4, 1, 2, 3, 1, 2, 3, 3, 2, 1, 3, 2, 1, 4, 3, 2, 2],
        [2, 2, 3, 4, 1, 2, 3, 1, 2, 3, 3, 2, 1, 3, 2, 1, 4, 3, 2, 2]
    ];

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string svgSkyscrapersNft =
        '<svg width="350" height="350" viewBox="0 0 350 350" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="a" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#9333ea"/><stop offset="1" stop-color="#4f46e5" stop-opacity=".99"/></linearGradient></defs><rect width="100%" height="100%" fill="url(#a)"/><text x="80%" y="95%" style="fill:#0f172a;font-family:serif;font-size:15px">zkGames</text><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" style="fill:#e2e8f0;font-family:serif;font-size:30px">Skyscrapers</text></svg>';

    constructor(address _verifierAddr) ERC721("SkyscrapersNFT", "SerzkGames") {
        verifierAddr = _verifierAddr;
    }

    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[45] memory input
    ) public view returns (bool) {
        return IVerifier(verifierAddr).verifyProof(a, b, c, input);
    }

    function verifySkyscrapersBoard(uint256[45] memory input)
        private
        view
        returns (bool)
    {
        bool isEqual = true;
        for (uint256 i = 0; i < skyscrapersBoardList.length; ++i) {
            isEqual = true;
            for (uint256 j = 0; j < skyscrapersBoardList[i].length; ++j) {
                for (
                    uint256 k = 0;
                    k < skyscrapersBoardList[i][j].length;
                    ++k
                ) {
                    if (input[5 * j + k] != skyscrapersBoardList[i][j][k]) {
                        isEqual = false;
                        break;
                    }
                }
            }
            if (isEqual) {
                if (verifySkyscrapersAmount(input, i)) {
                    return isEqual;
                }
            }
        }
        return isEqual;
    }

    function verifySkyscrapersAmount(uint256[45] memory input, uint256 pos)
        private
        view
        returns (bool)
    {
        bool isEqual = true;
        uint256 k = 25;
        for (uint256 i = 0; i < skyscrapersAmountList[pos].length; ++i) {
            if (input[k] != skyscrapersAmountList[pos][i]) {
                isEqual = false;
                break;
            }
            ++k;
        }
        return isEqual;
    }

    function verifySkyscrapers(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[45] memory input
    ) public view returns (bool) {
        require(verifySkyscrapersBoard(input), "This board does not exist");
        require(verifyProof(a, b, c, input), "Failed proof check");
        return true;
    }

    function pickRandomBoard(string memory stringTime)
        private
        view
        returns (uint8[5][5] memory, uint8[20] memory)
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
        ) % skyscrapersBoardList.length;
        return (
            skyscrapersBoardList[randPosition],
            skyscrapersAmountList[randPosition]
        );
    }

    function generateSkyscrapersBoard(string memory stringTime)
        public
        view
        returns (uint8[5][5] memory, uint8[20] memory)
    {
        return pickRandomBoard(stringTime);
    }

    function mintSkyscrapersNft() private {
        uint256 newItemId = _tokenIds.current();

        // Get all the JSON metadata in place and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // Set the title of the NFT
                        "Skyscrapers",
                        '", "description": "Solved Skyscrapers on zkGames.", "image": "data:image/svg+xml;base64,',
                        // Add data:image/svg+xml;base64 and then append the base64 encoding of the svg
                        Base64.encode(bytes(svgSkyscrapersNft)),
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

    function verifySkyscrapersAndMintNft(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[45] memory input
    ) public {
        require(verifySkyscrapersBoard(input), "This board does not exist");
        require(verifyProof(a, b, c, input), "Failed proof check");
        mintSkyscrapersNft();
    }
}
