#!/bin/bash
# if [ "$#" -ne 1 ]
# then
#   echo "Usage: ./recursive-proof-generation.sh"
#   exit 1
# fi

echo "Run the recursiveProofGeneration.ts"
npx hardhat run scripts/recursive-proof-generation/recursiveProofGeneration.ts
#npx hardhat run --network localhost recursiveProofGeneration.ts


