const Poll = artifacts.require('Poll');

contract('Poll contract', (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance ;

    beforeEach( async () => {
        contractInstance = await Poll.new();
    })

    it('Should return pong', async () => {
        const result = await contractInstance.pingTest();
        assert.equal(result, 'Pong');
    })

    it('Should return float', async () => {
        const result = await contractInstance.floatTest(20, 3);
        assert.equal(result, 666);
    })
})



