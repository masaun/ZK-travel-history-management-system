use alloy::{
    providers::{ProviderBuilder},
    primitives::{Address, U256},
    sol,
};
use std::env;

sol! {
    #[sol(rpc)]
    contract StakingPool {
        // Getters
        function version() public view returns (string);
        function stakers(address) public view returns (bool);
        function stakedAmounts(address) public view returns (uint256);
        function getContractBalance() public view returns (uint256);

        // State-changing
        function registerAsStaker() public returns (bool);
        function deregisterAsStaker() public returns (bool);
        function stakeNativeTokenIntoStakingPool() public payable returns (bool);
        function unstakeNativeTokenFromStakingPool() public returns (bool);
        function checkpoint(string methodName) public returns (bool);
        function testFunctionForCheckPoint() public returns (bool);
    }
}

#[tokio::main]
async fn main() -> eyre::Result<()> {
    // -------------------------------
    // Config (replace with your info)
    // -------------------------------
    let rpc_url = "https://mainnet.base.org"; // Base mainnet RPC

    let contract_addr: Address = env::var("STAKING_POOL_ON_BASE_MAINNET")
        .expect("Set STAKING_POOL_ON_BASE_MAINNET in your environment")
        .parse()?; // Replace with deployed contract
    //let contract_addr: Address = "0xYourContractAddress".parse()?; // Replace with deployed contract

    // -------------------------------
    // Setup provider
    // -------------------------------
    // Parse RPC URL
    let rpc_url = rpc_url.parse::<reqwest::Url>()
        .map_err(|e| eyre::eyre!("Invalid RPC URL: {}", e))?;
    
    let provider = ProviderBuilder::new()
        .on_http(rpc_url);
    
    // For now, we'll create a simple contract instance without signer
    // to test basic functionality

    let staking_pool = StakingPool::new(contract_addr, provider);

    // -------------------------------
    // CLI args
    // -------------------------------
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage:
            cargo run -- version
            cargo run -- register
            cargo run -- stake <ETH_AMOUNT>
            cargo run -- unstake
            cargo run -- balance");
        return Ok(());
    }

    match args[1].as_str() {
        "version" => {
            let v = staking_pool.version().call().await?;
            println!("Contract version: {}", v._0);
        }

        "register" => {
            println!("Register functionality requires a signer. Not implemented in read-only mode.");
        }

        "stake" => {
            println!("Stake functionality requires a signer. Not implemented in read-only mode.");
        }

        "unstake" => {
            println!("Unstake functionality requires a signer. Not implemented in read-only mode.");
        }

        "balance" => {
            let bal = staking_pool.getContractBalance().call().await?;
            println!("Contract balance: {} wei (~{} ETH)", bal._0, wei_to_eth(bal._0));
        }

        _ => {
            eprintln!("Unknown command: {}", args[1]);
        }
    }

    Ok(())
}

fn eth_to_wei(amount: f64) -> U256 {
    let wei = amount * 1e18;
    U256::from(wei as u128)
}

fn wei_to_eth(wei: U256) -> f64 {
    let as_f64: f64 = wei.to::<u128>() as f64;
    as_f64 / 1e18
}
