echo "Compiling the smart contracts..."
sh buildContract.sh

# @notice - This script file must be run from the root directory of the project, where is the location of .env file.
echo "Load the environment variables from the .env file..."
source .env
#. ./.env

# echo "Deploying & Verifying the HonkVerifier contract on Base mainnet..."
# forge script scripts/base-mainnet/deployment/DeploymentAllContracts.s.sol --slow --multi --broadcast --private-key ${BASE_MAINNET_PRIVATE_KEY} --verify --etherscan-api-key ${BASESCAN_API_KEY}

echo "Deploying the HonkVerifier SC on BASE Mainnet + Gas Cost Simulation..."
forge script scripts/base-mainnet/deployment/DeploymentForHonkVerifier.s.sol \
    --broadcast \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    --private-key ${BASE_MAINNET_PRIVATE_KEY} \
    --gas-limit 15000000 \
    --legacy
    #--skip-simulation

echo "Verify the HonkVerifier SC on BASE Mainnet Explorer..."
forge script scripts/base-mainnet/deployment/DeploymentForHonkVerifier.s.sol \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    --private-key ${BASE_MAINNET_PRIVATE_KEY} \
    --gas-limit 15000000 \
    --resume \
    --verify \
    --verifier blockscout \
    --verifier-url https://base.blockscout.com/api/