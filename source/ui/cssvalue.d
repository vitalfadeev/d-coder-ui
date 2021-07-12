module ui.cssvalue;

import ui.base  : Length;
import ui.base  : Display;
import ui.base  : POS;
import ui.base  : LineStyle;
import ui.color : Color;
import ui.base  : Hidden;

struct Percent    { float number; alias number this; }
struct MinContent {}
struct MaxContent {}
struct FitContent {}
struct Auto       {}
struct Initial    {}
struct Revert     {}
struct Unset      {}

enum CSSValueType
{
    Pos,
    Length,
    Percent,
    LineStyle,
    Color,
    Display,
    MinContent,
    MaxContent,
    FitContent,
    Hidden,

    Auto,
    Initial,
    Revert,
    Unset
}


struct CSSValue
{
    CSSValueType type;
    union
    {
        POS        pos;
        Length     length;
        Percent    percent;
        LineStyle  lineStyle;
        Color      color;
        Display    display;
        MinContent minContent;
        MaxContent maxContent;
        FitContent fitContent;
        Hidden     hidden;

        Auto       auto_;
        Initial    initial;
        Revert     revert;
        Unset      unset;
    }


    // Setters
    void opAssign( POS a        ) { type = CSSValueType.Pos;        pos       = a; }
    void opAssign( Length a     ) { type = CSSValueType.Length;     length    = a; }
    void opAssign( Percent a    ) { type = CSSValueType.Percent;    percent   = a; }
    void opAssign( LineStyle a  ) { type = CSSValueType.LineStyle;  lineStyle = a; }
    void opAssign( Color a      ) { type = CSSValueType.Color;      color     = a; }
    void opAssign( Display a    ) { type = CSSValueType.Display;    display   = a; }
    void opAssign( MinContent a ) { type = CSSValueType.MinContent; }
    void opAssign( MaxContent a ) { type = CSSValueType.MaxContent; }
    void opAssign( FitContent a ) { type = CSSValueType.FitContent; }
    void opAssign( Hidden a     ) { type = CSSValueType.Hidden;     hidden    = a; }

    void opAssign( Auto a       ) { type = CSSValueType.Auto;    }
    void opAssign( Initial a    ) { type = CSSValueType.Initial; }
    void opAssign( Revert a     ) { type = CSSValueType.Revert;  }
    void opAssign( Unset a      ) { type = CSSValueType.Unset;   }
}


