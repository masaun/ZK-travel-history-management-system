pragma solidity ^0.8.17;

import { TravelHistoryProofVerifier } from "./TravelHistoryProofVerifier.sol";

contract TravelHistoryManager {
    /// TOOD:
    TravelHistoryProofVerifier public travelHistoryProofVerifier;

    mapping(address => mapping(bytes => bytes32)) public publicInputsOfTravelHistoryProofs;
    mapping(address => mapping(bytes => mapping(bytes32 => bool))) public travelHistoryProofRecords;

    constructor(TravelHistoryProofVerifier _travelHistoryProofVerifier) {
        travelHistoryProofVerifier = _travelHistoryProofVerifier;
    }

    /**
     * @notice - Record (Submit) a travel history proof on-chain /w publicInput.
     */
    function recordTravelHistoryProof(bytes calldata proof, bytes32[] calldata publicInputs) public view returns (bool) {
        // Verify a travel history proof
        bool result = travelHistoryProofVerifier.verifyTravelHistoryProof(proof, publicInputs);
        require(result, "Travel History Proof is not valid");

        // Record a travel history proof
        travelHistoryProofRecords[msg.sender][proof][publicInputs] = true;

        // Record a publicInput of a given travel history proof
        publicInputsOfTravelHistoryProofs[msg.sender][proof] = publicInputs;
    }

    /**
     * @notice - Check whether or not a given proof (and its publicInputs) is recorded on-chain.
     */
    function isTravelHistoryProofRecorded(bytes calldata proof, bytes32[] calldata publicInputs) public view returns (bool) {
        return travelHistoryProofRecords[msg.sender][proof][publicInputs];
    }

    /**
     * @notice - Retrieve a publicInput of a given travel history proof from on-chain.
     */
    function getPublicInputsOfTravelHistoryProof(bytes calldata proof) public view returns (bytes32[] memory _publicInputs) {
        return publicInputsOfTravelHistoryProof[msg.sender][proof];
    }
}
