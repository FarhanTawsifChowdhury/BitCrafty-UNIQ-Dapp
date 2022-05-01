// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UNIQ is ERC20 {
    mapping(address => bool) public isPresent;
    constructor(uint256 amount) ERC20("UNIQ", "UNIQ") {
        _mint(msg.sender, amount);
    }

    function mintTokens() public {
        _mint(msg.sender, 100000);
    }

    function decimals() public view virtual override returns (uint8) {
        return 2;
    }

    function transferTokens(uint256 amount, address to, UNIQ uniq)public{
        uint256 erc20balance = uniq.balanceOf(msg.sender);
        require(amount <= erc20balance, "balance is low");
        uniq.transfer(to, amount);
    }

    function transferTokensFrom(uint256 amount, address to, UNIQ uniq, address from)public{
        uint256 erc20balance = uniq.balanceOf(from);
        require(amount <= erc20balance, "balance is low");
        uniq.transferFrom(from, to, amount);
    }
}