echo "Load the environment variables from the .env file..."
. ./.env

echo "Verifying a proof via the Starter (UltraVerifier) contract on Electroneum Testnet..."
forge script scripts/electroneum-testnet/TravelHistoryProofVerifier.s.sol --broadcast --private-key ${ELECTRONEUM_TESTNET_PRIVATE_KEY} --skip-simulation