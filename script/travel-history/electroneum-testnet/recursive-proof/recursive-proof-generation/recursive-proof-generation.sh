#!/bin/bash
if [ "$#" -ne 1 ]
then
  echo "Usage: ./recursive-proof-generation.sh"
  exit 1
fi

echo "Run the ./recursive-proof-generation.ts"
node ./recursiveProofGeneration.ts
