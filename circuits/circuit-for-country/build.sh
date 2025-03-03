echo "Compiling circuit..."
nargo compile
if [ $? -ne 0 ]; then
  exit 1
fi

echo "Generate witness..."
nargo execute

echo "Proving and generating a ZK Proof..."
bb prove -b ./target/traveled_country.json -w ./target/traveled_country.gz -o ./target/traveled_country_proof.bin

echo "Generating vkey..."
bb write_vk -b ./target/traveled_country.json -o ./target/traveled_country_vk.bin

echo "Link vkey to the zkProof"
bb verify -k ./target/traveled_country_vk.bin -p ./target/traveled_country_proof.bin

echo "Check a zkProof"
head -c 32 ./target/traveled_country_proof.bin | od -An -v -t x1 | tr -d $' \n'

echo "Copy and paste vk for generating a Solidity Verifier contract"
cp ./target/traveled_country_vk.bin ./target/vk

echo "Generate a Solidity Verifier contract"
bb contract

echo "Done"