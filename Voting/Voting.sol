// SPDX-License-Identifier: MIT 
pragma solidity >= 0.6.0 < 0.9.0;

contract Voting {

    struct vote{
        address voterAddress;
        bool choice;
    }
    struct voter{
        string voterName;
        bool voted;
    }
    mapping(uint => vote) private votes;
    mapping(address => voter) public voterRegister;

    uint private countResult = 0;
    uint public finalResult = 0;
    uint public totalVoter = 0;
    uint public totalVote = 0;

    address public ballotOfficialAddress;      
    string public ballotOfficialName;
    string public proposal;

    enum State { Created, Voting, Ended }
    State public state;

    constructor(
        string memory _ballotOfficialName,
        string memory _proposal) public {
        ballotOfficialAddress = msg.sender;
        ballotOfficialName = _ballotOfficialName;
        proposal = _proposal;
        
        state = State.Created;
    }

    function addVoter(address _voterAddress, string memory _voterName)
        public
        inState(State.Created)
        onlyOfficial
    {
        voter memory v;
        v.voterName = _voterName;
        v.voted = false;
        voterRegister[_voterAddress] = v;
        totalVoter++;
        // emit voterAdded(_voterAddress);
    }

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    modifier onlyOfficial() {
        require(msg.sender ==ballotOfficialAddress);
        _;
    }

    function startVote()
        public
        inState(State.Created)
        onlyOfficial
    {
        state = State.Voting;     
        // emit voteStarted();
    }

    function doVote(bool _choice)
        public
        inState(State.Voting)
        returns (bool voted)
    {
        bool found = false;
        
        if (bytes(voterRegister[msg.sender].voterName).length != 0 
        && !voterRegister[msg.sender].voted){
            voterRegister[msg.sender].voted = true;
            vote memory v;
            v.voterAddress = msg.sender;
            v.choice = _choice;
            if (_choice){
                countResult++; //counting on the go
            }
            votes[totalVote] = v;
            totalVote++;
            found = true;
        }
        // emit voteDone(msg.sender);
        return found;
    }

    function endVote()
        public
        inState(State.Voting)
        onlyOfficial
    {
        state = State.Ended;
        finalResult = countResult; //move result from private countResult to public finalResult
        // emit voteEnded(finalResult);
    }


}



// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
// 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB