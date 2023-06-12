// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;
import './IERC20.sol';

interface IMasterChef {
    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
    }

    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken; // Address of LP token contract.
        uint256 allocPoint; // How many allocation points assigned to this pool. whales to distribute per block.
        uint256 lastRewardBlock; // Last block number that whales distribution occurs.
        uint256 accwhalePerShare; // Accumulated whales per share, times 1e12. See below.
    }
    function factory() external view returns (address);
    function poolInfo(uint _pid) external view returns (PoolInfo memory);
    function userInfo(uint _pid, address _account) external view returns (UserInfo memory);
    
    function poolLength() external view returns (uint256);
    function getPid(address token) external view returns (uint);
    function pendingwhale(uint256 _pid, address _user) external view returns (uint256);

    function deposit(uint256 _pid, uint256 _amount) external;
    function withdraw(uint256 _pid, uint256 _amount) external;
    function massUpdatePools() external;
}