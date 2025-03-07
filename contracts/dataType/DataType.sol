pragma solidity ^0.8.25;

library DataType {

    struct PublicInput {
        bytes32 root;
        bytes32 country_code;
        bytes32 enter_date;
        bytes32 exit_date;
        bytes32 nullifierHash;
    }

}