class VoteCoder {
    decodeVoteList(input, candidatesCount) {
        const voters = input[0];
        const candidatesAddress = input[1];
        const notes = input[2];


        if (!Array.isArray(voters) || !Array.isArray(candidatesAddress) || !Array.isArray(notes) ||
            candidatesAddress.length !== notes.length) {
            throw new Error('Can\'t encode this input into election list .');
        }

        const votes = [];

        for(let i = 0; i < voters.length; i++) {
            const tmpNotes = [];
            const tmpCandidatesAddress = [];

            for(let j = 0; j < candidatesCount; j++) {
                tmpNotes.push(notes[(i * candidatesCount) + j].toNumber());
                tmpCandidatesAddress.push(candidatesAddress[(i * candidatesCount) + j]);
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
