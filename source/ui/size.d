module ui.size;

import core.sys.windows.windows;


struct Size
{
    union 
    {
        struct
        {
            int w;
            int h;
        }
version (windows)
        SIZE windowsSIZE;
    }
}
