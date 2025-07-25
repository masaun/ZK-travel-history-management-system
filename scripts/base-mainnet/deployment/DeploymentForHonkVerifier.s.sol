pragma solidity ^0.8.17;

import "forge-std/Script.sol";

/// @dev - ZK (Ultraplonk) circuit, which is generated in Noir.
import { HonkVerifier } from "../../../contracts/circuit/ultra-verifier/plonk_vk.sol";

/**
 * @notice - Deployment script to deploy HonkVerifier only - on Base Mainnet
 * @dev - This deploys only the HonkVerifier contract to reduce gas usage
 */
contract DeploymentForHonkVerifier is Script {
    HonkVerifier public verifier;

    function setUp() public {}

    function run() public {
        //vm.createSelectFork("base_mainnet");
        uint256 deployerPrivateKey = vm.envUint("BASE_MAINNET_PRIVATE_KEY");
        
        // Set gas configuration for Base mainnet
        //vm.txGasPrice(0.01 gwei); // Base mainnet typically has very low gas costs
        
        vm.startBroadcast(deployerPrivateKey);

        verifier = new HonkVerifier();

        vm.stopBroadcast();

        /// @dev - Logs of the deployed HonkVerifier on Base Mainnet
        console.logString("HonkVerifier deployed on Base Mainnet:");
        console.log("HonkVerifier:", address(verifier));
        console.logString("\n");
    }
}

// CLI for Base Mainnet HonkVerifier Deployment:
// forge script script/base-mainnet/deployment/DeploymentForHonkVerifier.s.sol --broadcast --rpc-url $BASE_MAINNET_RPC --private-key $BASE_MAINNET_PRIVATE_KEY --gas-limit 15000000 --legacy --verify
