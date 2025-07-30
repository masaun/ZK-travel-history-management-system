echo "Load the environment variables from the .env file..."
. ./.env

echo "Deploying the smart contracts (icl. UltraVerifier, TravelHistoryProofVerifier, TravelHistoryManager) on BASE Mainnet + Gas Cost Simulation..."
forge script scripts/base-mainnet/deployment/DeploymentAllContracts.s.sol \
    --broadcast \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    --private-key ${BASE_MAINNET_PRIVATE_KEY} \
    --gas-limit 10000000 \
    ./contracts/circuit/ultra-verifier/plonk_vk.sol:UltraVerifier \
    ./contracts/circuit/TravelHistoryProofVerifier.sol:TravelHistoryProofVerifier \
    ./contracts/circuit/TravelHistoryManager.sol:TravelHistoryManager
    #--skip-simulation \
    #--legacy

echo "Verify the deployed-smart contracts (icl. UltraVerifier, InsuranceClaimProofVerifier) on BASE Mainnet Explorer..."
forge script scripts/base-mainnet/deployment/DeploymentAllContracts.s.sol \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    --private-key ${BASE_MAINNET_PRIVATE_KEY} \
    --gas-limit 10000000 \
    --resume \
    --verify \
    --verifier blockscout \
    --verifier-url https://base.blockscout.com/api/