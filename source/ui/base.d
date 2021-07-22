module ui.base;

import ui;
import ui.linestyle;
import std.json;

enum MAX_CLASSES = size_t.sizeof * 8; // for x86_64 = 64
enum MAX_ELEMENT_CLASSES = 16;
alias size_t ClassId;


alias int POWER;
alias int POS;


struct Computed
{
    // absolute coord, relative from document root
    Rect       absolute;

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
    // border Style
    LineStyle  borderTopStyle;
    LineStyle  borderRightStyle;
    LineStyle  borderBottomStyle;
    LineStyle  borderLeftStyle;
    // border color
    Color      borderTopColor;
    Color      borderRightColor;
    Color      borderBottomColor;
    Color      borderLeftColor;

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

    // display
    Display    innerDisplay;
    Display    outerDisplay;
    Display    display;

    // box model
    BoxSizing   boxSizing;

    //
    void function( Element* element ) setter;
    void function( Element* element, Event* event ) on;

    //
    //
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
else
{
    enum PenType : uint
    {
        none = 0,
        solid = 1
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


POS px( double a )
{
    import std.math : round;
    import std.conv : to;
    return round( a ).to!POS;
}


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
    magnetic,
    window
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

enum Hidden
{
    visible,
    hidden,
    collapse
}


struct Length
{
    float length;
    LengthUnit unit = LengthUnit.none;
}


enum LengthUnit
{
        none,
        // Font-relative lengths
        cap,   // "cap height" (nominal height of capital letters) of the element’s font.
        ch,    // width, or more precisely the advance measure, of the glyph "0" (zero, the Unicode character U+0030) in the element's font.
        em,    // calculated font-size of the element. If used on the font-size property itself, it represents the inherited font-size of the element.
        ex,    // x-height of the element's font. On fonts with the "x" letter, this is generally the height of lowercase letters in the font; 1ex ≈ 0.5em in many fonts.
        ic,    // used advance measure of the "水" glyph (CJK water ideograph, U+6C34), found in the font used to render it.
        lh,    // computed value of the line-height property of the element on which it is used, converted to an absolute length.
        rem,   // font-size of the root element (typically <html>). When used within the root element font-size, it represents its initial value (a common browser default is 16px, but user-defined preferences may modify this).
        rlh,   // computed value of the line-height property on the root element (typically <html>), converted to an absolute length. When used on the font-size or line-height properties of the root element, it refers to the properties' initial value.
        // Viewport-percentage lengths
        vh,    // 1% of the height of the viewport's initial containing block.
        vw,    // 1% of the width of the viewport's initial containing block.
        vi,    // 1% of the size of the initial containing block, in the direction of the root element’s inline axis.
        vb,    // 1% of the size of the initial containing block, in the direction of the root element’s block axis.
        vmin,  // smaller of vw and vh.
        vmax,  // larger of vw and vh.
        // Absolute length units
        px,    // pixel
        cm,    // centimeter. 1cm = 96px/2.54
        mm,    // millimeter. 1mm = 1/10th of 1cm
        Q,     // quarter of a millimeter. 1Q = 1/40th of 1cm
        inch,   // inch.       1in = 2.54cm = 96px.
        pc,    // pica.       1pc = 12pt   = 1/6th of 1in.
        pt,    // point.      1pt = 1/72nd of 1in.
}


//struct Color
//{
//    int osColor;
//    alias osColor this;
//}


struct LineWidth
{
    LineWidthType type;
    Length        length;
}

enum LineWidthType : byte
{
    inherit = -2,
    length  = -1,
    thin    =  1,
    medium  =  2,
    thick   =  3,
}

// percentage
struct Percentage
{
    float number;
    alias number this;
}


//
enum LineCap
{
    butt,
    round,
    square
}
