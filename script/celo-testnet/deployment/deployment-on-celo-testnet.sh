echo "Load the environment variables from the .env file..."
. ./.env

echo "Deploying the UltraVerifier and TravelHistoryProofVerifier contract on Celo Alfajores Testnet..."
forge script script/celo-testnet/deployment/DeploymentAllContracts.s.sol \
    --broadcast \
    --rpc-url ${CELO_TESTNET_RPC} \
    --chain-id ${CELO_TESTNET_CHAIN_ID} \
    --private-key ${CELO_TESTNET_PRIVATE_KEY} \
    ./contracts/circuit/ultra-verifier/plonk_vk.sol:UltraVerifier \
    ./TravelHistoryProofVerifier.sol:TravelHistoryProofVerifier \
    ./TravelHistoryManager.sol:TravelHistoryManager --skip-simulation --legacy

# [NOTE - Adding the "--legacy" option]: Due to this error - Error: Failed to estimate EIP1559 fees. This chain might not support EIP1559, try adding --legacy to your command.

echo "Verify the deployed-smart contracts on Celo Alfajores Testnet Explorer..."
forge script script/base-testnet/deployment/DeploymentAllContracts.s.sol \
    --rpc-url ${CELO_TESTNET_RPC} \
    --chain-id ${CELO_TESTNET_CHAIN_ID} \
    --private-key ${CELO_TESTNET_PRIVATE_KEY} \
    --resume \
    --verify \
    --verifier etherscan \
    --verifier-url https://api-alfajores.celoscan.io/api \
    --etherscan-api-key ${CELOSCAN_API_KEY} \