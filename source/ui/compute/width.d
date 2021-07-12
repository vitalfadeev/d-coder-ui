module ui.compute.width;

import ui;


void compute_width( Element* element )
{
    with ( element )
    switch ( width.type )
    {
        case CSSValueType.Pos:
            computed.width = width.pos;
            break;
        case CSSValueType.Length:
            computed.width = width.length.toPixels;
            break;
        case CSSValueType.Percent:
            auto parentWidth = getParentWidth( element );
            computed.width = round( width.percent * parentWidth / 100 ).to!POS;
            break;
        default:
    }
}


POS toPixels( Length l )
{
    return l.length.round.to!POS;
}


POS getParentWidth( Element* element )
{
    with ( element )
    switch ( computed.display )
    {
        case Display.window:
            // screen width
            return Screen.width;
        default:
    }

    return 0;
}

