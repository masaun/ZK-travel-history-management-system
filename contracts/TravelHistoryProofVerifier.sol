pragma solidity ^0.8.25;

import { HonkVerifier } from "./circuit/ultra-verifier/plonk_vk.sol";
//import { UltraVerifier } from "./circuit/ultra-verifier/plonk_vk.sol";
//import { HonkVerifier } from "../circuits/target/Verifier.sol";


/**
 * @notice - Verify a travel history of a traveler
 * @dev - TravelHistoryManager.sol can be customized by each authority (i.e. A border control of each country)
 */
contract TravelHistoryProofVerifier {
    HonkVerifier public verifier;
    
    string public version;

    constructor(HonkVerifier _verifier) {
        verifier = _verifier;
        version = "0.2.18";
    }

    function verifyTravelHistoryProof(bytes calldata proof, bytes32[] calldata publicInput) public view returns (bool) {
        bool proofResult = verifier.verify(proof, publicInput); /// @dev - HonkVerifier#verify()
        require(proofResult, "Proof is not valid");
        return proofResult;
    }
}
