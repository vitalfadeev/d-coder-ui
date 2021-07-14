module ui.rendercontext.glfw;

version ( GLFW ):
import glfw3.api;
import bindbc.opengl;
import bindbc.opengl : glColor3b;
import ui.color  : Color;
import ui.base   : POS;
import ui.path2d : Path2D;
import ui.rect   : Rect;
import ui.base   : LineCap;
import std.stdio : writefln;

/** */
// RenderContext
// Windows GDI
struct CanvasRenderingContext2D
{
    //Rect   _relativeWindowiewport; // offset from the window left top corner
    Rect   _viewport;              // offset from the doument left top corner
    Path2D _clipPath;
    Path2D _strokePath;

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
        glColor3b( color.r, color.g, color.b );
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
        glPointSize( 10 );
        glLineWidth( value );
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

        // Send shader program to GPU
        // Send array of the vertecies to GPU
        // Send array of the colors to GPU
        // Draw array

        // SECOND GEOMETRY(-IES): Line segments, Line strip, Line loop
        // Specify six vertices that will be used to form lines,
        // Will render with one of GL_LINES or GL_LINE_STRIP or GL_LINE_LOOP
        float[] sixVertsForLines = 
        {
            -0.2f, -0.8f,
             0.8f,  0.2f,
             0.6f,  0.8f,
            -0.5f,  0.6f,
            -0.4f, -0.0f,
            -0.7f, -0.3f,
        };

        // Do the same as above, now for the vertices that specify lines.
        glBindVertexArray( myVAO[ iLines ] );
        glBindBuffer( GL_ARRAY_BUFFER, myVBO[ iLines ] );
        glBufferData( GL_ARRAY_BUFFER, sixVertsForLines.sizeof, sixVertsForLines, GL_STATIC_DRAW );
        glVertexAttribPointer( vertPos_loc, 2, GL_FLOAT, GL_FALSE, 0, null );
        glEnableVertexAttribArray( vertPos_loc );


        //if ( _strokePath.length > 0 )
        //{
        //    // group by: [ move, line, line ], [ move, line, line ]
        //    auto grouped = _strokePath.splitWhen!( 
        //            ( Rec a, Rec b ) 
        //            {
        //                return 
        //                    // moveTo, moveTo --> [ moveTo ], [ moveTo ]
        //                    (
        //                        a.type == Path2DRecordType.moveTo &&
        //                        b.type == Path2DRecordType.moveTo
        //                    ) ||
        //                    // lineTo, moveTo      --> [ lineTo ], [ moveTo ]
        //                    // ..., lineTo, moveTo --> [ ..., lineTo ], [ moveTo ]
        //                    (
        //                        a.type == Path2DRecordType.lineTo &&
        //                        b.type == Path2DRecordType.moveTo 
        //                    )
        //                    ;
        //            }
        //        )();

        //    //
        //    foreach ( grp; grouped )
        //    {
        //        glBegin( GL_LINES );
        //        foreach ( p; grp )
        //        {
        //            glVertex2i( p.point.x, p.point.y );
        //        }
        //        glEnd();
        //    }
        //}
    }

    /**
     * path: A Path2D path to stroke.
     */
    void stroke( Path2D path )
    {
        //
    }

    // Paths
    /** 
     * Starts a new path by emptying the list of sub-paths. Call this method when you want to create a new path.
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
        // 1. Translate coordinates from Document system to Window system
        // 2. Save path command 'move' for rendering after 'stroke()'

        auto ctxX = x - _viewport.left;
        auto ctxY = y - _viewport.top;

        _strokePath.moveTo( ctxX, ctxY );
    }


    /** 
     * Connects the last point in the subpath to the (x, y) coordinates with a straight line.
     */
    void lineTo( int x, int y )
    {
        // 1. Translate coordinates from Document system to Window system
        // 2. Save path command 'line' for rendering after 'stroke()'

        auto ctxX = x - _viewport.left;
        auto ctxY = y - _viewport.top;

        _strokePath.lineTo( x, y );
    }
    

//private:
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

enum int NumObjects = 3;
enum int iPoints    = 0;
enum int iLines     = 1;
enum int iTriangles = 2;

GLuint[ NumObjects ] myVBO;  // Vertex Buffer Object - holds an array of data
GLuint[ NumObjects ] myVAO;  // Vertex Array Object - holds info about an array of vertex data;

// We create one shader program: it consists of a vertex shader and a fragment shader
enum uint shaderProgram1;
enum uint vertPos_loc = 0;   // Corresponds to "location = 0" in the verter shader definition
enum uint vertColor_loc = 1; // Corresponds to "location = 1" in the verter shader definition

void drawLines( float[] coords, Color[] colors )
{
    // Select shader program
    // Send pairs [ (x, y), (x2, y2), ... ] to GPU
    // Draw

    // Setup geometry
    // Allocate Vertex Array Objects (VAOs) and Vertex Buffer Objects (VBOs).
    glGenVertexArrays( NumObjects, &myVAO.ptr );
    glGenBuffers( NumObjects, &myVBO.ptr );

    // SECOND GEOMETRY(-IES): Line segments, Line strip, Line loop
    // Specify six vertices that will be used to form lines,
    // Will render with one of GL_LINES or GL_LINE_STRIP or GL_LINE_LOOP
    GLfloat[] sixVertsForLines = 
    {
        -0.2f, -0.8f,
         0.8f,  0.2f,
         0.6f,  0.8f,
        -0.5f,  0.6f,
        -0.4f, -0.0f,
        -0.7f, -0.3f,
    };

    // Do the same as above, now for the vertices that specify lines.
    glBindVertexArray( myVAO[ iLines ] );
    glBindBuffer( GL_ARRAY_BUFFER, myVBO[ iLines ] );
    glBufferData( GL_ARRAY_BUFFER, sixVertsForLines.sizeof, sixVertsForLines, GL_STATIC_DRAW );
    glVertexAttribPointer( vertPos_loc, 2, GL_FLOAT, GL_FALSE, 0, null );
    glEnableVertexAttribArray( vertPos_loc );

    //
    // Render
    glUseProgram( shaderProgram1 );

    glBindVertexArray( myVAO[ iLines ] );
    glVertexAttrib3f( vertColor_loc, 0.5f, 1.0f, 0.2f );      // A greenish color (R, G, B values).
    glDrawArrays( GL_LINES, 0, coords.length.to!GLsizei );

    checkForOpenglErrors();   // Really a great idea to check for errors -- esp. good for debugging!

    // then glfwSwapBuffers( window );
}


//
// If an error is found, it could have been caused by any command since the
//   previous call to check_for_opengl_errors()
// To find what generated the error, you can try adding more calls to
//   check_for_opengl_errors().
char[8][36] errNames = 
{
    "Unknown OpenGL error",
    "GL_INVALID_ENUM", "GL_INVALID_VALUE", "GL_INVALID_OPERATION",
    "GL_INVALID_FRAMEBUFFER_OPERATION", "GL_OUT_OF_MEMORY",
    "GL_STACK_UNDERFLOW", "GL_STACK_OVERFLOW" 
};

bool checkForOpenglErrors() 
{
    int numErrors = 0;
    GLenum err;

    while ( ( err = glGetError() ) != GL_NO_ERROR ) 
    {
        numErrors++;
        int errNum = 0;

        switch ( err ) 
        {
        case GL_INVALID_ENUM:
            errNum = 1;
            break;
        case GL_INVALID_VALUE:
            errNum = 2;
            break;
        case GL_INVALID_OPERATION:
            errNum = 3;
            break;
        case GL_INVALID_FRAMEBUFFER_OPERATION:
            errNum = 4;
            break;
        case GL_OUT_OF_MEMORY:
            errNum = 5;
            break;
        case GL_STACK_UNDERFLOW:
            errNum = 6;
            break;
        case GL_STACK_OVERFLOW:
            errNum = 7;
            break;
        }

        writefln!"OpenGL ERROR: %s.\n"( errNames[errNum] );
    }
    return (numErrors != 0);
}
