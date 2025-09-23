echo "Load the environment variables from the .env file..."
source .env

echo "Running the TravelHistoryManager contract interactions with a single SC call..."
cargo run --bin travel_history_manager_on_base_mainnet_with_single_sc_call -- --show-output any_network