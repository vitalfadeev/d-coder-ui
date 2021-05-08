module ui.classlist;

import ui.classregistry : Class;
import ui.base : MAX_ELEMENT_CLASSES;


struct ClassList
{
    Class*[ MAX_ELEMENT_CLASSES ] lst;
    alias lst this;

    bool has( Class* cls )
    {
        import std.algorithm : canFind;

        return lst.canFind( cls );
    }

    string toString()
    {
        string s;

        foreach( cls; lst )
        {
            s ~= cls.name ~ ", ";
        }

        if ( s.length > 2 )
        {
            s = s[ 0 .. $-2 ];
        }

        return s;
    }
}


