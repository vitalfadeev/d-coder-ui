module ui.parse.t.e;

import std.range           : front;
import std.conv            : to;
import std.stdio           : writeln;
import std.range           : popFront;
import ui.parse.t.tokenize : Tok;
import ui.parse.t.parser   : ParsedElement;
import ui.parse.t.parser   : attachTo;
import ui.parse.t.tokenize : tokenize;
import ui.parse.t.tokenize : TokType;
import ui.parse.css.border : parse_border;
import ui.parse.css.width  : parse_width;
import ui.parse.css.height : parse_height;


void parse_tag_e( R )( ref R range, Tok[] tokenized, size_t indent, ParsedElement* parentElement )
{
    import std.string : stripRight;
    import std.range  : empty;
    import std.range  : front;
    import std.range  : popFront;

    const
    string[] tags = 
    [
        "e",
    ];

    const
    string[] properties = 
    [
        "border",
        "width",
        "height",
    ];

    size_t indentLength;
    string word;

    auto element = new ParsedElement( indent, tokenized.front.s, tokenized_classes( tokenized ) );
    element.attachTo( parentElement );

    // skip tag line
    range.popFront();

    //
    if ( !range.empty )
    for ( string line; !range.empty; range.popFront() )
    {
        line = range.front.stripRight();

        if ( line.length > 0 )
        {
            tokenized = tokenize( line, &indentLength );
            word = tokenized.front.s;

            // tags
            if ( tokenized.front.type == TokType.tag )
            {
                static
                foreach ( TAG; tags )
                {
                    if ( word == TAG )
                    {
                        mixin ( "parse_tag_" ~ TAG ~ "( range, tokenized, indentLength, element );" );
                    }
                }            
            }
            else

            // properties
            {
                static
                foreach ( PROP; properties )
                {
                    if ( word == PROP )
                    {
                        mixin ( "parse_" ~ PROP ~ "( tokenized, element.setters );" );
                    }
                }
            }
        }

        if ( range.empty )
        {
            break;
        }
    }
}


//string tokenized_id( Tok[] tokenized )
//{
//    import std.algorithm : filter;
//    import std.algorithm : map;
//    import std.array     : array;
//    import std.range     : front;
//    import std.range     : take;
//    import std.range     : empty;

//    auto range =
//        tokenized
//            .filter!( t => t.type == TokType.id )
//            .map!( t => t.s )
//            .take(1);

//    return range.empty ? "" : range.front; 
//}

string[] tokenized_classes( Tok[] tokenized )
{
    import std.algorithm : filter;
    import std.algorithm : map;
    import std.array     : array;

    return
        tokenized
            .filter!( t => t.type == TokType.className )
            .map!( t => t.s )
            .array;
}
