module ui.parse.css.border_width;

import ui.parse.css.types : Length;
import ui.parse.css.types : LengthUnit;
import ui.parse.css.types : LineWidthType;
import ui.parse.css.stringiterator  : StringIterator;
import ui.parse.css.line_width;



bool parse_border_width( string s, ref string[] setters )
{
    // https://developer.mozilla.org/ru/docs/Web/CSS/border-width

    /*
    <line-width> = <length> | thin | medium | thick

    // Keyword values
    border-width: thin;
    border-width: medium;
    border-width: thick;

    // <length> values
    border-width: 4px;
    border-width: 1.2rem;

    // vertical | horizontal
    border-width: 2px 1.5em;

    // top | horizontal | bottom
    border-width: 1px 2em 1.5cm;

    // top | right | bottom | left
    border-width: 1px 2em 0 4rem;

    // Global keywords
    border-width: inherit;
    border-width: initial;
    border-width: unset;
    */

    import std.format       : format;
    import std.string       : isNumeric;
    import ui.parse.css.types  : Length;
    import ui.parse.css.types  : LengthUnit;
    import ui.parse.css.types  : LineWidth;

    LineWidth lineWidth;

    if ( parse_line_width( new StringIterator( s ), &lineWidth ) )
    {
        import std.stdio : writeln;

        final
        switch ( lineWidth.type )
        {
            case LineWidthType.length:
                setters ~= format!"borderWidth = (%f).%s;"( lineWidth.length.length, lineWidth.length.unit );
                break;

            case LineWidthType.thin:
            case LineWidthType.medium:
            case LineWidthType.thick:
                setters ~= format!"borderWidth = (%d).px;"( lineWidth.type );
                break;

            case LineWidthType.inherit:
                //
        }

        return true;
    }

    return false;
}
