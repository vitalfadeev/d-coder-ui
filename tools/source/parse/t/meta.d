module parse.t.meta;

import parse.t.tokenize : Tok;
import parse.t.parser : ParsedElement;


void parseSection_meta( R )( R range, Tok[] tokenized, size_t indent, ParsedElement* bodyElement )
{
    import std.string : stripRight;

    const
    string[] properties = 
    [
        "width",
        "height",
        "style",
        "show",
    ];

}

