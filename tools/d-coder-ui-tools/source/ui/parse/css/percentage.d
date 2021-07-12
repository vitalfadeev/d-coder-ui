module ui.parse.css.percentage;

import ui.parse.css.types : Percentage;
import ui.parse.css.stringiterator : StringIterator;
import ui.parse.css.number : parse_number;

// https://developer.mozilla.org/en-US/docs/Web/CSS/percentage

bool parse_percentage( StringIterator range, Percentage* percentage )
{
    if ( parse_number( range, &percentage.number ) )
    {
        // % 
        if ( range.front == '%' )
        {
            return true;
        }
    }

    return false;
}
