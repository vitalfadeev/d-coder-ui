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
    ref CSSValue opAssign( POS a        ) return { type = CSSValueType.Pos;        pos       = a; return this; }
    ref CSSValue opAssign( Length a     ) return { type = CSSValueType.Length;     length    = a; return this; }
    ref CSSValue opAssign( Percent a    ) return { type = CSSValueType.Percent;    percent   = a; return this; }
    ref CSSValue opAssign( LineStyle a  ) return { type = CSSValueType.LineStyle;  lineStyle = a; return this; }
    ref CSSValue opAssign( Color a      ) return { type = CSSValueType.Color;      color     = a; return this; }
    ref CSSValue opAssign( Display a    ) return { type = CSSValueType.Display;    display   = a; return this; }
    ref CSSValue opAssign( MinContent a ) return { type = CSSValueType.MinContent;                return this; }
    ref CSSValue opAssign( MaxContent a ) return { type = CSSValueType.MaxContent;                return this; }
    ref CSSValue opAssign( FitContent a ) return { type = CSSValueType.FitContent;                return this; }
    ref CSSValue opAssign( Hidden a     ) return { type = CSSValueType.Hidden;     hidden    = a; return this; }

    ref CSSValue opAssign( Auto a       ) return { type = CSSValueType.Auto;     return this; }
    ref CSSValue opAssign( Initial a    ) return { type = CSSValueType.Initial;  return this; }
    ref CSSValue opAssign( Revert a     ) return { type = CSSValueType.Revert;   return this; }
    ref CSSValue opAssign( Unset a      ) return { type = CSSValueType.Unset;    return this; }
}


