module parse.t.head;

import parse.t.parser : Doc;
import parse.t.tokenize : Tok;
import parse.t.parser : ParsedElement;


void parseSection_head( R )( R range, Tok[] tokenized, size_t indent, Doc* doc )
{
    import std.string : stripRight;

    const
    string[] properties = 
    [
        "title",
    ];
}
