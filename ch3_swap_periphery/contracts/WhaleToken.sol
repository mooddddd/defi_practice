pragma solidity 0.6.6;

import './ERC20.sol';

contract WhaleToken is ERC20("Whale Token", "WHLE") {
    address public owner;
    address public minter;

    constructor () public {
        owner = msg.sender;
        minter = msg.sender;
    }

    modifier onlyMinter() {
        require(msg.sender == minter || msg.sender == owner, "only minter");
        _;
    }

    function mint(address to, uint amount) onlyMinter external {
        _mint(to, amount);
    }

    function burn(address to, uint amount) onlyMinter external {
        _burn(to, amount);
    }

    function transferMinter(address to) onlyMinter external {
        minter = to;
    }
}