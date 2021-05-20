module ui.drawer;

import ui : Color;
import ui : Point;
import ui : Size;
import ui : POS;
import ui : Pen;
import ui : PenType;
import ui : Event;


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
    void  clipRect( int cx, int cy, int w, int h );
    void  set();
    void  vid();
    int   on( Event* event ) nothrow;
}


// Thread local
IDrawer drawer;
