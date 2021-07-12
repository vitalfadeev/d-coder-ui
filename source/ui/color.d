module ui.color;

version (windows)
import core.sys.windows.windows : COLORREF;
version (windows)
import core.sys.windows.windows : RGB;

import std.format               : format;
import std.stdio                : writefln;


/** */
struct Color
{
    union
    {
        struct
        {
            ubyte r;
            ubyte g;
            ubyte b;
        }
version (windows)
        COLORREF windowsCOLORREF;
    }
    ubyte a = 0xFF; // 0x00 - transparent, 0xFF - opaque


    /** */
    bool isTransparent()
    {
        return cast( bool ) ( a == 0 );
    }   


    /** */
    bool isOpaque()
    {
        return cast( bool ) ( a != 0 );
    }   


    version ( window )
    pragma( inline )
    void opAssign( uint a )
    {
        windowsCOLORREF = _rgb( a );
    }


version (windows)
    COLORREF opCast( T : COLORREF )()
    {
        return windowsCOLORREF;
    }    


    string toString()
    {
        return format!"Color( 0x%x%x%x )"( r, g, b );
    }


    string asHex()
    {
        return format!"0x%x%x%x"( r, g, b );
    }
}



uint _rgb( uint x )
{
    return 
        cast( uint ) ( 
            ( ( x & 0x000000FF ) << 16 )  |  
            ( ( x & 0x0000FF00 ) )  |  
            ( ( x & 0x00FF0000 ) >> 16 ) 
        );    
}


/** */
Color rgb( uint x )
{
    return 
        Color( 
            ( x & 0x00FF0000 ) >> 16,  // R
            ( x & 0x0000FF00 ) >> 8,   // G
            ( x & 0x000000FF )         // B
        );
}


Color rgb( ubyte r, ubyte g, ubyte b )
{
    return 
        Color( 
            r,  // R
            g,  // G
            b   // B
        );
}


/** */
Color argb( uint x )
{
    return 
        Color(
            ( x & 0x00FF0000 ) >> 16, // R
            ( x & 0x0000FF00 ) >> 8,  // G
            ( x & 0x000000FF ),       // B
            //a: ( x & 0xFF000000 ) >> 24  // A
        );
}


///
unittest
{
    auto color = 0xAABBCC.rgb;

    assert( color.windowsCOLORREF == RGB( 0xAA, 0xBB, 0xCC ) );

    assert( color.b == 0xCC );
    assert( color.g == 0xBB );
    assert( color.r == 0xAA );
    assert( color.a == 0xFF );
}

///
unittest
{
    auto color = 0xAABBCC.rgb;
    assert( !color.isTransparent );
}

//
unittest
{
    auto color = ( 0x00AABBCC ).argb;
    assert( color.windowsCOLORREF == RGB( 0xAA, 0xBB, 0xCC ) );
    assert( color.isTransparent );
}

//
unittest
{
    auto color = ( 0xFFAABBCC ).argb;
    assert( color.windowsCOLORREF == RGB( 0xAA, 0xBB, 0xCC ) );
    assert( !color.isTransparent );
}

