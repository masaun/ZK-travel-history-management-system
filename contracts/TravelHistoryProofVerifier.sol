pragma solidity ^0.8.25;

import { UltraVerifier } from "../circuits/target/contract.sol";


/**
 * @notice - Verify a travel history of a traveler
 * @dev - TravelHistoryManager.sol can be customized by each authority (i.e. A border control of each country)
 */
contract TravelHistoryProofVerifier {
    UltraVerifier public verifier;

    constructor(UltraVerifier _verifier) {
        verifier = _verifier;
    }

    function verifyTravelHistoryProof(bytes calldata proof, bytes32[] calldata publicInput) public view returns (bool) {
        bool proofResult = verifier.verify(proof, publicInput); /// @dev - UltraVerifier#verify()
        require(proofResult, "Proof is not valid");
        return proofResult;
    }
}
