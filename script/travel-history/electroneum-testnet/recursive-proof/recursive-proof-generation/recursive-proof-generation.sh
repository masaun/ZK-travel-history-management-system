#!/bin/bash
# if [ "$#" -ne 1 ]
# then
#   echo "Usage: ./recursive-proof-generation.sh"
#   exit 1
# fi

echo "Run the ./recursive-proof-generation.ts on localhost network"
npx hardhat run --network localhost recursiveProofGeneration.ts
#node ./recursiveProofGeneration.ts

