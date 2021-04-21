module parse.css.border_width;

import parse.css.types : Length;
import parse.css.types : LengthUnit;
import parse.css.types : LineWidthType;
import stringiterator  : StringIterator;
import parse.css.line_width;



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
    import parse.css.types  : Length;
    import parse.css.types  : LengthUnit;
    import parse.css.types  : LineWidth;

    LineWidth lineWidth;

    if ( parse_line_width( new StringIterator( s ), &lineWidth ) )
    {
        final
        switch ( lineWidth.type )
        {
            case LineWidthType.length:
                setters ~= format!"borderTopWidth         = (%f).(%s);"( lineWidth.length.length, lineWidth.length.unit.stringof );
                setters ~= format!"borderRightWidth       = (%f).(%s);"( lineWidth.length.length, lineWidth.length.unit.stringof );
                setters ~= format!"borderBottomWidth      = (%f).(%s);"( lineWidth.length.length, lineWidth.length.unit.stringof );
                setters ~= format!"borderLeftWidth        = (%f).(%s);"( lineWidth.length.length, lineWidth.length.unit.stringof );
                setters ~= format!"borderTopLeftWidth     = (%f).(%s);"( lineWidth.length.length, lineWidth.length.unit.stringof );
                setters ~= format!"borderTopRightWidth    = (%f).(%s);"( lineWidth.length.length, lineWidth.length.unit.stringof );
                setters ~= format!"borderBottomLeftWidth  = (%f).(%s);"( lineWidth.length.length, lineWidth.length.unit.stringof );
                setters ~= format!"borderBottomRightWidth = (%f).(%s);"( lineWidth.length.length, lineWidth.length.unit.stringof );
                break;

            case LineWidthType.thin:
            case LineWidthType.medium:
            case LineWidthType.thick:
                setters ~= format!"borderTopWidth         = (%d).px;"( lineWidth.type );
                setters ~= format!"borderRightWidth       = (%d).px;"( lineWidth.type );
                setters ~= format!"borderBottomWidth      = (%d).px;"( lineWidth.type );
                setters ~= format!"borderLeftWidth        = (%d).px;"( lineWidth.type );
                setters ~= format!"borderTopLeftWidth     = (%d).px;"( lineWidth.type );
                setters ~= format!"borderTopRightWidth    = (%d).px;"( lineWidth.type );
                setters ~= format!"borderBottomLeftWidth  = (%d).px;"( lineWidth.type );
                setters ~= format!"borderBottomRightWidth = (%d).px;"( lineWidth.type );
                break;

            case LineWidthType.inherit:
                //
        }

        return true;
    }

    return false;
}
