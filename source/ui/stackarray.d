module ui.stackarray;

import std.container.array;


/**
 * Stack allocated array
 */
struct StackArray( T, alias N )
{
    size_t length;
    T[N] arr;


nothrow @nogc:
    typeof( this ) opOpAssign( string op : "~" )( T b )
    {
        version ( DEBUG )
        {
            // range check
            if ( length > N )
            {
                assert( 0, "error: array length > " ~ N.stringof );
            }
        }

        arr[ length ] = b;
        length++;

        return this;
    }


    bool empty()
    {
        return length == 0;
    }


    T* createOne()
    {
        version ( DEBUG )
        {
            // range check
            if ( length > N )
            {
                assert( 0, "error: array length > " ~ N.stringof );
            }
        }

        length++;

        return &arr[ length-1 ];
    }


    int opApply( int delegate( ref T ) nothrow @nogc dg )
    {
        int result = 0;

        for ( size_t i; i < length; i++ )
        {
            result = dg( arr[ i ] );

            if ( result )
            {
                break;
            }
        }

        return result;
    }
}
