module parse.t.linereader;

import parse.t.charreader : CharReader;


struct LineReader
{
    CharReader stream;

    this( string s )
    {
        stream = CharReader( s );
    }

    this( CharReader reader )
    {
        stream = reader;
    }

    bool empty()
    {
        import std.range : empty;
        return stream.empty;
    }

    string front()
    {
        import std.range : popFront;

        string _front;

        // each Unicode Char Sequence
        foreach ( s; stream )
        {
            _front ~= s;

            if ( isNewLine( s ) )
            {
                break;
            }
        }

        return _front;
    }        

    void popFront()
    {
        import std.range : popFront;

        // each Unicode Char Sequence
        for ( ; !stream.empty; stream.popFront() )
        {
            if ( isNewLine( stream.front ) )
            {
                stream.popFront();
                break;
            }
        }
    }

    typeof( this ) save()
    {
        return this;
    }
}

bool isNewLine( string s )
{
    import std.string : startsWith;
    return s.startsWith( "\n" );
}

