module ui.point;

import core.sys.windows.windows;


struct Point
{
    union
    {
        struct
        {
            int x;
            int y;
        }
version (windows)
        POINT windowsPOINT;
    }

    // a + b 
    Point opBinary( string op : "+" )( Point b )
    {
        return Point( this.x + b.x, this.y + b.y );
    }

    // a - b
    Point opBinary( string op : "-" )( Point b )
    {
        return Point( this.x - b.x, this.y - b.y );
    }
}
