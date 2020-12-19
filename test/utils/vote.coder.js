class VoteCoder {
    decodeVoteList(input, candidatesCount) {
        const voters = input[0];
        const candidatesAddress = input[1];
        const notes = input[1];


        if (!Array.isArray(voters) || !Array.isArray(candidatesAddress) || !Array.isArray(notes) ||
            candidatesAddress.length !== notes.length) {
            throw new Error('Can\'t encode this input into election list .');
        }

        const votes = [];
        console.log({notes, candidatesAddress});

        for(let i = 0; i < voters.length; i++) {
            const tmpNotes = [];
            const tmpCandidatesAddress = [];



            for(let j = i; j < i + candidatesCount; j++) {
                tmpNotes.push(notes[j].toNumber());
                tmpCandidatesAddress.push(candidatesAddress[j]);
            }
            let ballot = {};
            for(let j = 0; j < candidatesCount; j++) {
                ballot[tmpCandidatesAddress[j]] = tmpNotes[j];
            }
            const vote = {voter: voters[i], ballot };
            votes.push(vote);
        }
        return votes;

    }

}

module.exports = new VoteCoder();
