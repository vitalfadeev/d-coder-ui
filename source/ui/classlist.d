module ui.classlist;

import ui.classregistry : Class;
import ui.base : MAX_ELEMENT_CLASSES;


struct ClassList
{
    size_t length;
    Class*[ MAX_ELEMENT_CLASSES ] lst;
    alias lst this;

    bool has( Class* cls )
    {
        foreach ( c; lst[ 0 .. length ] )
        {
            if ( c == cls )
                return true;
        }

        return false;
    }

    void opOpAssign( string op : "~" )( Class* cls )
    {
        import std.conv : to;

        if ( length < MAX_ELEMENT_CLASSES-1 )
        {
            lst[ length ] = cls;
            length += 1;
        }
        else
        {
            assert( 0, "error: out of range: ClassList.lst: " ~ length.to!string ~ " > " ~ MAX_ELEMENT_CLASSES.to!string);
        }

    }

    int opApply( int delegate( Class* ) dg )
    {
        int result = 0;

        foreach ( cls; lst[ 0 .. length ] )
        {
            result = dg( cls );

            if ( result ) 
            {
                break;
            }
        }

        return result;
    }

    size_t countUntil( Class* cls )
    {
        foreach ( c; lst[ 0 .. length ] )
        {
            if ( c == cls )
                return true;
        }

        return -1;
    }

    void deleteInPlace( size_t a, size_t b )
    {
        lst[ 0 .. length-(b-a) ] = lst[ 0 .. a ] ~ lst[ b .. length ];
        length -= b-a;
    }

    string toString()
    {
        string s;

        foreach ( cls; lst[ 0 .. length ] )
        {
            s ~= cls.name ~ ", ";
        }

        if ( s.length > 2 )
        {
            s = s[ 0 .. $-2 ];
        }

        return s;
    }
}


