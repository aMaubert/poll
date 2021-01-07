const Poll = artifacts.require('Poll');
const GeneratorService = require('./utils').GeneratorService;
const randomNumber = require('./utils').randomNumber;
const voteCoder = require('./utils').voteCoder;
const candidateCoder = require('./utils').candidateCoder;
const truffleAssert = require('truffle-assertions');


contract('Vote Factory And Vote Helper', (accounts) => {
    let [alice, bob, virginie] = accounts;
    let contractInstance ;
    let generatorService ;

    beforeEach( async () => {
        contractInstance = await Poll.new();
        generatorService = new GeneratorService(contractInstance);
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

        await contractInstance.nextStep(electionId, {from : alice}); // Election should be in Vote state


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

    it('Should have an error when yout vote an election with a state other that Vote', async () => {

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

        await truffleAssert.fails(
            //When
            contractInstance.addVote(electionId, candidatesAddress, candidatesNote, {from : alice}),
            //Then
            truffleAssert.ErrorType.REVERT,
            'Can\'t vote this election .'
        );

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

        await generatorService.electionNextStep(electionId, alice);

        const aliceVote = await generatorService.addVotes(electionId, candidates, alice);
        const bobVote = await generatorService.addVotes(electionId, candidates, bob);
        const virginieVote = await generatorService.addVotes(electionId, candidates, virginie);

        //When
        const voteToEncode = await contractInstance.allVotesByElectionID(electionId);

        //Then
        const votes = voteCoder.decodeVoteList(voteToEncode, candidates.length);


        const aliceVoteRes = votes.find(vote => vote.voter === alice);
        const bobVoteRes = votes.find(vote => vote.voter === bob);
        const virginieVoteRes = votes.find(vote => vote.voter === virginie);

        assert.notEqual(aliceVote, undefined);
        assert.notEqual(bobVote, undefined);
        assert.notEqual(virginieVote, undefined);

        for( const candidate of Object.keys(aliceVote) ) {
            assert.equal(aliceVote[candidate], aliceVoteRes.ballot[candidate]);
        }

        for( const candidate of Object.keys(bobVote) ) {
            assert.equal(bobVote[candidate], bobVoteRes.ballot[candidate]);
        }

        for( const candidate of Object.keys(virginieVote) ) {
            assert.equal(virginieVote[candidate], virginieVoteRes.ballot[candidate]);
        }

    })


})
