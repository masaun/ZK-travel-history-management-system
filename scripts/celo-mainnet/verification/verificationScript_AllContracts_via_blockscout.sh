# @notice - This script file must be run from the root directory of the project, where is the location of .env file.
echo "Load the environment variables from the .env file..."
source .env
#. ./.env

# @notice - Verify the HonkVerifier contract on Celo Mainnet. 
echo "Verifying the HonkVerifier contract on Celo Mainnet (via BlockScout)..."
forge verify-contract \
  --rpc-url ${CELO_MAINNET_RPC} \
  --verifier blockscout \
  --verifier-url 'https://celo.blockscout.com/api/' \
  ${HONK_VERIFIER_ON_CELO_MAINNET} \
  ./contracts/circuit/ultra-verifier/plonk_vk.sol:HonkVerifier

# @notice - Verify the TravelHistoryProofVerifier contract on Celo Mainnet. 
echo "Verifying the TravelHistoryProofVerifier contract on Celo Mainnet (via BlockScout)..."
forge verify-contract \
  --rpc-url ${CELO_MAINNET_RPC} \
  --verifier blockscout \
  --verifier-url 'https://celo.blockscout.com/api/' \
  ${TRAVEL_HISTORY_PROOF_VERIFIER_ON_CELO_MAINNET} \
  ./contracts/TravelHistoryProofVerifier.sol:TravelHistoryProofVerifier

# @notice - Verify the TravelHistoryManager contract on Celo Mainnet. 
echo "Verifying the TravelHistoryManager contract on Celo Mainnet (via BlockScout)..."
forge verify-contract \
  --rpc-url ${CELO_MAINNET_RPC} \
  --verifier blockscout \
  --verifier-url 'https://celo.blockscout.com/api/' \
  ${TRAVEL_HISTORY_MANAGER_ON_CELO_MAINNET} \
  ./contracts/TravelHistoryManager.sol:TravelHistoryManager