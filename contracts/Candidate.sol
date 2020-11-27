pragma solidity >=0.4.22 <0.8.0;

contract Candidate {

    // Events à utiliser pour le front :
    //event CandidateAdded(Candidate candidate); // Ou string name, string firstName ?
    event CandidateAdded(string name, string firstName);

    struct Candidate {
        string name;
        string firstName;
        address candidateAddress;
    }

    function _createCandidate(string memory _name, string memory _firstName) private returns(Candidate memory){
        Candidate memory candidate = Candidate(_name, _firstName, msg.sender);
        emit CandidateAdded(_name, _firstName);
        return candidate;
    }

    function coucouTest() public pure returns (string memory) {
        string memory coucou =  "coucou";
        return coucou;
    }
}
