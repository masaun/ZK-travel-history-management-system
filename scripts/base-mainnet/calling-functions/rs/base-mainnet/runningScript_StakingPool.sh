echo "Load the environment variables from the .env file..."
source .env

echo "Running StakingPool contract interactions..."
cargo run --bin staking_pool_on_base_mainnet -- --show-output any_network