pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./Definitions.sol";
import "./UniqueID.sol";


/*
This file is responsible to create and modify polls
*/
contract PollFactory is Definitions, UniqueID  {

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


    mapping(uint => Election) public elections;

    uint256 public electionCount;

    mapping(uint256 => address) public electionToOwner;

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier isElectionOwner(uint electionID) {
        require(
            msg.sender == electionToOwner[electionID],
            "only election's owner"
        );
        _;
    }



    event ElectionAdded(uint id, string name);

    event ChangeElectionState(ElectionState state);

    constructor() public {
        electionCount = 0;
    }

    function createElection(string memory _electionName) public {
        elections[electionCount] = Election(electionCount, _electionName, ElectionState.APPLICATION, 0, 0);
        electionToOwner[electionCount] = msg.sender;

        emit ElectionAdded(electionCount,_electionName);
        electionCount++;
    }

    //TODO test
    function nextStep(uint _idElection) public isElectionOwner(_idElection) {
        for(uint i = 0; i < electionCount; i++) {
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
