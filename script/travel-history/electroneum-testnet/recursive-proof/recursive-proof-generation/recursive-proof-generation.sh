#!/bin/bash
if [ "$#" -ne 1 ]
then
  echo "Usage: ./recursive-proof-generation.sh"
  exit 1
fi

echo "Run the ./recursive-proof-generation.ts"
node ./recursiveProofGeneration.ts

# cp ./circuits/Nargo.toml /tmp/$1/Nargo.toml
# cp ./circuits/Verifier.toml /tmp/$1/Verifier.toml
# cp -r ./circuits/src /tmp/$1/
# echo "" > /tmp/$1/Prover.toml && echo "File created"