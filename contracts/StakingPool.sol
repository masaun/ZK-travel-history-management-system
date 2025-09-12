pragma solidity ^0.8.25;

import { IERC20 } from "./interfaces/IERC20.sol";

/**
 * @notice - The StakingPool contract
 */
contract StakingPool {
    IERC20 public usdc; // USDC token contract instance

    mapping(address => mapping(uint256 => string)) public checkpoints;
    mapping(address caller => uint256 count) public checkpointCounts;
    mapping(address => bool) public stakers;
    mapping(address => uint256) public stakedAmounts;

    string public version;

    constructor() {
        usdc = IERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913); // USDC token on BASE Mainnet
        version = "0.2.40";
    }

    /**
     * @notice - Register as a staker
     */
    function registerAsStaker() public returns (bool) {
        require(!stakers[msg.sender], "You have already registered as a staker");
        stakers[msg.sender] = true;
        checkpoints[msg.sender][block.timestamp] = "registerAsStaker";
        checkpointCounts[msg.sender]++;
        return true;
    }

    function deregisterAsStaker() public returns (bool) {
        require(stakers[msg.sender], "You are not registered as a staker");
        stakers[msg.sender] = false;
        checkpoints[msg.sender][block.timestamp] = "deregisterAsStaker";
        checkpointCounts[msg.sender]++;
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
        checkpointCounts[msg.sender]++;
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
        checkpointCounts[msg.sender]++;
        return true;
    }

    /**
     * @notice - stake a given amount of a ERC20 token into the staking pool
     */
    function stakeERC20TokenIntoStakingPool() public returns (bool) {
        // [TODO]:
        checkpoints[msg.sender][block.timestamp] = "stakeERC20TokenIntoStakingPool";
        checkpointCounts[msg.sender]++;
        return true;
    }

    /**
     * @notice - unstake a given amount of a ERC20 token from the staking pool
     */
    function unstakeERC20TokenFromStakingPool() public returns (bool) {
        // [TODO]:
        require(usdc.balanceOf(address(this)) > 0, "No staked ERC20 tokens to withdraw");
        checkpoints[msg.sender][block.timestamp] = "unstakeERC20TokenFromStakingPool";
        checkpointCounts[msg.sender]++;
        return true;
    }

    /**
     * @notice - stake a given amount of a USDC (ERC20 token) into the staking pool
     */
    function stakeUSDCIntoStakingPool(uint amount) public returns (bool) {
        require(usdc.balanceOf(msg.sender) > amount, "Insufficient ERC20 token balance to stake");
        //usdc.safeTransferFrom(msg.sender, address(this), amount);
        checkpoints[msg.sender][block.timestamp] = "stakeUSDCIntoStakingPool";
        checkpointCounts[msg.sender]++;
        return true;
    }

    /**
     * @notice - unstake a given amount of a USDC (ERC20 token) from the staking pool
     */
    function unstakeUSDCFromStakingPool() public returns (bool) {
        require(usdc.balanceOf(address(this)) > 0, "No staked ERC20 tokens to withdraw");
        //usdc.safeTransfer(msg.sender, amount);
        checkpoints[msg.sender][block.timestamp] = "unstakeERC20TokenFromStakingPool";
        checkpointCounts[msg.sender]++;
        return true;
    }


    /**
     * @notice - Get the contract's native token balance
     */
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice - Get the rewards based on the count of a caller's checkpoints
     */
    function getRewards() public view returns (bool) {
        uint256 rewardAmount = checkpointCounts[msg.sender] * 1;  // 1 wei reward per checkpoint
        require(rewardAmount > 0, "No rewards available");
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
        checkpointCounts[msg.sender]++;
        return true;
    }

    /**
     * @notice - Receive function to accept Ether transfers
     */
    receive() external payable {
        require(msg.value > 0, "Must send some Ether");
        stakedAmounts[msg.sender] += msg.value;
        checkpoints[msg.sender][block.timestamp] = "receive";
        checkpointCounts[msg.sender]++;
    }

    /**
     * @notice - Fallback function
     */
    fallback() external payable {
        require(msg.value > 0, "Must send some Ether");
        stakedAmounts[msg.sender] += msg.value;
        checkpoints[msg.sender][block.timestamp] = "fallback";
        checkpointCounts[msg.sender]++;
    }
}
