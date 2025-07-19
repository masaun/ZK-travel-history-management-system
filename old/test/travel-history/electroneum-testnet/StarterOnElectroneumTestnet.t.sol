pragma solidity ^0.8.17;

import "../../contracts/Starter.sol";
import "../../circuits/target/contract.sol";
import "forge-std/console.sol";

import "forge-std/Test.sol";
import {NoirHelper} from "foundry-noir-helper/NoirHelper.sol";


contract StarterOnElectroneumTestnetTest is Test {
    Starter public starter;
    HonkVerifier public verifier;
    NoirHelper public noirHelper;

    function setUp() public {
        noirHelper = new NoirHelper();
        
        address ULTRA_VERIFIER = vm.envAddress("ULTRAVERIFER_CONTRACT_ADDRESS_ON_ELECTRONEUM_TESTNET");
        address STARTER = vm.envAddress("STARTER_CONTRACT_ADDRESS_ON_ELECTRONEUM_TESTNET");
        verifier = HonkVerifier(ULTRA_VERIFIER);
        //verifier = new HonkVerifier();
        starter = Starter(STARTER);
        //starter = new Starter(verifier);
    }

    function test_verifyProof() public {
        noirHelper.withInput("x", 1).withInput("y", 1).withInput("return", 1);
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 2);
        starter.verifyEqual(proof, publicInputs);
    }

    function test_wrongProof() public {
        noirHelper.clean();
        noirHelper.withInput("x", 1).withInput("y", 5).withInput("return", 5);
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_wrongProof", 2);
        vm.expectRevert();
        starter.verifyEqual(proof, publicInputs);
    }

    // function test_all() public {
    //     // forge runs tests in parallel which messes with the read/writes to the proof file
    //     // Run tests in wrapper to force them run sequentially
    //     verifyProof();
    //     wrongProof();
    // }

}
