#!/bin/bash
# if [ "$#" -ne 1 ]
# then
#   echo "Usage: ./recursive-proof-generation.sh"
#   exit 1
# fi

echo "Run the ./recursive-proof-generation.ts on localhost network"
npx hardhat --network localhost run recursiveProofGeneration.ts
#node ./recursiveProofGeneration.ts

