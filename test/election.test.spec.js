const Poll = artifacts.require('Poll');
const truffleAssert = require('truffle-assertions');
const fromWei = require('web3').utils.fromWei;
const GeneratorService = require('./utils').GeneratorService;
const candidateCoder = require('./utils').candidateCoder;
const electionCoder = require('./utils').electionCoder;
const ElectionState = require('./utils').ElectionState;
const randomNumber = require('./utils').randomNumber;
const voteCoder = require('./utils').voteCoder;

contract('Poll contract', (accounts) => {
    let [alice, bob, virginie] = accounts;
    let contractInstance ;
    let generatorService ;

    beforeEach( async () => {
        contractInstance = await Poll.new();
        generatorService = new GeneratorService(contractInstance);
    })

    it('Should create Election', async () => {
        const electionName = "Election 1";
        const result = await contractInstance.createElection(electionName);
        truffleAssert.eventEmitted(result, 'ElectionAdded', (event) => event.id && event.name === electionName );
    })

    it('Should Fetch All elections', async () => {
        //Given
        const election1 = { name: 'Election 1' };
        const election1Id = await generatorService.addElection(election1.name, alice);
        const election2 = { name: 'Election 2' };
        const election2Id = await generatorService.addElection(election2.name, alice);

        //When
        const electionsToDecode = await contractInstance.allElections();

        const elections = electionCoder.decodeCandidateList(electionsToDecode);

        //Then
        const firstElection = elections.find(election => election.id === election1Id);
        assert.equal(firstElection.name, election1.name);
        assert.equal(firstElection.state, ElectionState.APPLICATION);

        const secondElection = elections.find(election => election.id === election2Id);
        assert.equal(secondElection.name, election2.name);
        assert.equal(secondElection.state, ElectionState.APPLICATION);

    })

    it('Should Add a candidates', async () => {
        const electionName = 'Election 1';
        const electionId = await generatorService.addElection(electionName, alice);

        const candidate = {name: 'Maubert', firstName: 'Allan'};
        const addCandidateTransaction = await contractInstance.addCandidate(electionId, candidate.name, candidate.firstName, {from: alice});
        truffleAssert.eventEmitted(addCandidateTransaction, 'CandidateAdded', (event) => event.name === candidate.name && event.firstName === candidate.firstName );
    })

    it('Should Fetch all candidates of a given election ', async () => {

        //Given
        const electionName = 'Election 1';
        const electionId = await generatorService.addElection(electionName, alice);

        const firstCandidate = {name: 'AZERTY', firstName: 'bob'};
        await generatorService.addCandidate(electionId, firstCandidate.name, firstCandidate.firstName, bob);

        const secondCandidate = {name: 'MON-NOM-EST-TROP-LONG-ET-GRAS', firstName: 'virginie'};
        await generatorService.addCandidate(electionId, secondCandidate.name, secondCandidate.firstName, virginie);

        //When
        const candidatesToDecode = await contractInstance.allCandidatesByElectionID(electionId);

        const candidates = candidateCoder.decodeCandidateList(candidatesToDecode);

        //Then
        const candidateBob = candidates.find(candidate => candidate.address === bob);

        assert.equal(candidateBob.name, firstCandidate.name);
        assert.equal(candidateBob.firstName, firstCandidate.firstName);

        const candidateVirginie = candidates.find(candidate => candidate.address === virginie);

        assert.equal(candidateVirginie.name, secondCandidate.name);
        assert.equal(candidateVirginie.firstName, secondCandidate.firstName);
    })


    it('Should add a Vote ', async () => {

        //Given
        const electionName = 'Election 1';
        const electionId = await generatorService.addElection(electionName, alice);

        const firstCandidate = {name: 'AZERTY', firstName: 'bob'};
        await generatorService.addCandidate(electionId, firstCandidate.name, firstCandidate.firstName, bob);

        const secondCandidate = {name: 'MON-NOM-EST-TROP-LONG-ET-GRAS', firstName: 'virginie'};
        await generatorService.addCandidate(electionId, secondCandidate.name, secondCandidate.firstName, virginie);


        const candidatesToDecode = await contractInstance.allCandidatesByElectionID(electionId);
        const candidates = candidateCoder.decodeCandidateList(candidatesToDecode);

        let candidatesAddress = [];
        let candidatesNote = [];
        candidates.forEach(candidate => {
            candidatesAddress.push(candidate.address);
            //Get a random number between 0 and 20
            candidatesNote.push(randomNumber(20));
        });


        //When
        const addVoteTransaction = await contractInstance.addVote(electionId, candidatesAddress, candidatesNote, {from : alice});

        //Then
        const result = addVoteTransaction.logs[0].args;
        const vote = {voter: result.voter_address, candidates: result.candidates, notes: result.notes.map(note => note.toNumber()) };

        assert.equal(vote.voter, alice);
        assert.equal(candidatesAddress.length, vote.candidates.length);
        assert.equal(candidatesAddress.length, vote.notes.length);

        for(let i = 0; i < candidatesAddress.length; i++ ) {
            assert.equal(candidatesAddress[i], vote.candidates[i]);
            assert.equal(candidatesNote[i], vote.notes[i]);
        }

    })

    it('Should Fetch all votes of a given election ', async () => {

        //Given
        const electionName = 'Election 1';
        const electionId = await generatorService.addElection(electionName, alice);

        const firstCandidate = {name: 'AZERTY', firstName: 'bob'};
        await generatorService.addCandidate(electionId, firstCandidate.name, firstCandidate.firstName, bob);

        const secondCandidate = {name: 'MON-NOM-EST-TROP-LONG-ET-GRAS', firstName: 'virginie'};
        await generatorService.addCandidate(electionId, secondCandidate.name, secondCandidate.firstName, virginie);


        const candidatesToDecode = await contractInstance.allCandidatesByElectionID(electionId);
        const candidates = candidateCoder.decodeCandidateList(candidatesToDecode);

        await generatorService.addVotes(electionId, candidates, alice);
        await generatorService.addVotes(electionId, candidates, bob);
        await generatorService.addVotes(electionId, candidates, virginie);

        //When
        const voteToEncode = await contractInstance.allVotesByElectionID(electionId);

        voteToEncode.logs[0].args[0].forEach(bn => console.log({bn}));
        const votes = voteCoder.decodeVoteList(voteToEncode);

        console.log({votes});

    })

})

