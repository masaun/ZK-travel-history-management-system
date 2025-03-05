echo "Compiling circuit..."
nargo compile
if [ $? -ne 0 ]; then
  exit 1
fi

echo "Generate witness..."
nargo execute

echo "Proving and generating a ZK Proof..."
bb prove -b ./target/travel_history_recursion.json -w ./target/travel_history_recursion.gz -o ./target/travel_history_recursion_proof.bin

echo "Generating vkey..."
bb write_vk -b ./target/travel_history_recursion.json -o ./target/travel_history_recursion_vk.bin

echo "Link vkey to the zkProof"
bb verify -k ./target/travel_history_recursion_vk.bin -p ./target/travel_history_recursion_proof.bin

echo "Check a zkProof"
head -c 32 ./target/travel_history_recursion_proof.bin | od -An -v -t x1 | tr -d $' \n'

echo "Copy and paste vk for generating a Solidity Verifier contract"
cp ./target/travel_history_recursion_vk.bin ./target/vk

echo "Generate a Solidity Verifier contract"
bb contract

echo "Done"