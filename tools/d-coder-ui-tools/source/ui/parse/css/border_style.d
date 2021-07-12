module ui.parse.css.border_style;

import ui.parse.css.line_style;
import ui.parse.css.types;
import ui.parse.css.stringiterator : StringIterator;


bool parse_border_style( string s, ref string[] setters )
{
    import std.format : format;

    LineStyle lineStyle;

    if ( parse_line_style( s, &lineStyle ) )
    {
        setters ~= format!"borderStyle = LineStyle.%s;"( lineStyle );

        return true;
    }

    return false;
}


