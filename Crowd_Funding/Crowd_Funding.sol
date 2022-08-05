//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract CrowdFunding {
    address public manager;
    uint public minimumContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;
    address payable[] public addresses;

     struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }
    mapping(uint=>Request) public requests;
    uint public numRequests; 

    mapping (address=>uint) public contributors;

    constructor(uint _target, uint _deadline, uint _minimumContribution) {
        target = _target;
        deadline = block.timestamp+_deadline;
        minimumContribution = _minimumContribution;
        manager = msg.sender;

    }

    modifier onlyManager {
        manager = msg.sender;
        _;
    }

    function sendEth() public payable {
        require(block.timestamp < deadline,"Deadline has passed");
        require(msg.value >= minimumContribution,"Minimum contribution has not met");
        if(contributors[msg.sender] == 0)
        {
            noOfContributors++;
            addresses.push(payable(msg.sender));
        }          
        contributors[msg.sender] += msg.value;
        raisedAmount+=msg.value; 
        
    }

    function getContractBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function refundToAll() public {
        require(manager == msg.sender,"Only manager can refund.");
        require(block.timestamp > deadline,"Deadline has not yet passed.");
        require(target < raisedAmount,"Target has not met yet.");

        for(uint i=0 ; i < noOfContributors ; i++)
        {
            addresses[i].transfer(contributors[addresses[i]]);
        }

    }

    function refund() public {
        require(block.timestamp > deadline,"Deadline has not yet passed");
        require(contributors[msg.sender]>0,"You have not contributed");
        require(target < raisedAmount,"Target has not met yet.");

        address payable user = payable(msg.sender);
        user.transfer(contributors[user]);
        contributors[user] = 0;
        noOfContributors--;
        // delete addresses[msg.sender];
    }

    function createRequests(string memory _description,address payable _recipient,uint _value) public onlyManager{
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.description=_description;
        newRequest.recipient=_recipient;
        newRequest.value=_value;
        newRequest.completed=false;
        newRequest.noOfVoters=0;        
    }

    function voteRequest(uint256 requestNo) public {
        require(contributors[msg.sender] > 0,"You are not a contributor.");
        Request storage thisRequest = requests[requestNo];
        require(thisRequest.voters[msg.sender] == false ,"You already voted.");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint requestNo) public {
        require(raisedAmount >= target,"Target amount has not reahed yet.");
        Request storage thisRequest = requests[requestNo];
        require(thisRequest.noOfVoters > noOfContributors/2,"Majority does not support");
        require(thisRequest.completed == false,"The request has been completed");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
    }


}