pragma solidity ^0.8.17;

import { TravelHistoryManager } from "../contracts/TravelHistoryManager.sol";
import { TravelHistoryProofVerifier } from "../contracts/TravelHistoryProofVerifier.sol";
import { HonkVerifier } from "../contracts/circuit/ultra-verifier/plonk_vk.sol";

import "forge-std/console.sol";
import { Test } from "forge-std/Test.sol";
import { NoirHelper } from "foundry-noir-helper/NoirHelper.sol";


contract TravelHistoryManagerTest is Test {
    TravelHistoryManager public travelHistoryManager;
    TravelHistoryProofVerifier public travelHistoryProofVerifier;
    HonkVerifier public verifier;
    NoirHelper public noirHelper;

    function setUp() public {
        noirHelper = new NoirHelper();
        verifier = new HonkVerifier();
        travelHistoryProofVerifier = new TravelHistoryProofVerifier(verifier);
        travelHistoryManager = new TravelHistoryManager(travelHistoryProofVerifier);
    }

    function test_scenario() public {
        uint256[] memory hash_path = new uint256[](2);
        hash_path[0] = 0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8;
        hash_path[1] = 0x2a653551d87767c545a2a11b29f0581a392b4e177a87c8e3eb425c51a26a8c77;

        bytes32[] memory hash_path_bytes32 = new bytes32[](2);
        hash_path_bytes32[0] = bytes32(hash_path[0]);
        hash_path_bytes32[1] = bytes32(hash_path[1]);

        noirHelper.withInput("root", bytes32(uint256(0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629)))
                  .withInput("hash_path", hash_path_bytes32)
                  //.withInput("hash_path", hash_path)
                  .withInput("index", bytes32(uint256(0)))
                  .withInput("secret", bytes32(uint256(1))) /// @dev - [NOTE]: 'Field' type in Noir must be the form of this (= bytes32(uint256(XXX))).
                  //.withInput("name", bytes32(uint256(name_bytes32)))                        /// @dev - Name of the traveler
                  //.withInput("passport_number", bytes32(uint256(passport_number_bytes32)))  /// @dev - Passport number of the traveler
                  .withInput("passport_number", bytes32(uint256(13003286)))                   /// @dev - Passport number of the traveler
                  .withInput("country_code", uint256(1))        /// @dev - i.e). If a country that a traveler visit is USA, its country code is '1'
                  .withInput("enter_date", uint256(1614556800)) /// Mar 01 in 2021, 00:00:00 GMT
                  .withInput("exit_date", uint256(1615636700)); /// Mar 13 in 2021, 11:58:20 GMT

        /// @dev - Generate (Prove) a travel history proof
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 5);
        travelHistoryProofVerifier.verifyTravelHistoryProof(proof, publicInputs);

        /// @dev - Record a travel history proof on-chain /w publicInput
        travelHistoryManager.recordTravelHistoryProof(proof, publicInputs);

        /// @dev - Check whether or not a given proof is recorded on-chain
        //bool isRecorded = travelHistoryManager.isTravelHistoryProofRecorded(msg.sender, proof);
        //require(isRecorded == true, "A given proof is not recorded on-chain");

        /// @dev - Retrieve a publicInput of a given travel history proof from on-chain
        bool result = travelHistoryManager.isTravelerBreachingDaysLimitOfStaying(msg.sender, proof);
        require(result == true, "A traveler is breaching 90 days limit of staying in Shechen Area");
    }

 

}
