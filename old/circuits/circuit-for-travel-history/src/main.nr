use dep::std;
mod tests; // tests/mod.nr

/**
 * @notice - This function is used to verify the validity of the travel history.
 * @dev - A travel history should be a recursion proof. (See the details: https://noir-lang.org/docs/noir/standard_library/recursion )
 */
fn main(
    verification_key : [Field; 114], 
    proof : [Field; 93], 
    public_inputs : [Field; 1], 
    key_hash : Field, // @dev - vkHash
) {
    // Verify the travel proof
    std::verify_proof(
        verification_key, 
        proof, 
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