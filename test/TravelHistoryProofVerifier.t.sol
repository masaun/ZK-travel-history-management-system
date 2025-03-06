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
        noirHelper.withInput("x", 1).withInput("y", 1).withInput("return", 1);
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 2);
        travelHistoryProofVerifier.verifyEqual(proof, publicInputs);
    }

    function test_wrongProof() public {
        noirHelper.clean();
        noirHelper.withInput("x", 1).withInput("y", 5).withInput("return", 5);
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_wrongProof", 2);
        vm.expectRevert();
        travelHistoryProofVerifier.verifyEqual(proof, publicInputs);
    }

    // function test_all() public {
    //     // forge runs tests in parallel which messes with the read/writes to the proof file
    //     // Run tests in wrapper to force them run sequentially
    //     verifyProof();
    //     wrongProof();
    // }

}
