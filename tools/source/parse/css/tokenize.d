module parse.css.tokenize;

import stringiterator : StringIterator;


string[] tokenize( string s )
{
    // "border: 1px solid #ccc"
    // [ "border", ":", "1px", "solid", "#ccc" ]
    //
    // "border: 1px solid rgb( 255, 255, 255 )"
    // [ "border", ":", "1px", "solid", "rgb( 255, 255, 255 )" ]

    // border
    // :
    // 1px 
    // rgb( 255, 255, 255 )
    // "string"
    // /* comment */

    auto iter = new StringIterator( s, 0 );

    // indent
    size_t indentLength;
    readIndent( iter, indentLength );

    // keyword
    string[] tokenized;
    readKeyword( iter, tokenized );

    // skip spaces
    skipSpaces( iter );

    // :
    readColon( iter, tokenized );

    // skip spaces
    skipSpaces( iter );

    // ...
    readKeywordArgs( iter, tokenized );

    return tokenized;
}


bool readIndent( StringIterator iter, ref size_t indentLength )
{
    import std.algorithm : countUntil;
    indentLength = iter.countUntil!"a != ' '"();
    return indentLength > 0;
}


bool readKeyword( StringIterator iter, ref string[] tokenized )
{
    size_t startPos = iter.pos;

    foreach ( c; iter )
    {
        if ( c == ' ' )
        {
            break;
        }
        else

        if ( c == ':' )
        {
            break;
        }
    }

    //
    if ( startPos < iter.pos )
    {
        tokenized ~= iter.s[ startPos .. iter.pos ];
        return true;
    }
    else
    {
        return false;
    }
}


bool skipSpaces( StringIterator iter )
{
    import std.algorithm : countUntil;
    auto spacesCount = iter.countUntil!"a != ' '"();
    return spacesCount > 0;
}


bool readColon( StringIterator iter, ref string[] tokenized )
{
    size_t startPos = iter.pos;

    foreach ( c; iter )
    {
        if ( c == ':' )
        {
            break;
        }
    }

    //
    if ( startPos < iter.pos )
    {
        tokenized ~= iter.s[ startPos .. iter.pos ];
        return true;
    }
    else
    {
        return false;
    }
}


bool readKeywordArgs( StringIterator iter, ref string[] tokenized )
{
    size_t startPos = iter.pos;
    size_t argPos   = iter.pos;

    foreach ( c; iter )
    {
        if ( c == ' ' )
        {
            tokenized ~= iter.s[ argPos .. iter.pos ];
            skipSpaces( iter );
            argPos = iter.pos;
        }
        else

        if ( c == '(' )
        {
            if ( readRoundBrackets( iter ) )
            {
                tokenized ~= iter.s[ argPos .. iter.pos ];
                argPos = iter.pos;
            }
            else
            {
                assert( 0, "error: got '(', but not got ')'" ~ iter.s[ argPos .. $ ] );
            }
        }
        else

        if ( c == '"' )
        {
            if ( readDoubleQuoted( iter ) )
            {
                tokenized ~= iter.s[ argPos .. iter.pos ];
                argPos = iter.pos;
            }
            else
            {
                assert( 0, "error: got '\"', but not got '\"'" ~ iter.s[ argPos .. $ ] );
            }
        }
    }

    // to EOF
    if ( argPos < iter.pos )
    {
        tokenized ~= iter.s[ argPos .. iter.pos ];
    }

    return true;
}


bool readRoundBrackets( StringIterator iter )
{
    size_t startPos = iter.pos;

    int opened = 0;
    int closed = 0;

    foreach ( c; iter )
    {
        if ( c == '(' )
        {
            opened++;
        }
        else

        if ( c == ')' )
        {
            closed++;
            if ( closed == opened )
            {
                iter.popFront(); // read )
                return true;
            }
        }
        else

        if ( c == '"' )
        {
            if ( readDoubleQuoted( iter ) )
            {
                //
            }
            else
            {
                assert( 0, "error: got '\"', but not got '\"'" ~ iter.s[ startPos .. $ ] );
            }
        }
    }

    return false;
}


bool readDoubleQuoted( StringIterator iter )
{
    foreach ( c; iter )
    {
        // escaped: \"
        // escaped: \\
        if ( c == '\\' )
        {
            iter.popFront();
            continue; // iter.popFront() again
        }
        else

        if ( c == '\"' )
        {
            iter.popFront(); // read last "
            return true;
        }
    }

    return false;
}


unittest
{
    import std.stdio : writeln;
    assert( tokenize( "border: 1px solid #ccc" ) == ["border", ":", "1px", "solid", "#ccc"] );
    assert( tokenize( "border: 1px solid rgb( 255, 255, 255 )" ) == ["border", ":", "1px", "solid", "rgb( 255, 255, 255 )"] );
    assert( tokenize( "border-image: url( \"images/b.jpg\" )" ) == ["border-image", ":", "url( \"images/b.jpg\" )"] );
}


//void main()
//{
//    import std.stdio : writeln;
//    writeln( tokenize( "border: 1px solid #ccc" ) );
//    writeln( tokenize( "border: 1px solid rgb( 255, 255, 255 )" ) );
//    writeln( tokenize( "border-image: url( \"images/b.jpg\" )" ) );
//}

