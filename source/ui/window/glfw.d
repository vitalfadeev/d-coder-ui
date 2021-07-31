module ui.window.glfw;

version( GLFW ):
import deps.glfw;
import deps.gl3;
import core.stdc.stdio;
import ui.event : Event;


/** */
nothrow @nogc
auto createMainWindow( int w, int h, string name )
{
    return MainWindow( w, h, name );
}


/** */
nothrow @nogc
auto createWindow( int w, int h, string name )
{
    return Window( w, h, name );
}


/** */
struct MainWindow
{
    GLFWwindow* glfwWindow;
    alias glfwWindow this;

    nothrow @nogc
    this( int w, int h, string name )
    {
        glfwWindowHint( GLFW_CONTEXT_VERSION_MAJOR, 3 );
        glfwWindowHint( GLFW_CONTEXT_VERSION_MINOR, 3 );
        glfwWindowHint( GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE );

        glfwWindow = glfwCreateWindow( w, h, name.ptr, null, null );
        if ( ! glfwWindow ) 
        {
            return;
        }

        glfwMakeContextCurrent( glfwWindow );
        glfwSwapInterval( 1 ); // Set vsync on so glfwSwapBuffers will wait for monitor updates.
                               // note: 1 is not a boolean! Set e.g. to 2 to run at half the monitor refresh rate.

        // bindbc-opengl
        GLSupport retVal = loadOpenGL();
        if ( retVal == GLSupport.badLibrary || retVal == GLSupport.noLibrary ) 
        {
            glfwDestroyWindow( glfwWindow );
            return;
        }

        // Shaders
        import ui.shaders;
        loadShaders();
    }


    nothrow @nogc
    ~this()
    {
        if ( glfwWindow )
            glfwDestroyWindow( glfwWindow );
    }


    nothrow @nogc
    int on( Event* event )
    {
        return 0;
    }
}


struct Window
{
    GLFWwindow* glfwWindow;
    alias glfwWindow this;


    nothrow @nogc
    this( int w, int h, string name )
    {
        glfwWindowHint( GLFW_CONTEXT_VERSION_MAJOR, 3 );
        glfwWindowHint( GLFW_CONTEXT_VERSION_MINOR, 3 );

        glfwWindow = glfwCreateWindow( w, h, name.ptr, null, null );
        if ( ! glfwWindow ) 
        {
            return;
        }

        glfwMakeContextCurrent( glfwWindow );
        glfwSwapInterval( 1 ); // Set vsync on so glfwSwapBuffers will wait for monitor updates.
                               // note: 1 is not a boolean! Set e.g. to 2 to run at half the monitor refresh rate.

        // bindbc-opengl
        GLSupport retVal = loadOpenGL();
        if ( retVal == GLSupport.badLibrary || retVal == GLSupport.noLibrary ) 
        {
            glfwDestroyWindow( glfwWindow );
            return;
        }
    }

    nothrow @nogc
    ~this()
    {
        if ( glfwWindow )
            glfwDestroyWindow( glfwWindow );
    }


    nothrow @nogc
    int on( Event* event )
    {
        return 0;
    }
}
