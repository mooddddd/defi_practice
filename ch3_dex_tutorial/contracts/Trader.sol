// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "./interfaces/IERC20.sol";
import "./interfaces/IUniswapV2Router02.sol";
import "./interfaces/IUniswapV2Factory.sol";
import "./interfaces/IMasterChef.sol";
import "hardhat/console.sol";

contract Trader {
    // contracts
    address constant FACTORY = 0x90B06a1B5920E45c5f0aC3D701728669527bF275;
    address constant ROUTER = 0x0D827eaDe12e5f296e3Dd0e08fc38ad990dC1142;
    address constant CHEF = 0x5bc059C6fAC255702Ea697415f82e44c5ec3CB76;

    // tokens
    address constant WKLAY = 0x043c471bEe060e00A56CcD02c0Ca286808a5A436;
    address constant WHLE = 0x15308179057A1d5e56C61a612b1EADfA5F669Aad;
    
    constructor() {}

    receive () external payable {}

    // ------------- VIEW ------------- 

    function pendingReward(uint pid) external view returns (uint) {
        // TODO
        return 0;
    }

    function pendingRewardAll() external view returns (uint) {
        // TODO
        return 0;
    }

    function depositBalance(uint pid) external view returns (uint) {
        // TODO
        return 0;
    }

    // ------------- LIQUIDITY ------------- 

    function addLiquidityKlay(address token, uint amountDesired) payable external {
        // TODO
    }

    function addLiquidity(address tokenA, address tokenB, uint amountA, uint amountB) external {
        // TODO
    }

    function removeLiquidity(address tokenA, address tokenB, uint liquidity) external {
        // TODO
    }

    function removeLiquidityKlay(address token, uint liquidity) external {
        // TODO
    }

    // ------------- SWAP ------------- 

    function swapExactTokenToToken(uint amountIn, address[] calldata path) external {
        // TODO
    }

    function swapTokenToExactToken(uint amountOut, uint amountInMax, address[] calldata path) external {
        // TODO
    }

    function swapExactKlayToToken(address[] calldata path) payable external {
        // TODO
    }

    function swapKlayToExactToken(uint amountOut, address[] calldata path) payable external {
        // TODO
    }


    // ------------- FARM ------------- 

    function deposit(uint pid, uint amount) external {
        // TODO
    }

    function withdraw(uint pid, uint amount) external {
        // TODO
    }

    function harvest() public {
        // TODO
    }

    function claimReward() external {
        // TODO
    }

    // ------------- UTILS ------------- 

    function approveToken(address token, address spender) private {
        if (IERC20(token).allowance(address(this), spender) == 0) {
            IERC20(token).approve(spender, type(uint).max);
        }
    }
}