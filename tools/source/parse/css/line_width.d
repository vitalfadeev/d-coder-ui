module parse.css.line_width;

import parse.css.length : parse_length;
import parse.css.types;
import stringiterator;


LineWidthType[ string ] types;

static 
this()
{
    types =
    [
        "thin"   : LineWidthType.thin,
        "medium" : LineWidthType.medium,
        "thick"  : LineWidthType.thick
    ];
}


bool parse_line_width( StringIterator range, LineWidth* lw )
{
    // https://developer.mozilla.org/ru/docs/Web/CSS/border-width
    //
    // <line-width> = <length> | thin | medium | thick

    import std.uni : isNumber;

    // length
    if ( range.front.isNumber() )
    {
        if ( parse_length( range, &lw.length ) )
        {
            lw.type = LineWidthType.length;
            return true;
        }
        else            
        {
            assert( 0, "error: wrong line length" );
            //return false;
        }
    }
    else

    // thin | medium | thick
    {
        auto word = range.rest;

        if ( auto type = word in types )
        {
            lw.type = *type;
            return true;
        }
        else
        {
            assert( 0, "error: wrong keyword in line width: " ~ word );
            // return false;
        }
    }
}
