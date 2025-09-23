echo "Load the environment variables from the .env file..."
source .env

echo "Running StakingPool contract interactions with a single SC call..."
cargo run --bin staking_pool_on_celo_mainnet_with_single_sc_call -- --show-output any_network