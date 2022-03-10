// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
    // wallet stuffs
    receive() external payable{}
    function checkWallet() public view onlyOwner returns(uint){
        return address(this).balance;
    }
    //owner stuffs
    address public owner;
    constructor(){
        owner=msg.sender;
    }
    modifier onlyOwner(){
        require(owner==msg.sender,"sorry you are not the owner!!!");
        _;
    }
    //participants stuffs
    address[] public participants;
    
    function sendMoney() public payable{
        require(owner!=msg.sender,"sorry owner can't play the lottery!!");
        address payable contractWallet=payable(address(this));
        contractWallet.transfer(2 ether);
        participants.push(msg.sender);
    }
    // random function
    function randomValue() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)))%participants.length;

    }
    //lottery stuffs
    function resultsOfLottery() public onlyOwner payable{
        require(participants.length>=3,"very low numbers of participants is there!!");
        address payable winner = payable(participants[randomValue()]);
        winner.transfer(checkWallet());
        participants= new address payable[](0);
    }
}