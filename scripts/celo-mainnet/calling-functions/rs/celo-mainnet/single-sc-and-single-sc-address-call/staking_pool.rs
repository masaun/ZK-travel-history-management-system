// @dev - Alloy
use alloy::{
    network::AnyNetwork, // @dev - icl. AnyNetwork for Celo Mainnet
    providers::{Provider, ProviderBuilder},
    signers::local::PrivateKeySigner,
    sol,
    primitives::{address, Bytes, FixedBytes, Address, U256},
    hex::FromHex,
    rpc::types::TransactionRequest,
    network::TransactionBuilder,
};
use alloy_node_bindings::Anvil;
use serde_json;

// Generate the contract bindings for the StakingPool interface.
sol! { 
    // The `rpc` attribute enables contract interaction via the provider. 
    #[sol(rpc)] 
    StakingPool,
    "artifacts/0910/StakingPool.sol/StakingPool.json"
} 

use dotenv::dotenv;
use std::env;


/**
 * @dev - Call the StakingPool#checkpoint() on Celo Mainnet
 * @dev - Run this script with the "sh ./celo-mainnet/runningScript_StakingPool.sh" command at the root directory (= /rs)
 * @dev - Example: `any_network` 🔴
 *    (Run: `cargo run --example any_network` 🟣)
 *    https://alloy.rs/examples/advanced/any_network#example-any_network
 */
#[tokio::main]
async fn main() {
    batch_call().await;
}

/**
 * @dev - Batch call the StakingPool#checkpoint() function on Celo Mainnet
 * @dev - [TODO 1]: for-loop of the 5 private keys + Call the checkpoint() function inside it.
 * @dev - [TODO 2]: for-loop of the 12 SC address of StakingPool
 */
pub async fn batch_call() {
    // 1. Loads .env file
    dotenv().ok();

    // 2. Fetch values from .env file
    let private_key_1 = env::var("PRIVATE_KEY_1").unwrap_or_else(|_| String::new());
    let private_key_2 = env::var("PRIVATE_KEY_2").unwrap_or_else(|_| String::new());
    let private_key_3 = env::var("PRIVATE_KEY_3").unwrap_or_else(|_| String::new());
    let private_key_4 = env::var("PRIVATE_KEY_4").unwrap_or_else(|_| String::new());
    let private_key_5 = env::var("PRIVATE_KEY_5").unwrap_or_else(|_| String::new());
    // let private_key_1 = env::var("PRIVATE_KEY_1").expect("");
    // let private_key_2 = env::var("PRIVATE_KEY_2").expect("");
    // let private_key_3 = env::var("PRIVATE_KEY_3").expect("");
    // let private_key_4 = env::var("PRIVATE_KEY_4").expect("");
    // let private_key_5 = env::var("PRIVATE_KEY_5").expect("");

    let list_of_private_keys = [
        private_key_1,
        private_key_2,
        private_key_3,
        private_key_4,
        private_key_5
    ];

    // 3. Fetch an array of StakingPool contract addresses from .env file
    let _contract_addresses_array = env::var("STAKING_POOL_ON_CELO_MAINNET_SINGLE_SC_CALL_AND_SINGLE_SC_ADDRESS_LIST").unwrap_or_default();
    println!("✅ contract_addresses_array: {:?}", _contract_addresses_array);

    let contract_addresses_array: Vec<Address> = _contract_addresses_array
        .trim_matches(|c| c == '[' || c == ']' || c == ' ')
        .split(',')
        .map(|s| s.trim_matches(|c| c == '"' || c == ' '))
        .filter(|s| !s.is_empty())
        .map(|s| s.parse().expect("Invalid address format"))
        .collect();

    println!("{:?}", contract_addresses_array);

    // @dev - for-loop of the 5 private keys + Call the checkpoint() function inside it.
    for c in 1..=12 {
        println!("🔄 Loop count (c): {}", c);
        for i in 1..=5 {
            let private_key = &list_of_private_keys[i - 1];

            // @dev - for-loop of the 12 SC address of StakingPool
            for contract_address in contract_addresses_array.iter() {
                let result = checkpoint(private_key, *contract_address).await;
                //let result = checkpoint(private_key.clone()).await;
                //let result = checkpoint(private_key.expect("")).await;
            }
        }
    }

    // @dev - Single call for testing -> [Result]: Successful
    //let result = checkpoint().await;
}

/**
 * @dev - Call the StakingPool#checkpoint() function on Celo Mainnet
 */
pub async fn checkpoint(_private_key: &String, _contract_address: Address) -> eyre::Result<()> {
    // 1. Fetch values from env
    dotenv().ok();  // Loads .env file
    //let rpc_url = "https://mainnet.base.org".parse()?;
    let rpc_url = env::var("CELO_MAINNET_RPC").expect("").parse()?;
    let private_key = _private_key;
    //let private_key = env::var("PRIVATE_KEY")?;
    let contract_address: Address = _contract_address;
    //let contract_address: Address = env::var("STAKING_POOL_ON_BASE_MAINNET").expect("").parse()?;
    println!("✅ rpc_url: {:?}", rpc_url);
    println!("✅ private_key: {:?}", private_key);
    println!("✅ contract_address: {:?}", contract_address);

    // 2. Start Anvil (local test network)
    //let anvil = Anvil::new().spawn();
    //println!("✅ Anvil running at: {}", anvil.endpoint());

    // Create a signer using one of Anvil's default private keys
    let signer: PrivateKeySigner = private_key.parse()?;
    
    // Create provider with wallet  
    let provider = ProviderBuilder::new()
        .with_gas_estimation()
        .network::<AnyNetwork>() // @dev - Use AnyNetwork for Celo Mainnet
        .wallet(signer)
        .connect_http(rpc_url);

    // 3. Deploy ZkJwtProofVerifier first using helper function
    //let zk_jwt_proof_verifier_address = deploy_zk_jwt_proof_verifier(&provider).await?;
    //let zk_jwt_proof_verifier = ZkJwtProofVerifier::new(zk_jwt_proof_verifier_address, &provider);

    // 4. Deploy StakingPool with HonkVerifier address as constructor parameter
    let staking_pool_json = std::fs::read_to_string("artifacts/0910/StakingPool.sol/StakingPool.json")?;
    let staking_pool_artifact: serde_json::Value = serde_json::from_str(&staking_pool_json)?;
    let bytecode_hex = staking_pool_artifact["bytecode"]["object"]
        .as_str()
        .ok_or_else(|| eyre::eyre!("Failed to get StakingPool bytecode"))?;

    // Append constructor parameter (HonkVerifier address) to bytecode
    //let mut deploy_bytecode = Bytes::from_hex(bytecode_hex)?.to_vec();
    //let mut constructor_arg = [0u8; 32];
    //constructor_arg[12..].copy_from_slice(zk_jwt_proof_verifier_address.as_slice());
    //zk_deploy_bytecode.extend_from_slice(&constructor_arg);

    //let deploy_tx = TransactionRequest::default().with_deploy_code(Bytes::from(deploy_bytecode));
    //let receipt = provider.send_transaction(deploy_tx).await?.get_receipt().await?;
    //let contract_address = receipt.contract_address.expect("StakingPool deployment failed");

    let staking_pool = StakingPool::new(contract_address, &provider);
    println!("✅ StakingPool contract address on Celo Mainnet: {:?}", contract_address);

    // 7. Call the StakingPool contract (expecting it to fail gracefully)
    println!("🔄 Calling the StakingPool#checkpoint() ...");
    let method_name: String = "checkpoint".to_string();
    let tx = staking_pool.checkpoint(method_name);
    println!("🔄 Result: {:?}", tx);

    // 8. Send the transaction and await receipt
    let tx_sent = tx.send().await?;
    let tx_receipt = tx_sent.get_receipt().await?;
    println!("✅ Transaction receipt: {:?}", tx_receipt);

    Ok(())
} 