module parse.t.body;

import stringiterator   : StringIterator;
import parse.t.tokenize : readIndent;
import parse.t.tokenize : readIndent;
import parse.t.e        : parseTag_e;


string[] tags = 
[ 
    "e" 
];


void parseSection_body( R )( R range, ref Doc doc )
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
    import parse.t.tokenize : TokType;
    import parse.css.border : parse_border;

    string[] bodyProperties = 
    [
        "border",
    ];

    size_t indentLength;

    // by line
    foreach ( line; range )
    {
        line = line.stripRight();

        if ( line.length > 0 )
        {
            //
            auto tokenized = tokenize( line, indentLength );
            string[] parsed;

            // body property
            if ( tokenized.front.type == TokType.property )
            {
                static
                foreach ( PROP; bodyProperties )
                {
                    if ( word == PROP )
                    {
                        mixin ( "parse_" ~ PROP ~ "( tokenized, parsed );" );
                        continue;
                    }
                }
            }
            else

            // tag
            if ( tokenized.front.type == TokType.tag )
            {
                static
                foreach ( TAG; tags )
                {
                    if ( word == TAG )
                    {
                        mixin ( "parse_" ~ TAG ~ "( range, word, tokenized, indentLength, parsed );" );
                        continue;
                    }
                }
            }
            else

            // ignore wrong
            {
                //
            }
        }
    }
}

