const Candidate = artifacts.require('Candidate');

contract('Candidat contract', (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance ;

    beforeEach( async () => {
        contractInstance = await Candidate.new();
    })

    it('Should return coucou', async () => {
        const result = await contractInstance.coucouTest();
        assert.equal(result, 'coucou');
    })
})