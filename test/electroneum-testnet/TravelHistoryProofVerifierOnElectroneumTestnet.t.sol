pragma solidity ^0.8.17;

import { TravelHistoryProofVerifier } from "../../contracts/TravelHistoryProofVerifier.sol";
import { UltraVerifier } from "../../circuits/target/contract.sol";
import "forge-std/console.sol";

import { Test } from "forge-std/Test.sol";
import { NoirHelper } from "foundry-noir-helper/NoirHelper.sol";


contract TravelHistoryProofVerifierOnElectroneumTestnetTest is Test {
    TravelHistoryProofVerifier public travelHistoryProofVerifier;
    UltraVerifier public verifier;
    NoirHelper public noirHelper;

    function setUp() public {
        noirHelper = new NoirHelper();
        
        address ULTRA_VERIFIER = vm.envAddress("ULTRAVERIFER_CONTRACT_ADDRESS_ON_ELECTRONEUM_TESTNET");
        address TRAVEL_HISTORY_PROOF_VERIFIER = vm.envAddress("TRAVEL_HISTORY_PROOF_VERIFIER_CONTRACT_ADDRESS_ON_ELECTRONEUM_TESTNET");
        verifier = UltraVerifier(ULTRA_VERIFIER);
        //verifier = new UltraVerifier();
        travelHistoryProofVerifier = TravelHistoryProofVerifier(TRAVEL_HISTORY_PROOF_VERIFIER);
        //travelHistoryProofVerifier = new TravelHistoryProofVerifier(verifier);
    }

    function test_verifyProof() public {
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
                  .withInput("country_code", bytes32(uint256(1)));

        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 3);
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
                  .withInput("index", uint256(0))
                  .withInput("secret", uint256(1))
                  .withInput("country_code", uint256(31));   

        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_wrongProof", 3);

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
