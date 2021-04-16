module parse.t.head;


void parseSection_head( R )( R range, string word, string[] tokenized, ref Parsed parsed )
{
    import std.string : stripRight;

    string[] properties = 
    [
        "title",
    ];

    int indentLength;

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
                    mixin ( "parseHeadProperty_" ~ PROP ~ "( range, word, tokenized, parsed );" );
                    continue;
                }
            }
        }
    }
}


void parseHeadProperty_title( R )( range, string word, string[] tokenized, ref Parsed parsed )
{
    parsed.head.lst ~= PropRecord( "title", tokenized[1] );
}
