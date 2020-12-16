pragma solidity >=0.4.22 <0.8.0;


contract CandidateFactory {

    /*
        Pour le back :

    */

    // Events à utiliser pour le front :
    //event CandidateAdded(Candidate candidate); // Ou string name, string firstName ?
    event CandidateAdded(string name, string firstName);

    struct Candidate {
        string name;
        string firstName;
        address candidateAddress;
    }

}
