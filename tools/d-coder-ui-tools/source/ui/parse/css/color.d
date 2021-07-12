module ui.parse.css.color;

/+
/* These syntax variations all specify the same color: a fully opaque hot pink. */

/* Hexadecimal syntax */
#f09
#F09
#ff0099
#FF0099

/* Functional syntax */
rgb(255,0,153)
rgb(255, 0, 153)
rgb(255, 0, 153.0)
rgb(100%,0%,60%)
rgb(100%, 0%, 60%)
rgb(100%, 0, 60%) /* ERROR! Don't mix numbers and percentages. */
rgb(255 0 153)

/* Hexadecimal syntax with alpha value */
#f09f
#F09F
#ff0099ff
#FF0099FF

/* Functional syntax with alpha value */
rgb(255, 0, 153, 1)
rgb(255, 0, 153, 100%)

/* Whitespace syntax */
rgb(255 0 153 / 1)
rgb(255 0 153 / 100%)

/* Functional syntax with floats value */
rgb(255, 0, 153.6, 1)
rgb(1e2, .5e1, .5e0, +.25e2%)


/* Hexadecimal syntax */
#3a30                    /*   0% opaque green */ 
#3A3F                    /* full opaque green */ 
#33aa3300                /*   0% opaque green */ 
#33AA3380                /*  50% opaque green */ 

/* Functional syntax */
rgba(51, 170, 51, .1)    /*  10% opaque green */ 
rgba(51, 170, 51, .4)    /*  40% opaque green */ 
rgba(51, 170, 51, .7)    /*  70% opaque green */ 
rgba(51, 170, 51,  1)    /* full opaque green */ 

/* Whitespace syntax */
rgba(51 170 51 / 0.4)    /*  40% opaque green */
rgba(51 170 51 / 40%)    /*  40% opaque green */

/* Functional syntax with floats value */
rgba(255, 0, 153.6, 1)
rgba(1e2, .5e1, .5e0, +.25e2%)


/* These examples all specify the same color: a lavender. */
hsl(270,60%,70%)
hsl(270, 60%, 70%)
hsl(270 60% 70%)
hsl(270deg, 60%, 70%)
hsl(4.71239rad, 60%, 70%)
hsl(.75turn, 60%, 70%)

/* These examples all specify the same color: a lavender that is 15% opaque. */
hsl(270, 60%, 50%, .15)
hsl(270, 60%, 50%, 15%)
hsl(270 60% 50% / .15)
hsl(270 60% 50% / 15%)


hsla(240, 100%, 50%, .05)     /*   5% opaque blue */ 
hsla(240, 100%, 50%, .4)      /*  40% opaque blue */ 
hsla(240, 100%, 50%, .7)      /*  70% opaque blue */ 
hsla(240, 100%, 50%, 1)       /* full opaque blue */ 

/* Whitespace syntax */
hsla(240 100% 50% / .05)      /*   5% opaque blue */ 

/* Percentage value for alpha */
hsla(240 100% 50% / 5%)       /*   5% opaque blue */ 
+/


/+
<color>{1,4}
where 
<color> = <rgb()> | <rgba()> | <hsl()> | <hsla()> | <hex-color> | <named-color> | currentcolor | <deprecated-system-color>

where 
<rgb()> = rgb( <percentage>{3} [ / <alpha-value> ]? ) | rgb( <number>{3} [ / <alpha-value> ]? ) | rgb( <percentage>#{3} , <alpha-value>? ) | rgb( <number>#{3} , <alpha-value>? )
<rgba()> = rgba( <percentage>{3} [ / <alpha-value> ]? ) | rgba( <number>{3} [ / <alpha-value> ]? ) | rgba( <percentage>#{3} , <alpha-value>? ) | rgba( <number>#{3} , <alpha-value>? )
<hsl()> = hsl( <hue> <percentage> <percentage> [ / <alpha-value> ]? ) | hsl( <hue>, <percentage>, <percentage>, <alpha-value>? )
<hsla()> = hsla( <hue> <percentage> <percentage> [ / <alpha-value> ]? ) | hsla( <hue>, <percentage>, <percentage>, <alpha-value>? )

where 
<alpha-value> = <number> | <percentage>
<hue> = <number> | <angle>
+/


import ui.parse.css.types;
import std.stdio : writeln;


bool parse_color( string s, Color* color )
{
    import std.string : startsWith;
    import ui.parse.css.color_hex : parse_color_hex;

    //
    if ( s.startsWith( "#" ) )
    {
        return parse_color_hex( s, color );
    }
    else

    if ( s.startsWith( "rgb" ) )
    {
        //
    }
    else

    {
        assert( 0, "error: usupported color: " ~ s );
    }

    return false;
}

