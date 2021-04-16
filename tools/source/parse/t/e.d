module parse.t.e;


void parseTag_e( R )( R range, string word, string[] tokenized, int startIndent, ref Parsed parsed )
{
    import std.string : stripRight;

    string[] properties = 
    [
        "border",
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

            //
            if ( indentLength > startIndent )
            {
                // parent = prev
                // parent.appendChild( cur )
                // parent.setProperty( cur )
            }
            else

            if ( indentLength == startIndent )
            {
                // parent.appendChild( cur )
                // parent.setProperty( cur )
            }
            else

            if ( indentLength < startIndent )
            {
                // find parent
                // parent.appendChild( cur )
                // parent.setProperty( cur )
            }

            //
            auto tokenized = tokenize( line );
            word = tokenized[0];

            // properties
            static
            foreach ( PROP; properties )
            {
                if ( word == PROP )
                {
                    mixin ( "parseElementProperty_" ~ PROP ~ "( range, word, tokenized, parsed );" );
                    continue;
                }
            }

            // tags
            static
            foreach ( TAG; tags )
            {
                if ( word == TAG )
                {
                    mixin ( "parseTag_" ~ TAG ~ "( range, word, tokenized, indentLength, parsed );" );
                    continue;
                }
            }            
        }
    }
}


