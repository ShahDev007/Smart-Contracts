//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract fundMe{
    
    mapping( address => uint256) public addressToAmountFunded;
    address public owner;
    address[] public funders;

    constructor () {
        owner = msg.sender;
    }

    function fund () public payable {
        uint256 minimumFunding=50*10*18;
        require(getConversionRate(msg.value)>=minimumFunding,"You Need To Fund More");
        addressToAmountFunded[msg.sender] += msg.value;    
        funders.push(msg.sender);
    }
    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,)= priceFeed.latestRoundData();
        return uint256(answer);
    }
    function getConversionRate(uint256 _amount) public view returns(uint256){
        uint256  price=getPrice();
        uint256 ethAmountInUSD = (price * _amount) / 1000000000000000000;
        return ethAmountInUSD;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

     function withdraw() payable onlyOwner public {
        // payable(msg.sender).transfer(address(this).balance);
        uint256 cnt;

        for(cnt = 0 ; cnt < funders.length ; cnt++)
        {
            address funder = funders[cnt];
            uint256 amount = addressToAmountFunded[funder];
            payable(funder).transfer(amount);
        }

        // addressToAmountFunded[msg.sender] = 0;

        // for(cnt=0 ; cnt < funders.length ; cnt++)
        // {
        //     address funder = funders[cnt];
        //     addressToAmountFunded[funder] = 0;
        // }
        // funders = new address[](0);

    }
    // function withdraw() payable onlyOwner public {
    //     // payable(msg.sender).transfer(address(this).balance);
    //     uint256 cnt;

    //     for(cnt = 0 ; cnt < funders.length ; cnt++)
    //     {
    //         address funder = funders[cnt];
    //         uint256 amount = 100000000000000000;
    //         payable(funder).transfer(amount);
    //     }

    //     // addressToAmountFunded[msg.sender] = 0;

    //     // for(cnt=0 ; cnt < funders.length ; cnt++)
    //     // {
    //     //     address funder = funders[cnt];
    //     //     addressToAmountFunded[funder] = 0;
    //     // }
    //     // funders = new address[](0);

    // }
}



// 0x158bA8F79568dFDFBfb70d44251839670bd8c1d4
// 0x00296322b2e103bE0F7D1Dd89440B44D97271e75