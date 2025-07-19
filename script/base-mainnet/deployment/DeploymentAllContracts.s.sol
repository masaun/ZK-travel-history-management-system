pragma solidity ^0.8.17;

import "forge-std/Script.sol";

/// @dev - ZK (Ultraplonk) circuit, which is generated in Noir.
import { HonkVerifier } from "../../../contracts/circuit/ultra-verifier/plonk_vk.sol"; /// @dev - Deployed-Verifier SC, which was generated based on the main.nr
//import { UltraVerifier } from "../../../circuits/target/contract.sol"; /// @dev - Deployed-Verifier SC, which was generated based on the main.nr
import { TravelHistoryProofVerifier } from "../../../contracts/TravelHistoryProofVerifier.sol";
import { TravelHistoryManager } from "../../../contracts/TravelHistoryManager.sol";

//import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


/**
 * @notice - Deployment script to deploy all SCs at once - on Sonic Blaze Testnet
 * @dev - [CLI]: Using the CLI, which is written in the bottom of this file, to deploy all SCs
 */
contract DeploymentAllContracts is Script {
    //using SafeERC20 for MockRewardToken;

    HonkVerifier public verifier;
    TravelHistoryProofVerifier public travelHistoryProofVerifier;
    TravelHistoryManager public travelHistoryManager;

    function setUp() public {}

    function run() public {
        vm.createSelectFork("BASE_MAINNET");
        uint256 deployerPrivateKey = vm.envUint("BASE_MAINNET_PRIVATE_KEY");
        //uint256 deployerPrivateKey = vm.envUint("LOCALHOST_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        //vm.startBroadcast();
        verifier = new UltraVerifier();
        travelHistoryProofVerifier = new TravelHistoryProofVerifier(verifier);
        travelHistoryManager = new TravelHistoryManager(travelHistoryProofVerifier);

        vm.stopBroadcast();

        /// @dev - Logs of the deployed-contracts on Base Sepolia Testnet
        console.logString("Logs of the deployed-contracts on Base Sepolia Testnet");
        console.logString("\n");
        //console.log("%s: %s", "RewardPoolFactory SC", address(rewardPoolFactory));
        //console.logString("\n");
    }
}



/////////////////////////////////////////
/// CLI (icl. SC sources) - New version
//////////////////////////////////////

// forge script script/DeploymentAllContracts.s.sol --broadcast --private-key <SONIC_BLAZE_TESTNET_PRIVATE_KEY> \
//     ./circuits/target/contract.sol:UltraVerifier \
//     ./Starter.sol:Starter --skip-simulation
