//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {BasicNFT} from "../src/BasicNFT.sol";
import {Script} from "forge-std/Script.sol";

contract DeployBasicNft is Script {


    function run() external returns (BasicNFT) {
        vm.startBroadcast();
        BasicNFT s_nft = new BasicNFT();
        vm.stopBroadcast();

        return s_nft;
    }
}