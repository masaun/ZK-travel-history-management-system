pragma solidity ^0.8.17;

import "forge-std/Script.sol";

/// @dev - ZK (Ultraplonk) circuit, which is generated in Noir.
import { StakingPool } from "../../../contracts/StakingPool.sol";

/**
 * @notice - Deployment script to deploy all SCs at once - on BASE Mainnet
 */
contract DeploymentForStakingPool_basescan is Script {
    StakingPool public stakingPool;

    function setUp() public {}

    function run() public {

        vm.createSelectFork('base_mainnet'); // [NOTE]: foundry.toml - BASE Mainnet RPC URL

        uint256 deployerPrivateKey = vm.envUint("BASE_MAINNET_PRIVATE_KEY");
        //uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        //vm.startBroadcast();

        /// @dev - Deploy SCs
        //verifier = StakingPool(vm.envAddress("STAKING_POOL_ON_BASE_MAINNET"));
        stakingPool = new StakingPool();

        vm.stopBroadcast();

        /// @dev - Logs of the deployed-contracts on BASE Mainnet
        console.logString("Logs of the deployed-contracts on BASE Mainnet");
        console.logString("\n");
        console.log("%s: %s", "StakingPool SC", address(stakingPool));
    }
}