module parse.t.meta;

import parse.t.tokenize : Tok;
import parse.t.parser : ParsedElement;
import parse.t.parser : Doc;


void parseSection_meta( R )( R range, Tok[] tokenized, size_t indent, Doc* doc )
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

