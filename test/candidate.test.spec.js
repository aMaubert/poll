const Poll = artifacts.require('Poll');
const truffleAssert = require('truffle-assertions');
const GeneratorService = require('./utils').GeneratorService;
const candidateCoder = require('./utils').candidateCoder;

contract('Candidate Factory And Candidate Helper', (accounts) => {
    let [alice, bob, virginie] = accounts;
    let contractInstance ;
    let generatorService;

    beforeEach( async () => {
        contractInstance = await Poll.new();
        generatorService = new GeneratorService(contractInstance);
    })

    it('Should Add a candidate', async () => {
        const electionName = 'Election 1';
        const electionId = await generatorService.addElection(electionName, alice);

        const candidate = {name: 'Maubert', firstName: 'Allan'};
        const addCandidateTransaction = await contractInstance.addCandidate(electionId, candidate.name, candidate.firstName, {from: alice});
        truffleAssert.eventEmitted(addCandidateTransaction, 'CandidateAdded', (event) => event.name === candidate.name && event.firstName === candidate.firstName );
    })

    it('Should fail when you add a candidate to an election that is not in state APPLICATION', async () => {
        const electionName = 'Election 1';
        const electionId = await generatorService.addElection(electionName, alice);
        await generatorService.electionNextStep(electionId, alice);

        const candidate = {name: 'Maubert', firstName: 'Allan'};
        await truffleAssert.fails(
            //When
            contractInstance.addCandidate(electionId, candidate.name, candidate.firstName, {from: alice}),
            //Then
            truffleAssert.ErrorType.REVERT,
            'Can\'t apply to this election .'
        );
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



})
