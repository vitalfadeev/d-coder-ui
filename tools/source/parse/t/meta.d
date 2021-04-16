module parse.t.meta;


void parseSection_meta( R )( R range, string word, string[] tokenized, ref Parsed parsed )
{
    import std.string : stripRight;

    string[] properties = 
    [
        "width",
        "height",
        "style",
        "show",
    ];

    int indentLength;
    string word;

    //
    foreach ( line; range )
    {
        line = line.stripRight();

        if ( line.length > 0 )
        {
            parseIndent( line, &indentLength );

            if ( indentLength == 0 )
            {
                return;
            }

            auto tokenized = tokenize( line );
            word = tokenized[0];

            //
            static
            foreach ( PROP; properties )
            {
                if ( word == PROP )
                {
                    mixin ( "parseMetaProperty_" ~ PROP ~ "( range, word, tokenized, parsed );" );
                    continue;
                }
            }
        }
    }
}

