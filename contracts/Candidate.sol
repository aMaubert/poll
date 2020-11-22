pragma solidity >=0.4.22 <0.8.0;

contract Candidate {

    struct Candidate {
        string name;
        string firstName;
        address candidateAddress;
    }

    function _createCandidate(string memory _name, string memory _firstName) private returns(Candidate memory){
        return Candidate(_name, _firstName, msg.sender);
    }

    function coucouTest() public pure returns (string memory) {
        string memory coucou =  "coucou";
        return coucou;
    }
}
