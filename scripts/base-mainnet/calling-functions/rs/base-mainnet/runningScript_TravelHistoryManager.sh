echo "Load the environment variables from the .env file..."
source .env

echo "Running the TravelHistoryManager contract interactions..."
cargo run --bin travel_history_manager_on_base_mainnet -- --show-output any_network