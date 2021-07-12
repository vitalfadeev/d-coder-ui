module ui.compute.display;

import ui;


void compute_display( Element* element )
{
    with ( element )
    switch ( display.type )
    {
        case CSSValueType.Display:
            computed.display = display.display;
            break;
        case CSSValueType.Auto:
            break;
        default:
    }
}
