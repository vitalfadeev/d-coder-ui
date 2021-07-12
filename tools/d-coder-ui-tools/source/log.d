module log;

struct Log
{
    static const string fileName = "t_parser.log";
    static bool logged = false;

    static
    void error( string msg )
    {
        toConsole( "error: " ~ msg );
        toFile( "error: " ~ msg ~ "\n" );
    }

    static 
    void toConsole( string msg )
    {
        import std.stdio : writeln;
        writeln( msg );
    }

    static 
    void toFile( string msg )
    {
        import std.file : append;
        import std.file : exists;
        import std.file : remove;

        // remove prev log file
        if ( !logged )
        {
            if ( exists( fileName ) )
            {
                remove( fileName );
            }

            logged = true;
        }

        append( fileName, msg );
    }
}
