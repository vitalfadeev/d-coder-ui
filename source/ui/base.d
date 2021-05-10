module ui.base;

import ui;
import std.json;

enum MAX_CLASSES = 255;
enum MAX_ELEMENT_CLASSES = 16;


struct Computed
{
    // border width
    int        borderTopWidth;
    int        borderRightWidth;
    int        borderBottomWidth;
    int        borderLeftWidth;
    // border color
    Color      borderTopColor;
    Color      borderRightColor;
    Color      borderBottomColor;
    Color      borderLeftColor;
    // border Style
    LineStyle  borderTopStyle;
    LineStyle  borderRightStyle;
    LineStyle  borderBottomStyle;
    LineStyle  borderLeftStyle;

    Color      color;
    Background background;
    int        width;       // px | by-content: BY_CONTENT = -101 | percent: PERCENT = -1 .. -100
    int        height;      // px | by-content: BY_CONTENT = -101 | percent: PERCENT = -1 .. -100
    bool       fixed;       // fixed position, relative screen


    @property
    void borderWidth( int a )
    {
        borderTopWidth    = a;
        borderRightWidth  = a;
        borderBottomWidth = a;
        borderLeftWidth   = a;
    }

    @property
    string borderWidth()
    {
        return borderTopWidth.to!string;
    }

    @property
    void borderStyle( LineStyle a )
    {
        borderTopStyle    = a;
        borderRightStyle  = a;
        borderBottomStyle = a;
        borderLeftStyle   = a;
    }

    @property
    string borderStyle()
    {
        return borderTopStyle.to!string;
    }

    @property
    void borderColor( Color a )
    {
        borderTopColor    = a;
        borderRightColor  = a;
        borderBottomColor = a;
        borderLeftColor   = a;
    }

    @property
    string borderColor()
    {
        return borderTopColor.to!string;
    }
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


int px( double a )
{
    import std.math : round;
    import std.conv : to;
    return round( a ).to!int;
}


enum LineStyle
{
    none, 
    hidden, 
    dotted, 
    dashed, 
    solid, 
    double_,
    groove, 
    ridge, 
    inset, 
    outset
};


struct e
{
    string name = "e";

    //static
    //void setter( Element* element )
    //{
    //    //
    //}

    //static
    //void on( Element* element, Event* event )
    //{
    //    //
    //}
}
