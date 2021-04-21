module parse.css.line_style;

// none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset 
//
// https://developer.mozilla.org/en-US/docs/Web/CSS/border-style

import parse.css.types;


bool parse_line_style( string s, LineStyle* lineStyle )
{
    // "solid"
    // "type" = "PenType.solid"
    // Border border = { { width: 1, type: PenType.solid } };

    LineStyle[ string ] lineStyleKeywords =
    [
        "none"   : LineStyle.none, 
        "hidden" : LineStyle.hidden, 
        "dotted" : LineStyle.dotted, 
        "dashed" : LineStyle.dashed, 
        "solid"  : LineStyle.solid, 
        "double" : LineStyle.double_, 
        "groove" : LineStyle.groove, 
        "ridge"  : LineStyle.ridge, 
        "inset"  : LineStyle.inset, 
        "outset" : LineStyle.outset
    ];


    // style
    if ( auto style = s in lineStyleKeywords )
    {
        *lineStyle = *style;
        return true;
    }
    else

    // wrong style
    {
        assert( 0, "error: wrong line style: " ~ s );
        //return false;
    }
}

