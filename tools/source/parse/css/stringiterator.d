module stringiterator;


class StringIterator
{
    string s;
    size_t pos;
    size_t dcharsReaded;
    size_t nextPos;
    dchar  front;

    this( ref string s, size_t startPos=0 )
    {
        import std.utf : decode;

        this.s       = s;
        this.pos     = startPos;
        this.nextPos = startPos;

        if ( startPos < s.length )
        {
            front = s.decode( nextPos );
            dcharsReaded++;
        }
    }

    void popFront()
    {
        import std.utf : decode;
        
        pos = nextPos;

        if ( nextPos < s.length )
        {
            front = s.decode( nextPos );
            dcharsReaded++;
        }
    }

    bool empty()
    {
        return pos == s.length;
    }

    //
    string rest()
    {
        return s[ pos .. $ ];
    }
}
