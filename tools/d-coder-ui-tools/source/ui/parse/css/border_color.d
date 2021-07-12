module ui.parse.css.border_color;

/+
https://developer.mozilla.org/en-US/docs/Web/CSS/border-color

/* <color> values */
border-color: red;

/* top and bottom | left and right */
border-color: red #f015ca;

/* top | left and right | bottom */
border-color: red rgb(240,30,50,.7) green;

/* top | right | bottom | left */
border-color: red yellow green blue;

/* Global values */
border-color: inherit;
border-color: initial;
border-color: unset;
+/

import ui.parse.css.color;
import ui.parse.css.types : Color;


bool parse_border_color( string s, ref string[] setters )
{
    import std.format : format;

    Color color;

    if ( parse_color( s, &color ) )
    {
        setters ~= format!"borderColor = Color( 0x%X, 0x%X, 0x%X );"( color.r, color.g, color.b );
        return true;
    }

    return false;
}
