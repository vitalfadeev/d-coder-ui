module ui.drawelement.gl3.background;

version ( GL3 ):
import bindbc.opengl.bind.types;
import bindbc.opengl;
import ui.drawelement.gl3.vertex;
import ui.drawelement.gl3.vao;
import ui.linestyle;
import ui.color;


nothrow @nogc
void drawBackground(
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

    Color     backgroundColor
)
{
    // Calculate x, y, width, height
    // Set vertices
    // Draw 2 triangles

    // 
    auto windowedLeft   = left   - windowLeft;
    auto windowedTop    = top    - windowTop;
    auto windowedRight  = right  - windowLeft;
    auto windowedBottom = bottom - windowTop;

    // 
    if ( borderTopWidth > 0 )
    if ( borderTopStyle != LineStyle.none )
    {
        windowedTop += borderTopWidth;
    }

    if ( borderRightWidth > 0 )
    if ( borderRightStyle != LineStyle.none )
    {
        windowedRight -= borderRightWidth;
    }

    if ( borderBottomWidth > 0 )
    if ( borderBottomStyle != LineStyle.none )
    {
        windowedBottom -= borderBottomWidth;
    }

    if ( borderLeftWidth > 0 )
    if ( borderLeftStyle != LineStyle.none )
    {
        windowedLeft += borderLeftWidth;
    }

    //
    auto windowHeight   = windowBottom   - windowTop;
    auto viewportWidth  = windowedRight  - windowedLeft;
    auto viewportHeight = windowedBottom - windowedTop;
    auto GL_WindowedTop = windowHeight   - windowedBottom; // windowHeight-viewportHeight because Window from top-left, nut Viewport from bottom-left
    glViewport( windowedLeft, GL_WindowedTop, viewportWidth, viewportHeight ); 

    //
    auto glColor = backgroundColor.glColor;

    //
    Vertex[4] vertices =
    [
        Vertex( [ -1.0f,  1.0f ], glColor ), // top-left
        Vertex( [  1.0f,  1.0f ], glColor ), // top-right
        Vertex( [  1.0f, -1.0f ], glColor ), // bottom-right
        Vertex( [ -1.0f, -1.0f ], glColor ), // bottom-left
    ];

    //
    auto vao = VAO( vertices );
    glBindVertexArray( vao );
    glDrawArrays( GL_TRIANGLE_FAN , /*first*/ 0, /*count*/ cast( int ) vertices.length );
    glBindVertexArray( 0 ); // unbind
}


