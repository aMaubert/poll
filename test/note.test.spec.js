const Note = artifacts.require('Poll');

contract('Poll', (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance;

    beforeEach( async () => {
        contractInstance = await Poll.new(10);
    })

    /*it('New Note(10) should return Level.LEVEL3', async () => {
        const result = await contractInstance._createNote(10);
        assert.equal(result, Note.Level.LEVEL3);
    })

    it('Test should return Level.DEFAULT', async () => {
        const result = await contractInstance.test();
        console.log({result});
        assert.equal(result, "DEFAULT");
    })

    afterEach(async () => {
        await contractInstance.kill();
    });*/

})
