pragma solidity ^0.8.17;

import "forge-std/Script.sol";

/// @dev - ZK (Ultraplonk) circuit, which is generated in Noir.
import { HonkVerifier } from "../../../contracts/circuit/ultra-verifier/plonk_vk.sol";
import { TravelHistoryProofVerifier } from "../../../contracts/TravelHistoryProofVerifier.sol";
import { TravelHistoryManager } from "../../../contracts/TravelHistoryManager.sol";

/**
 * @notice - Deployment script to deploy SCs one by one - on Base Mainnet
 */
contract DeploymentSeparate is Script {
    function setUp() public {}

    /**
     * @notice Deploy HonkVerifier first
     */
    function deployHonkVerifier() public {
        vm.createSelectFork("base_mainnet");
        uint256 deployerPrivateKey = vm.envUint("BASE_MAINNET_PRIVATE_KEY");
        
        vm.txGasPrice(0.01 gwei);
        vm.startBroadcast(deployerPrivateKey);

        HonkVerifier verifier = new HonkVerifier();
        
        vm.stopBroadcast();

        console.logString("HonkVerifier deployed to:");
        console.log(address(verifier));
    }

    /**
     * @notice Deploy TravelHistoryProofVerifier (requires HonkVerifier address)
     */
    function deployTravelHistoryProofVerifier() public {
        vm.createSelectFork("base_mainnet");
        uint256 deployerPrivateKey = vm.envUint("BASE_MAINNET_PRIVATE_KEY");
        
        // Get the deployed HonkVerifier address from environment
        address honkVerifierAddress = vm.envAddress("HONK_VERIFIER_ADDRESS");
        HonkVerifier verifier = HonkVerifier(honkVerifierAddress);
        
        vm.txGasPrice(0.01 gwei);
        vm.startBroadcast(deployerPrivateKey);

        TravelHistoryProofVerifier travelHistoryProofVerifier = new TravelHistoryProofVerifier(verifier);
        
        vm.stopBroadcast();

        console.logString("TravelHistoryProofVerifier deployed to:");
        console.log(address(travelHistoryProofVerifier));
    }

    /**
     * @notice Deploy TravelHistoryManager (requires TravelHistoryProofVerifier address)
     */
    function deployTravelHistoryManager() public {
        vm.createSelectFork("base_mainnet");
        uint256 deployerPrivateKey = vm.envUint("BASE_MAINNET_PRIVATE_KEY");
        
        // Get the deployed TravelHistoryProofVerifier address from environment
        address travelHistoryProofVerifierAddress = vm.envAddress("TRAVEL_HISTORY_PROOF_VERIFIER_ADDRESS");
        TravelHistoryProofVerifier travelHistoryProofVerifier = TravelHistoryProofVerifier(travelHistoryProofVerifierAddress);
        
        vm.txGasPrice(0.01 gwei);
        vm.startBroadcast(deployerPrivateKey);

        TravelHistoryManager travelHistoryManager = new TravelHistoryManager(travelHistoryProofVerifier);
        
        vm.stopBroadcast();

        console.logString("TravelHistoryManager deployed to:");
        console.log(address(travelHistoryManager));
    }
}

// Deploy HonkVerifier first:
// forge script script/base-mainnet/deployment/DeploymentSeparate.s.sol:DeploymentSeparate --sig "deployHonkVerifier()" --broadcast --rpc-url $BASE_MAINNET_RPC --private-key $BASE_MAINNET_PRIVATE_KEY --gas-limit 15000000 --legacy

// Then deploy TravelHistoryProofVerifier:
// export HONK_VERIFIER_ADDRESS="0x..." # from previous step
// forge script script/base-mainnet/deployment/DeploymentSeparate.s.sol:DeploymentSeparate --sig "deployTravelHistoryProofVerifier()" --broadcast --rpc-url $BASE_MAINNET_RPC --private-key $BASE_MAINNET_PRIVATE_KEY --gas-limit 5000000 --legacy

// Finally deploy TravelHistoryManager:
// export TRAVEL_HISTORY_PROOF_VERIFIER_ADDRESS="0x..." # from previous step  
// forge script script/base-mainnet/deployment/DeploymentSeparate.s.sol:DeploymentSeparate --sig "deployTravelHistoryManager()" --broadcast --rpc-url $BASE_MAINNET_RPC --private-key $BASE_MAINNET_PRIVATE_KEY --gas-limit 3000000 --legacy
