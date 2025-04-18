pragma solidity ^0.8.25;

import { TravelHistoryProofVerifier } from "./TravelHistoryProofVerifier.sol";
import { DataType } from "./dataType/DataType.sol";

/**
 * @notice - The TravelHistoryManager contract
 * @dev - The TravelHistoryManager contract can be customized by each authority of each country (i.e. A border control of each country)
 */
contract TravelHistoryManager {
    using DataType for DataType.PublicInput;

    TravelHistoryProofVerifier public travelHistoryProofVerifier;

    mapping(address => mapping(bytes => DataType.PublicInput)) public publicInputsOfTravelHistoryProofs;
    mapping(address => mapping(bytes => bool)) public travelHistoryProofRecords;
    mapping(bytes32 hash => bool isNullified) public nullifiers;

    constructor(TravelHistoryProofVerifier _travelHistoryProofVerifier) {
        travelHistoryProofVerifier = _travelHistoryProofVerifier;
    }

    /**
     * @notice - Record (Submit) a travel history proof on-chain /w publicInput.
     * @dev - The publicInputs validation should be customized by each authority of each country (i.e. A border control of each country)
     */
    function recordTravelHistoryProof(bytes calldata proof, bytes32[] calldata publicInputs) public returns (bool) {
        // Verify a travel history proof
        bool result = travelHistoryProofVerifier.verifyTravelHistoryProof(proof, publicInputs);
        require(result, "Travel History Proof is not valid");

        // Record a travel history proof
        travelHistoryProofRecords[msg.sender][proof] = true;

        // Record a publicInput of a given travel history proof
        DataType.PublicInput memory publicInput;
        publicInput.root = publicInputs[0];
        publicInput.country_code = publicInputs[1];
        publicInput.enter_date = publicInputs[2];
        publicInput.exit_date = publicInputs[3];
        publicInput.nullifierHash = publicInputs[4];
        publicInputsOfTravelHistoryProofs[msg.sender][proof] = publicInput;

        // PublicInputs veridations (NOTE: This can be customized by each authority of each country)
        nullifiers[publicInput.nullifierHash] = true;
    }

    /**
     * @notice - Check whether or not a given proof (and its publicInputs) is recorded on-chain.
     */
    function isTravelHistoryProofRecorded(address traveler, bytes calldata proof) public view returns (bool) {
        return travelHistoryProofRecords[traveler][proof];
    }

    /**
     * @notice - Retrieve a publicInput of a given travel history proof from on-chain.
     */
    function getPublicInputsOfTravelHistoryProof(address traveler, bytes calldata proof) public view returns (DataType.PublicInput memory _publicInput) {
        return publicInputsOfTravelHistoryProofs[traveler][proof];
    }

    /**
     * @notice - Check whether or not a given traveler is breaching the 90 days limit of staying in Schengen Area.
     * @notice - NOTE: Travelers can stay in the Schengen Area (which includes most EU countries) for up to 90 days within a 180-day period without a visa for tourism, business, or family visits.
     */
    function isTravelerBreachingDaysLimitOfStaying(address traveler, bytes calldata proof) public view returns (bool) {
        DataType.PublicInput memory publicInput;
        publicInput = getPublicInputsOfTravelHistoryProof(traveler, proof);

        bytes32 root = publicInput.root;
        bytes32 country_code = publicInput.country_code;
        bytes32 enter_date = publicInput.enter_date;
        bytes32 exit_date = publicInput.exit_date;
        bytes32 nullifierHash = publicInput.nullifierHash;

        // @dev - PublicInputs veridations (NOTE: This can be customized by each authority of each country)
        // @dev - Check whether or not a given traveler is breaching the 90 days limit of staying in Schengen Area.
        bool result;
        if (uint256(exit_date) - uint256(enter_date) <= 90 days) {
            result = true;
        } else {
            result = false;
        }

        return result;
    }

}
