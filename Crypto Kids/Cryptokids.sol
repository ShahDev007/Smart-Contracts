// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CryptoKids {
    address public grandpa;
    address payable public address_kid;
    struct KidsInfo {
        address address_kid;
        uint256 age;
        uint256 gainedAmount;
    }
    mapping(uint=>KidsInfo) public requests;
    mapping(address=>uint) public kid;
    uint256 public numRequests;
    uint256 public transferingAmount;

    constructor(uint _transferingAmount){
        grandpa = msg.sender;
        transferingAmount = _transferingAmount;
    }

    modifier onlyGrandpa {
        require(msg.sender == grandpa);
        _;
    }

    function kids_entry(address _kid, uint256 _age) onlyGrandpa public {
        KidsInfo storage kidsinfo = requests[numRequests];
        numRequests++;
        kidsinfo.address_kid = _kid;
        kidsinfo.age = _age;
        kid[_kid] = _age;
    }

    function sendEth(uint requestNo) public payable onlyGrandpa {
        KidsInfo storage kidsinfo = requests[requestNo];
        kidsinfo.gainedAmount += (msg.value);
    }

    function withdraw(uint requestNo) public payable {
        KidsInfo storage kidsinfo = requests[requestNo];
        uint256 age_of_kid = kidsinfo.age;
        require(age_of_kid > 18,"You are still not young enough to get the ether from your grandpa.");
        // address_kid = kidsinfo.address_kid;
        payable(kidsinfo.address_kid).transfer(kidsinfo.gainedAmount);            
    }

}


// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db