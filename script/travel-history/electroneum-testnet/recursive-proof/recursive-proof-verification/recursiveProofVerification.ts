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

circuits = {
    main: await getCircuit('main'),
    recursive: await getCircuit('recursion'),
};

backends = {
    main: new BarretenbergBackend(circuits.main, { threads: 8 }),
    recursive: new BarretenbergBackend(circuits.recursive, { threads: 8 }),
};

noirs = {
    main: new Noir(circuits.main, backends.main),
    recursive: new Noir(circuits.recursive, backends.recursive),
};

describe('Proof verification', async () => {
    let verifierContract: any;

    before(async () => {
      verifierContract = await viem.deployContract('UltraVerifier');
    });

    it('Should verify off-chain', async () => {
      const verified = await noirs.recursive.verifyProof(finalProof);
      expect(verified).to.be.true;
    });

    it('Should verify on-chain', async () => {
      const verified = await verifierContract.read.verify(
        bytesToHex(finalProof.proof),
        finalProof.publicInputs,
      );
      expect(verified).to.be.true;
    });
  });