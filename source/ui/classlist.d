module ui.classlist;

import ui.classregistry : Class;
import ui.base : MAX_ELEMENT_CLASSES;
import std.stdio : writeln;


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
        import std.algorithm : countUntil;
        return lst[ 0 .. length ].countUntil( cls );
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


version ( ClassList2 )
{
    import ui.base : ClassId;
    import ui.classregistry : classReg2;

    struct ClassList2
    {
        ClassId classes; // bitset. for x86_64 = 64
        size_t orderLength;
        ubyte[ MAX_ELEMENT_CLASSES ] order;

        bool has( ClassId classId )
        {
            return ( classes & classId ) != 0;
        }

        bool has( T )()
          if ( is( T == struct ) )
        {
            return has( T.init.classId );
        }

        void opOpAssign( string op : "~" )( ClassId classId )
        {
            add( classId );
        }

        void add( ClassId classId )
        {
            remove( classId );

            classes |= classId;

            order[ orderLength ] = classId;
            orderLength += 1;
        }

        void add( T )()
          if ( is( T == struct ) )
        {
            add( T.init.classId );
        }

        void remove( ClassId classId )
        {
            import std.algorithm : countUntil;
     
            if ( has( classId ) )
            {
                auto pos = order[ 0 .. orderLength ].countUntil( classId );

                order[ pos .. orderLength-1 ] = order[ pos+1 .. orderLength ];
                orderLength -= 1;

                classes &= classId;
            }
        }

        void remove( T )()
          if ( is( T == struct ) )
        {
            remove( T.init.classId );
        }

        int opApply( int delegate( ref Class ) dg )
        {
            int result = 0;

            foreach ( ref clsId; order[ 0 .. orderLength ] )
            {
                result = dg( classReg2.classes[ clsId ] );

                if ( result ) 
                {
                    break;
                }
            }

            return result;
        }
    }
}
