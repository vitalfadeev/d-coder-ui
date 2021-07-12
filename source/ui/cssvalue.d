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
    CSSValue opAssign( POS a        ) { type = CSSValueType.Pos;        pos       = a; return this; }
    CSSValue opAssign( Length a     ) { type = CSSValueType.Length;     length    = a; return this; }
    CSSValue opAssign( Percent a    ) { type = CSSValueType.Percent;    percent   = a; return this; }
    CSSValue opAssign( LineStyle a  ) { type = CSSValueType.LineStyle;  lineStyle = a; return this; }
    CSSValue opAssign( Color a      ) { type = CSSValueType.Color;      color     = a; return this; }
    CSSValue opAssign( Display a    ) { type = CSSValueType.Display;    display   = a; return this; }
    CSSValue opAssign( MinContent a ) { type = CSSValueType.MinContent;                return this; }
    CSSValue opAssign( MaxContent a ) { type = CSSValueType.MaxContent;                return this; }
    CSSValue opAssign( FitContent a ) { type = CSSValueType.FitContent;                return this; }
    CSSValue opAssign( Hidden a     ) { type = CSSValueType.Hidden;     hidden    = a; return this; }

    CSSValue opAssign( Auto a       ) { type = CSSValueType.Auto;     return this; }
    CSSValue opAssign( Initial a    ) { type = CSSValueType.Initial;  return this; }
    CSSValue opAssign( Revert a     ) { type = CSSValueType.Revert;   return this; }
    CSSValue opAssign( Unset a      ) { type = CSSValueType.Unset;    return this; }
}


