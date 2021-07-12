module ui.parse.t.sectionreader;

import ui.parse.t.linereader : LineReader;


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
        import std.range  : empty;
        import std.range  : front;
        import std.range  : popFront;
        import std.string : stripRight;

        string[] _front;

        // take 1st line
        _front ~= stream.front;
        stream.popFront();

        // take next lines
        if ( !stream.empty )
        foreach ( line; stream )
        {
            // skip empty lines
            if ( line.stripRight.length == 0 )
            {
                continue;
            }

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
        import std.range  : empty;
        import std.range  : front;
        import std.string : stripRight;

        // skip 1st
        stream.popFront();

        // skip section lines
        if ( !stream.empty )
        for ( ; !stream.empty; stream.popFront() )
        {
            // skip empty lines
            if ( stream.front.stripRight.length == 0 )
            {
                continue;
            }

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
