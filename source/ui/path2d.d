module ui.path2d;

import ui.point : Point;


/**
  auto region = Path2D();
  region.rect( 80, 10, 20, 130 );
  region.rect( 40, 50, 100, 50 );
*/
struct Path2D
{
    Path2DRecord[] _path;
    alias _path this;

    /** 
     * Moves the starting point of a new sub-path to the (x, y) coordinates.
     */
    void moveTo( int x, int y )
    {
        _path ~= Path2DRecord( Path2DRecordType.moveTo, Point( x, y ) );
    }


    /** 
     * Connects the last point in the subpath to the (x, y) coordinates with a straight line.
     */
    void lineTo( int x, int y )
    {
        _path ~= Path2DRecord( Path2DRecordType.lineTo, Point( x, y ) );
    }
    

    /**
     * Creates a path for a rectangle at position (x, y) with a size that is determined by width and height.
     * 
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

        _path ~= Path2DRecord( Path2DRecordType.moveTo, Point( x,         y          ) ); // 1
        _path ~= Path2DRecord( Path2DRecordType.lineTo, Point( x + width, y          ) ); // 2
        _path ~= Path2DRecord( Path2DRecordType.lineTo, Point( x + width, y + height ) ); // 3
        _path ~= Path2DRecord( Path2DRecordType.lineTo, Point( x,         y + height ) ); // 4
        _path ~= Path2DRecord( Path2DRecordType.lineTo, Point( x,         y          ) ); // 1. close
    }


    /** */
    void clear()
    {
        // remove all path points 
        // and keep allocated memory for prevent allocations
        _path.length = 0;
    }
}


/** */
struct Path2DRecord
{
    Path2DRecordType type;
    union
    {
        Point point;
    }
}

enum Path2DRecordType
{
    moveTo,
    lineTo
}
