module ui.drawelement.gl3.element;

version ( GL3 ):
import ui.drawelement.gl3.borders;
import ui.drawelement.gl3.background;
import ui.drawelement.gl3.content;
import ui.drawelement.gl3.text;
import ui.drawelement.gl3.image : drawImage;
import ui.linestyle;
import ui.color;


// draw element
//   draw borders
//   draw background
//     draw background color
//     draw background image
//   draw content
//     draw image
//     draw text

nothrow @nogc
void drawElement(
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
    Color     borderBottomColor,

    Color     backgroundColor,

    int       paddingLeft,
    int       paddingTop,
    int       paddingRight,
    int       paddingBottom,
    string    text
)
{
    // Get Element pos & size (x,y) (w,h)
    // Set Clipping area
    //   Viewport to (x,y) (w,h)
    // Draw Borders
    //   top
    //   right
    //   bottom
    //   left
    // Clear
    //   fill with 'background' color
    // Set Clipping to content (x,y) (w,h)
    // Draw image
    // Draw text

/*
    //
    drawBorders(
        windowLeft,
        windowTop,
        windowRight,
        windowBottom,

        left,
        top,
        right,
        bottom,
        
        borderLeftWidth,
        borderTopWidth,
        borderRightWidth,
        borderBottomWidth,

        borderLeftStyle,
        borderTopStyle,
        borderRightStyle,
        borderBottomStyle,

        borderLeftColor,
        borderTopColor,
        borderRightColor,
        borderBottomColor
    );

    //
    drawBackground(
        windowLeft,
        windowTop,
        windowRight,
        windowBottom,

        left,
        top,
        right,
        bottom,
        
        borderLeftWidth,
        borderTopWidth,
        borderRightWidth,
        borderBottomWidth,

        borderLeftStyle,
        borderTopStyle,
        borderRightStyle,
        borderBottomStyle,

        backgroundColor
    );
*/

    //drawImage();


    //
    drawContent(
        paddingLeft,
        paddingTop,
        paddingRight,
        paddingBottom,
        text,
    );

}
