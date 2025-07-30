pragma solidity ^0.8.17;

import "forge-std/Script.sol";

/// @dev - ZK (Ultraplonk) circuit, which is generated in Noir.
import { HonkVerifier } from "../../../contracts/circuit/ultra-verifier/plonk_vk.sol";
import { TravelHistoryProofVerifier } from "../../../contracts/TravelHistoryProofVerifier.sol";
import { TravelHistoryManager } from "../../../contracts/TravelHistoryManager.sol";


/**
 * @notice - Deployment script to deploy all SCs at once - on Celo Mainnet
 */
contract DeploymentAllContracts is Script {
    HonkVerifier public verifier;
    TravelHistoryProofVerifier public travelHistoryProofVerifier;
    TravelHistoryManager public travelHistoryManager;

    function setUp() public {}

    function run() public {

        //vm.createSelectFork('celo-testnet'); // [NOTE]: Commmentout due to the error of the "Multi chain deployment does not support library linking at the moment"

        uint256 deployerPrivateKey = vm.envUint("CELO_MAINNET_PRIVATE_KEY");
        //uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        //vm.startBroadcast();

        /// @dev - Deploy SCs
        //verifier = UltraVerifier(vm.envAddress("ULTRA_VERIFIER_ON_CELO_MAINNET"));
        verifier = new HonkVerifier();
        travelHistoryProofVerifier = new TravelHistoryProofVerifier(verifier);
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

