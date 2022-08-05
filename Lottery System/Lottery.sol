//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract Lottery {
    address public manager;
    address payable[] public participants;
    address payable winner;

    mapping(address=>uint256) public ethCount;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == manager,"Only owners are able to see the total number of funds");
        _;
    }

    receive() external payable {
        require(msg.value >= 1 ether);
        // adding participants and transfering their money 
        participants.push(payable(msg.sender));
        // only transfering their money 
        // payable(msg.sender);
        ethCount[manager] += msg.value; 
    }

    function getBalance() public view onlyOwner returns(uint256){
        return address(this).balance;
    }

    function getRandomAddress() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, participants.length)));
    }
    function pickWinner() public onlyOwner {
        uint r = getRandomAddress();
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
    
}
