module ui.base;

import ui;
import std.json;


const PropsMembersCount = __traits( allMembers, Props ).length + 1;

struct Props
{
    Color      color;
    Border     border;
    Background background;
    int        width;       // px | by-content: BY_CONTENT = -101 | percent: PERCENT = -1 .. -100
    int        height;      // px | by-content: BY_CONTENT = -101 | percent: PERCENT = -1 .. -100
    bool       fixed;       // fixed position, relative screen

    ubyte                    modifiedLength; // 3
    ubyte[PropsMembersCount] modified;       // [ 2, 1, 3, 0 ] // 1=color, 2=border, 3=background, ..., PropsMembersCount, 0 ( zero ended )
    ubyte[PropsMembersCount] modifiedOrder;  // [ 2, 1, 3, 0 ] // 1.color at 2, 2.border at 1, 3.background at 3
}


struct Computed
{
    Color      color;
    Border     border;
    Background background;
    int        width;       // px
    int        height;      // px
    bool       fixed;       // fixed position, relative screen
}


ubyte memberId( T, string memberName )()
{
    import std.conv : to;

    static
    foreach ( i, name; __traits( allMembers, T ) ) 
    {
        if ( name == memberName )
        {
            return ( i + 1 ).to!ubyte;
        }
    }

    return 0;
}


//
version ( Windows )
{
    import core.sys.windows.windows;

    enum PenType : uint
    {
        none = 0,
        solid = PS_SOLID
    }
}


struct Background
{
    Color color;
}

struct Pen
{
    int     width;
    PenType type;
    Color   color;
}

struct Border
{
    Pen pen;
}


//struct stage
//{
//    Border border = { Pen( 3, PenType.solid, 0xFFFFCC.rgb ) };
//}


Element* createObject( string className )
{
    auto cls = classRegistry.find( className );

    if ( cls )
    {
        Element* element = new Element();
        element.classes ~= cls;
        return element;
    }
    else
    {
        assert( cls, "Class not registered: " ~ className );
    }

    return null;
}


