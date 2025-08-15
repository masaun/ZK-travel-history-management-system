pragma solidity ^0.8.25;

// [TODO]: Once the TravelBookingProofVerifier is implemented, uncomment the import statement below
//import { TravelBookingProofVerifier } from "./TravelBookingProofVerifier.sol";
import { DataType } from "./dataType/DataType.sol";

/**
 * @notice - The TravelBookingManager contract
 * @dev - The TravelBookingManager contract
 */
contract TravelBookingManager {
    using DataType for DataType.PublicInput;

    // [TODO]: Once the TravelBookingProofVerifier is implemented, uncomment the import statement below
    //TravelBookingProofVerifier public travelBookingProofVerifier;

    mapping(address => bool) public bookers;
    mapping(address => mapping(uint256 => bool)) public bookedRooms;
    mapping(address => uint256) public lockedAmounts; // @dev - Locked amounts for the booking to be escrowed.

    mapping(bytes32 hash => bool isNullified) public nullifiers;

    mapping(address => mapping(uint256 => string)) public checkpoints;

    string public version;

    // [TODO]: Once the TravelBookingProofVerifier is implemented, uncomment the constructor below
    constructor() {
    //constructor(TravelBookingProofVerifier _travelBookingProofVerifier) {
        //travelBookingProofVerifier = _travelBookingProofVerifier;
        version = "0.2.8";
    }

    /**
     * @notice - Once the proof is confirmed as a valid proof, the payment for booking a room will be escrowed to the travel agency or service provider.
     */
    function escrowBookingPayment(bytes calldata proof, bytes32[] calldata publicInputs) public returns (bool) {
        // Verify a travel booking proof
        bool isValidTravelBookingProof = true; // [TODO]: Replace with actual verification logic below (= travelBookingProofVerifier#verifyTravelBookingProof())
        //bool isValidTravelBookingProof = travelBookingProofVerifier.verifyTravelBookingProof(proof, publicInputs);
        require(isValidTravelBookingProof, "Travel Booking Proof is not valid");

        // @dev - [TODO]: Once the proof is confirmed as a valid proof, the payment will be escrowed to the travel agency or service provider.
        bool isPaymentEscrowed = true; // [TODO]: Replace with actual payment escrow logic

        checkpoints[msg.sender][block.timestamp] = "escrowBookingPayment";
    }

    function bookBooking(uint256 roomId) public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "bookBooking";
        bookedRooms[msg.sender][roomId] = true;

        // @dev - [TODO]: Implement the logic to book a room
        return true;
    }

    function cancelBooking(uint256 roomId) public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "cancelBooking";
        require(bookedRooms[msg.sender][roomId], "Room is not booked");
        bookedRooms[msg.sender][roomId] = false;
        // @dev - [TODO]: Implement the logic to cancel a booking
        return true;
    }

    function isBooked(address booker, uint256 roomId) public view returns (bool) {
        return bookedRooms[booker][roomId];
    }

    function isBooker(address booker) public view returns (bool) {
        return bookers[booker];
    }

    function registerAsBooker() public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "registerAsBooker";
        require(!bookers[msg.sender], "Booker already exists");
        bookers[msg.sender] = true;
        return true;
    }

    function unregisterAsBooker() public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "unregisterAsBooker";
        require(bookers[msg.sender], "Booker does not exist");
        bookers[msg.sender] = false;
        return true;
    }

    /**
     * @notice - checkpoint function
     */
    function checkpoint(string memory methodName) public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = methodName;
        return true;
    }

    function testFunction() public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "testFunction";
        return true;
    }

    /**
     * @notice - Receive function to accept Ether transfers
     */
    receive() external payable {
        require(msg.value > 0, "Must send some Ether");
        lockedAmounts[msg.sender] += msg.value;
        // (bool success, ) = msg.sender.call{value: msg.value}("");
        // require(success, "Transfering back failed");
        checkpoints[msg.sender][block.timestamp] = "receive";
    }

    /**
     * @notice - Fallback function
     */
    fallback() external payable {
        require(msg.value > 0, "Must send some Ether");
        lockedAmounts[msg.sender] += msg.value;
        // (bool success, ) = msg.sender.call{value: msg.value}("");
        // require(success, "Transfering back failed");
        checkpoints[msg.sender][block.timestamp] = "fallback";
    }
}
