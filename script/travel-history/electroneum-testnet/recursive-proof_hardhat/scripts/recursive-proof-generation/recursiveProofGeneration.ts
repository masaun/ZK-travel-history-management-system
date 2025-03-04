import chai from 'chai';
const { expect } = chai;
import { Noir } from '@noir-lang/noir_js';
import { BarretenbergBackend } from '@noir-lang/backend_barretenberg';
import { BackendInstances, Circuits, Noirs } from '../utils/types.ts';
import hre from 'hardhat';
const { viem } = hre;
import { compile, createFileManager } from '@noir-lang/noir_wasm';
import { join, resolve } from 'path';
import { ProofData } from '@noir-lang/types';
import { bytesToHex } from 'viem';


let circuits: Circuits;
let backends: BackendInstances;
let noirs: Noirs;


/**
 * @notice - Get the compiled circuit
 */
async function getCircuit(name: string) {
    const basePath = resolve(join('../../../../../../circuits', name));
    //const basePath = resolve(join('../noir', name));
    const fm = createFileManager(basePath);
    const compiled = await compile(fm, basePath);
    if (!('program' in compiled)) {
        throw new Error('Compilation failed');
    }
    return compiled.program;
}


/**
 * @notice - Setup configuration
 */
async function setUp() {
    circuits = {
        //main: await getCircuit('main'),
        main: await getCircuit('circuit-for-country'),
        //recursive: await getCircuit('recursion'),
        recursive: await getCircuit('circuit-for-travel-history'),
    };
    console.log(`circuits: ${circuits}`);

    backends = {
        main: new BarretenbergBackend(circuits.main, { threads: 8 }),
        recursive: new BarretenbergBackend(circuits.recursive, { threads: 8 }),
    };

    noirs = {
        main: new Noir(circuits.main, backends.main),
        recursive: new Noir(circuits.recursive, backends.recursive),
    };
}


/**
 * @notice - Proof generation
 */
async function generateProof() {
    let recursiveInputs: any;
    let intermediateProof: ProofData;
    let finalProof: ProofData;

    //const mainInput = { x: 1, y: 2 };
    const mainInput = { 
        root: "0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629",
        hash_path: [
          "0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8",
          "0x2a653551d87767c545a2a11b29f0581a392b4e177a87c8e3eb425c51a26a8c77"
        ],
        index: "0",
        secret: "1",
        country_code: "1"
    };

    const { witness } = await noirs.main.execute(mainInput);
    intermediateProof = await backends.main.generateProof(witness);

    const { proof, publicInputs } = intermediateProof;
    console.log(`proof: ${proof}, publicInputs: ${publicInputs}`);
    //expect(proof instanceof Uint8Array).to.be.true;

    const verified = await backends.main.verifyProof({ proof, publicInputs });
    //expect(verified).to.be.true;

    const numPublicInputs = 1;
    const { proofAsFields, vkAsFields, vkHash } =
        await backends.main.generateRecursiveProofArtifacts(
            { publicInputs, proof },
            numPublicInputs,
        );
    console.log(`proofAsFields: ${proofAsFields}, vkAsFields: ${vkAsFields}, vkHash: ${vkHash}`);
    //expect(vkAsFields).to.be.of.length(114); /// @dev - Must be [Field, 114]
    //expect(vkHash).to.be.a('string');

    recursiveInputs = {
        verification_key: vkAsFields,
        proof: proofAsFields,
        public_inputs: [mainInput.country_code],
        key_hash: vkHash,
    };

    /// @dev - Generate a final proof with a recursive input
    finalProof = await noirs.recursive.generateProof(recursiveInputs);
    console.log(`finalProof.proof: ${finalProof.proof}`);
    //expect(finalProof.proof instanceof Uint8Array).to.be.true;
}

async function main() {
    await setUp();
    await generateProof();
}

main().catch((error) => {
  process.exitCode = 1;
});