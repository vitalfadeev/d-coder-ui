module ui.event.keycodes.glfw;

version( GLFW ):
import glfw3.api;
import bindbc.glfw.types;
import std.string : startsWith;
import std.format : format;

static
foreach ( m; __traits( allMembers, bindbc.glfw.types ) ) 
{
    static 
    if ( m.startsWith( "GLFW_KEY_" ) )
    {
        //pragma( msg, m );
        mixin( format!"public import bindbc.glfw.types : %s;"( m ) );
    }
}
