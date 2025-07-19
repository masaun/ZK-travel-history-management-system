echo "Load the environment variables from the .env file..."
. ./.env

echo "Deploying the HonkVerifier and TravelHistoryProofVerifier contract on Base Mainnet..."
forge script script/base-mainnet/deployment/DeploymentAllContracts.s.sol \
    --broadcast \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    --private-key ${BASE_MAINNET_PRIVATE_KEY} \
    --gas-limit ${BASE_MAINNET_GAS_LIMIT} \
    --gas-price ${BASE_MAINNET_GAS_PRICE} \

# [NOTE - Adding the "--legacy" option]: Due to this error - Error: Failed to estimate EIP1559 fees. This chain might not support EIP1559, try adding --legacy to your command.

echo "Verify the deployed-smart contracts on Base Mainnet Explorer..."
forge script script/base-mainnet/deployment/DeploymentAllContracts.s.sol \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    --private-key ${BASE_MAINNET_PRIVATE_KEY} \
    --resume \
    --verify \
    --verifier ${BASE_MAINNET_BASESCAN_VERIFIER} \
    --verifier-url ${BASE_MAINNET_BASESCAN_VERIFIER_URL} \
    --etherscan-api-key ${BASESCAN_API_KEY} \