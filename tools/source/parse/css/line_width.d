module parse.css.line_width;

import parse.css.length : parse_length;
import parse.css.types;
import stringiterator;


LineWidthType[ string ] types =
{
    "thin"   = LineWidthType.thin,
    "medium" = LineWidthType.medium,
    "thick"  = LineWidthType.thick
};


bool parse_line_width( StringIterator range, LineWidth* lw )
{
    // https://developer.mozilla.org/ru/docs/Web/CSS/border-width
    //
    // <line-width> = <length> | thin | medium | thick

    import std.uni : isNumber;

    // length
    if ( range.front.isNumber() )
    {
        return parse_length( s, &lw.length );
    }
    else

    // thin | medium | thick
    {
        auto word = range.rest;

        if ( auto type = word in types )
        {
            lw.type = type;
            return true;
        }
        else
        {
            assert( 0, "error: wrong keyword in line width: " ~ word );
            // return false;
        }
    }

    return false;
}
