echo "Load the environment variables from the .env file..."
source .env

echo "Running the TravelBookingManager contract interactions with a batch SC call..."
cargo run --bin travel_booking_manager_on_celo_mainnet_with_batch_sc_call -- --show-output any_network