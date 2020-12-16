const Poll = artifacts.require('Poll');
const truffleAssert = require('truffle-assertions');
const fromWei = require('web3').utils.fromWei;

contract('Poll contract', (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance ;

    beforeEach( async () => {
        contractInstance = await Poll.new();
    })

    it('Should return float', async () => {
        const electionName = "Election 1";
        const result = await contractInstance.createElection(electionName);
        truffleAssert.eventEmitted(result, 'ElectionAdded', async (event) => {
            console.log({id: event.id});
            try{
                const results = await contractInstance.allElections();
                let ids = results[0];
                ids = ids.map(id => id.toNumber());
                const candidates = await contractInstance.allCandidatesByElectionID(ids[0]);

                console.log({candidates});
                const votes = await contractInstance.allVotesByElectionID(ids[0]);
                console.log({votes});
            } catch (error ) {
                console.error({error});
            }
            return event.id && event.name === electionName ;

        });
    })
})

