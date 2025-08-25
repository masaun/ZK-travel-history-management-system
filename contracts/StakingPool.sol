pragma solidity ^0.8.25;

/**
 * @notice - The StakingPool contract
 */
contract StakingPool {
    mapping(address => mapping(uint256 => string)) public checkpoints;
    mapping(address caller => mapping(uint256 blockTimestamp => uint256 count)) public checkpointCounts;
    mapping(address => bool) public stakers;
    mapping(address => uint256) public stakedAmounts;

    string public version;

    constructor() {
        version = "0.2.22";
    }

    /**
     * @notice - Register as a staker
     */
    function registerAsStaker() public returns (bool) {
        require(!stakers[msg.sender], "You have already registered as a staker");
        stakers[msg.sender] = true;
        checkpoints[msg.sender][block.timestamp] = "registerAsStaker";
        return true;
    }

    function deregisterAsStaker() public returns (bool) {
        require(stakers[msg.sender], "You are not registered as a staker");
        stakers[msg.sender] = false;
        checkpoints[msg.sender][block.timestamp] = "deregisterAsStaker";
        return true;
    }

    /**
     * @notice - stake a given amount of a native token into the staking pool
     */
    function stakeNativeTokenIntoStakingPool() public payable returns (bool) {
        require(msg.value > 0, "Amount must be greater than 0");
        require(msg.sender.balance >= msg.value, "Insufficient balance to stake");
        stakedAmounts[msg.sender] = msg.value;
        (bool success, ) = address(this).call{value: msg.value}("");
        require(success, "Stake failed");
        checkpoints[msg.sender][block.timestamp] = "stakeNativeTokenIntoStakingPool";
        return true;
    }

    /**
     * @notice - unstake a given amount of a native token from the staking pool
     */
    function unstakeNativeTokenFromStakingPool() public returns (bool) {
        require(stakers[msg.sender], "You are not a staker");
        require(stakedAmounts[msg.sender] > 0, "You have no staked amount to withdraw");
        uint256 amount = stakedAmounts[msg.sender];
        address payable staker = payable(msg.sender);
        stakedAmounts[msg.sender] = 0;
        (bool success, ) = staker.call{value: amount}("");
        require(success, "Unstake failed");
        checkpoints[msg.sender][block.timestamp] = "unstakeNativeTokenFromStakingPool";
        return true;
    }

    /**
     * @notice - Get the contract's native token balance
     */
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice - checkpoint function
     */
    function checkpoint(string memory methodName) public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = methodName;
        checkpoints[msg.sender][block.timestamp] = "checkpoint";
        checkpointCounts[msg.sender][block.timestamp]++;
        return true;
    }

    function testFunctionForCheckPoint() public returns (bool) {
        checkpoints[msg.sender][block.timestamp] = "testFunctionForCheckPoint";
        checkpointCounts[msg.sender][block.timestamp]++;
        return true;
    }

    /**
     * @notice - Receive function to accept Ether transfers
     */
    receive() external payable {
        require(msg.value > 0, "Must send some Ether");
        stakedAmounts[msg.sender] += msg.value;
        checkpoints[msg.sender][block.timestamp] = "receive";
    }

    /**
     * @notice - Fallback function
     */
    fallback() external payable {
        require(msg.value > 0, "Must send some Ether");
        stakedAmounts[msg.sender] += msg.value;
        checkpoints[msg.sender][block.timestamp] = "fallback";
    }
}
