# ZK Travel History in Noir

## Verify a travel history of a traveler
- `TravelHistoryManager.sol` can be customized by each authority (i.e. A border control of each country)




<br>

## Script /w NoirJS to generate a recursive proof

- Running the script file of the `recursiveProofGeneration.ts` (via the `Hardhat` script)
```bash
cd script/travel-history/electroneum-testnet/recursive-proof_hardhat/scripts/recursive-proof-generation

sh runningRecursiveProofGeneration.sh
```

<br>

<hr>


# Installations

## Installation - Smart contract
- Install libraries
  (NOTE: Before this installation, all folders should be removed under the ./lib directory)
```shell
forge install OpenZeppelin/openzeppelin-contracts
forge install 0xnonso/foundry-noir-helper
```

<br>

## ZK circuit - Generate (Prove) an Ultraplonk proof in Noir

- 1/ Move to the `./circuits` directory:
```shell
cd circuits
```

- 2/ Create the `Prover.toml` file by coping the example file (`Prover.example.toml`) in the `./circuits` directory.
```shell
cp Prover.example.toml Prover.toml
```

- 3/ Write the `input data` should be written in the `Prover.toml`.
  - [NOTE]: `"Boolean"` type data should be written in a string number (True: `"0"` / False: `"1"`).
```toml
return = ""
x = ""
y = ""
```


- 2/ Run the `build.sh` to run ZK circuit
```shell
sh build.sh
```

- 3/ The UltraVerifier contract (`contract.sol`) and `proof` and `vk` in Noir would be generated under the `./circuits/target`.


<br>

## ZK circuit - Test
- Run the `circuit_test.sh` to test the ZK circuit. 
```shell
cd circuits
sh circuit_test.sh
```

<br>

## Smart Contract - Compile

- Compile the smart contracts
```shell
sh ./buildContract.sh
```

<br>

## Smart Contract - Script on Sonic Testnet / Electroneum Testnet

- Run the script of the `Starter.s.sol`, which is the test file of the `Starter.sol` on Sonic Testnet.
```shell
sh ./script/starter-script.sh
```

<br>

- Run the script of the `Starter.s.sol`, which is the test file of the `Starter.sol` on Electroneum Testnet.
```shell
sh ./script/electroneum-testnet/starter-script.sh
```

<br>

- Run the script of the `Verify.s.sol`, which is the test file of the `UltraVerifier.sol` on Sonic Testnet.
```shell
sh ./script/verify-script.sh
```

<br>

- Run the script of the `Verify.s.sol`, which is the test file of the `UltraVerifier.sol` on Electroneum Testnet.
```shell
sh ./script/electroneum-testnet/verify-script.sh
```

<br>

## Smart Contract - Test on Local Network / Electroneum Testnet

- Run the test of the `TravelHistoryProofVerifier.t.sol`, which is the test file of the `TravelHistoryProofVerifier.sol` on Local Network.
```shell
sh ./test/runningTest_TravelHistoryProofVerifier.sh
```

<br>

- Run the test of the `TravelHistoryProofVerifierOnElectroneumTestnet.t.sol`, which is the test file of the `TravelHistoryProofVerifier.sol` on Electroneum Testnet.
```shell
sh ./test/electroneum-testnet/runningTest_TravelHistoryProofVerifierOnElectroneumTestnet.sh
```



<br>



<br>

## Smart Contract - Deployment (on `Electroneum Testnet`)

- NOTE: Each Smart Contract has been deployed on `Electroneum Testnet`. See the `"Deployed-smart contracts onSonic Testnet"` paragraph above in this README.

- 1/ Create the `.env` file by coping the example file (`.env.example`) in the root directory.
  - Then, you should add a private key of your deployer address to the `ELECTRONEUM_TESTNET_PRIVATE_KEY`.
```shell
cp .env.example .env
```

- 2/ Deploy all contracts on `Electroneum Testnet` by running the `script/electroneum-testnet/deployment/DeploymentAllContracts.s.sol` 
```bash
sh ./script/electroneum-testnet/deployment/deployment-on-electroneum-testnet.sh
```
Or, directly executing the following command:
```bash
# [NOTE]: Execute the following at the root directory.

forge script script/electroneum-testnet/deployment/DeploymentAllContracts.s.sol --broadcast --private-key ${ELECTRONEUM_TESTNET_PRIVATE_KEY} \
    ./circuits/target/contract.sol:UltraVerifier \
    ./TravelHistoryProofVerifier.sol:TravelHistoryProofVerifier \
    ./TravelHistoryManager.sol:TravelHistoryManager --skip-simulation --legacy

# [NOTE - Adding the "--legacy" option]: Due to this error - Error: Failed to estimate EIP1559 fees. This chain might not support EIP1559, try adding --legacy to your command.
```

<br>


## References and Resources

- Noir:
  - Doc: https://noir-lang.org/docs/getting_started/quick_start
  - `noir-starter` (for Foundry): https://github.com/AztecProtocol/noir-starter/tree/main/with-foundry


- Electroneum: 
  - Block Explorer (on Electroneum Testnet): https://blockexplorer.thesecurityteam.rocks
  - Doc (icl. RPC, etc): https://developer.electroneum.com/electroneum-stack/metamask
  - Fancet: https://faucet.electroneum.com/
