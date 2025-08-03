echo "Compile the smart contracts"
sh buildContract.sh

echo "Load the environment variables from the .env file..."
. ./.env

echo "Deploying & Verifying the TravelHistoryManager contract on BASE Mainnet (via BaseScan)..."
forge script scripts/base-mainnet/deployment/DeploymentForTravelHistoryManager_basescan.s.sol --slow --multi --broadcast --private-key ${BASE_MAINNET_PRIVATE_KEY} --verify --etherscan-api-key ${BASESCAN_API_KEY}
