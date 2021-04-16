module parser;


void parse( string s )
{
    auto tokens = tokenize( "border-image: url( \"images/b.jpg\" )" );

    auto keyword = tokens[0];

    if ( keyword == "border" )
    {
        import parse.css.border;
        string parsed;
        parseBorder( tokenized, parsed );
    }
}
