module ui.parse.t.style;

import std.range                   : front;
import std.range                   : back;
import std.range                   : empty;
import std.range                   : popFront;
import std.stdio                   : writeln;
import std.string                  : stripRight;
import std.string                  : splitLines;
import ui.parse.css.stringiterator : StringIterator;
import ui.parse.t.tokenize         : Tok;
import ui.parse.t.parser           : ParsedElement;
import ui.parse.t.tokenize         : readIndent;
import ui.parse.t.tokenize         : readClass;
import ui.parse.t.tokenize         : skipSpaces;
import ui.parse.t.tokenize         : readKeyword;
import ui.parse.t.tokenize         : readKeywordArgs;
import ui.parse.t.tokenize         : TokType;
import ui.parse.t.parser           : Doc;
import ui.parse.t.parser           : ParsedClass;
import ui.parse.t.parser           : StyleSection;
import ui.parse.t.tokenize         : readColon;
import ui.parse.t.charreader       : CharReader;
import std.string                  : startsWith;
import std.conv                    : to;
import std.string                  : replace;
import log                         : Log;


void parseSection_style( R )( ref R range, Tok[] tokenized, size_t indent, Doc* doc )
{
    size_t indentLength;
    ParsedClass* curElement;

    const
    string[] properties = 
    [
        "display",
        "position",
        "margin",
        "margin-left",
        "margin-top",
        "margin-right",
        "margin-bottom",
        "padding",
        "padding-top",
        "padding-right",
        "padding-bottom",
        "padding-left",
        "border",
        "border-top",
        "border-right",
        "border-bottom",
        "border-left",
        "width",
        "height",
        //"left",
        //"top",
        //"right",
        //"bottom",
        //
        "on",
    ];

    StyleSection* styleSection = &doc.style;

    // skip 'style' line
    range.popFront();

    //
    if ( !range.empty )
    for ( string line; !range.empty; range.popFront() )
    {
    parse_readed_line:
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

                // property: ...
                static
                foreach( PROP; properties )
                {
                    // on: ...
                    static
                    if ( PROP == "on" )
                    {
                        if ( word == "on" )
                        {
                            import ui.parse.t.on : parse_on;
                            if ( parse_on( range, tokenized, indentLength, curElement.eventCallbacks ) )
                            {
                                goto parse_readed_line; // OK
                            }
                            else
                            {
                                Log.error( "parse: " ~ line ); // FAIL
                            }
                        }
                    }
                    else

                    // border:..., color:..., background:...
                    if ( word == PROP )
                    {
                        mixin( 
                            format!
                            q{
                                import ui.parse.css.%s : parse_%s;
                                if ( parse_%s( tokenized, curElement.setters )() )
                                {
                                    // OK
                                }
                                else
                                {
                                    Log.error( "parse: " ~ line ); // FAIL
                                }
                            }
                            ( 
                                PROP.replace( "-", "_" ), PROP.replace( "-", "_" ), 
                                PROP.replace( "-", "_" ) 
                            )
                            );
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


