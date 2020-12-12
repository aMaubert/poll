pragma solidity >=0.4.22 <0.8.0;

import "./Candidate.sol";
import "./Vote.sol";
import "./Poll.sol";

contract Election is Vote {
    address public owner = msg.sender;
    uint public last_completed_migration;

    // Events à utiliser pour le front :
    event ElectionAdded(uint idElection); // Ou string name ?
    //event ElectionAdded(string name);
    event CandidateAdded(string name);
    event ChangeState(State state);

    /*
        Pour le front : - Une méthode qui retourne toutes les élections pour laquelle a voté une adresse
                        - Une méthode getElection(id)
    */

    /*
        Pour le back : - ajouter un vote à une election
                       - calculer la moyenne d'un candidat
                       - event au front pour changement etat
                       - event au front à l'ajout d'un candidat
    */


    mapping (address => Vote[]) getElectionsVoted;

    Election[] public elections;

    enum State { APPLICATION, VOTE, RESULTS}

    struct Election {
        uint id;
        string name;
        State state;
        Candidate[] candidates;
        Vote[] votes;
        //        mapping(uint => Vote) votes;
    }

    modifier restricted() {
        require(
            msg.sender == owner,
            "This function is restricted to the contract's owner"
        );
        _;
    }

    function createElection(string memory _electionName) public {
        Election storage election = elections[0];
        election.id = _getUniqueId();
        election.name = _electionName;
        emit ElectionAdded(election.id);
    }

    // TODO : Function getElection(uint idElection)

    function addCandidate(Candidate _candidate, uint _idElection) public {
        for (uint i = 0; i < elections.length; i++) {
            // On compare les deux chaines de caractères (l'une est de type stockage et l'autre memory)
            if(elections[i].id == _idElection) {
                elections[i].candidates.push(_candidate);
                // Handle getCandidateName(candidate.name)
                //emit CandidateAdded(_candidate.name);
            }
        }
    }

    function addVote(uint8[5] memory _notes, uint _idElection) public {
//        for (uint i = 0; i < elections.length; i++) {
//            // On compare les deux chaines de caractères (l'une est de type stockage et l'autre memory)
//            if(elections[i].id == _idElection) {
//                Vote memory tmpVote = Vote(msg.sender);
//                for(uint j = 0; j < _notes.length; j++) {
//                    tmpVote.ballot[j] = _createNote(_notes);
//                }
//                elections[i].votes[_getUniqueId()] = tmpVote;
//            }
//        }
    }

    // On récupère la liste des candidats d'une élection pour un vote.
    function getCandidatesForElection(uint _idElection) public restricted returns(Candidate[] memory) {
        for (uint i = 0; i < elections.length; i++) {
            if(elections[i].id == _idElection) {
                return elections[i].candidates;
            }
        }
        Candidate[] memory tmpCandidate;
        return tmpCandidate;
    }

    function nextStep(uint _idElection) public restricted {
        for(uint i = 0; i < elections.length; i++) {
            if(elections[i].id == _idElection) {
                if(elections[i].state == State.APPLICATION) {
                    elections[i].state = State.VOTE;
                    emit ChangeState(elections[i].state);
                } else if(elections[i].state == State.VOTE){
                    elections[i].state = State.RESULTS;
                    emit ChangeState(elections[i].state);
                }
            }
        }
    }

    // Restricted ou public ?
    function getResult(uint _idElection) public restricted returns (string memory) {
//        for(uint i = 0; i < elections.length; i++) {
//            if(elections[i].id == _idElection) {
//                if(elections[i].state == State.RESULTS) {
//                    calculateScore(elections[i].votes);
//
//                    return elections[i].candidates[0].name;
//                }
//            }
//        }
        return "winner";
    }

//    function calculateScore(Vote[] memory _votes) private {
//        for(uint i = 0; i < _votes.length; i++) {
//            // On part du principe que le Vote[0] correspond à la note du Candidate[0]
//            candidates[i].push(_votes[i]);
//        }
//    }

    function _getUniqueId() internal view returns (uint)
    {
        bytes20 b = bytes20(keccak256(abi.encodePacked(msg.sender, now)));
        uint addr = 0;
        for (uint index = b.length-1; index+1 > 0; index--) {
            addr += uint8(b[index]) * ( 16 ** ((b.length - index - 1) * 2));
        }

        return addr;
    }
}
