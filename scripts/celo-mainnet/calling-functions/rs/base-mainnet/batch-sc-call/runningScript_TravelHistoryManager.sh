echo "Load the environment variables from the .env file..."
source .env

echo "Running the TravelHistoryManager contract interactions with a batch SC call..."
cargo run --bin travel_history_manager_on_base_mainnet_with_batch_sc_call -- --show-output any_network