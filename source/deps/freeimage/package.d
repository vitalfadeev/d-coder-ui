module deps.freeimage;

version ( FreeImage ):
public import bindbc.freeimage;
import core.stdc.stdio  : printf;
import core.stdc.stdlib : exit;


// FreeImage
static
this()
{
    /*
    This version attempts to load the FreeImage shared library using well-known variations
    of the library name for the host system.
    */
    FISupport retFreeImage = loadFreeImage();

    if ( retFreeImage != fiSupport ) 
    {
        // Handle error. For most use cases, its reasonable to use the the error handling API in
        // bindbc-loader to retrieve error messages for logging and then abort. If necessary, it's
        // possible to determine the root cause via the return value:

        if ( retFreeImage == FISupport.noLibrary ) 
        {
            printf( "FreeImage shared library failed to load" );
            exit( -1 );
        }
        else 
        if ( FISupport.badLibrary ) 
        {
            // One or more symbols failed to load. The likely cause is that the
            // shared library is for a lower version than bindbc-freeimage was configured
            // to load.
            printf( "One or more symbols failed to load" );
            exit( -1 );
        }
    }
}


static
~this()
{
    //
}
