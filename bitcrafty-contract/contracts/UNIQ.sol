// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UNIQ is ERC20 {
    mapping(address => bool) public isPresent;
    address public owner;
    constructor() ERC20("UNIQ", "UNIQ") {
        owner = address(this);
        _mint(owner, 1000000000000000000000000000);
    }

    function airdrop(address receiver) public {
        _transfer(owner, receiver, 10000);
    }

    function getERC20Owner() view public returns (address) {
        return owner;
    }

    function decimals() public view virtual override returns (uint8) {
        return 2;
    }

}