module ui.rendercontext.imgui;

version ( IMGUI ):
import imgui;
import ui.color  : Color;
import ui.base   : POS;
import ui.path2d : Path2D;
import ui.rect   : Rect;
import ui.base   : LineCap;

/** */
// RenderContext
// Windows GDI
struct CanvasRenderingContext2D
{
    // Fill and stroke styles
    /**
     color:    A DOMString parsed as CSS <color> value.
     gradient: A CanvasGradient object (a linear or radial gradient).
     pattern:  A CanvasPattern object (a repeating image).     

     var ctx = canvas.getContext('2d');
     ctx.strokeStyle = 'green';
     ctx.strokeRect(10, 10, 100, 100);
     */
    void strokeStyle( Color color )
    {
        _strokeStyleColor = color;
    }

    //void strokeStyle( string color )
    //{
    //    //
    //}
    //void strokeStyle( string gradient )
    //{
    //    //
    //}
    //void strokeStyle( string pattern )
    //{
    //    //
    //}

    /**
     x:      The x-axis coordinate of the rectangle's starting point.
     y:      The y-axis coordinate of the rectangle's starting point.
     width:  The rectangle's width. Positive values are to the right, and negative to the left.
     height: The rectangle's height. Positive values are down, and negative are up.

     const ctx = canvas.getContext('2d');
     ctx.strokeStyle = 'green';
     ctx.strokeRect(20, 10, 160, 100);
     */
    void strokeRect( POS x, POS y, POS width, POS height )
    {
        //
    }

    /** 
     text:       A DOMString specifying the text string to render into the context. The text is rendered using the settings specified by font, textAlign, textBaseline, and direction.
     x:          The x-axis coordinate of the point at which to begin drawing the text, in pixels.
     y:          The y-axis coordinate of the baseline on which to begin drawing the text, in pixels.
     [maxWidth]: The maximum number of pixels wide the text may be once rendered. If not specified, there is no limit to the width of the text. However, if this value is provided, the user agent will adjust the kerning, select a more horizontally condensed font (if one is available or can be generated without loss of quality), or scale down to a smaller font size in order to fit the text in the specified width.
    */
    void fillText( string text, POS x, POS y )
    {
        // Clipping 
        // by clip()
        // by CSS "text-overflow: clip":
        // - clip
        // - ellipsis
        // - "-"
        // - ""
        // and CSS "overflow: hidden"
        // - visible
        // - hidden
        // - scroll
        // - auto
        // and CSS "white-space: nowrap"
        // - normal
        // - nowrap
        // - pre
        // - pre-wrap
        // - pre-line
        // - pre-wrap
        // - break-spaces

        //import ui.string : toLPWSTR;

        //auto options = ETO_CLIPPED;

        //ExtTextOutW(
        //    _hdc,
        //    x,
        //    y,
        //    options,
        //    &clipRect.windowsRECT,
        //    text.toLPWSTR,
        //    text.length,
        //    NULL
        //);
    }

    void fillText( string text, POS x, POS y, int maxWidth )
    {
        //
    }

    /** */
    void clip()
    {
        //
    }

    void clip( FillRule fillRule )
    {
        //
    }

    void clip( Path2D path )
    {
        _clipPath = path;
    }

    void clip( Path2D path, FillRule fillRule )
    {
        //
    }

    // Line styles
    /** 
     Sets the thickness of lines.

     value: A number specifying the line width, in coordinate space units. Zero, negative, Infinity, and NaN values are ignored. This value is 1.0 by default.
     */
    void lineWidth( float value )
    {
        _lineWidth = value;
    }

    /** 
     Determines the shape used to draw the end points of lines.

     lineCap: butt | round | square
        - butt:   The ends of lines are squared off at the endpoints. Default value.
        - round:  The ends of lines are rounded.
        - square: The ends of lines are squared off by adding a box with an equal width and half the height of the line's thickness.
     */
    void lineCap( LineCap lineCap )
    {
        //
    }

    /**
     Sets the line dash pattern used when stroking lines. It uses an array of values that specify alternating lengths of lines and gaps which describe the pattern.

     segments: An Array of numbers that specify distances to alternately draw a line and a gap (in coordinate space units). If the number of elements in the array is odd, the elements of the array get copied and concatenated. For example, [5, 15, 25] will become [5, 15, 25, 5, 15, 25]. If the array is empty, the line dash list is cleared and line strokes return to being solid.
     */
    void setLineDash( uint[] segments )
    {
        //
    }

    /**
     Sets the line dash offset, or "phase." 

     value: A float specifying the amount of the line dash offset. The default value is 0.0. 
     */
    void lineDashOffset( float value )
    {
        //
    }

    // Drawing paths
    /**
     Strokes (outlines) the current or given path with the current stroke style.

     Strokes are aligned to the center of a path; in other words, half of the stroke is drawn on the inner side, and half on the outer side.

     The stroke is drawn using the non-zero winding rule, which means that path intersections will still get filled.
     */
    void stroke()
    {
        import std.algorithm.iteration : splitWhen;

        if ( _strokePath.length > 0 )
        {
            // see https://www.opengl.org/sdk/docs/man2/xhtml/glOrtho.xml
            glOrtho( 0.0, 400.0, 0.0, 400.0, 0.0, 1.0 ); // this creates a canvas you can do 2D drawing on

            // group by: [ move, line, line ], [ move, line, line ]
            auto grouped = _strokePath.splitWhen!( 
                    ( Rec a, Rec b ) 
                    {
                        return 
                            // moveTo, moveTo --> [ moveTo ], [ moveTo ]
                            (
                                a.type == Path2DRecordType.moveTo &&
                                b.type == Path2DRecordType.moveTo
                            ) ||
                            // lineTo, moveTo      --> [ lineTo ], [ moveTo ]
                            // ..., lineTo, moveTo --> [ ..., lineTo ], [ moveTo ]
                            (
                                a.type == Path2DRecordType.lineTo &&
                                b.type == Path2DRecordType.moveTo 
                            )
                            ;
                    }
                )();

            //
            foreach ( grp; grouped )
            {
                glBegin( GL_LINES );
                foreach ( p; grp )
                {
                    glVertex2i( p.point.x, p.point.y );
                }
                glEnd();
            }
        }
    }

    /**
     path: A Path2D path to stroke.
    */
    void stroke( Path2D path )
    {
        //
    }

    // Paths
    /** 
     Starts a new path by emptying the list of sub-paths. Call this method when you want to create a new path.
     */
    void beginPath()
    {
        _strokePath.clear();
    }


    /** 
     * Moves the starting point of a new sub-path to the (x, y) coordinates.
     */
    void moveTo( int x, int y )
    {
        _strokePath.moveTo( x, y );
    }


    /** 
     * Connects the last point in the subpath to the (x, y) coordinates with a straight line.
     */
    void lineTo( int x, int y )
    {
        _strokePath.lineTo( x, y );
        imguiDrawLine( 
            graphicsXPos, 
            windowHeight - 80, 
            graphicsXPos + 100, 
            windowHeight - 60, 
            1.0f, 
            RGBA(32, 192, 32, 192) 
        );
    }
    

private:
    Path2D _clipPath;
    Path2D _strokePath;
    float  _lineWidth;
    Color  _strokeStyleColor;

    Rect clipRect()
    {
        Rect rect;

        POS minx;
        POS miny;
        POS maxx;
        POS maxy;

        foreach ( p; _clipPath._path )
        {
            if ( minx > p.x )
                minx = p.x;
            if ( miny > p.y )
                miny = p.y;
            if ( maxx > p.x )
                maxx = p.x;
            if ( maxy > p.y )
                maxy = p.y;
        }

        rect = Rect( minx, miny, maxx, maxy );

        return rect;
    }
}

alias RenderContext = CanvasRenderingContext2D;

enum FillRule
{
    nonzero,
    evenodd
}

