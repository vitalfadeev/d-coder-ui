module ui.shaders.loadshaders;

version( GL3 ):
import ui.shaders.linear;


nothrow @nogc
void loadShaders()
{
    loadLinearShader();
}
