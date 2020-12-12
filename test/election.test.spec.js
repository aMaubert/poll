const Poll = artifacts.require('Poll');
const truffleAssert = require('truffle-assertions');

contract('Poll contract', (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance ;

    beforeEach( async () => {
        contractInstance = await Poll.new();
    })

    it('Should return float', async () => {
        const electionName = "Election 1";
        const result = await contractInstance.createElection(electionName);
        truffleAssert.eventEmitted(result, 'ElectionAdded', (event) => {
            console.log({id: event.id});
            contractInstance.fetchElectionByID(event.id)
                .then(res => {
                    console.log({res: res[3]});
                });
            return event.id && event.name === electionName ;
        });
    })
})
