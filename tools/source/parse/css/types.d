module parse.css.types;


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


struct Color
{
    int osColor;
    alias osColor this;
}


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
