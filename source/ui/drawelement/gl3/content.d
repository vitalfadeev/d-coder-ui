module ui.drawelement.gl3.content;

version ( GL3 ):
import bindbc.opengl.bind.types;
import bindbc.opengl;
import ui.drawelement.gl3.text : drawText;


nothrow @nogc
void drawContent(
    int paddingLeft,
    int paddingTop,
    int paddingRight,
    int paddingBottom,
    string text,
)
{
    drawText( text );
}
