# @notice - This script file must be run from the root directory of the project, where is the location of .env file.
echo "Load the environment variables from the .env file..."
source .env
#. ./.env

# @notice - [Result]: Successfully "verified" the THonkVerifier contract on Base Mainnet. 
echo "Verifying the HonkVerifier contract on Base Mainnet (via BaseScan)..."
forge verify-contract \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    ${HONK_VERIFIER_ON_BASE_MAINNET} \
    ./contracts/circuit/plonk_vk.sol:HonkVerifier \
    --etherscan-api-key ${BASESCAN_API_KEY}

echo "Verifying the HonkVerifier contract on Base Mainnet via Curl command..."
curl "https://api.basescan.org/api?module=contract&action=checkverifystatus&guid=${GUID}&apikey=${BASESCAN_API_KEY}"


# @notice - [Result]: Successfully "verified" the TravelHistoryProofVerifier contract on Base Mainnet. 
echo "Verifying the TravelHistoryProofVerifier contract on Base Mainnet (via BaseScan)..."
forge verify-contract \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    ${TRAVEL_HISTORY_PROOF_VERIFIER_ON_BASE_MAINNET} \
    ./contracts/circuit/TravelHistoryProofVerifier.sol:TravelHistoryProofVerifier \
    --etherscan-api-key ${BASESCAN_API_KEY}


echo "Verifying the TravelHistoryProofVerifier contract on Base Mainnet via Curl command..."
curl "https://api.basescan.org/api?module=contract&action=checkverifystatus&guid=${GUID}&apikey=${BASESCAN_API_KEY}"


# @notice - [Result]: Successfully "verified" the TravelHistoryManager contract on Base Mainnet. 
echo "Verifying the TravelHistoryManager contract on Base Mainnet (via BaseScan)..."
forge verify-contract \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    ${TRAVEL_HISTORY_MANAGER_ON_BASE_MAINNET} \
    ./contracts/circuit/TravelHistoryManager.sol:TravelHistoryManager \
    --etherscan-api-key ${BASESCAN_API_KEY}


echo "Verifying the TravelHistoryManager contract on Base Mainnet via Curl command..."
curl "https://api.basescan.org/api?module=contract&action=checkverifystatus&guid=${GUID}&apikey=${BASESCAN_API_KEY}"


# @notice - [Result]: Successfully "verified" the TravelBookingManager contract on Base Mainnet. 
echo "Verifying the TravelBookingManager contract on Base Mainnet (via BaseScan)..."
forge verify-contract \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    ${TRAVEL_BOOKING_MANAGER_ON_BASE_MAINNET} \
    ./contracts/circuit/TravelBookingManager.sol:TravelBookingManager \
    --etherscan-api-key ${BASESCAN_API_KEY}


echo "Verifying the TravelBookingManager contract on Base Mainnet via Curl command..."
curl "https://api.basescan.org/api?module=contract&action=checkverifystatus&guid=${GUID}&apikey=${BASESCAN_API_KEY}"


# @notice - [Result]: Successfully "verified" the StakingPool contract on Base Mainnet. 
echo "Verifying the StakingPool contract on Base Mainnet (via BaseScan)..."
forge verify-contract \
    --rpc-url ${BASE_MAINNET_RPC} \
    --chain-id ${BASE_MAINNET_CHAIN_ID} \
    ${STAKING_POOL_ON_BASE_MAINNET} \
    ./contracts/circuit/StakingPool.sol:StakingPool \
    --etherscan-api-key ${BASESCAN_API_KEY}


echo "Verifying the StakingPool contract on Base Mainnet via Curl command..."
curl "https://api.basescan.org/api?module=contract&action=checkverifystatus&guid=${GUID}&apikey=${BASESCAN_API_KEY}"
