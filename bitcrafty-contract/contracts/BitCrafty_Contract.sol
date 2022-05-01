// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./UNIQ.sol";

contract BitCrafty_Contract {

    mapping(uint256 => Handicraft) private idToHandicraft;
    mapping(uint256 => string) private tokenUriMapping;

    mapping(address => uint256) private totalPurchaseValue;

    struct Handicraft {uint256 handicraftId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;}

    mapping(address => bool) public isPresent;
    UNIQ public uniq;

    event HandicraftCreated (uint256 indexed handicraftId, address seller, address owner, uint256 price, bool sold);

    event Transfer(address seller, address owner, uint256 handicraftId);
    event Mint(address to, uint256 handicraftId);

    uint private handicraftsSold;
    uint private handicraftIds;

    modifier priceGreaterThanZero(uint256 price){require(price > 0, "Please enter price greater than zero.");
        _;}

    modifier onlyItemOwner(uint256 handicraftId){require(idToHandicraft[handicraftId].owner == msg.sender, "Only handicraft owner can sell.");
        _;}
    modifier amountSpentIsGreaterThan10{require(totalPurchaseValue[msg.sender] >= 10000000000000000000, "Total purchase value should atleast be greater than 10 Ethers");
        _;}

    modifier ownerBalanceIsGreaterThanReward{require(address(this).balance > msg.value, "Smart contract balance should at least be greater than reward ");
        _;}

    constructor() payable{
        uniq = UNIQ(500000);
    }

    function getTokens()public{
        if (isPresent[msg.sender] == false) {
            isPresent[msg.sender] = true;
            uniq.mintTokens();
        }
    }

    function createHandicraftToken(string memory tokenURI, uint256 price) public payable returns (uint) {
        uniq.transferTokens(getListingPrice(price), address(this), uniq);
        handicraftIds = handicraftIds + 1;
        emit Mint(msg.sender, handicraftIds);
        tokenUriMapping[handicraftIds] = tokenURI;
        createHandicraft(handicraftIds, price);
        return handicraftIds;
    }

    function createHandicraft(uint256 handicraftId, uint256 price) private priceGreaterThanZero(price) {
        idToHandicraft[handicraftId] = Handicraft(handicraftId, payable(msg.sender), payable(address(this)), price, false);
        emit Transfer(msg.sender, address(this), handicraftId);
        emit HandicraftCreated(handicraftId, msg.sender, address(this), price, false);
    }

    function getTokenURI(uint256 handicraftId) public view returns (string memory) {return tokenUriMapping[handicraftId];}

    function getListingPrice(uint256 price) public pure returns (uint256) {return (price * 2) / 100;}

    function createMarketSale(uint256 handicraftId) public payable {
        uint price = idToHandicraft[handicraftId].price;
        address seller = idToHandicraft[handicraftId].seller;
        require(msg.value == price, "Please pay the mentioned value for transaction.");
        idToHandicraft[handicraftId].owner = payable(msg.sender);
        idToHandicraft[handicraftId].sold = true;
        idToHandicraft[handicraftId].seller = payable(address(0));
        handicraftsSold = handicraftsSold + 1;
        emit Transfer(address(this), msg.sender, handicraftId);
        uniq.transferTokens(price, seller, uniq);
        //        payable(seller).transfer(msg.value);
        totalPurchaseValue[msg.sender] = totalPurchaseValue[msg.sender] + idToHandicraft[handicraftId].price;}

    function resellHandicraft(uint256 handicraftId, uint256 price) public payable onlyItemOwner(handicraftId) {
        uniq.transferTokens(getListingPrice(price), address(this), uniq);
        idToHandicraft[handicraftId].price = price;
        idToHandicraft[handicraftId].sold = false;
        idToHandicraft[handicraftId].owner = payable(address(this));
        idToHandicraft[handicraftId].seller = payable(msg.sender);
        emit Transfer(msg.sender, address(this), handicraftId);
        handicraftsSold = handicraftsSold - 1;}

    function fetchHandicrafts() public view returns (Handicraft[] memory) {uint itemCount = handicraftIds;
        uint unsoldItemCount = handicraftIds - handicraftsSold;
        uint currentIndex = 0;
        Handicraft[] memory items = new Handicraft[](unsoldItemCount);
        for (uint i = 0; i < itemCount; i++) {if (idToHandicraft[i + 1].owner == address(this)) {uint currentId = i + 1;
            Handicraft storage currentItem = idToHandicraft[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;}}
        return items;}

    function fetchMyHandicrafts() public view returns (Handicraft[] memory) {uint totalItemCount = handicraftIds;
        uint itemCount = 0;
        uint currentIndex = 0;
        for (uint i = 0; i < totalItemCount; i++) {if (idToHandicraft[i + 1].owner == msg.sender) {itemCount += 1;}}
        Handicraft[] memory items = new Handicraft[](itemCount);
        for (uint i = 0; i < totalItemCount; i++) {if (idToHandicraft[i + 1].owner == msg.sender) {uint currentId = i + 1;
            Handicraft storage currentItem = idToHandicraft[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;}}
        return items;}

    function fetchMyListedHandicrafts() public view returns (Handicraft[] memory) {uint totalItemCount = handicraftIds;
        uint itemCount = 0;
        uint currentIndex = 0;
        for (uint i = 0; i < totalItemCount; i++) {if (idToHandicraft[i + 1].seller == msg.sender) {itemCount += 1;}}
        Handicraft[] memory items = new Handicraft[](itemCount);
        for (uint i = 0; i < totalItemCount; i++) {if (idToHandicraft[i + 1].seller == msg.sender) {uint currentId = i + 1;
            Handicraft storage currentItem = idToHandicraft[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;}}
        return items;}

    function fetchRewards() public view returns (uint256) {if (totalPurchaseValue[msg.sender] >= 10) {uint reward = (totalPurchaseValue[msg.sender] * 1) / 100;
        return reward;}
        return 0;}

    function redeemReward(uint reward) public amountSpentIsGreaterThan10 ownerBalanceIsGreaterThanReward payable {
        uniq.transferTokensFrom(reward, msg.sender, uniq, address(this));
        //        payable(msg.sender).transfer(reward);
        totalPurchaseValue[msg.sender] = 0;}

}