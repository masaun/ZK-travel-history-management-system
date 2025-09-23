//SPDX-License-Identifier: MIT
pragma solidity >=0.8.23 <=0.8.28;

/// @title Semaphore contract interface.
interface ISemaphore {
    error Semaphore__GroupHasNoMembers();
    error Semaphore__MerkleTreeDepthIsNotSupported();
    error Semaphore__MerkleTreeRootIsExpired();
    error Semaphore__MerkleTreeRootIsNotPartOfTheGroup();
    error Semaphore__MismatchedGroupIdsAndNullifiersLength();
    error Semaphore__YouAreUsingTheSameNullifierTwice();
    error Semaphore__InvalidProof();

    /// It defines all the group parameters used by Semaphore.sol.
    struct Group {
        uint256 merkleTreeDuration;
        mapping(uint256 => uint256) merkleRootCreationDates;
        mapping(uint256 => bool) nullifiers;
    }

    /// It defines all the Semaphore proof parameters used by Semaphore.sol.
    struct SemaphoreNoirProof {
        uint256 merkleTreeDepth;
        uint256 merkleTreeRoot;
        uint256 nullifier;
        uint256 message;
        uint256 scope;
        bytes proofBytes;
    }

    /// It defines all the Semaphore proof parameters used by Semaphore.sol.
    /// @param nullifiers: nullfiers of all the child proofs batched in this proof
    /// @param merkleTreeRoots: merkleTreeRoots of all the child proofs batched in this proof
    /// @param scopes: scopes of all the child proofs batched in this proof
    /// @param messages: messages of all the child proofs batched in this proof
    /// @param publicInputs:  publicInputs of this proof, first element is the hashing of all the above
    /// @param proofBytes: proofBytes of this proof
    struct SemaphoreNoirBatchedProof {
        uint256[] nullifiers;
        uint256[] merkleTreeRoots;
        uint256[] scopes;
        uint256[] messages;
        bytes32[] publicInputs;
        bytes proofBytes;
    }

    /// @dev Event emitted when the Merkle tree duration of a group is updated.
    /// @param groupId: Id of the group.
    /// @param oldMerkleTreeDuration: Old Merkle tree duration of the group.
    /// @param newMerkleTreeDuration: New Merkle tree duration of the group.
    event GroupMerkleTreeDurationUpdated(
        uint256 indexed groupId,
        uint256 oldMerkleTreeDuration,
        uint256 newMerkleTreeDuration
    );

    /// @dev Event emitted when a Semaphore proof is validated.
    /// @param groupId: Id of the group.
    /// @param merkleTreeDepth: Depth of the Merkle tree.
    /// @param merkleTreeRoot: Root of the Merkle tree.
    /// @param nullifier: Nullifier.
    /// @param message: Semaphore message.
    /// @param scope: Scope.
    /// @param proof: Zero-knowledge proofs.
    event ProofValidated(
        uint256 indexed groupId,
        uint256 merkleTreeDepth,
        uint256 indexed merkleTreeRoot,
        uint256 nullifier,
        uint256 message,
        uint256 indexed scope,
        bytes proof
    );

    /// @dev Event emitted when a Batched Semaphore proof is validated.
    /// @param groupIds: Id of the group for each proof in a batch.
    /// @param nullifiers: Nullifier for each proof in a batch.
    /// @param messages: Semaphore message for each proof in a batch.
    /// @param scopes: Scope for each proof in a batch.
    /// @param publicInputHash: Hash of the public inputs.
    /// @param proof: Batched zero-knowledge proofs.
    event BatchedProofValidated(
        uint256[] groupIds,
        uint256[] nullifiers,
        uint256[] messages,
        uint256[] scopes,
        uint256 indexed publicInputHash,
        bytes proof
    );

    /// @dev Returns the current value of the group counter.
    /// @return The current group counter value.
    function groupCounter() external view returns (uint256);

    /// @dev See {SemaphoreGroups-_createGroup}.
    function createGroup() external returns (uint256);

    /// @dev See {SemaphoreGroups-_createGroup}.
    function createGroup(address admin) external returns (uint256);

    /// @dev It creates a group with a custom Merkle tree duration.
    /// @param admin: Admin of the group. It can be an Ethereum account or a smart contract.
    /// @param merkleTreeDuration: Merkle tree duration.
    /// @return Id of the group.
    function createGroup(address admin, uint256 merkleTreeDuration) external returns (uint256);

    /// @dev See {SemaphoreGroups-_updateGroupAdmin}.
    function updateGroupAdmin(uint256 groupId, address newAdmin) external;

    /// @dev See {SemaphoreGroups-_acceptGroupAdmin}.
    function acceptGroupAdmin(uint256 groupId) external;

    /// @dev Updates the group Merkle tree duration.
    /// @param groupId: Id of the group.
    /// @param newMerkleTreeDuration: New Merkle tree duration.
    function updateGroupMerkleTreeDuration(uint256 groupId, uint256 newMerkleTreeDuration) external;

    /// @dev See {SemaphoreGroups-_addMember}.
    function addMember(uint256 groupId, uint256 identityCommitment) external;

    /// @dev See {SemaphoreGroups-_addMembers}.
    function addMembers(uint256 groupId, uint256[] calldata identityCommitments) external;

    /// @dev See {SemaphoreGroups-_updateMember}.
    function updateMember(
        uint256 groupId,
        uint256 oldIdentityCommitment,
        uint256 newIdentityCommitment,
        uint256[] calldata merkleProofSiblings
    ) external;

    /// @dev See {SemaphoreGroups-_removeMember}.
    function removeMember(uint256 groupId, uint256 identityCommitment, uint256[] calldata merkleProofSiblings) external;

    /// @dev Saves the nullifier hash to prevent double signaling and emits an event
    /// if the zero-knowledge proof is valid.
    /// @param groupId: Id of the group.
    /// @param proof: Semaphore zero-knowledge proof.
    function validateProof(uint256 groupId, SemaphoreNoirProof calldata proof) external;

    /// @dev Verifies a zero-knowledge proof by returning true or false.
    /// @param groupId: Id of the group.
    /// @param proof: Semaphore zero-knowledge proof.
    function verifyProof(uint256 groupId, SemaphoreNoirProof calldata proof) external returns (bool);
}
