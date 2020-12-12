const Poll = artifacts.require('Poll');

contract('Candidat contract', (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance ;

    beforeEach( async () => {
        contractInstance = await Poll.new();
    })


})
