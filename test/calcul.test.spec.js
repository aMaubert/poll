const Poll = artifacts.require('Poll');

contract('Poll contract', (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance ;

    beforeEach( async () => {
        contractInstance = await Poll.new();
    })

    /*it('Divide(5,2,2) Should return 2,50', async () => {
        const result = await contractInstance.divide(5,2,2);
        console.log({result});
        assert.equal(result, "2,50");
    })

    it('formatStringNumber("250",2) Should return 2,50', async () => {
        const result = await contractInstance.formatStringNumber("250",2);
        console.log({result});
        assert.equal(result, "2,50");
    })*/

})