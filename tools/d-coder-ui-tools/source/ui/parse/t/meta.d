module ui.parse.t.meta;

import ui.parse.t.tokenize : Tok;
import ui.parse.t.parser : ParsedElement;
import ui.parse.t.parser : Doc;


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

