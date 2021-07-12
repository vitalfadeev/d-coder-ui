module ui.parse.css.color_hex;

import ui.parse.css.types;


bool parse_color_hex( string s, Color* color )
{
    import std.algorithm : startsWith;
    import std.string : strip;

    if ( s.length == 4 )
    {
        return parse_color_hex3( s, color );
    }
    else
    if ( s.length == 7 )
    {
        return parse_color_hex6( s, color );
    }

    return false;
}

bool parse_color_hex3( string s, Color* color )
{
    // #CCC

    import std.conv : to;

    *color = 
        Color(
            to!ubyte( to!ubyte( s[ 1 .. 2 ], 16 ) << 4 ),
            to!ubyte( to!ubyte( s[ 2 .. 3 ], 16 ) << 4 ),
            to!ubyte( to!ubyte( s[ 3 .. 4 ], 16 ) << 4 )
        );

    return true;
}


bool parse_color_hex6( string s, Color* color )
{
    // #CCDDEE

    import std.conv : to;

    *color = 
        Color(
            to!ubyte( s[ 1 .. 3 ], 16 ),
            to!ubyte( s[ 3 .. 5 ], 16 ),
            to!ubyte( s[ 5 .. 7 ], 16 )
        );

    return true;
}
