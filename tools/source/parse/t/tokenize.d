module parse.t.tokenize;

import stringiterator : StringIterator;


enum TokType
{
    indent,
    keyword,
    tag,
    className,
    id,
    property,
    colon,
    propertyArg
}

struct Tok
{
    TokType type;
    string  s;
    size_t  line;
    size_t  pos;
}


Tok[] tokenize( string s, size_t* indentLength )
{
    // "border: 1px solid #ccc"
    // [ "border", ":", "1px", "solid", "#ccc" ]
    //
    // "border: 1px solid rgb( 255, 255, 255 )"
    // [ "border", ":", "1px", "solid", "rgb( 255, 255, 255 )" ]
    //
    // e
    // e .class
    // e .class #id
    // e .class .class #id
    // [ indent, tagName, className, className, id ]
    // [ indent, property, args ]

    // border
    // :
    // 1px 
    // rgb( 255, 255, 255 )
    // "string"
    // /* comment */

    import std.range : back;

    auto iter = new StringIterator( s, 0 );

    // indent
    readIndent( iter, indentLength );

    // keyword
    Tok[] tokenized;
    readKeyword( iter, tokenized );

    // skip spaces
    skipSpaces( iter );

    // 
    if ( !iter.empty )
    {
        auto c = iter.front;

        // tag
        if ( c == '.' || c == '#' )
        {
            // update 1st token type
            tokenized.back.type = TokType.tag;

            read_class_or_id:

            // .class
            if ( c == '.' )
            {
                // skip spaces
                readClass( iter, tokenized );

                // skip spaces
                skipSpaces( iter );
                
                if ( !iter.empty )
                {
                    c = iter.front;
                    goto read_class_or_id;  // the last .class will be added to list after the prior .class
                }
            }
            else

            // #id
            if ( c == '#' )
            {
                // skip spaces
                readId( iter, tokenized );

                // skip spaces
                skipSpaces( iter );

                if ( !iter.empty )
                {
                    c = iter.front;
                    goto read_class_or_id;  // the last #id will overwrite the prior #id
                }
            }
            else

            {
                // no more variants. ignore some wrong
                skipWordToSpaces( iter );

                // skip spaces
                skipSpaces( iter );                
            }
        }
        else

        // keyword: args
        if ( c == ':' )
        {
            // update 1st token type
            tokenized.back.type = TokType.property;

            // skip spaces
            skipSpaces( iter );

            // ...
            readKeywordArgs( iter, tokenized );
        }
    }

    return tokenized;
}


bool readIndent( StringIterator iter, size_t* indentLength )
{
    import std.algorithm : countUntil;
    *indentLength = iter.countUntil!"a != ' '"();
    return *indentLength > 0;
}


bool readKeyword( StringIterator iter, ref Tok[] tokenized )
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
        tokenized ~= Tok( TokType.keyword, iter.s[ startPos .. iter.pos ], 0, startPos );
        return true;
    }
    else
    {
        return false;
    }
}


bool readClass( StringIterator iter, ref Tok[] tokenized )
{
    size_t dotPos = iter.pos;

    // skip '.'
    iter.popFront();

    size_t startPos = iter.pos;

    foreach ( c; iter )
    {
        if ( c == ' ' )
        {
            break;
        }
    }

    //
    if ( startPos < iter.pos )
    {
        tokenized ~= Tok( TokType.className, iter.s[ startPos .. iter.pos ], 0, startPos );
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


bool skipWordToSpaces( StringIterator iter )
{
    import std.algorithm : countUntil;
    auto charsCount = iter.countUntil!"a == ' '"();
    return charsCount > 0;
}


bool readColon( StringIterator iter, ref Tok[] tokenized )
{
    size_t startPos = iter.pos;

    foreach ( c; iter )
    {
        if ( c == ':' )
        {
            iter.popFront();
            break;
        }
    }

    //
    if ( startPos < iter.pos )
    {
        tokenized ~= Tok( TokType.colon, iter.s[ startPos .. iter.pos ], 0, startPos );
        return true;
    }
    else
    {
        return false;
    }
}


bool readKeywordArgs( StringIterator iter, ref Tok[] tokenized )
{
    size_t startPos = iter.pos;
    size_t argPos   = iter.pos;

    foreach ( c; iter )
    {
        if ( c == ' ' )
        {
            tokenized ~= Tok( TokType.propertyArg, iter.s[ argPos .. iter.pos ], 0, argPos );
            skipSpaces( iter );
            argPos = iter.pos;
        }
        else

        if ( c == '(' )
        {
            if ( readRoundBrackets( iter ) )
            {
                tokenized ~= Tok( TokType.propertyArg, iter.s[ argPos .. iter.pos ], 0, argPos );
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
                tokenized ~= Tok( TokType.propertyArg, iter.s[ argPos .. iter.pos ], 0, argPos );
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
        tokenized ~= Tok( TokType.propertyArg, iter.s[ argPos .. iter.pos ], 0, argPos );
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


bool readId( StringIterator iter, ref Tok[] tokenized )
{
    auto hasPos = iter.pos;

    // skip '#'
    iter.popFront();

    size_t startPos = iter.pos;

    foreach ( c; iter )
    {
        if ( c == ' ' )
        {
            break;
        }
    }

    //
    if ( startPos < iter.pos )
    {
        tokenized ~= Tok( TokType.id, iter.s[ startPos .. iter.pos ], 0, startPos );
        return true;
    }
    else
    {
        return false;
    }
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
    
//    size_t indentLength;

//    writeln( tokenize( "border: 1px solid #ccc", &indentLength ) );
//    writeln( tokenize( "border: 1px solid rgb( 255, 255, 255 )", &indentLength ) );
//    writeln( tokenize( "border-image: url( \"images/b.jpg\" )", &indentLength ) );
//}

