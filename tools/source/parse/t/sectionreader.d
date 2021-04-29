module parse.t.sectionreader;

import parse.t.linereader : LineReader;


struct SectionReader
{
    LineReader stream;

    this( string s )
    {
        stream = LineReader( s );
    }

    this( LineReader reader )
    {
        stream = reader;
    }

    bool empty()
    {
        import std.range : empty;
        return stream.empty;
    }

    string[] front()
    {
        import std.range : empty;
        import std.range : front;
        import std.range : popFront;

        string[] _front;

        // take 1st line
        _front ~= stream.front;
        stream.popFront();

        // take next lines
        foreach ( line; stream )
        {
            if ( isNotWhite( line ) )
            {
                break;
            }

            _front ~= line;
        }

        return _front;
    }

    void popFront()
    {
        import std.range : empty;

        // skip 1st
        stream.popFront();

        // skip section lines
        for ( ; !stream.empty; stream.popFront() )
        {
            if ( isNotWhite( stream.front ) )
            {
                break;
            }
        }
    }
}


bool isNotWhite( string s )
{
    import std.string : startsWith;
    return !s.startsWith( " " );
}
