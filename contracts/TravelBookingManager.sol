pragma solidity ^0.8.25;

// [TODO]: Integrate a ReClaim Protocol's verifier contract.
import { ReclaimProtocolVerifier } from "./reclaim-protocol/ReclaimProtocolVerifier.sol";

// [TODO]: Once the TravelBookingProofVerifier is implemented, uncomment the import statement below
//import { TravelBookingProofVerifier } from "./TravelBookingProofVerifier.sol";
import { DataType } from "./dataType/DataType.sol";

/**
 * @notice - The TravelBookingManager contract
 * @dev - The TravelBookingManager contract
 */
contract TravelBookingManager {
    using DataType for DataType.PublicInput;

    // [TODO]: Integrate a ReClaim Protocol's verifier contract.
    ReclaimProtocolVerifier public reclaimProtocolVerifier;

    // [TODO]: Once the TravelBookingProofVerifier is implemented, uncomment the import statement below
    //TravelBookingProofVerifier public travelBookingProofVerifier;

    mapping(address => bool) public bookers;
    mapping(address => bool) public propertyOwners;
    mapping(address => bool) public OTAs; // @dev - Online Travel Agencies
    mapping(address => mapping(uint256 => bool)) public bookedRooms;
    mapping(uint256 roomId => address booker) public bookerOfRooms;
    mapping(uint256 roomId => bool isListed) public listedRoomes;
    mapping(uint256 => uint256) public roomPrices; // @dev - Room prices for each room ID
    mapping(address => uint256) public lockedAmounts; // @dev - Locked amounts for the booking to be escrowed.

    mapping(bytes32 hash => bool isNullified) public nullifiers;

    mapping(address => mapping(uint256 => string)) public checkpoints;
    mapping(address caller => uint256 count) public checkpointCounts;

    string public version;

    // [TODO]: Once the TravelBookingProofVerifier is implemented, uncomment the constructor below
    constructor() {
    //constructor(TravelBookingProofVerifier _travelBookingProofVerifier) {
        //travelBookingProofVerifier = _travelBookingProofVerifier;
        version = "0.70.100";
    }

    /**
     * @notice - Once the proof is confirmed as a valid proof, the payment for booking a room will be escrowed to the travel agency or service provider.
     */
    function escrowBookingPayment(bytes calldata proof, bytes32[] calldata publicInputs, uint256 roomId) public returns (bool) {
        // Verify a travel booking proof
        bool isValidTravelBookingProof = true; // [TODO]: Replace with actual verification logic below (= travelBookingProofVerifier#verifyTravelBookingProof())
        //bool isValidTravelBookingProof = travelBookingProofVerifier.verifyTravelBookingProof(proof, publicInputs);
        require(isValidTravelBookingProof, "Travel Booking Proof is not valid");

        // @dev - [TODO]: Once the proof is confirmed as a valid proof, the payment will be escrowed to the travel agency or service provider.
        bool isPaymentEscrowed = true; // [TODO]: Replace with actual payment escrow logic

        // @dev - Book a room
        address booker = bookerOfRooms[roomId];
        uint256 roomPrice = roomPrices[roomId];
        lockedAmounts[booker] -= roomPrice; // @dev - booking amount
        payable(msg.sender).call{value: roomPrice}(""); // @dev - Lock the booking amount in the contract

        checkpoints[msg.sender][block.timestamp] = "escrowBookingPayment";
    }

    function bookBooking(uint256 roomId) public payable returns (bool) {
        require(bookers[msg.sender] == true || OTAs[msg.sender] == true, "You must be registered as a booker or an OTA");
        checkpoints[msg.sender][block.timestamp] = "bookBooking";
        bookedRooms[msg.sender][roomId] = true;
        bookerOfRooms[roomId] = msg.sender;

        // @dev - Book a room
        uint256 roomPrice = roomPrices[roomId];
        lockedAmounts[msg.sender] += roomPrice; // @dev - booking amount

        // @dev - Lock a booking amount
        bool success;
        (success, ) = address(this).call{value: msg.value}(""); // @dev - Lock the booking amount in the contract
        require(success, "Failed to lock a booking amount");
        return true;
    }

    function cancelBooking(uint256 roomId) public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "cancelBooking";
        require(bookedRooms[msg.sender][roomId], "Room is not booked");
        bookedRooms[msg.sender][roomId] = false;
        bookerOfRooms[roomId] = address(0);

        // @dev - Retrieve a room price
        uint256 roomPrice = roomPrices[roomId];

        // @dev - Unlock a booking amount
        bool success;
        (success, ) = msg.sender.call{value: roomPrice}(""); // @dev - Unlock the booking amount in the contract
        require(success, "Failed to unlock a booking amount");
        return true;
    }

    function listAvailableRooms(uint256 roomId, uint256 roomPrice) public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "listAvailableRooms";
        require(propertyOwners[msg.sender] == true, "Only property owners can list rooms");
        listedRoomes[roomId] = true;
        roomPrices[roomId] = roomPrice; // @dev - Set the price for the room
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

    function registerAsPropertyOwner() public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "registerAsPropertyOwner";
        require(!propertyOwners[msg.sender], "Property Owner already exists");
        propertyOwners[msg.sender] = true;
        return true;
    }

    function unregisterAsPropertyOwner() public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "unregisterAsPropertyOwner";
        require(propertyOwners[msg.sender], "Property Owner does not exist");
        propertyOwners[msg.sender] = false;
        return true;
    }

    // @dev - The OTA (Online Travel Agencies) registry / unregistry
    function registerAsOTA() public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "registerAsOTA";
        require(!OTAs[msg.sender], "OTA already exists");
        OTAs[msg.sender] = true;
        return true;
    }

    function unregisterAsOTA() public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "unregisterAsOTA";
        require(OTAs[msg.sender], "OTA does not exist");
        OTAs[msg.sender] = false;
        return true;
    }

    /**
     * @notice - checkpoint function
     */
    function checkpoint(string memory methodName) public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = methodName;
        checkpoints[msg.sender][block.timestamp] = "checkpoint";
        checkpointCounts[msg.sender]++;
        return true;
    }

    function testFunctionForCheckPoint() public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "testFunctionForCheckPoint";
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


    function addToSixtTwo(string memory methodName) public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "addToSixtyTwo";
        checkpointCounts[msg.sender]++;
        return true;
    }


}
