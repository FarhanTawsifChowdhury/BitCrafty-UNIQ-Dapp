pragma solidity ^0.8.4;

import "/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UNIQ is ERC20 {
    mapping(address => bool) public isPresent;
    constructor() ERC20("UNIQ", "UNIQ") {
    }

    function mintTokens(){
        _mint(msg.sender, 1000);
    }

    function transferTokens(uint256 amount, address to, UNIQ uniq){
        uint256 erc20balance = token.balanceOf(msg.sender);
        require(amount <= erc20balance, "balance is low");
        uniq.transfer(to, amount);
    }

    function transferTokensFrom(uint256 amount, address to, UNIQ uniq, address from){
        uint256 erc20balance = token.balanceOf(from);
        require(amount <= erc20balance, "balance is low");
        uniq.transferFrom(from, to, amount);
    }
}