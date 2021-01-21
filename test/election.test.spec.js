const Poll = artifacts.require('Poll');
const truffleAssert = require('truffle-assertions');
const GeneratorService = require('./utils').GeneratorService;
const electionCoder = require('./utils').electionCoder;
const ElectionState = require('./utils').ElectionState;

contract('Election Factory And Election Helper', (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance ;
    let generatorService ;

    beforeEach( async () => {
        contractInstance = await Poll.new();
        generatorService = new GeneratorService(contractInstance);
    });

    it('Should create Election', async () => {
        const electionName = "Election 1";
        const result = await contractInstance.createElection(electionName);
        truffleAssert.eventEmitted(result, 'ElectionAdded', (event) => event.id && event.name === electionName );
    });

    it('Should Fetch All elections', async () => {
        //Given
        const election1 = { name: 'Election 1' };
        const election1Id = await generatorService.addElection(election1.name, alice);
        const election2 = { name: 'Election 2' };
        const election2Id = await generatorService.addElection(election2.name, alice);

        //When
        const electionsToDecode = await contractInstance.allElections();

        const elections = electionCoder.decodeElectionList(electionsToDecode);

        //Then
        const firstElection = elections.find(election => election.id === election1Id);
        assert.equal(firstElection.name, election1.name);
        assert.equal(firstElection.state, ElectionState.APPLICATION);

        const secondElection = elections.find(election => election.id === election2Id);
        assert.equal(secondElection.name, election2.name);
        assert.equal(secondElection.state, ElectionState.APPLICATION);

    });

    it('Should change election state from Application to VOTE', async () => {
        //Given
        const election = { name: 'Election 1' };
        const electionId = await generatorService.addElection(election.name, alice);

        //When
        const transaction = await contractInstance.nextStep(electionId, {from : alice});
        truffleAssert.eventEmitted(transaction, 'ChangeElectionState', (event) => {
            const currentState = electionCoder.decodeElectionState(event.state.toNumber());
            assert.notEqual(currentState, ElectionState.APPLICATION);
            return currentState  === ElectionState.VOTE ;
        });
    });

    it('Should change election state from VOTE to RESULTS', async () => {
        //Given
        const election = { name: 'Election 1' };
        const electionId = await generatorService.addElection(election.name, alice);

        //When
        await contractInstance.nextStep(electionId, {from : alice}); //APPLICATION State
        const transaction = await contractInstance.nextStep(electionId, {from : alice});//VOTE State

        truffleAssert.eventEmitted(transaction, 'ChangeElectionState', (event) => {
            const currentState = electionCoder.decodeElectionState(event.state.toNumber());
            assert.notEqual(currentState, ElectionState.APPLICATION);
            assert.notEqual(currentState, ElectionState.VOTE);
            return currentState  === ElectionState.RESULTS ;
        });
    });

    it('Should not change the election state if you call nextStep and your are not the owner of the election', async () => {
        const election = { name: 'Election 1' };
        const electionId = await generatorService.addElection(election.name, alice);

        await truffleAssert.fails(
            //When
            contractInstance.nextStep(electionId, {from : bob}),  // bob is not the owner of the election, it's alice
            //Then
            truffleAssert.ErrorType.REVERT,
            'only election\'s owner'
        );

    });

    it('Should fetch election by ID', async () => {
        const electionToCreate = { name: 'Election 1' };
        const electionId = await generatorService.addElection(electionToCreate.name, alice);
        const electionToDecode = await contractInstance.fetchElectionByID(electionId,  {from: alice});
        const election = electionCoder.decodeElection(electionToDecode);
        assert.equal(election.name, electionToCreate.name);

    });

    it('Should fail when fetch an election by ID when we have 0 elections', async () => {
        await truffleAssert.fails(
            //When
            contractInstance.fetchElectionByID(0,  {from: alice}),
            //Then
            truffleAssert.ErrorType.REVERT,
            'We have 0 elections .'
        );
    });

    it('Should fail when fetch an election by  wrong ID', async () => {
        const electionToCreate = { name: 'Election 1' };
        await generatorService.addElection(electionToCreate.name, alice);
        await truffleAssert.fails(
            //When
            contractInstance.fetchElectionByID(2,  {from: alice}),
            //Then
            truffleAssert.ErrorType.REVERT,
            'Election doesn\'t exists .'
        );
    });
});

