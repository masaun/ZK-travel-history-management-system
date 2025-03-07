pragma solidity ^0.8.17;

import { TravelHistoryProofVerifier } from "../contracts/TravelHistoryProofVerifier.sol";
import { UltraVerifier } from "../circuits/target/contract.sol";

import "forge-std/console.sol";
import { Test } from "forge-std/Test.sol";
import { NoirHelper } from "foundry-noir-helper/NoirHelper.sol";


contract TravelHistoryProofVerifierTest is Test {
    TravelHistoryProofVerifier public travelHistoryProofVerifier;
    UltraVerifier public verifier;
    NoirHelper public noirHelper;

    function setUp() public {
        noirHelper = new NoirHelper();
        verifier = new UltraVerifier();
        travelHistoryProofVerifier = new TravelHistoryProofVerifier(verifier);
    }

    function test_verifyProof() public {
        uint256[] memory hash_path = new uint256[](2);
        hash_path[0] = 0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8;
        hash_path[1] = 0x2a653551d87767c545a2a11b29f0581a392b4e177a87c8e3eb425c51a26a8c77;

        bytes32[] memory hash_path_bytes32 = new bytes32[](2);
        hash_path_bytes32[0] = bytes32(hash_path[0]);
        hash_path_bytes32[1] = bytes32(hash_path[1]);

        //bytes32 name_bytes32 = bytes32(abi.encodePacked("John Smith"));
        //bytes32 passport_number_bytes32 = bytes32(abi.encodePacked("C03003286"));
        //console.logBytes(abi.encodePacked("John Smith")); /// [Log]: 0x4a6f686e20536d697468
        //console.logBytes(abi.encodePacked("C03003286"));  /// [Log]: 0x433033303033323836
        //console.logBytes32(name_bytes32);                 /// [Log]: 0x4a6f686e20536d69746800000000000000000000000000000000000000000000
        //console.logBytes32(passport_number_bytes32);      /// [Log]: 0x4330333030333238360000000000000000000000000000000000000000000000

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

        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 5);
        travelHistoryProofVerifier.verifyTravelHistoryProof(proof, publicInputs);
    }

    function test_wrongProof() public {
        noirHelper.clean();

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
                  .withInput("secret", bytes32(uint256(1)))
                  //.withInput("name", bytes32(uint256(name_bytes32)))                        /// @dev - Name of the traveler
                  //.withInput("passport_number", bytes32(uint256(passport_number_bytes32)))  /// @dev - Passport number of the traveler
                  .withInput("passport_number", bytes32(uint256(13003286)))                   /// @dev - Passport number of the traveler
                  .withInput("country_code", uint256(31))       // +31 is the country code of NL (Netherland)
                  .withInput("enter_date", uint256(1614556800)) // Mar 01 in 2021, 00:00:00 GMT
                  .withInput("exit_date", uint256(1615636700)); // Mar 13 in 2021, 11:58:20 GMT

        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_wrongProof", 5);

        /// @dev - This should fail because the public input is wrong
        bytes32[] memory fakePublicInputs = new bytes32[](3);
        fakePublicInputs[0] = publicInputs[0];
        fakePublicInputs[1] = bytes32(uint256(49));  // @dev - This is wrong publicInput ("country_code") - when this proof was geneerated.
        fakePublicInputs[2] = publicInputs[2];
        vm.expectRevert();
        travelHistoryProofVerifier.verifyTravelHistoryProof(proof, fakePublicInputs);
    }

    // function test_all() public {
    //     // forge runs tests in parallel which messes with the read/writes to the proof file
    //     // Run tests in wrapper to force them run sequentially
    //     verifyProof();
    //     wrongProof();
    // }

}
