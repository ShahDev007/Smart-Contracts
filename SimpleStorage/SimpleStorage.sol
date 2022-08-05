// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleStorage{

    uint public favoriteNumber;
    // uint256 favoriteNumber = 5;
    // int256 favoriteNumber = -5;
    // bool favoriteBool = true;
    // string favoriteString = "Dev";
    // address favoriteAddress = "0x158bA8F79568dFDFBfb70d44251839670bd8c1d4";
    // bytes32 favoriteBytes = "Cat";

    struct People{
        uint256 favoriteNumber;
        string name;         
    }

    People[] public people;

    mapping(string => uint256) public nameToFavNumber;

// In memory data is stored only for execution and in storage data is stored forever

    function addPerson(string memory _name, uint256 _favoriteNumber) public{
        // peopsle.push(People({favoriteNumber:_favoriteNumber,name:_name)});
        people.push(People(_favoriteNumber,_name));
         nameToFavNumber[_name] = _favoriteNumber;
    }

    // People public person = People({favoriteNumber:12,name:"Dev"});
    
    function store (uint256 _favoriteNumber) public virtual {
         favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

}

