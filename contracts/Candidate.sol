pragma solidity ^0.4.0;

contract Candidate {

    struct Candidate {
        string name;
        string firstName;
        string candidateAddress;
    }

    function _createCandidate(string _name, string _firstName) private returns(Candidate){
        return Candidate(_name, _firstName, msg.sender);
    }
}
