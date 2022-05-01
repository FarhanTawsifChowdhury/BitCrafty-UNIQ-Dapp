// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UNIQ is ERC20 {
    mapping(address => bool) public isPresent;
    address private owner;
    constructor() ERC20("UNIQ", "UNIQ") {
        _mint(msg.sender, 1000000000000000000000000000);
        owner = msg.sender;
    }

    function getERC20Owner() view public returns (address) {
        return owner;
    }
}