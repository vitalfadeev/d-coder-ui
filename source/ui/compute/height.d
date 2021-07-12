module ui.compute.height;

import ui;
import std.math : round;
import std.conv : to;
import ui.base  : POS;


void compute_height( Element* element )
{
    with ( element )
    switch ( width.type )
    {
        case CSSValueType.Pos:
            computed.height = height.pos;
            break;
        case CSSValueType.Length:
            computed.height = height.length.toPixels;
            break;
        case CSSValueType.Percent:
            auto parentHeight = getParentHeight( element );
            computed.height = round( height.percent.number * parentHeight / 100 ).to!POS;
            break;
        default:
    }
}


POS toPixels( Length l )
{
    return l.length.round.to!POS;
}


POS getParentHeight( Element* element )
{
    with ( element )
    switch ( computed.display )
    {
        case Display.window:
            // screen width
            return Screen.height;
        default:
    }

    return 0;
}

