'use client'
import { useWriteContract, useAccount } from "wagmi";
import TravelBookingManagerArtifact from "./artifacts/TravelBookingManager.sol/TravelBookingManager.json";
//import { USDTAbi } from "../abi/USDTAbi";

const TravelBookingManagerAddress = process.env.NEXT_PUBLIC_TRAVEL_BOOKING_MANAGER_ON_BASE_MAINNET; // Replace with your contract address
//const USDTAddress = "0x...";

export const OnChainTxButton = () => {
    const { writeContract, isPending, error } = useWriteContract();
    const { isConnected } = useAccount();

    const handleCallCheckpointFunction = async () => {
      try {
        writeContract({
            abi: TravelBookingManagerArtifact.abi,
            //abi: USDTAbi,
            address: TravelBookingManagerAddress as `0x${string}`,
            //address: USDTAddress,
            functionName: "checkpoint",
            args: ["Test Checkpoint from Frontend"],
        });
        console.log("Transaction initiated");
      } catch (error) {
        console.error("Failed to call checkpoint function:", error);
      }
    }

    return (
      <div>
        <button 
          onClick={handleCallCheckpointFunction}
          disabled={!isConnected || isPending}
          className="w-full justify-center inline-flex items-center gap-2 rounded-lg bg-gradient-to-r from-green-500 to-emerald-600 py-3 px-4 text-sm font-semibold text-white shadow-lg hover:from-green-600 hover:to-emerald-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 dark:focus:ring-offset-gray-800 transition-all duration-200 transform hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
        >
          {isPending ? 'Processing...' : 'Call Checkpoint Function'}
        </button>
        {error && (
          <div className="mt-2 text-sm text-red-600 dark:text-red-400">
            Error: {error.message}
          </div>
        )}
      </div>
    )
}
