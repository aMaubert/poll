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
        mapping(uint => Candidate) candidates;
        uint candidatesSize;
        mapping(uint => Vote) votes;
    }

    Election[] public elections;

    enum ElectionState { APPLICATION, VOTE, RESULTS}

    event ElectionAdded(uint id, string name);

    event ChangeElectionState(ElectionState state);

    mapping(address => Election) public participated;

    mapping(uint256 => address) public electionToOwner;

    //TODO implement this
    function createElection(string memory _electionName) public {
        uint electionID =  generateUniqueId();
        Election memory newElection = Election({id:electionID, name :_electionName, state: ElectionState.APPLICATION, candidatesSize: 1  });
        elections.push( newElection ) ;
        elections[0].candidates[newElection.candidatesSize] =  Candidate( "frzr", "fezgzr",msg.sender);
        electionToOwner[electionID] = msg.sender;
        emit ElectionAdded(electionID,_electionName);
    }

    //TODO test
    function nextStep(uint _idElection) public electionOwner(_idElection) {
        for(uint i = 0; i < elections.length; i++) {
            if(elections[i].id == _idElection) {
                if(elections[i].state == ElectionState.APPLICATION) {
                    elections[i].state = ElectionState.VOTE;
                    emit ChangeElectionState(elections[i].state);
                } else if(elections[i].state == ElectionState.VOTE){
                    elections[i].state = ElectionState.RESULTS;
                    emit ChangeElectionState(elections[i].state);
                }
            }
        }
    }

}
