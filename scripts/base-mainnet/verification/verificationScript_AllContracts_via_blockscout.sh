# @notice - This script file must be run from the root directory of the project, where is the location of .env file.
echo "Load the environment variables from the .env file..."
source .env
#. ./.env

# @notice - Verify the HonkVerifier contract on BASE Mainnet. 
echo "Verifying the HonkVerifier contract on BASE Mainnet (via BlockScout)..."
forge verify-contract \
  --rpc-url ${BASE_MAINNET_RPC} \
  --verifier blockscout \
  --verifier-url 'https://base.blockscout.com/api/' \
  ${HONK_VERIFIER_ON_BASE_MAINNET} \
  ./contracts/circuit/ultra-verifier/plonk_vk.sol:HonkVerifier

# @notice - Verify the TravelHistoryProofVerifier contract on BASE Mainnet. 
echo "Verifying the TravelHistoryProofVerifier contract on BASE Mainnet (via BlockScout)..."
forge verify-contract \
  --rpc-url ${BASE_MAINNET_RPC} \
  --verifier blockscout \
  --verifier-url 'https://base.blockscout.com/api/' \
  ${TRAVEL_HISTORY_PROOF_VERIFIER_ON_BASE_MAINNET} \
  ./contracts/TravelHistoryProofVerifier.sol:TravelHistoryProofVerifier

# @notice - Verify the TravelHistoryManager contract on BASE Mainnet. 
echo "Verifying the TravelHistoryManager contract on BASE Mainnet (via BlockScout)..."
forge verify-contract \
  --rpc-url ${BASE_MAINNET_RPC} \
  --verifier blockscout \
  --verifier-url 'https://base.blockscout.com/api/' \
  ${TRAVEL_HISTORY_MANAGER_ON_BASE_MAINNET} \
  ./contracts/TravelHistoryManager.sol:TravelHistoryManager

# @notice - Verify the StakingPool contract on BASE Mainnet. 
echo "Verifying the StakingPool contract on BASE Mainnet (via BlockScout)..."
forge verify-contract \
  --rpc-url ${BASE_MAINNET_RPC} \
  --verifier blockscout \
  --verifier-url 'https://base.blockscout.com/api/' \
  ${STAKING_POOL_ON_BASE_MAINNET} \
  ./contracts/StakingPool.sol:StakingPool