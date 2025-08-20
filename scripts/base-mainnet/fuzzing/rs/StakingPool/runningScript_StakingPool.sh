echo "Load the environment variables from the .env file..."
source .env

echo "Running StakingPool contract interactions..."
cargo run -- version
cargo run -- register
cargo run -- stake 0.05
cargo run -- unstake
cargo run -- balance