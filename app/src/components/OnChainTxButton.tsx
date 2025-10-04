'use client'
import { config } from '@/config'
import { writeContract } from '@wagmi/core'
import { useAccount, useChainId } from "wagmi";
import { base } from '@reown/appkit/networks'
import TravelBookingManagerArtifact from "./artifacts/TravelBookingManager.sol/TravelBookingManager.json";

const TravelBookingManagerAddress = process.env.NEXT_PUBLIC_TRAVEL_BOOKING_MANAGER_ON_BASE_MAINNET;

export const OnChainTxButton = () => {
    const { address, isConnected } = useAccount();
    const chainId = useChainId();

    const handleCallCheckpointFunction = async () => {
      try {
        const result = await writeContract(config, {
            abi: TravelBookingManagerArtifact.abi,
            address: TravelBookingManagerAddress as `0x${string}`,
            functionName: "checkpoint",
            args: ["Test Checkpoint from Frontend"],
            account: address!,
            chain: base,
        });
        console.log("Transaction successful:", result);
      } catch (error) {
        console.error("Failed to call checkpoint function:", error);
      }
    }

    return (
      <div>
        <button 
          onClick={handleCallCheckpointFunction}
          disabled={!isConnected}
          className="w-full justify-center inline-flex items-center gap-2 rounded-lg bg-gradient-to-r from-green-500 to-emerald-600 py-3 px-4 text-sm font-semibold text-white shadow-lg hover:from-green-600 hover:to-emerald-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 dark:focus:ring-offset-gray-800 transition-all duration-200 transform hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
        >
          Call Checkpoint Function
        </button>
      </div>
    )
}