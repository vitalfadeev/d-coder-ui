module ui.parse.css.margin_percentage;

import ui.parse.css.types : Percentage;
import ui.parse.css.percentage : parse_percentage;
import ui.parse.css.stringiterator : StringIterator;


bool parse_margin_percentage( string s, Percentage* percentage )
{
    import ui.parse.css.percentage : parse_percentage;
    return parse_percentage( new StringIterator( s ), percentage );
}
