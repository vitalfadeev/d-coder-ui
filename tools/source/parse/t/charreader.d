module parse.t.charreader;


struct CharReader
{
    string stream;
    string start;
    size_t numCodeUnits;

    this( string s )
    {
        stream = s;
        start  = s;
    }

    bool empty()
    {
        import std.range : empty;
        return stream.empty;
    }

    string front()
    {
        import std.utf : stride;

        numCodeUnits = stream.stride();
        string _front = stream[ 0 .. numCodeUnits ];

        return _front;
    }

    void popFront()
    {
        import std.utf : stride;

        numCodeUnits = stream.stride();
        stream = stream[ numCodeUnits .. $ ];
    }

    typeof( this ) save()
    {
        return this;
    }

    auto getState()
    {
        return State( stream, start );
    }

    auto opBinary( string op : "-" )( State b )
    {
        return this.stream.ptr - b.s.ptr; // size_t
    }

    auto opEquals( State b )
    {
        return this.stream.ptr == b.s.ptr; // bool
    }

    auto readedOf( ref State state )
    {
        return state.s[ 0 .. this.stream.ptr - state.s.ptr ];
    }
}


struct State
{
    string s;
    string start;

    auto pos()
    {
        return s.ptr - start.ptr;
    }
}
