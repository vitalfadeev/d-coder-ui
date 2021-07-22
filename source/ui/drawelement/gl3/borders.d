module ui.drawelement.gl3.borders;

version ( GL3 ):
import bindbc.opengl.bind.types;
import bindbc.opengl;
import ui.drawelement.gl3.vertex;
import ui.drawelement.gl3.vao;
import ui.linestyle;
import ui.color;
import ui.shaders.linear : linearShader;


nothrow @nogc
void drawBorders(
    int windowLeft,
    int windowTop,
    int windowRight,
    int windowBottom,

    int     left,
    int     top,
    int     right,
    int     bottom,
    
    int       borderLeftWidth,
    int       borderTopWidth,
    int       borderRightWidth,
    int       borderBottomWidth,

    LineStyle borderLeftStyle,
    LineStyle borderTopStyle,
    LineStyle borderRightStyle,
    LineStyle borderBottomStyle,

    Color     borderLeftColor,
    Color     borderTopColor,
    Color     borderRightColor,
    Color     borderBottomColor
)
{
    // Create GL buffer
    // Add Vertices
    // Draw

    // 
    auto windowedLeft   = left   - windowLeft;
    auto windowedTop    = top    - windowTop;
    auto windowedRight  = right  - windowLeft;
    auto windowedBottom = bottom - windowTop;

    //
    auto viewportWidth  = right  - left;
    auto viewportHeight = bottom - top;

    // deviceX = ( windowX - viewportCenterX ) / viewportWidth * 2
    auto windowedViewportCenterX = cast( GLfloat ) windowedLeft + ( cast( GLfloat ) viewportWidth )  / 2;
    auto windowedViewportCenterY = cast( GLfloat ) windowedTop  + ( cast( GLfloat ) viewportHeight ) / 2;

    //
    auto windowHeight = windowBottom - windowTop;
    auto GL_windowedTop = windowHeight - viewportHeight - windowedTop; // because Window from top-left, but GL Viewport from bottom-left
    glViewport( windowedLeft, GL_windowedTop, viewportWidth, viewportHeight ); 

    // 
    if ( borderTopWidth > 0 )
    if ( borderTopStyle != LineStyle.none )
    {
        drawTopBorder( 
            windowedLeft, windowedTop, windowedRight, windowedBottom, 
            windowedViewportCenterX, windowedViewportCenterY,
            viewportWidth, viewportHeight,
            borderLeftWidth,
            borderRightWidth,
            borderTopWidth,
            borderTopColor,
            borderTopStyle
        );
    }

    if ( borderRightWidth > 0 )
    if ( borderRightStyle != LineStyle.none )
    {
        drawRightBorder( 
            windowedLeft, windowedTop, windowedRight, windowedBottom, 
            windowedViewportCenterX, windowedViewportCenterY,
            viewportWidth, viewportHeight,
            borderTopWidth,
            borderBottomWidth,
            borderRightWidth,
            borderRightColor,
            borderRightStyle
        );
    }

    if ( borderBottomWidth > 0 )
    if ( borderBottomStyle != LineStyle.none )
    {
        drawBottomBorder( 
            windowedLeft, windowedTop, windowedRight, windowedBottom, 
            windowedViewportCenterX, windowedViewportCenterY,
            viewportWidth, viewportHeight,
            borderRightWidth,
            borderLeftWidth,
            borderBottomWidth,
            borderBottomColor,
            borderBottomStyle
        );
    }

    if ( borderLeftWidth > 0 )
    if ( borderLeftStyle != LineStyle.none )
    {
        drawLeftBorder( 
            windowedLeft, windowedTop, windowedRight, windowedBottom, 
            windowedViewportCenterX, windowedViewportCenterY,
            viewportWidth, viewportHeight,
            borderBottomWidth,
            borderTopWidth,
            borderLeftWidth,
            borderLeftColor,
            borderLeftStyle
        );  
    }
}


//                       
//                   tl              tr
//                    1              2
//                      +----------+
//                       \        /       border top
//                        +------+
//                       4        3 
//                      bl        br
//        
//             +                            +
//             | \                        / |
//             |  +                      +  |
//             |  |                      |  |
// border left |  |                      |  | border right
//             |  |                      |  |
//             |  +                      +  |
//             | /                        \ |
//             +                            +
//        
//                      tl        tr
//                       1        2
//                        +------+
//                       /        \       border bottom
//                      +----------+
//                    4              3 
//                   bl              br

/** 
 * left   - relative Document root
 * top    - relative Document root
 * right  - relative Document root
 * bottom - relative Document root
 * */
pragma( inline, true )
nothrow @nogc
void drawTopBorder( 
    int windowedLeft,       // relative Document top-left
    int windowedTop, 
    int windowedRight,
    int windowedBottom,
    GLfloat windowedViewportCenterX,
    GLfloat windowedViewportCenterY,
    int     viewportWidth,
    int     viewportHeight,
    int       borderLeftWidth,
    int       borderRightWidth,
    int       lineWidth,
    Color     color,
    LineStyle lineStyle
 )
{
    // Set clipping area
    //   Gl viewport is already setted in drawElement(). viewport coord relative at Window/GLContext
    // Set style
    // Set color
    // Set verices
    // Draw

    // Style
    switch ( lineStyle )
    {
        case LineStyle.solid:
            glUseProgram( linearShader );
            break;
        default:
    }

    // Color
    auto glColor = color.glColor;

    // GL to Window ( insde in OpenGL, after setViewport() ). https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glViewport.xhtml
    //   windowedX = viewportWidth / 2 * device_X + viewportCenterX
    //
    // Window to GL
    //   device_X = ( windowedX - viewportCenterX ) / viewportWidth * 2

    //
    pragma( inline, true )
    auto deviceX( int windowedX )
    {
        return ( cast( GLfloat ) windowedX - windowedViewportCenterX ) / viewportWidth * 2;
    }

    pragma( inline, true )
    auto deviceY( int windowedY )
    {
        return -( cast( GLfloat ) windowedY - windowedViewportCenterY ) / viewportHeight * 2;
    }

    //
    GLfloat GL_tl_x = deviceX( windowedLeft );
    GLfloat GL_tl_y = deviceY( windowedTop );

    GLfloat GL_tr_x = deviceX( windowedRight );
    GLfloat GL_tr_y = deviceY( windowedTop );

    GLfloat GL_br_x = deviceX( windowedRight - borderRightWidth );
    GLfloat GL_br_y = deviceY( windowedTop   + lineWidth );

    GLfloat GL_bl_x = deviceX( windowedLeft + borderLeftWidth);
    GLfloat GL_bl_y = deviceY( windowedTop  + lineWidth );

    Vertex[4] vertices =
    [
        Vertex( [ GL_tl_x,  GL_tl_y ], glColor ), // top-left
        Vertex( [ GL_tr_x,  GL_tr_y ], glColor ), // top-right
        Vertex( [ GL_br_x,  GL_br_y ], glColor ), // bottom-right
        Vertex( [ GL_bl_x,  GL_bl_y ], glColor ), // bottom-left
    ];

    auto vao = VAO( vertices );
    glBindVertexArray( vao );
    glDrawArrays( GL_TRIANGLE_FAN , /*first*/ 0, /*count*/ cast( int ) vertices.length );
    glBindVertexArray( 0 ); // unbind
}


/** 
 * left   - relative Document root
 * top    - relative Document root
 * right  - relative Document root
 * bottom - relative Document root
 * */
pragma( inline, true )
nothrow @nogc
void drawRightBorder( 
    int windowedLeft,       // relative Document top-left
    int windowedTop, 
    int windowedRight,
    int windowedBottom,
    GLfloat windowedViewportCenterX,
    GLfloat windowedViewportCenterY,
    int     viewportWidth,
    int     viewportHeight,
    int       borderTopWidth,
    int       borderBottomWidth,
    int       lineWidth,
    Color     color,
    LineStyle lineStyle
)
{
    // Set clipping area
    //   Gl viewport is already setted in drawElement(). viewport coord relative at Window/GLContext
    // Set style
    // Set color
    // Set verices
    // Draw

    // Style
    switch ( lineStyle )
    {
        case LineStyle.solid:
            glUseProgram( linearShader );
            break;
        default:
    }

    // Color
    auto glColor = color.glColor;

    // GL to Window ( insde in OpenGL, after setViewport() ). https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glViewport.xhtml
    //   windowedX = viewportWidth / 2 * device_X + viewportCenterX
    //
    // Window to GL
    //   device_X = ( windowedX - viewportCenterX ) / viewportWidth * 2

    //
    pragma( inline, true )
    auto deviceX( int windowedX )
    {
        return ( cast( GLfloat ) windowedX - windowedViewportCenterX ) / viewportWidth * 2;
    }

    pragma( inline, true )
    auto deviceY( int windowedY )
    {
        return -( cast( GLfloat ) windowedY - windowedViewportCenterY ) / viewportHeight * 2;
    }

    //                       
    GLfloat GL_tl_x = deviceX( windowedRight - lineWidth );
    GLfloat GL_tl_y = deviceY( windowedTop + borderTopWidth );

    GLfloat GL_tr_x = deviceX( windowedRight ); // -1 because [ 0 .. 100 ] is 101 pixel. exclude right
    GLfloat GL_tr_y = deviceY( windowedTop );

    GLfloat GL_br_x = deviceX( windowedRight );
    GLfloat GL_br_y = deviceY( windowedBottom );

    GLfloat GL_bl_x = deviceX( windowedRight - lineWidth );
    GLfloat GL_bl_y = deviceY( windowedBottom - borderBottomWidth );

    Vertex[4] vertices =
    [
        Vertex( [ GL_tl_x,  GL_tl_y ], glColor ), // top-left
        Vertex( [ GL_tr_x,  GL_tr_y ], glColor ), // top-right
        Vertex( [ GL_br_x,  GL_br_y ], glColor ), // bottom-right
        Vertex( [ GL_bl_x,  GL_bl_y ], glColor ), // bottom-left
    ];

    auto vao = VAO( vertices );
    glBindVertexArray( vao );
    glDrawArrays( GL_TRIANGLE_FAN , /*first*/ 0, /*count*/ cast( int ) vertices.length );
    glBindVertexArray( 0 ); // unbind
}


pragma( inline, true )
nothrow @nogc
void drawBottomBorder( 
    int windowedLeft,       // relative Document top-left
    int windowedTop, 
    int windowedRight,
    int windowedBottom,
    GLfloat windowedViewportCenterX,
    GLfloat windowedViewportCenterY,
    int     viewportWidth,
    int     viewportHeight,
    int       borderRightWidth,
    int       borderLeftWidth,
    int       lineWidth,
    Color     color,
    LineStyle lineStyle
)
{
    // Set clipping area
    //   Gl viewport is already setted in drawElement(). viewport coord relative at Window/GLContext
    // Set style
    // Set color
    // Set verices
    // Draw

    // Style
    switch ( lineStyle )
    {
        case LineStyle.solid:
            glUseProgram( linearShader );
            break;
        default:
    }

    // Color
    auto glColor = color.glColor;

    // GL to Window ( insde in OpenGL, after setViewport() ). https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glViewport.xhtml
    //   windowedX = viewportWidth / 2 * device_X + viewportCenterX
    //
    // Window to GL
    //   device_X = ( windowedX - viewportCenterX ) / viewportWidth * 2

    //
    pragma( inline, true )
    auto deviceX( int windowedX )
    {
        return ( cast( GLfloat ) windowedX - windowedViewportCenterX ) / viewportWidth * 2;
    }

    pragma( inline, true )
    auto deviceY( int windowedY )
    {
        return -( cast( GLfloat ) windowedY - windowedViewportCenterY ) / viewportHeight * 2;
    }

    //                       
    GLfloat GL_tl_x = deviceX( windowedLeft + borderLeftWidth );
    GLfloat GL_tl_y = deviceY( windowedBottom - lineWidth );

    GLfloat GL_tr_x = deviceX( windowedRight - borderRightWidth ); // -1 because [ 0 .. 100 ] is 101 pixel. exclude right
    GLfloat GL_tr_y = deviceY( windowedBottom - lineWidth );

    GLfloat GL_br_x = deviceX( windowedRight );
    GLfloat GL_br_y = deviceY( windowedBottom );

    GLfloat GL_bl_x = deviceX( windowedLeft );
    GLfloat GL_bl_y = deviceY( windowedBottom  );

    Vertex[4] vertices =
    [
        Vertex( [ GL_tl_x,  GL_tl_y ], glColor ), // top-left
        Vertex( [ GL_tr_x,  GL_tr_y ], glColor ), // top-right
        Vertex( [ GL_br_x,  GL_br_y ], glColor ), // bottom-right
        Vertex( [ GL_bl_x,  GL_bl_y ], glColor ), // bottom-left
    ];

    auto vao = VAO( vertices );
    glBindVertexArray( vao );
    glDrawArrays( GL_TRIANGLE_FAN , /*first*/ 0, /*count*/ cast( int ) vertices.length );
    glBindVertexArray( 0 ); // unbind
}


pragma( inline, true )
nothrow @nogc
void drawLeftBorder( 
    int windowedLeft,       // relative Document top-left
    int windowedTop, 
    int windowedRight,
    int windowedBottom,
    GLfloat windowedViewportCenterX,
    GLfloat windowedViewportCenterY,
    int     viewportWidth,
    int     viewportHeight,
    int       borderBottomWidth,
    int       borderTopWidth,
    int       lineWidth,
    Color     color,
    LineStyle lineStyle
)
{
    // Set clipping area
    //   Gl viewport is already setted in drawElement(). viewport coord relative at Window/GLContext
    // Set style
    // Set color
    // Set verices
    // Draw

    // Style
    switch ( lineStyle )
    {
        case LineStyle.solid:
            glUseProgram( linearShader );
            break;
        default:
    }

    // Color
    auto glColor = color.glColor;

    // GL to Window ( insde in OpenGL, after setViewport() ). https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/glViewport.xhtml
    //   windowedX = viewportWidth / 2 * device_X + viewportCenterX
    //
    // Window to GL
    //   device_X = ( windowedX - viewportCenterX ) / viewportWidth * 2

    // 
    pragma( inline, true )
    auto deviceX( int windowedX )
    {
        return ( cast( GLfloat ) windowedX - windowedViewportCenterX ) / viewportWidth * 2;
    }

    pragma( inline, true )
    auto deviceY( int windowedY )
    {
        return -( cast( GLfloat ) windowedY - windowedViewportCenterY ) / viewportHeight * 2;
    }

    //                       
    GLfloat GL_tl_x = deviceX( windowedLeft );
    GLfloat GL_tl_y = deviceY( windowedTop );

    GLfloat GL_tr_x = deviceX( windowedLeft + lineWidth ); // -1 because [ 0 .. 100 ] is 101 pixel. exclude right
    GLfloat GL_tr_y = deviceY( windowedTop + borderTopWidth );

    GLfloat GL_br_x = deviceX( windowedLeft + lineWidth );
    GLfloat GL_br_y = deviceY( windowedBottom - borderBottomWidth );

    GLfloat GL_bl_x = deviceX( windowedLeft );
    GLfloat GL_bl_y = deviceY( windowedBottom );

    Vertex[4] vertices =
    [
        Vertex( [ GL_tl_x,  GL_tl_y ], glColor ), // top-left
        Vertex( [ GL_tr_x,  GL_tr_y ], glColor ), // top-right
        Vertex( [ GL_br_x,  GL_br_y ], glColor ), // bottom-right
        Vertex( [ GL_bl_x,  GL_bl_y ], glColor ), // bottom-left
    ];

    auto vao = VAO( vertices );
    glBindVertexArray( vao );
    glDrawArrays( GL_TRIANGLE_FAN , /*first*/ 0, /*count*/ cast( int ) vertices.length );
    glBindVertexArray( 0 ); // unbind
}
