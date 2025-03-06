pragma solidity ^0.8.17;

import { Script } from "forge-std/Script.sol";
import { UltraVerifier } from "../../circuits/target/contract.sol";
import { TravelHistoryProofVerifier } from "../../contracts/TravelHistoryProofVerifier.sol";

import { console2 } from "forge-std/console2.sol";

contract TravelHistoryProofVerifierScript is Script {
    TravelHistoryProofVerifier public travelHistoryProofVerifier;
    UltraVerifier public verifier;

    function setUp() public {}

    function run() public returns (bool) {
        vm.createSelectFork("electroneum_testnet");
        uint256 deployerPrivateKey = vm.envUint("ELECTRONEUM_TESTNET_PRIVATE_KEY");
        //uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address ULTRA_VERIFIER = vm.envAddress("ULTRAVERIFER_CONTRACT_ADDRESS_ON_ELECTRONEUM_TESTNET");
        address TRAVEL_HISTORY_PROOF_VERIFIER = vm.envAddress("TRAVEL_HISTORY_PROOF_VERIFIER_CONTRACT_ADDRESS_ON_ELECTRONEUM_TESTNET");
        verifier = UltraVerifier(ULTRA_VERIFIER);
        //verifier = new UltraVerifier();
        travelHistoryProofVerifier = TravelHistoryProofVerifier(TRAVEL_HISTORY_PROOF_VERIFIER);
        //travelHistoryProofVerifier = new TravelHistoryProofVerifier(verifier);

        bytes memory proof_w_inputs = vm.readFileBinary("./circuits/target/with_foundry_proof.bin");
        bytes memory proofBytes = sliceAfter64Bytes(proof_w_inputs);
        //string memory proof = vm.readLine("./circuits/proofs/with_foundry.proof");
        //bytes memory proofBytes = vm.parseBytes(proof);

        bytes32[] memory correct = new bytes32[](2);
        correct[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000003);   // [Expect]: Successful (= Vaild Proof)
        //correct[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000001); // [Expect]: Reverted (= Invalid Proof)
        correct[1] = correct[0];

        bool equal = travelHistoryProofVerifier.verifyTravelHistoryProof(proofBytes, correct);
        console2.logBool(equal); /// [Log]: true
        return equal;
    }

    /**
     * @dev - Utility function, because the proof file includes the public inputs at the beginning
     */
    function sliceAfter64Bytes(bytes memory data) internal pure returns (bytes memory) {
        uint256 length = data.length - 64;
        bytes memory result = new bytes(data.length - 64);
        for (uint i = 0; i < length; i++) {
            result[i] = data[i + 64];
        }
        return result;
    }
}
