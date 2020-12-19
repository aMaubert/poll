class CandidateCoder {
    decodeCandidateList(input) {
        const addresses = input['0'];
        const names = input['1'];
        const firstNames = input['2'];

        if( !Array.isArray(addresses) || !Array.isArray(names) || !Array.isArray(firstNames) ||
            addresses.length !== names.length || names.length !== firstNames.length) {
            throw new Error('Can\'t encode this input into candidate list .');
        }
        const candidates = [];
        for(let i = 0; i < addresses.length; i++) {
            const candidate = {address: addresses[i], name: names[i], firstName: firstNames[i]};
            candidates.push(candidate);
        }
        return candidates;
    }
}

module.exports = new CandidateCoder();
