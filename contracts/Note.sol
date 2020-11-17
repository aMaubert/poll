pragma solidity ^0.4.0;

contract Note {
    uint max_note = 20;
    struct Note {
        uint8 note;
    }

    modifier checkNote(uint note) {
        require(
            note < max_note,
            "The note is too high"
        );
        _;
    }

    function _createNote(uint8 note) private checkNote returns(Note){
        return Note(note);
    }
}
