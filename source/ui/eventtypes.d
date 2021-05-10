module ui.eventtypes;

import core.sys.windows.winuser;
import std.string : startsWith;
import std.format : format;

static
foreach ( m; __traits( allMembers, core.sys.windows.winuser ) ) 
{
    static 
    if ( m.startsWith( "WM_" ) )
    {
        //pragma( msg, m );
        mixin( format!"public import core.sys.windows.winuser : %s;"( m ) );
    }
}
