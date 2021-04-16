module ui.drawer;

import ui : Color;
import ui : Point;
import ui : Size;
import ui : POS;
import ui : Pen;
import ui : PenType;
import ui.event : MouseKeyEvent;
import ui.event : MouseMoveEvent;
import ui.event : MouseWheelEvent;
import ui.event : KeyboardKeyEvent;


/** */
interface IDrawer
{
    void  center( Point praCenter, POS x, POS y );                 // Point of view
    Point center();
    void  clear();
    Size  size();
    void  color( Color color );
    void  pen( Color color );
    void  pen( Color color, int width );
    void  pen( Color color, PenType type, int width );
    void  pen( ref Pen pen );
    void  moveTo( POS x, POS y );
    void  lineTo( POS x, POS y );
    void  point( POS x, POS y, Color color );
    void  rectangle( int w, int h );
    void  set();
    void  vid();
    void  process( ref MouseKeyEvent event );
    void  process( ref MouseMoveEvent event );
    void  process( ref MouseWheelEvent event );
    void  process( ref KeyboardKeyEvent event );
}


// Thread local
IDrawer drawer;
