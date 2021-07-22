module ui.drawelement.gl3.vertex;

version ( GL3 ):
import bindbc.opengl.bind.types;
import bindbc.opengl;


struct Vertex 
{
    GLfloat[2] position;
    GLfloat[3] color;
}

