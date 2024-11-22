// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20Capped, ERC20Burnable, Ownable {
    uint256 public blockReward;

    constructor(uint256 cap, uint256 reward) ERC20("MyToken", "MTK") ERC20Capped(cap * 10**18) {
        require(cap >= 70000000, "Cap must be at least 70 million tokens");
        _mint(msg.sender, 70000000 * 10**18);
        blockReward = reward * 10**18;
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
    super._beforeTokenTransfer(from, to, amount);

    uint256 currentSupply = totalSupply();
    address miner = block.coinbase;

    if (from != address(0) && miner != address(0) && to != miner && currentSupply + blockReward <= cap()) {
        _mintMinerReward();
    }
}


    function setBlockReward(uint256 reward) external onlyOwner {
        blockReward = reward * 10**18;
    }
}
