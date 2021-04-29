module parse.t.body;

import stringiterator   : StringIterator;
import parse.t.parser   : ParsedElement;
import parse.t.tokenize : readIndent;
import parse.t.tokenize : readIndent;
import parse.t.tokenize : tokenize;
import parse.t.tokenize : Tok;
import parse.t.e        : parse_tag_e;
import std.conv : to;
import std.stdio : writeln;
import parse.t.parser : Doc;
import std.range : popFront;


void parseSection_body( R )( ref R range, Tok[] tokenized, size_t indent, Doc* doc )
{
    // body .className #id
    //   e .className .className #id
    //     e
    //     e
    //
    // doc.body:
    // ParsedElement { classes: [ className ], id: id, tag: body }
    //   ParsedElement
    //     ParsedElement
    //     ParsedElement
    import std.string       : stripRight;
    import std.range        : front;
    import std.range        : empty;
    import parse.t.tokenize : TokType;
    import parse.css.border : parse_border;

    const
    string[] tags = 
    [ 
        "e" 
    ];

    auto bodyElement = &doc.body;

    // 
    bodyElement.tagName = "body";
    bodyElement.indentLength = indent;

    size_t indentLength;

    // skip body line
    range.popFront();

    // lines under body
    if ( !range.empty )
    for ( string line; !range.empty; range.popFront() )
    {
        line = range.front;

        tokenized = tokenize( line.stripRight, &indentLength );

        // tag
        if ( tokenized.front.type == TokType.tag )
        {
            static
            foreach( TAG; tags )
            {
                if ( tokenized.front.s == TAG )
                {
                    mixin ( "parse_tag_" ~ TAG ~ "( range, tokenized, indentLength, bodyElement );" );
                }
            }
        }
        else

        // body property
        if ( tokenized.front.type == TokType.property )
        {
            const
            string[] bodyProperties = 
            [
                "border",
            ];

            auto word = tokenized.front.s;

            static
            foreach ( PROP; bodyProperties )
            {
                if ( word == PROP )
                {
                    mixin ( "parse_" ~ PROP ~ "( tokenized, bodyElement.setters );" );
                }
            }
        }
        else

        // ignore wrong
        {
            //
        }

        if ( range.empty )
        {
            break;
        }
    }
}

