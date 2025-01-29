//SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract TestBasicNft is Test {
    DeployBasicNft public deployer;
    BasicNFT public basicNft;
    address public USER = makeAddr("user");
    string public constant uri =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory name = basicNft.name();
        string memory expected = "Dogie";

        //assert(name == expected);
        assert(keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked(expected)));
        //assertEq(name, expected);
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(uri);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(uri)));
    }
}
