module deps.glfw;

// GLFW
version ( GLFW ):
public import bindbc.glfw;
import core.stdc.stdio  : fprintf;
import core.stdc.stdio  : stderr;
import core.stdc.stdio  : printf;
import core.stdc.stdlib : exit;


extern(C) nothrow @nogc 
void errorCallback( int error, const(char)* description ) 
{
    fprintf( stderr, "Error: glfw: %s\n", description );
}


static
this()
{
    /*
     This version attempts to load the GLFW shared library using well-known variations of the library name for the host
     system.
    */
    GLFWSupport ret = loadGLFW();

    if ( ret != glfwSupport ) 
    {
        /*
         Handle error. For most use cases, it's reasonable to use the the error handling API in bindbc-loader to retrieve
         error messages for logging and then abort. If necessary, it's possible to determine the root cause via the return
         value:
        */

        if ( ret == GLFWSupport.noLibrary ) 
        {
            // The GLFW shared library failed to load
            printf( "error: glfw: The GLFW shared library failed to load\n" );
            exit( -1 );
        }
        else 
        if ( GLFWSupport.badLibrary ) 
        {
            /*
             One or more symbols failed to load. The likely cause is that the shared library is for a lower version than bindbc-glfw was configured to load (via GLFW_31, GLFW_32 etc.)
            */
            printf( "error: glfw: One or more symbols failed to load. The likely cause is that the shared library is for a lower version than bindbc-glfw was configured to load (via GLFW_31, GLFW_32 etc.)\n" );
            exit( -1 );
        }
    }

    //
    glfwSetErrorCallback( &errorCallback );

    if ( ! glfwInit() ) 
    {
        printf( "error: glfw: Can't init glfw library\n" );
        exit( -1 );
    }
}


static
~this()
{
    glfwTerminate();
}

