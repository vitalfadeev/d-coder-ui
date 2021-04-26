module parse.t.e;

import parse.t.tokenize : Tok;
import parse.t.parser : ParsedElement;
import std.range : front;
import parse.t.parser : attachTo;
import parse.t.tokenize : tokenize;
import std.conv : to;
import parse.t.tokenize : TokType;
import parse.css.border : parse_border;
import std.stdio : writeln;
import std.range : popFront;


void parse_tag_e( R )( R range, Tok[] tokenized, size_t indent, ParsedElement* parentElement )
{
    import std.string : stripRight;

    const
    string[] tags = 
    [
        "e",
    ];

    const
    string[] properties = 
    [
        "border",
    ];

    size_t indentLength;
    string word;

    auto element = new ParsedElement( indent, tokenized.front.s, tokenized_id( tokenized ), tokenized_classes( tokenized ) );
    element.attachTo( parentElement );

    // skip tag line
    range.popFront();

    //
    foreach ( line; range )
    {
        line = line.stripRight();

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
    }
}


string tokenized_id( Tok[] tokenized )
{
    import std.algorithm : filter;
    import std.algorithm : map;
    import std.array     : array;
    import std.range     : front;
    import std.range     : take;
    import std.range     : empty;

    auto range =
        tokenized
            .filter!( t => t.type == TokType.id )
            .map!( t => t.s )
            .take(1);

    return range.empty ? "" : range.front; 
}

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
