//mod test_inputs; // test_inputs.nr

mod tests {
    use crate::main; // src/main.nr
    //use crate::MAX_DATA_LENGTH;

    #[test]
    fn test_verifier() {
        let root: Field = 0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629;   // @dev - Merkle Root
        let hash_path: [Field; 2] = [0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8, 0x2a653551d87767c545a2a11b29f0581a392b4e177a87c8e3eb425c51a26a8c77];
        let index: Field = 0;
        let secret: Field = 1;
        //let name: Field,           // @dev - Name of the traveler
        let passport_number: Field = 13003286;  // @dev - Passport number of the traveler
        let country_code: u64 = 1;   // @dev - i.e). If a country that a traveler visit is USA, its country code is "1" (by removing "+" from "+1"). If the country is "Dominican Republic" (+1-809), its country code is "1809".
        let enter_date: u64 = 1614556800;        // @dev - UNIX timestamp
        let exit_date: u64 = 1615636700;  

        let nullifier = main(
            root,
            hash_path,
            index,
            secret,
            //name,
            passport_number,
            country_code,
            enter_date,
            exit_date,
        );

        let note_commitment = std::hash::pedersen_hash([secret]);
        let _nullifier = std::hash::pedersen_hash([root, secret, root, secret]);

        // Constraint check
        assert(nullifier == _nullifier, "Invalid nullifier");

        println(nullifier);
        println("The test of the est_verifier() has been successful");
    }
}