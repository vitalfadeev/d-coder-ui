module ui.parse.css.rgb;

import ui.parse.css.types;


bool parse_color_rgb( string s, Color* color )
{
    // rgb( 255, 255, 255 )

    import std.array     : split;
    import std.array     : array;
    import std.algorithm : map;
    import std.string    : strip;
    import std.conv      : to;

    string rgbValues = s[ 4 .. $-1 ]; // rgb( 255, 255, 255 ) -> "255, 255, 255"
    string[] splits = rgbValues.split(",").map!( a => a.strip ).array;

    *color = 
        Color(
            to!ubyte( splits[0], 10 ),
            to!ubyte( splits[1], 10 ),
            to!ubyte( splits[2], 10 )
        );

    return true;
}
