module ui.rect;

import core.sys.windows.windows;


struct Rect
{
    union
    {
        struct
        {
            int x;
            int y;
            int x2;
            int y2;
        };
        struct
        {
            int left;
            int top;
            int right;
            int bottom;
        };
        struct
        {
            int c;
            int h;
            int d;
            int g;
        };
version (windows)
        RECT windowsRECT;
    }


    int cd()
    {
        import std.math : abs;
        return abs( d - c );
    }


    int hg()
    {
        import std.math : abs;
        return abs( h - g );
    }
}

