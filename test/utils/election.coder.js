const ElectionState = require('./election-state.enum');

const ElectionStateDecode = Object.freeze({
    0: 'APPLICATION',
    1: 'VOTE',
    2: 'RESULTS'
});

const decodeElectionState = (state) => ElectionState[ElectionStateDecode[state.toString()]] ;

class ElectionCoder {

    decodeCandidateList(input) {
        const ids = input['0'];
        const names = input['1'];
        const states = input['2'];

        if (!Array.isArray(ids) || !Array.isArray(names) || !Array.isArray(states) ||
            ids.length !== names.length || names.length !== states.length) {
            throw new Error('Can\'t encode this input into election list .');
        }

        const elections = [];

        for(let i = 0; i < ids.length; i++) {
            const election = {id: ids[i].toNumber(), name: names[i], state: decodeElectionState(states[i]) };
            elections.push(election);
        }

        return elections;
    }
}

module.exports = new ElectionCoder();
