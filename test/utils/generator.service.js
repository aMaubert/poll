const randomNumber = require('./random.number');

class GeneratorService {
    constructor(contractInstance) {
        this.contractInstance = contractInstance;
    }

    async addElection(electionName, sender) {
        const transaction = await this.contractInstance.createElection(electionName, {from: sender});
        const result = transaction.logs[0].args;
        const {id , name} = result;
        return id.toNumber();
    }

    async addCandidate(electionId,name, firstName, sender) {
        this.contractInstance.addCandidate(electionId,name, firstName, {from: sender});
    }

    async addVotes(electionId, candidates, sender) {
        let candidatesAddress = [];
        let candidatesNote = [];
        candidates.forEach(candidate => {
            candidatesAddress.push(candidate.address);
            //Get a random number between 0 and 20
            candidatesNote.push(randomNumber(20));
        });

        this.contractInstance.addVote(electionId, candidatesAddress, candidatesNote, {from : sender});
        let ret = {};
        for(let i = 0; i < candidatesAddress.length; i++) {
            ret[candidatesAddress[i]] = candidatesNote[i];
        }
        return ret;
    }
}

module.exports = GeneratorService;
