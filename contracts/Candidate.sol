pragma solidity >=0.4.22 <0.8.0;

contract Candidate {

    /*
        Pour le back :

    */

    // Events à utiliser pour le front :
    //event CandidateAdded(Candidate candidate); // Ou string name, string firstName ?
    event CandidateAdded(string name, string firstName, uint8[5] scores);

    struct Candidate {
        string name;
        string firstName;
        address candidateAddress;
        uint8[5] scores;
    }

    function _createCandidate(string memory _name, string memory _firstName) private returns(Candidate memory){
        uint8[5] memory scores = [0, 0, 0, 0, 0];
        Candidate memory candidate = Candidate(_name, _firstName, msg.sender, scores);
        emit CandidateAdded(_name, _firstName, scores);
        return candidate;
    }

    function coucouTest() public pure returns (string memory) {
        string memory coucou =  "coucou";
        return coucou;
    }
}
