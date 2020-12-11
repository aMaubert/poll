pragma solidity >=0.4.22 <0.8.0;

import "./Candidate.sol";
import "./Vote.sol";
import "./Poll.sol";

contract Election is Poll {
    address public owner = msg.sender;
    uint public last_completed_migration;

    // Events à utiliser pour le front :
    //event ElectionAdded(Election election); // Ou string name ?
    event ElectionAdded(string name);
    event CandidateAdded(string name);
    event ChangeState(State state);

    /*
        Pour le front : - Une méthode qui retourne toutes les élections pour laquelle a voté une adresse
                        - Une méthode getElection(id)
    */
    mapping (address => Vote[]) getElectionsVoted;



    enum State {Applications, Vote, Results}

    struct Election {
        uint id;
        string name;
        State state;
        Candidate[] candidates;
        Vote[] votes;
    }



    Election[] public elections;

    modifier restricted() {
        require(
            msg.sender == owner,
            "This function is restricted to the contract's owner"
        );
        _;
    }

    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
    }

    function createElection(string memory _electionName) public {
        Candidate[] memory tmpCandidate; // Variables temporaires pour pouvoir retourner une liste de structures vide.
        Vote[] memory tmpVote;
        Election memory election = Election(_getUniqueId(), _electionName, State.Applications, tmpCandidate, tmpVote);
        emit ElectionAdded(_electionName);
        elections.push(election);
    }

    function addCandidate(Candidate _candidate, string memory _electionName) public {
        for (uint i = 0; i < elections.length; i++) {
            // On compare les deux chaines de caractères (l'une est de type stockage et l'autre memory)
            if(keccak256(abi.encodePacked(elections[i].name)) == keccak256(abi.encodePacked(_electionName))) {
                elections[i].candidates.push(_candidate);
                // Handle getCandidateName(candidate.name)
                //emit CandidateAdded(_candidate.name);
            }
        }
    }

    function addVote(Vote _vote, string memory _electionName) public {
        for (uint i = 0; i < elections.length; i++) {
            // On compare les deux chaines de caractères (l'une est de type stockage et l'autre memory)
            if(keccak256(abi.encodePacked(elections[i].name)) == keccak256(abi.encodePacked(_electionName))) {
                elections[i].votes.push(_vote);
            }
        }
    }

    // On récupère la liste des candidats d'une élection pour un vote.
    function getCandidatesForElection(string memory _electionName) public restricted returns(Candidate[] memory) {
        for (uint i = 0; i < elections.length; i++) {
            if(keccak256(abi.encodePacked(elections[i].name)) == keccak256(abi.encodePacked(_electionName))) {
                return elections[i].candidates;
            }
        }
        Candidate[] memory tmpCandidate;
        return tmpCandidate;
    }

    function nextStep(string memory _electionName) public restricted {
        for(uint i = 0; i < elections.length; i++) {
            if(keccak256(abi.encodePacked(elections[i].name)) == keccak256(abi.encodePacked(_electionName))) {
                if(elections[i].state == State.Applications) {
                    elections[i].state = State.Vote;
                    emit ChangeState(elections[i].state);
                } else if(elections[i].state == State.Vote){
                    elections[i].state = State.Results;
                    emit ChangeState(elections[i].state);
                }
            }
        }
    }

    function calculateResult(uint _idElection) public restricted returns (Candidate) {
        for(uint i = 0; i < elections.length; i++) {
            if(elections[i].id == _idElection) {
                if(elections[i].state == State.Results) {
                    // TODO : Logique de calcul des résultats à mettre en place.
                    return elections[i].candidates[0];
                }
            }
        }
        return elections[0].candidates[0];
    }

    function _getUniqueId() private view returns (uint)
    {
        bytes20 b = bytes20(keccak256(abi.encodePacked(msg.sender, now)));
        uint addr = 0;
        for (uint index = b.length-1; index+1 > 0; index--) {
            addr += uint8(b[index]) * ( 16 ** ((b.length - index - 1) * 2));
        }

        return addr;
    }
}
