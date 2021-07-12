module ui.parse.t.head;

import ui.parse.t.parser   : Doc;
import ui.parse.t.tokenize : Tok;
import ui.parse.t.parser   : ParsedElement;


void parseSection_head( R )( R range, Tok[] tokenized, size_t indent, Doc* doc )
{
    import std.string : stripRight;

    const
    string[] properties = 
    [
        "title",
    ];
}
