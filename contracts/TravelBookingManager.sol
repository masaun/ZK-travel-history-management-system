pragma solidity ^0.8.25;

import { TravelHistoryProofVerifier } from "./TravelHistoryProofVerifier.sol";
import { DataType } from "./dataType/DataType.sol";

/**
 * @notice - The TravelBookingManager contract
 * @dev - The TravelBookingManager contract
 */
contract TravelBookingManager {
    using DataType for DataType.PublicInput;

    TravelHistoryProofVerifier public travelHistoryProofVerifier;

    // mapping(address => mapping(bytes => DataType.PublicInput)) public publicInputsOfTravelHistoryProofs;
    // mapping(address => mapping(bytes => bool)) public travelHistoryProofRecords;
    mapping(bytes32 hash => bool isNullified) public nullifiers;

    // mapping(address => bool) public travelers;

    string public version;

    constructor(TravelHistoryProofVerifier _travelHistoryProofVerifier) {
        travelHistoryProofVerifier = _travelHistoryProofVerifier;
        version = "0.2.2";
    }

    /**
     * @notice - Once the proof is confirmed as a valid proof, the payment will be escrowed to the travel agency or service provider.
     */
    function escrowPayment(bytes calldata proof, bytes32[] calldata publicInputs) public returns (bool) {
        // Verify a travel history proof
        bool result = travelHistoryProofVerifier.verifyTravelHistoryProof(proof, publicInputs);
        require(result, "Travel History Proof is not valid");

        // @dev - [TODO]: Once the proof is confirmed as a valid proof, the payment will be escrowed to the travel agency or service provider.

    }
}
