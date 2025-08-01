# ZK Travel History Management System

## Tech Stack
- `ZK circuit`: Written in [`Noir`](https://noir-lang.org/docs/) powered by [Aztec](https://aztec.network/)) 
- Smart Contract: Written in Solidity (Framework: Foundry)
- Blockchain: [`Electroneum`](https://developer.electroneum.com/) (Testnet)

<br>

## Overview

- In the international travel scean, an international traveler would submit and show their passport at the border control at the airport in order for a border protection officer to be able to check their travel history and so on. 
  - At this point, the border protection officer would require the international traveler to submit and show their passport.
    (At this point, If an interanational traveler had stayed in certain countries for a long time beyond the days limit of that these international traveler can stay the country, the border protection officer may refuse that the international traveler enter their country)

  - However, some of information-written in the passport may not be needed for the border protection officer to check the international traveler's travel history and so on.

<br>

- This project ("ZK Travel History Management System") can solve this problem by using combination of the `ZK` (`Zero-Knowledge`) circuit and the Smart Contract on Blockchain. 
  - 1/ Everytime an international traveler would depart from an airport in abroad, the international traveler would generate a `travel history ZK proof`, which includes information of a `country` they stayed and an `enter/exit date` of the country, via the ZK circuit.

  - 2/ When an international traveler would arrived at an airport in abroad and come to the checkpoint of the border control, the international traveler would submit the `travel history ZK proof`, which was generated when the step 1/, to the `TravelHistoryManager` contract (`TravelHistoryManager.sol`) - instead of submitting their passport to the border protection officer.

  - 3/ The border protection officer can validate whether or not the travel history of the international traveler has no problem `without seeing` all data from the passport. Also, the international traveler can efficiently be approved `without revealing` all data by submitting the passport.

<br>

- The `TravelHistoryManager` contract (`TravelHistoryManager.sol`) is supposed to be deployed by the border protection/control authority of each country.
  - Since the requirement of the travel history is different depends on country, a border protection/control authority of an country is supposed to modify the validation in the `TravelHistoryManager` contract and deploy it on blockchain (`Electroneum Testnet`).

  - i.e). In the example `TravelHistoryManager` contract (`TravelHistoryManager.sol`) deployed on `Electroneum Testnet`, the validation to check whether or not an international traveler stay in the Schengen Area beyond `90 days limit`.

- NOTE:
  - This project would focus on a `travel history`. In the future, other items should be added.
  - In this project, the [`Electroneum` Testnet](https://developer.electroneum.com/electroneum-stack/metamask) would be used as a blockchain where the Smart Contracts for this project are deployed.

<br>

## Demo Video

- https://youtu.be/qBIm-d0m_LY?si=mHVC4JvtmZgZUPjP

<br>

## Deployed-smart contracts on [`Electroneum` Testnet](https://developer.electroneum.com/electroneum-stack/metamask)

| Contract Name | Descripttion | Deployed-contract addresses on Electroneum Testnet |
| ------------- |:-------------:| -----:|
| UltraVerifier | The UltraPlonk Verifer contract (`./circuits/target/contract.sol`), which is generated based on ZK circuit in Noir (`./circuits/src/main.nr`). FYI: To generated this contract, the way of the [Noir's Solidity Verifier generation](https://noir-lang.org/docs/how_to/how-to-solidity-verifier) was used. | [0x0A95E7Fc5c292eCe47893E63A1380f08a061814A](https://blockexplorer.thesecurityteam.rocks/address/0x0A95E7Fc5c292eCe47893E63A1380f08a061814A) |
| TravelHistoryProofVerifier | The smart contract that enable to validate whether or not a proof-submitted is valid. | [0xE82595069b66064345f8EeB162e3c4e2F4cED704](https://blockexplorer.thesecurityteam.rocks/address/0xE82595069b66064345f8EeB162e3c4e2F4cED704) |
| TravelHistoryManager | The example smart contract that enable to validate whether or not a travel history proof-submitted is valid and validate whether or not the traveler breach the days limit of staying a country | [0xED169AF4E8d68d167B8c7bf66f241f30B8cA8083](https://blockexplorer.thesecurityteam.rocks/address/0xED169AF4E8d68d167B8c7bf66f241f30B8cA8083) |

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

## ZK circuit - Generate (Prove) an Ultraplonk proof in [`Noir`](https://noir-lang.org/docs/)

- 1/ Move to the `./circuits` directory:
```shell
cd circuits
```

- 2/ Create the `Prover.toml` file by coping the example file (`Prover.example.toml`) in the `./circuits` directory.
```shell
cp Prover.example.toml Prover.toml
```

- 3/ Write the `input data` should be written in the `Prover.toml`.


- 4/ Run the `build.sh` to run ZK circuit
```shell
sh build.sh
```

- 5/ The UltraVerifier contract (`contract.sol`) and `proof` and `vk` in Noir would be generated under the `./circuits/target`.


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

## Smart Contract - Script on `Electroneum Testnet`

- Run the script of the `TravelHistoryProofVerifier.s.sol`, which is the test file of the `TravelHistoryProofVerifier.sol` on Electroneum Testnet.
```shell
sh ./script/electroneum-testnet/runningScript_TravelHistoryProofVerifier.sh
```

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
sh ./scripts/electroneum-testnet/deployment/deployment-on-electroneum-testnet.sh
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

## Smart Contract - Deployment (on `Base Sepolia Testnet`)

- 1/ Create the `.env` file by coping the example file (`.env.example`) in the root directory.
  - Then, you should add a private key of your deployer address to the `BASE_TESTNET_PRIVATE_KEY`.
```shell
cp .env.example .env
```

- 2/ Deploy all contracts on `Base Sepolia Testnet` by running the `script/base-testnet/deployment/DeploymentAllContracts.s.sol` 
```bash
sh ./scripts/base-testnet/deployment/deployment-on-base-testnet.sh
```

<br>

## Smart Contract - Deployment (on `Base Mainnet`)

- Run the `DeploymentForHonkVerifier_basescan.s.sol` to deploy the  `HonkVerifier` contract on BASE mainnet:
  - NOTE: The smart contract is verified via the `BaseScan` of BASE Mainnet (https://basescan.io))
```bash
sh ./scripts/base-mainnet/deployment/deploymentScript_HonkVerifier_via_basescan.sh
```

<br>

- Run the `DeploymentForTravelHistoryProofVerifier_basescan.s.sol` to deploy the  `TravelHistoryProofVerifier` contract on BASE mainnet:
  - NOTE: The smart contract is verified via the `BaseScan` of BASE Mainnet (https://basescan.io)
```bash
sh ./scripts/base-mainnet/deployment/deploymentScript_TravelHistoryProofVerifier_via_basescan.sh
```

<br>

- Run the `DeploymentForTravelHistoryManager_basescan.s.sol` to deploy the  `TravelHistoryManager` contract on BASE mainnet:
  - NOTE: The smart contract is verified via the `BaseScan` of BASE Mainnet (https://basescan.io)
```bash
sh ./scripts/base-mainnet/deployment/deploymentScript_TravelHistoryManager_via_basescan.sh
```


<br>

## Deployment on Celo mainnet (`Each SC`)

- Run the `DeploymentForHonkVerifier_celoscan.s.sol` to deploy the  `HonkVerifier` contract on BASE mainnet:
  - NOTE: The smart contract is verified via the `CeloScan` of Celo Mainnet (https://celoscan.io)
```bash
sh ./scripts/celo-mainnet/deployment/deploymentScript_HonkVerifier_via_celoscan.sh
```

<br>

- Run the `DeploymentForTravelHistoryProofVerifier_celoscan.s.sol` to deploy the  `TravelHistoryProofVerifier` contract on BASE mainnet:
  - NOTE: The smart contract is verified via the `CeloScan` of Celo Mainnet (https://celoscan.io)
```bash
sh ./scripts/celo-mainnet/deployment/deploymentScript_TravelHistoryProofVerifier_via_celoscan.sh
```

<br>

- Run the `DeploymentForTravelHistoryManager_celoscan.s.sol` to deploy the  `TravelHistoryManager` contract on BASE mainnet:
  - NOTE: The smart contract is verified via the `CeloScan` of Celo Mainnet (https://celoscan.io)
```bash
sh ./scripts/celo-mainnet/deployment/deploymentScript_TravelHistoryManager_via_celoscan.sh
```

<br>

## Smart Contract - Deployment (on `Celo Alfajores Testnet`)

- 1/ Create the `.env` file by coping the example file (`.env.example`) in the root directory.
  - Then, you should add a private key of your deployer address to the `CELO_TESTNET_PRIVATE_KEY`.
```shell
cp .env.example .env
```

- 2/ Deploy all contracts on `Celo Sepolia Testnet` by running the `script/celo-testnet/deployment/DeploymentAllContracts.s.sol` 
```bash
sh ./script/celo-testnet/deployment/deployment-on-celo-testnet.sh
```

<br>

## Smart Contract - Verification on BASE mainnet (`Each SC`)
- Run for verifying the  `All` contract on BASE mainnet:
  - NOTE: The smart contract is verified in `BlockScout` of BASE Mainnet (https://base.blockscout.com)
```bash
sh ./scripts/base-mainnet/verification/verificationScript_AllContracts_via_blockscout.sh
```

<br>

## Smart Contract - Verification on Celo mainnet (`Each SC`)
- Run for verifying the  `All` contract on Celo mainnet:
  - NOTE: The smart contract is verified in `BlockScout` of Celo Mainnet (https://celo.blockscout.com)
```bash
sh ./scripts/celo-mainnet/verification/verificationScript_AllContracts_via_blockscout.sh
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
