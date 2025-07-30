pragma solidity ^0.8.17;

import "forge-std/Script.sol";

/// @dev - ZK (Ultraplonk) circuit, which is generated in Noir.
import { HonkVerifier } from "../../../contracts/circuit/ultra-verifier/plonk_vk.sol";

/**
 * @notice - Deployment script to deploy all SCs at once - on BASE Mainnet
 */
contract DeploymentForHonkVerifier_basescan is Script {
    HonkVerifier public verifier;

    function setUp() public {}

    function run() public {

        vm.createSelectFork('base_mainnet'); // [NOTE]: foundry.toml - BASE Mainnet RPC URL

        uint256 deployerPrivateKey = vm.envUint("BASE_MAINNET_PRIVATE_KEY");
        //uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        //vm.startBroadcast();

        /// @dev - Deploy SCs
        //verifier = UltraVerifier(vm.envAddress("HONK_VERIFIER_ON_BASE_MAINNET"));
        verifier = new HonkVerifier();

        vm.stopBroadcast();

        /// @dev - Logs of the deployed-contracts on BASE Mainnet
        console.logString("Logs of the deployed-contracts on BASE Mainnet");
        console.logString("\n");
        console.log("%s: %s", "UltraVerifier SC", address(verifier));
    }
}