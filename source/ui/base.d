module ui.base;

import ui;
import std.json;

enum MAX_CLASSES = size_t.sizeof * 8; // for x86_64 = 64
enum MAX_ELEMENT_CLASSES = 16;
alias size_t ClassId;


struct Computed
{
    // center, with scroll, relative from parent
    POS        centerX;  // px, center: relative from the parent center
    POS        centerY;  // px, center: relative from the parent center

    // position
    Position   position;

    //
    POS        top;
    POS        left;
    POS        bottom;
    POS        right;

    // border width
    POS        borderTopWidth;
    POS        borderRightWidth;
    POS        borderBottomWidth;
    POS        borderLeftWidth;
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

    // color
    Color      color;
    Background background;

    // width, height
    POS        width;       // px | by-content: BY_CONTENT = -101 | percent: PERCENT = -1 .. -100
    POS        height;      // px | by-content: BY_CONTENT = -101 | percent: PERCENT = -1 .. -100

    // position
    bool       fixed;       // fixed position, relative screen

    // margin
    POS        marginLeft;
    POS        marginTop;
    POS        marginRight;
    POS        marginBottom;

    // padding
    POS        paddingLeft;
    POS        paddingTop;
    POS        paddingRight;
    POS        paddingBottom;

    // Magnetic helpers
    // to childs
    POWER      magnetInLeft   = 100;
    POWER      magnetInRight  = 100;
    POWER      magnetInTop    = 100;
    POWER      magnetInBottom = 100;

    // to sibling
    POWER      magnetLeft     = 100;
    POWER      magnetRight    = 100;
    POWER      magnetTop      = 100;
    POWER      magnetBottom   = 100;

    // display
    Display    innerDisplay;
    Display    outerDisplay;

    // box model
    BoxSizing   boxSizing;


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

enum Display
{
    // outside
    inline,
    block,
    run_in,
    // inside
    flow,
    flow_root,
    table,
    flex,
    grid,
    ruby,
    // listitem
    list_item,
    // box
    contents,
    none,
    // internal
    table_row_group,
    table_header_group,
    table_footer_group,
    table_row,
    table_cell,
    table_column_group,
    table_column,
    table_caption,
    ruby_base,
    ruby_text,
    ruby_base_container,
    ruby_text_container,
    // legacy
    inline_block,
    inline_list_item,
    inline_table,
    inline_flex,
    inline_grid,
    // magnetic
    magnetic
};

enum BoxSizing
{
    content_box,
    border_box,
};

// position
enum Position
{
    static_,
    relative,  // left, top, right, bottom of flow position
    absolute,  // left, top, right, bottom of parent element. Own layer: z-index. Width = right - left, Height =bottom - top. margin applied. 
    fixed,     // left, top, right, bottom of viewport
    sticky,    // left, top, right, bottom of viewport. When scrolling then "fixed", else "static".
}

struct e
{
    const
    string name = "e";
}