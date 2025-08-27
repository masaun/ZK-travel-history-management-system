pragma solidity ^0.8.17;

import "forge-std/Script.sol";

import { TravelBookingManager } from "../../../contracts/TravelBookingManager.sol";


/**
 * @notice - Deployment script to deploy the TravelBookingManager SC - on Celo Mainnet
 */
contract DeploymentForTravelBookingManager_basescan is Script {
    TravelBookingManager public travelBookingManager;

    function setUp() public {}

    function run() public {

        //vm.createSelectFork("https://mainnet.celo.org");
        vm.createSelectFork('celo_mainnet'); // [NOTE]: foundry.toml - Celo Mainnet RPC URL

        uint256 deployerPrivateKey = vm.envUint("CELO_MAINNET_PRIVATE_KEY");
        //uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        //vm.startBroadcast();

        /// @dev - Deploy SCs
        travelBookingManager = new TravelBookingManager();
        vm.stopBroadcast();

        /// @dev - Logs of the deployed-contracts on Celo Mainnet
        console.logString("Logs of the deployed-contracts on Celo Mainnet");
        console.logString("\n");
        console.log("%s: %s", "TravelBookingManager SC", address(travelBookingManager));
    }
}

