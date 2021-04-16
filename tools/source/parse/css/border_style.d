module parse.css.border_style;

import parse.css.line_style;
import parse.css.types;
import stringiterator : StringIterator;


bool parse_border_style( string s, ref string[] setters )
{
    import std.format : format;

    LineStyle lineStyle;

    if ( parse_line_style( s, &lineStyle ) )
    {
        setters ~= format!"borderTopStyle         = LineStyle.%s;"( lineStyle.stringof );
        setters ~= format!"borderRightStyle       = LineStyle.%s;"( lineStyle.stringof );
        setters ~= format!"borderBottomStyle      = LineStyle.%s;"( lineStyle.stringof );
        setters ~= format!"borderLeftStyle        = LineStyle.%s;"( lineStyle.stringof );
        setters ~= format!"borderTopLeftStyle     = LineStyle.%s;"( lineStyle.stringof );
        setters ~= format!"borderTopRightStyle    = LineStyle.%s;"( lineStyle.stringof );
        setters ~= format!"borderBottomLeftStyle  = LineStyle.%s;"( lineStyle.stringof );
        setters ~= format!"borderBottomRightStyle = LineStyle.%s;"( lineStyle.stringof );

        return true;
    }

    return false;
}


