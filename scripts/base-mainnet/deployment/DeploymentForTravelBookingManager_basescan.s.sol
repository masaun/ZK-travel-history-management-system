pragma solidity ^0.8.17;

import "forge-std/Script.sol";

import { TravelBookingManager } from "../../../contracts/TravelBookingManager.sol";


/**
 * @notice - Deployment script to deploy the TravelBookingManager SC - on BASE Mainnet
 */
contract DeploymentForTravelBookingManager_basescan is Script {
    TravelBookingManager public travelBookingManager;

    function setUp() public {}

    function run() public {

        //vm.createSelectFork("https://mainnet.base.org");
        vm.createSelectFork('base_mainnet'); // [NOTE]: foundry.toml - BASE Mainnet RPC URL

        uint256 deployerPrivateKey = vm.envUint("BASE_MAINNET_PRIVATE_KEY");
        //uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        //vm.startBroadcast();

        /// @dev - Deploy SCs
        travelBookingManager = new TravelBookingManager();
        vm.stopBroadcast();

        /// @dev - Logs of the deployed-contracts on BASE Mainnet
        console.logString("Logs of the deployed-contracts on BASE Mainnet");
        console.logString("\n");
        console.log("%s: %s", "TravelBookingManager SC", address(travelBookingManager));
    }
}

