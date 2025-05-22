#####################################################################################################################
# @notice - This script is new version of Noir's script. Please see more details from Noir's official documentation #
#####################################################################################################################

echo "Compiling circuit..."
nargo compile
if [ $? -ne 0 ]; then
  exit 1
fi

echo "Generate witness..."
nargo execute

echo "Proving and generating a zkProof..."
bb prove -b ./target/travel_history.json -w ./target/travel_history.gz -o ./target
#bb prove -b ./target/travel_history.json -w ./target/travel_history.gz -o ./target/travel_history_proof.bin

echo "Copy a zkProof-generated and paste it as a travel_history_proof.bin"
cp ./target/proof ./target/travel_history_proof.bin

echo "Generating vkey..."
# Generate the verification key. You need to pass the `--oracle_hash keccak` flag when generating vkey and proving
# to instruct bb to use keccak as the hash function, which is more optimal in Solidity
bb write_vk -b ./target/travel_history.json -o ./target --oracle_hash keccak
#bb write_vk -b ./target/travel_history.json -o ./target/travel_history_vk.bin

echo "Copy a vkey-generated and paste it as a travel_history_vk.bin"
cp ./target/vk ./target/travel_history_vk.bin

echo "Link vkey to the zkProof"
bb verify -k ./target/travel_history_vk.bin -p ./target/travel_history_proof.bin

echo "Check a zkProof"
head -c 32 ./target/travel_history_proof.bin | od -An -v -t x1 | tr -d $' \n'

#echo "Copy and paste vk for generating a Solidity Verifier contract"
#cp ./target/travel_history_vk.bin ./target/vk

echo "Generate a Solidity Verifier contract from the vkey..."
bb write_solidity_verifier -k ./target/vk -o ./target/Verifier.sol
#bb contract

echo "Copy a Solidity Verifier contract-generated (Verifier.sol) into the ./contracts/circuit/ultra-verifier directory"
#echo "Copy a Solidity Verifier contract-generated into the ./contracts/circuit/ultra-verifier directory"
cp ./target/Verifier.sol ../contracts/circuit/ultra-verifier
#cp ./target/contract.sol ../contracts/circuit/ultra-verifier

echo "Rename the Verifier.sol with the plonk_vk.sol in the ./contracts/circuit/ultra-verifier directory"
#echo "Rename the contract.sol with the plonk_vk.sol in the ./contracts/circuit/ultra-verifier directory"
mv ../contracts/circuit/ultra-verifier/Verifier.sol ../contracts/circuit/ultra-verifier/plonk_vk.sol
#mv ../contracts/circuit/ultra-verifier/contract.sol ../contracts/circuit/ultra-verifier/plonk_vk.sol

echo "Done"