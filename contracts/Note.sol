pragma solidity >=0.4.22 <0.8.0;

contract Note {
    uint max_note = 20;
    uint min_note = 0;
    struct Note {
        uint8 note;
    }

    modifier checkNote(uint note) {
        require(
            note <= max_note && note >= min_note,
            "The note is too high or negative"
        );
        _;
    }

    function _createNote(uint8 note) private checkNote(note) returns(Note memory){
        return Note(note);
    }
}
