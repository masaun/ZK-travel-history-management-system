pragma solidity ^0.8.25;

import { TravelHistoryProofVerifier } from "./TravelHistoryProofVerifier.sol";

    /**
     * @notice - The TravelHistoryManager contract
     * @dev - The TravelHistoryManager contract can be customized by each authority of each country (i.e. A border control of each country)
     */
contract TravelHistoryManager {
    /// TOOD:
    TravelHistoryProofVerifier public travelHistoryProofVerifier;

    mapping(address => mapping(bytes => bytes32)) public publicInputsOfTravelHistoryProofs;
    mapping(address => mapping(bytes => mapping(bytes32 => bool))) public travelHistoryProofRecords;
    mapping(bytes32 hash => bool isNullified) public nullifiers;

    constructor(TravelHistoryProofVerifier _travelHistoryProofVerifier) {
        travelHistoryProofVerifier = _travelHistoryProofVerifier;
    }

    /**
     * @notice - Record (Submit) a travel history proof on-chain /w publicInput.
     * @dev - The publicInputs validation should be customized by each authority of each country (i.e. A border control of each country)
     */
    function recordTravelHistoryProof(bytes calldata proof, bytes32[] calldata publicInputs) public view returns (bool) {
        // Verify a travel history proof
        bool result = travelHistoryProofVerifier.verifyTravelHistoryProof(proof, publicInputs);
        require(result, "Travel History Proof is not valid");

        // PublicInputs veridations (NOTE: This can be customized by each authority of each country)
        bytes32 nullifierHash = publicInputs[4];
        nullifiers[nullifierHash] = true;

        // Record a travel history proof
        travelHistoryProofRecords[msg.sender][proof][publicInputs] = true;

        // Record a publicInput of a given travel history proof
        publicInputsOfTravelHistoryProofs[msg.sender][proof] = publicInputs;
    }

    /**
     * @notice - Check whether or not a given proof (and its publicInputs) is recorded on-chain.
     */
    function isTravelHistoryProofRecorded(address traveler, bytes calldata proof, bytes32[] calldata publicInputs) public view returns (bool) {
        return travelHistoryProofRecords[traveler][proof][publicInputs];
    }

    /**
     * @notice - Retrieve a publicInput of a given travel history proof from on-chain.
     */
    function getPublicInputsOfTravelHistoryProof(address traveler, bytes calldata proof) public view returns (bytes32[] memory _publicInputs) {
        return publicInputsOfTravelHistoryProof[traveler][proof];
    }

    /**
     * @notice - Check whether or not a given traveler is breaching the 90 days limit of staying in Schengen Area.
     * @notice - NOTE: Travelers can stay in the Schengen Area (which includes most EU countries) for up to 90 days within a 180-day period without a visa for tourism, business, or family visits.
     */
    function isTravelerBreachingDaysLimitOfStaying(address traveler, bytes calldata proof) public view returns (bool) {
        bytes32[] memory publicInputs = new bytes32[](5); 
        publicInputs = publicInputsOfTravelHistoryProof[traveler][proof];
        bytes32 root = publicInputs[0];
        bytes32 country_code = publicInputs[1];
        bytes32 enter_date = publicInputs[2];
        bytes32 exit_date = publicInputs[3];
        bytes32 nullifierHash = publicInputs[4];

        // PublicInputs veridations (NOTE: This can be customized by each authority of each country)
        bool result;
        if (exit_date - enter_date <= 90 days) {
            result = true;
        } else {
            result = false;
        }

        return result;
    }

}
