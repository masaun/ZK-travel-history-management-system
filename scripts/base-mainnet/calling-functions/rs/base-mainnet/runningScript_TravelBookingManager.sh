echo "Load the environment variables from the .env file..."
source .env

echo "Running the TravelBookingManager contract interactions..."
cargo run --bin travel_booking_manager_on_base_mainnet -- --show-output any_network