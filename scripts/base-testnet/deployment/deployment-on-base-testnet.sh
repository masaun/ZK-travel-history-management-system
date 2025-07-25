echo "Load the environment variables from the .env file..."
. ./.env

echo "Deploying the UltraVerifier and TravelHistoryProofVerifier contract on Base Sepolia Testnet..."
forge script script/base-testnet/deployment/DeploymentAllContracts.s.sol \
    --broadcast \
    --rpc-url ${BASE_TESTNET_RPC} \
    --chain-id ${BASE_TESTNET_CHAIN_ID} \
    --private-key ${BASE_TESTNET_PRIVATE_KEY} \
    ./contracts/circuit/ultra-verifier/plonk_vk.sol:UltraVerifier \
    ./TravelHistoryProofVerifier.sol:TravelHistoryProofVerifier \
    ./TravelHistoryManager.sol:TravelHistoryManager --skip-simulation --legacy

# [NOTE - Adding the "--legacy" option]: Due to this error - Error: Failed to estimate EIP1559 fees. This chain might not support EIP1559, try adding --legacy to your command.

echo "Verify the deployed-smart contracts on Base Sepolia Testnet Explorer..."
forge script script/base-testnet/deployment/DeploymentAllContracts.s.sol \
    --rpc-url ${BASE_TESTNET_RPC} \
    --chain-id ${BASE_TESTNET_CHAIN_ID} \
    --private-key ${BASE_TESTNET_PRIVATE_KEY} \
    --resume \
    --verify \
    --verifier etherscan \
    --verifier-url https://api-sepolia.basescan.org/api \
    --etherscan-api-key ${BASESCAN_API_KEY} \