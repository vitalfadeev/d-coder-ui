module deps.harfbuzz;

version ( HarfBuzz ):
import bindbc.freetype;
public import bindbc.hb;
public import bindbc.hb.bind.ft;
import core.stdc.stdio  : printf;
import core.stdc.stdlib : exit;
public import deps.harfbuzz.hbshaper;
public import deps.harfbuzz.hbfeature;


static
this()
{
    /*
    This version attempts to load the HarfBuzz shared library using well-known
    variations of the library name for the host system. See test/app.d file for a
    more complete example.
    */
    HBSupport retHB = loadHarfBuzz();
    if ( retHB != hbSupport )
    {
        // Handle error. For most use cases, its reasonable to use the the error
        // handling API in bindbc-loader to retrieve error messages for logging
        // and then abort. If necessary, it's possible to determine the root cause
        // via the return value:

        if ( retHB == HBSupport.noLibrary )
        {
            printf( "error: HarfBuzz shared library failed to load." );
            exit( -1 );
        }
        else
        if ( retHB == HBSupport.badLibrary )
        {
            // One or more symbols failed to load. The likely cause is that the
            // shared library is for a lower version than bindbc-harfbuzz was configured
            // to load (via HB_2_6_3, etc.)
            printf( "error: HarfBuzz: One or more symbols failed to load." );
            exit( -1 );
        }
    }
}


static 
~this()
{
    //
}
