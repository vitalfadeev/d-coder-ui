module ui.loadui.glfw;

version ( GLFW ):
import glfw3.api;
import bindbc.opengl;
import bindbc.opengl.bind.types;
import core.stdc.stdio;
import core.stdc.stdio : printf;


nothrow @nogc
int loadUI()
{
    // GLFW
    version ( GLFW )
    {
        glfwSetErrorCallback( &errorCallback );

        if ( ! glfwInit() ) 
        {
            return -1;
        }
    }

    // FreeType
    version ( FreeType )
    {
        import bindbc.freetype;

        /*
        This version attempts to load the FreeType shared library using well-known variations
        of the library name for the host system.
        */
        FTSupport ret = loadFreeType();

        if ( ret != ftSupport ) 
        {

            // Handle error. For most use cases, its reasonable to use the the error handling API in
            // bindbc-loader to retrieve error messages for logging and then abort. If necessary, it's
            // possible to determine the root cause via the return value:

            if ( ret == FTSupport.noLibrary ) 
            {
                printf( "error: FreeType shared library failed to load.\n" );
            }
            else 
            if ( FTSupport.badLibrary ) 
            {
                // One or more symbols failed to load. The likely cause is that the
                // shared library is for a lower version than bindbc-freetype was configured
                // to load (via FT_26, FT_27, etc.)
                printf( "error: FreeType: One or more symbols failed to load.\n" );
            }
        }

        //
        FT_Library ft;

        // All functions return a value different than 0 whenever an error occurred
        if ( FT_Init_FreeType( &ft ) )
        {
            printf( "error::FreeType: Could not init FreeType Library\n" );
            return -1;
        }            
    }

    return 0;
}


extern(C) @nogc nothrow
void errorCallback( int error, const(char)* description ) 
{
    fprintf(stderr, "Error: %s\n", description);
}


void unloadUI()
{
    glfwTerminate();
}
