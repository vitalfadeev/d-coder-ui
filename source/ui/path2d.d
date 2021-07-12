module ui.path2d;

import ui.point : Point;


/**
  let region = new Path2D();
  region.rect(80, 10, 20, 130);
  region.rect(40, 50, 100, 50);
*/
class Path2D
{
    /**
     * x:      The x-axis coordinate of the rectangle's starting point.
     * y:      The y-axis coordinate of the rectangle's starting point.
     * width:  The rectangle's width. Positive values are to the right, and negative to the left.
     * height: The rectangle's height. Positive values are down, and negative are up.
     */
    void rect( int x, int y, int width, int height )
    {
        // 1         2
        //  +-------+
        //  |       |
        //  |       |
        //  +-------+
        // 4         3

        _path ~= Point( x,         y );          // 1
        _path ~= Point( x + width, y );          // 2
        _path ~= Point( x + width, y + height ); // 3
        _path ~= Point( x,         y + height ); // 4
        _path ~= Point( x,         y );          // 1. close
    }

private:
    Point[] _path;
}


