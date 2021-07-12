module ui.parse.css.margin_length;

import ui.parse.t.tokenize : Tok;
import ui.parse.css.types : Length;


bool parse_margin_length( string s, Length* len )
{
    import ui.parse.css.length : parse_length;
    import ui.parse.css.stringiterator : StringIterator;

    return parse_length( new StringIterator( s ), len );
}
