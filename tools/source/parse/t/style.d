module parse.t.style;

import std.range        : front;
import std.range        : back;
import std.range        : empty;
import std.range        : popFront;
import std.stdio        : writeln;
import std.string       : stripRight;
import std.string       : splitLines;
import stringiterator   : StringIterator;
import parse.css.border : parse_border;
import parse.t.tokenize : Tok;
import parse.t.parser   : ParsedElement;
import parse.t.tokenize : readIndent;
import parse.t.tokenize : readClass;
import parse.t.tokenize : skipSpaces;
import parse.t.tokenize : readKeyword;
import parse.t.tokenize : readKeywordArgs;
import parse.t.tokenize : TokType;
import parse.t.parser   : Doc;
import parse.t.parser   : ParsedClass;
import parse.t.parser   : StyleSection;
import parse.t.tokenize : readColon;
import parse.t.charreader : CharReader;
import std.string : startsWith;
import std.conv : to;


void parseSection_style( R )( ref R range, Tok[] tokenized, size_t indent, Doc* doc )
{
    size_t indentLength;
    ParsedClass* curElement;

    const
    string[] properties = 
    [
        "border",
    ];

    StyleSection* styleSection = &doc.style;

    // skip 'style' line
    range.popFront();

    //
    if ( !range.empty )
    for ( string line; !range.empty; range.popFront() )
    {
        line = range.front;

        tokenized = tokenize( line, &indentLength );

        // style
        if ( tokenized.front.type == TokType.className )
        {
            curElement = new ParsedClass();
            curElement.className = tokenized.front.s;
            styleSection.classes ~= curElement;
        }
        else

        // property
        if ( tokenized.front.type == TokType.property )
        {
            if ( curElement !is null )
            {
                auto word = tokenized.front.s;

                static
                foreach( PROP; properties )
                {
                    if ( word == PROP )
                    {
                        writeln( "parse_", PROP );
                        mixin( "parse_" ~ PROP ~ "( tokenized, curElement.setters );" );
                        writeln( "parsed_", PROP, ": ", curElement.setters );
                    }
                }
            }
            else

            //
            {
                assert( 0, "error: class name expected before: " ~ tokenized.to!string );
            }

        }
    }
}


// style
//  stage
//    border: 1px solid
//
// [ "stage" ]
// [ "border", ":", "1px", "solid" ]

Tok[] tokenize( string s, size_t* indentLength )
{
    Tok[] tokenized;

    auto reader = CharReader( s );

    // indent
    readIndent( reader, indentLength );

    // keyword
    readKeyword( reader, tokenized );

    // skip spaces
    skipSpaces( reader );

    // class or property
    if ( !reader.empty )
    {
        auto c = reader.front;

        // property. format is: "keyword: args"
        if ( c.startsWith( ":" ) )
        {
            // update 1st token type
            tokenized.back.type = TokType.property;

            // :
            readColon( reader, tokenized );

            // skip spaces
            skipSpaces( reader );

            // ...
            readKeywordArgs( reader, tokenized );
        }
        else

        // class. format is: "stage"
        {
            // update 1st token type
            tokenized.back.type = TokType.className;
        }
    }
    else

    // class. format is: "stage"
    {
        // update 1st token type
        tokenized.back.type = TokType.className;
    }        

    return tokenized;
}


