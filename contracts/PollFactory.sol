pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;


import "./CalculUtils.sol";
import "./VoteFactory.sol";
import "./CandidateFactory.sol";
import "./UniqueID.sol";

/*
This file is responsible to create and modify polls
*/
contract PollFactory is VoteFactory, CandidateFactory, UniqueID  {

    /*
        Pour le front : - Une méthode qui retourne toutes les élections pour laquelle un utilisateur a voté
                        - Une méthode getElection(id)
    */

    /*
        Pour le back : - ajouter un vote à une election
                       - calculer la médianne des candidats
                       - event au front pour changement etat
                       - event au front à l'ajout d'un candidat
    */

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier electionOwner(uint electionID) {
        require(
            msg.sender == electionToOwner[electionID],
            "This function is restricted to the election's owner"
        );
        _;
    }

    struct Election {
        uint256 id;
        string name;
        ElectionState state;
        uint candidateCount;
        uint voteCount;
        mapping(uint => Candidate) candidates;
        mapping(uint => Vote) votes;
    }

    mapping(uint => Election) public elections;

    uint256 public electionCount;

    enum ElectionState { APPLICATION, VOTE, RESULTS}

    event ElectionAdded(uint id, string name);

    event ChangeElectionState(ElectionState state);

    mapping(address => Election) public participated;

    mapping(uint256 => address) public electionToOwner;

    constructor() public {
        electionCount = 0;
    }

    event printNumber(uint);
    event printElection(uint256, string, ElectionState);
    event candidateAdded(string, string, address);



    //TODO implement this
    function createElection(string memory _electionName) public {
        elections[electionCount] = Election(electionCount, _electionName, ElectionState.APPLICATION, 0, 0);
        electionToOwner[electionCount] = msg.sender;

        emit ElectionAdded(electionCount,_electionName);
        electionCount++;

    }

    //TODO test
//    function nextStep(uint _idElection) public electionOwner(_idElection) {
//        for(uint i = 0; i < elections.length; i++) {
//            if(elections[i].id == _idElection) {
//                if(elections[i].state == ElectionState.APPLICATION) {
//                    elections[i].state = ElectionState.VOTE;
//                    emit ChangeElectionState(elections[i].state);
//                } else if(elections[i].state == ElectionState.VOTE){
//                    elections[i].state = ElectionState.RESULTS;
//                    emit ChangeElectionState(elections[i].state);
//                }
//            }
//        }
//    }

    //TODO implement the test
    function addCandidate(uint256 electionID, string memory _name, string memory _firstName) public {
        Election storage election = elections[electionID];

        election.candidates[election.candidateCount] = Candidate(_name, _firstName, msg.sender);
        election.candidateCount++;
        emit CandidateAdded(_name, _firstName);
    }

    function addVote(uint256 electionID, address[] memory candidateAddresses, uint8[] memory notes) public {
        Election storage election = elections[electionID];
        election.votes[election.voteCount] = Vote(msg.sender, candidateAddresses.length);

        for(uint i = 0; i < candidateAddresses.length; i++) {
            election.votes[election.voteCount].ballot[candidateAddresses[i]] = notes[i];
        }
        election.voteCount++ ;
        emit VoteAdded(msg.sender, candidateAddresses, notes);

    }

}
