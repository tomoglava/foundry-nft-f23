// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {

    //errors
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSVGImgUri;
    string private s_happySVGImgUri;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIDtoMood;

    constructor(string memory sadSvgImgUri, string memory happySvgImgUri) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSVGImgUri = sadSvgImgUri;
        s_happySVGImgUri = happySvgImgUri;
    }

    function flipMood(uint256 tokenId) public {
        //only want the NFT owner to be able to flip the mood

        if(getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIDtoMood[tokenId] == Mood.HAPPY) {
            s_tokenIDtoMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIDtoMood[tokenId] = Mood.HAPPY;
        }
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIDtoMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;

        if (s_tokenIDtoMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySVGImgUri;
        } else {
            imageURI = s_sadSVGImgUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that reflects the owners mood.", "atributes": [{"trait_type": "moodiness", "value": 100}], "image": ',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function gets_tokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function gets_tokenIDtoMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIDtoMood[tokenId];
    }
}
