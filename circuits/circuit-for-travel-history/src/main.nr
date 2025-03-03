use dep::std;
mod tests; // tests/mod.nr

/**
 * @notice - This function is used to verify the validity of the travel history.
 * @dev - A travel history should be a recursion proof. (See the details: https://noir-lang.org/docs/noir/standard_library/recursion )
 */
fn main(
    verification_key : [Field; 3], 
    proof_a : [Field; 3], 
    proof_b : [Field; 3], 
    public_inputs : [Field; 1], 
    key_hash : Field,
) {
    // Verify the travel proof "a"
    std::verify_proof(
        verification_key, 
        proof_a, 
        public_inputs, 
        key_hash
    );

    // Verify the travel proof "b"
    std::verify_proof(
        verification_key, 
        proof_b, 
        public_inputs, 
        key_hash
    );
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// Reference Implementation of a "Recursion Proof": https://noir-lang.org/docs/noir/standard_library/recursion
///////////////////////////////////////////////////////////////////////////////////////////////////

// fn main(
//     verification_key : [Field; 114],
//     proof : [Field; 93],
//     public_inputs : [Field; 1],
//     key_hash : Field,
//     proof_b : [Field; 93],
// ) {
//     std::verify_proof(
//         verification_key,
//         proof,
//         public_inputs,
//         key_hash
//     );

//     std::verify_proof(
//         verification_key,
//         proof_b,
//         public_inputs,
//         key_hash
//     );
// }