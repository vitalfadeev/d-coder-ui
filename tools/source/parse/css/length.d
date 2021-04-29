module parse.css.length;

import parse.css.types : Length;
import parse.css.types : LengthUnit;
import stringiterator  : StringIterator;


bool parse_length( StringIterator range, Length* len )
{
    // https://developer.mozilla.org/en-US/docs/Web/CSS/length

    import parse.css.number : parse_number;

    LengthUnit[ string ] units = 
    [
        // Font-relative lengths
        "cap"  : LengthUnit.cap,  // "cap height" (nominal height of capital letters) of the element’s font.
        "ch"   : LengthUnit.ch,   // width, or more precisely the advance measure, of the glyph "0" (zero, the Unicode character U+0030) in the element's font.
        "em"   : LengthUnit.em,   // calculated font-size of the element. If used on the font-size property itself, it represents the inherited font-size of the element.
        "ex"   : LengthUnit.ex,   // x-height of the element's font. On fonts with the "x" letter, this is generally the height of lowercase letters in the font; 1ex ≈ 0.5em in many fonts.
        "ic"   : LengthUnit.ic,   // used advance measure of the "水" glyph (CJK water ideograph, U+6C34), found in the font used to render it.
        "lh"   : LengthUnit.lh,   // computed value of the line-height property of the element on which it is used, converted to an absolute length.
        "rem"  : LengthUnit.rem,  // font-size of the root element (typically <html>). When used within the root element font-size, it represents its initial value (a common browser default is 16px, but user-defined preferences may modify this).
        "rlh"  : LengthUnit.rlh,  // computed value of the line-height property on the root element (typically <html>), converted to an absolute length. When used on the font-size or line-height properties of the root element, it refers to the properties' initial value.
        // Viewport-percentage lengths
        "vh"   : LengthUnit.vh,    // 1% of the height of the viewport's initial containing block.
        "vw"   : LengthUnit.vw,    // 1% of the width of the viewport's initial containing block.
        "vi"   : LengthUnit.vi,    // 1% of the size of the initial containing block, in the direction of the root element’s inline axis.
        "vb"   : LengthUnit.vb,    // 1% of the size of the initial containing block, in the direction of the root element’s block axis.
        "vmin" : LengthUnit.vmin,  // smaller of vw and vh.
        "vmax" : LengthUnit.vmax,  // larger of vw and vh.
        // Absolute length units
        "px"   : LengthUnit.px,    // pixel
        "cm"   : LengthUnit.cm,    // centimeter. 1cm = 96px/2.54
        "mm"   : LengthUnit.mm,    // millimeter. 1mm = 1/10th of 1cm
        "Q"    : LengthUnit.Q,     // quarter of a millimeter. 1Q = 1/40th of 1cm
        "in"   : LengthUnit.inch,  // inch.       1in = 2.54cm = 96px.
        "pc"   : LengthUnit.pc,    // pica.       1pc = 12pt   = 1/6th of 1in.
        "pt"   : LengthUnit.pt,    // point.      1pt = 1/72nd of 1in.
    ];

    if ( parse_number( range, &len.length ) )
    {
        import std.stdio : writeln;

        // without unit
        if ( range.empty )
        {
            len.unit = LengthUnit.none;
            return true;
        }
        else

        // test unit
        {
            string ssss = range.s[ range.pos .. $ ];
     
            // unit
            if ( auto unit = ssss in units )
            {
                len.unit = *unit;
                return true;
            }
            else

            // wrong unit
            {
                assert( 0, "error: wrong unit: " ~ ssss ~ ": in the: " ~ range.s );
                //return false;
            }
        }
    }
    else
    {
        return false;
    }
}


unittest 
{
    import parse.css.length;
    import parse.css.types;
    import stringiterator;

    string s;
    Length len;
    
    s = "1"; 
    assert( parse_length( new StringIterator( s ), &len ) && len == Length( 1.0, LengthUnit.none ) );
    
    s = "1.0"; 
    assert( parse_length( new StringIterator( s ), &len ) && len == Length( 1.0, LengthUnit.none ) );
    
    s = "1px"; 
    assert( parse_length( new StringIterator( s ), &len ) && len == Length( 1.0, LengthUnit.px ) );

    s = "1.5px"; 
    assert( parse_length( new StringIterator( s ), &len ) && len == Length( 1.5, LengthUnit.px ) );

    s = "1.5pxe"; // wrong
    assert( parse_length( new StringIterator( s ), &len ) == false );
}

