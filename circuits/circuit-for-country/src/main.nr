use dep::std;
mod tests; // tests/mod.nr

//#[recursive]
fn main(
    root: pub Field,   // @dev - Merkle Root
    hash_path: [Field; 2],
    index: Field,
    secret: Field,
    country_code: pub Field // @dev - i.e). If a country that a traveler visit is USA, its country code is "1" (by removing "+" from "+1"). If the country is "Dominican Republic" (+1-809), its country code is "1809".
) -> pub Field {
    let note_commitment = std::hash::pedersen_hash([secret]);
    let nullifier = std::hash::pedersen_hash([root, secret, country_code]);

    // Constraint: root == check_root
    let check_root = std::merkle::compute_merkle_root(note_commitment, index, hash_path);
    assert(root == check_root);

    // Constraint: 
    //assert(country_code > 2000, "Invalid country code");

    nullifier // @dev - Return the nullifier -> Then, it will be stored on-chain so that it can be used to prevent double-spending.
}