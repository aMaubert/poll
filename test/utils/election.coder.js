const ElectionState = require('./election-state.enum');

const ElectionStateDecode = Object.freeze({
    0: 'APPLICATION',
    1: 'VOTE',
    2: 'RESULTS'
});


class ElectionCoder {

    decodeElectionState(state){
        return ElectionState[ElectionStateDecode[state.toString()]] ;
    }


    decodeElectionList(input) {
        const ids = input['0'];
        const names = input['1'];
        const states = input['2'];

        if (!Array.isArray(ids) || !Array.isArray(names) || !Array.isArray(states) ||
            ids.length !== names.length || names.length !== states.length) {
            throw new Error('Can\'t encode this input into election list .');
        }

        const elections = [];

        for(let i = 0; i < ids.length; i++) {
            const election = {id: ids[i].toNumber(), name: names[i], state: this.decodeElectionState(states[i]) };
            elections.push(election);
        }

        return elections;
    }

    decodeMediansList(input) {
        console.log(input);
        const names = input['0'];
        const firstNames = input['1'];
        const addresses = input['2'];
        const medians = input['3'];
        const averages = input['4'];


        if (!Array.isArray(names) || !Array.isArray(firstNames) || !Array.isArray(addresses) || !Array.isArray(medians) || !Array.isArray(averages) ||
            names.length !== firstNames.length || firstNames.length !== addresses.length || addresses.length !== medians.length || medians.length !== averages.length) {
            throw new Error('Can\'t decode this input into result list .');
        }


        const results = [];
        for(let i = 0; i < names.length; i++) {
            const result = {name: names[i], firstName: firstNames[i], address: addresses[i], median: medians[i].toNumber()/100, average: averages[i].toNumber()/100};
            results.push(result);
        }

        return results;
    }


    decodeElection(input) {
        const id = input['0'];
        const name = input['1'];
        const state = input['2'];
        return {id: id.toNumber(), name: name, state: this.decodeElectionState(state)};
    }
}

module.exports = new ElectionCoder();
