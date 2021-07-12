module ui.parse.css.number;

import ui.parse.css.stringiterator : StringIterator;


bool parse_number( StringIterator range, float* result )
{
    // https://developer.mozilla.org/en-US/docs/Web/CSS/number

    /*
    12          A raw <integer> is also a <number>.
    4.01        Positive fraction
    -456.8      Negative fraction
    0.0         Zero
    +0.0        Zero, with a leading +
    -0.0        Zero, with a leading -
    .60         Fractional number without a leading zero
    10e3        Scientific notation
    -3.4e-2     Complicated scientific notation    
    */

    //import std.uni : byGrapheme;
    import std.encoding : codePoints;
    import std.math     : pow;
    import std.range    : front;
    import std.range    : empty;
    import std.range    : popFront;
    import std.range    : tee;
    import std.uni      : isNumber;

    //
    int   sign                = 1;
    bool  isFloat             = false;
    int   floatIndeger        = 0;
    float floatDecimal        = 0.0;
    float floatMultiplier     = 1.0;
    bool  floatIndegerParsed  = false;
    int   integer             = 0;

    int   scientificSign      = 1;
    int   scientificNumber    = 0;
    bool  isScientific        = false;

    const int multiplier = 10;

    auto c = range.front;

    // +
    if ( c == '+' )
    {
        sign = +1;
        range.popFront();
        c = range.front;
    }
    else

    // -
    if ( c == '-' )
    {
        sign = -1;
        range.popFront();
        c = range.front;
    }

    // .1 float
    if ( c == '.' )
    {
        isFloat = true;
        floatIndeger = 0;
        floatDecimal = 0;
        floatIndegerParsed = true;
        range.popFront();
    }

    //
    // not number
    if ( !range.front.isNumber() )
    {
        return false;
    }
    else

    // float
    if ( isFloat )
    {
        // parse float decimal
        goto parseFloatDecimal;
    }
    else

    // integer | float
    {
        // parse int | float
        for ( ; !range.empty; range.popFront() )
        {
            c = range.front;

            switch ( c )
            {
                case '0': 
                case '1': 
                case '2': 
                case '3': 
                case '4': 
                case '5': 
                case '6': 
                case '7': 
                case '8': 
                case '9': 
                    // number readed
                    integer *= multiplier;
                    integer += c - '0';
                    break;

                case 'e': 
                    // Scientific notation int | float readed
                    range.popFront();
                    isScientific = true;
                    goto parseScientificNotation;
                
                case '.': 
                    // float integer readed
                    isFloat = true;
                    floatIndeger = integer;
                    floatDecimal = 0;
                    floatIndegerParsed = true;
                    range.popFront();
                    goto parseFloatDecimal;

                default:
                    goto end;  // break loop
            }
        }
    }
    goto end;

parseFloatDecimal:
    // parse float decimal
    for ( ; !range.empty; range.popFront() )
    {        
        c = range.front;

        switch ( c )
        {
            case '0': 
            case '1': 
            case '2': 
            case '3': 
            case '4': 
            case '5': 
            case '6': 
            case '7': 
            case '8': 
            case '9': 
                // number readed
                floatMultiplier /= multiplier;
                floatDecimal += floatMultiplier * ( c - '0' );
                //writeln( "floatMultiplier * ( dc - '0' ): ", floatMultiplier * ( dc - '0' ) );
                break;

            case 'e': 
                // Scientific notation int | float readed
                range.popFront();
                isScientific = true;
                goto parseScientificNotation;
            
            default:
                goto end;  // break loop
        }
    }
    goto end;


parseScientificNotation:
    // parse Scientific notation
    //scientificSign

    //
    c = range.front;

    if ( c == '+' )
    {
        scientificSign = +1;
        range.popFront();
        c = range.front;
    }
    else
    if ( c == '-' )
    {
        scientificSign = -1;
        range.popFront();
        c = range.front;
    }

    //
    for ( ; !range.empty; range.popFront() )
    {        
        c = range.front;

        switch ( c )
        {
            case '0': 
            case '1': 
            case '2': 
            case '3': 
            case '4': 
            case '5': 
            case '6': 
            case '7': 
            case '8': 
            case '9': 
                // number readed
                scientificNumber *= multiplier;
                scientificNumber += ( c - '0' );
                break;

            default:
                break;  // break loop
        }
    }

end:
    // float
    if ( isFloat )
    {
        *result = sign * ( floatIndeger + floatDecimal );

        // with e...
        if ( isScientific )
        {
            if ( scientificSign == +1 )
                *result *= pow( 10, scientificNumber );
            else
                *result /= pow( 10, scientificNumber );
        }
    }
    else 

    // integer
    {
        *result = sign * integer;

        // with e...
        if ( isScientific )
        {
            *result *= pow( scientificSign * 10, scientificNumber );
        }
    }

    return true;
}


unittest
{
    float number;

    assert( parse_number( new StringIterator( "1" ),       &number )  && number == 1.0 );
    assert( parse_number( new StringIterator( "10" ),      &number )  && number == 10.0 );
    assert( parse_number( new StringIterator( "123" ),     &number )  && number == 123.0 );

    assert( parse_number( new StringIterator( "-1" ),      &number )  && number == -1.0 );
    assert( parse_number( new StringIterator( "-10" ),     &number )  && number == -10.0 );
    assert( parse_number( new StringIterator( "-123" ),    &number )  && number == -123.0 );

    assert( parse_number( new StringIterator( "+1" ),      &number )  && number == 1.0 );
    assert( parse_number( new StringIterator( "+10" ),     &number )  && number == 10.0 );
    assert( parse_number( new StringIterator( "+123" ),    &number )  && number == 123.0 );

    assert( parse_number( new StringIterator( ".1" ),      &number )  && number == .1f );
    assert( parse_number( new StringIterator( ".10" ),     &number )  && number == .10f );
    assert( parse_number( new StringIterator( ".123" ),    &number )  && number == .123f );

    assert( parse_number( new StringIterator( "1.0" ),     &number )  && number == 1.0f );
    assert( parse_number( new StringIterator( "1.1" ),     &number )  && number == 1.1f );
    assert( parse_number( new StringIterator( "1.10" ),    &number )  && number == 1.10f );
    assert( parse_number( new StringIterator( "1.123" ),   &number )  && number == 1.123f );

    assert( parse_number( new StringIterator( "-1.0" ),    &number )  && number == -1.0f );
    assert( parse_number( new StringIterator( "-1.1" ),    &number )  && number == -1.1f );
    assert( parse_number( new StringIterator( "-1.10" ),   &number )  && number == -1.10f );
    assert( parse_number( new StringIterator( "-1.123" ),  &number )  && number == -1.123f );

    assert( parse_number( new StringIterator( "-.1" ),     &number )  && number == -.1f );
    assert( parse_number( new StringIterator( "-.10" ),    &number )  && number == -.10f );
    assert( parse_number( new StringIterator( "-.123" ),   &number )  && number == -.123f );

    assert( parse_number( new StringIterator( "+1.0" ),    &number )  && number == 1.0f );
    assert( parse_number( new StringIterator( "+1.1" ),    &number )  && number == 1.1f );
    assert( parse_number( new StringIterator( "+1.10" ),   &number )  && number == 1.10f );
    assert( parse_number( new StringIterator( "+1.123" ),  &number )  && number == 1.123f );

    assert( parse_number( new StringIterator( "+.1" ),     &number )  && number == .1f );
    assert( parse_number( new StringIterator( "+.10" ),    &number )  && number == .10f );
    assert( parse_number( new StringIterator( "+.123" ),   &number )  && number == .123f );

    assert( parse_number( new StringIterator( "10e3" ),    &number )  && number == 10000.0f );
    assert( parse_number( new StringIterator( "-3.4e-2" ), &number )  && number == -.034f );

    assert( parse_number( new StringIterator( "12" ),      &number )  && number == 12 );
    assert( parse_number( new StringIterator( "4.01" ),    &number )  && number == 4.01f );
    assert( parse_number( new StringIterator( "-456.8" ),  &number )  && number == -456.8f );
    assert( parse_number( new StringIterator( "0.0" ),     &number )  && number == 0.0f );
    assert( parse_number( new StringIterator( "+0.0" ),    &number )  && number == 0.0f );
    assert( parse_number( new StringIterator( "-0.0" ),    &number )  && number == 0.0f );
    assert( parse_number( new StringIterator( ".60" ),     &number )  && number == 0.60f );
    assert( parse_number( new StringIterator( "10e3" ),    &number )  && number == 10e3f );
    assert( parse_number( new StringIterator( "-3.4e-2" ), &number )  && number == -3.4e-2f );
}
