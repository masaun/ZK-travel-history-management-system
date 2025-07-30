pragma solidity ^0.8.17;

import "forge-std/Script.sol";

/// @dev - ZK (Ultraplonk) circuit, which is generated in Noir.
import { HonkVerifier } from "../../../contracts/circuit/ultra-verifier/plonk_vk.sol"; /// @dev - Deployed-Verifier SC, which was generated based on the main.nr
import { TravelHistoryProofVerifier } from "../../../contracts/circuit/TravelHistoryProofVerifier.sol";
import { TravelHistoryManager } from "../../../contracts/TravelHistoryManager.sol";


/**
 * @notice - Deployment script to deploy the TravelHistoryProofVerifier SC - on Celo Mainnet
 */
contract DeploymentForTravelHistoryProofVerifier_celoscan is Script {
    HonkVerifier public verifier;
    TravelHistoryProofVerifier public travelHistoryProofVerifier;
    TravelHistoryManager public travelHistoryManager;

    function setUp() public {}

    function run() public {

        vm.createSelectFork("https://forno.celo.org"); // @dev - [NOTE]: Hardcoded the Celo Mainnet RPC URL - Instead of using the environment variable via the foundry.toml
        //vm.createSelectFork('celo-mainnet');

        uint256 deployerPrivateKey = vm.envUint("CELO_MAINNET_PRIVATE_KEY");
        //uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        //vm.startBroadcast();

        /// @dev - Deploy SCs
        verifier = HonkVerifier(vm.envAddress("HONK_VERIFIER_ON_CELO_MAINNET"));
        //verifier = new HonkVerifier();
        travelHistoryProofVerifier = TravelHistoryProofVerifier(vm.envAddress("TRAVEL_HISTORY_PROOF_VERIFIER_ON_CELO_MAINNET"));
        //travelHistoryProofVerifier = new TravelHistoryProofVerifier(verifier);
        travelHistoryManager = new TravelHistoryManager(travelHistoryProofVerifier);

        vm.stopBroadcast();

        /// @dev - Logs of the deployed-contracts on Celo Mainnet
        console.logString("Logs of the deployed-contracts on Celo Mainnet");
        console.logString("\n");
        console.log("%s: %s", "HonkVerifier SC", address(verifier));
        console.logString("\n");
        console.log("%s: %s", "TravelHistoryProofVerifier SC", address(travelHistoryProofVerifier));
        console.logString("\n");
        console.log("%s: %s", "TravelHistoryManager SC", address(travelHistoryManager));
    }
}

