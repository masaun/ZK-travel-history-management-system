'use client'
import { config } from '@/config'

// @dev - Wagmi, etc
import { writeContract } from '@wagmi/core'
//import { useReadContract, useWriteContract } from "wagmi";
import TravelBookingManagerArtifact from "./artifacts/TravelBookingManager.sol/TravelBookingManager.json";
//import { USDTAbi } from "../abi/USDTAbi";

const TravelBookingManagerAddress = process.env.NEXT_PUBLIC_TRAVEL_BOOKING_MANAGER_ON_BASE_MAINNET; // Replace with your contract address
//const USDTAddress = "0x...";

export const OnChainTxButton = () => {
    const handleCallCheckpointFunction = async () => {
      try {
        const result = await writeContract(config,{
            abi: TravelBookingManagerArtifact.abi,
            //abi: USDTAbi,
            address: TravelBookingManagerAddress as `0x${string}`,
            //address: USDTAddress,
            functionName: "checkpoint",
            args: ["Test Checkpoint from Frontend"],
        });
        console.log("Transaction successful:", result);
      } catch (error) {
        console.error("Failed to call checkpoint function:", error);
      }
    }

    return (
      <div>
        <button onClick={handleCallCheckpointFunction}>Call Checkpoint Function</button>
      </div>
    )
}
