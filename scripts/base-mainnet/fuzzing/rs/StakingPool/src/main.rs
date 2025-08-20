use alloy::{
    providers::{ProviderBuilder, Provider},
    signers::local::PrivateKeySigner,
    primitives::{Address, U256},
    transports::http::Http,
    sol,
};
use alloy_provider::fillers::{WalletFiller, JoinFill, FillProvider};
use alloy_signer::Signature;
use std::{env, str::FromStr};

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
    let private_key = env::var("PRIVATE_KEY")
        .expect("Set PRIVATE_KEY in your environment");

    let contract_addr: Address = env::var("STAKING_POOL_ON_BASE_MAINNET")
        .expect("Set STAKING_POOL_ON_BASE_MAINNET in your environment")
        .parse()?; // Replace with deployed contract
    //let contract_addr: Address = "0xYourContractAddress".parse()?; // Replace with deployed contract

    // -------------------------------
    // Setup provider + signer
    // -------------------------------
    let signer = PrivateKeySigner::from_str(&private_key)?;
    
    // Parse RPC URL
    let rpc_url = rpc_url.parse::<reqwest::Url>()
        .map_err(|e| eyre::eyre!("Invalid RPC URL: {}", e))?;
    
    // Create provider with signer (alloy v0.1 approach)
    let provider = ProviderBuilder::new()
        .wallet(signer)
        .on_http(rpc_url);

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
            println!("Calling registerAsStaker()...");
            let call_builder = staking_pool.registerAsStaker();
            let pending_tx = call_builder.send().await?;
            println!("Transaction sent: {:?}", pending_tx.tx_hash());
            
            let receipt = pending_tx.get_receipt().await?;
            println!("Registered as staker in block {:?}", receipt.block_number);
            if receipt.status() {
                println!("✅ Registration successful!");
            } else {
                println!("❌ Registration failed!");
            }
        }

        "stake" => {
            if args.len() < 3 {
                eprintln!("Usage: cargo run -- stake <ETH_AMOUNT>");
                return Ok(());
            }
            let eth_amount: f64 = args[2].parse().unwrap();
            let wei_amount = eth_to_wei(eth_amount);
            
            println!("Staking {} ETH ({} wei)...", eth_amount, wei_amount);
            let call_builder = staking_pool
                .stakeNativeTokenIntoStakingPool()
                .value(wei_amount);
            let pending_tx = call_builder.send().await?;
            println!("Transaction sent: {:?}", pending_tx.tx_hash());
            
            let receipt = pending_tx.get_receipt().await?;
            println!("Staked {} ETH in block {:?}", eth_amount, receipt.block_number);
            if receipt.status() {
                println!("✅ Staking successful!");
            } else {
                println!("❌ Staking failed!");
            }
        }

        "unstake" => {
            println!("Calling unstakeNativeTokenFromStakingPool()...");
            let call_builder = staking_pool.unstakeNativeTokenFromStakingPool();
            let pending_tx = call_builder.send().await?;
            println!("Transaction sent: {:?}", pending_tx.tx_hash());
            
            let receipt = pending_tx.get_receipt().await?;
            println!("Unstaked in block {:?}", receipt.block_number);
            if receipt.status() {
                println!("✅ Unstaking successful!");
            } else {
                println!("❌ Unstaking failed!");
            }
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
