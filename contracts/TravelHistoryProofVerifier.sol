pragma solidity ^0.8.25;

import { UltraVerifier } from "../circuits/target/contract.sol";

contract TravelHistoryProofVerifier {
    UltraVerifier public verifier;

    constructor(UltraVerifier _verifier) {
        verifier = _verifier;
    }

    function verifyTravelHistoryProof(bytes calldata proof, bytes32[] calldata publicInput) public view returns (bool) {
        bool proofResult = verifier.verify(proof, publicInput);
        require(proofResult, "Proof is not valid");
        return proofResult;
    }
}
