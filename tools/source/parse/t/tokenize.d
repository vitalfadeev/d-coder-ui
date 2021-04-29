module parse.t.tokenize;

import stringiterator : StringIterator;
import parse.t.charreader : CharReader;
import std.string : startsWith;
import std.stdio : writeln;


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

    Tok[] tokenized;

    auto reader = CharReader( s );

    // indent
    readIndent( reader, indentLength );

    // keyword
    readKeyword( reader, tokenized );

    // skip spaces
    skipSpaces( reader );

    // tag or property
    if ( !reader.empty )
    {
        auto c = reader.front;

        // property. format is: "keyword: args"
        if ( c.startsWith( ":" ) )
        {
            // update 1st token type
            tokenized.back.type = TokType.property;

            // :
            readColon( reader, tokenized );

            // skip spaces
            skipSpaces( reader );

            // ...
            readKeywordArgs( reader, tokenized );
        }
        else

        // tag. format is: "e class class"
        {
            // update 1st token type
            tokenized.back.type = TokType.tag;

            read_class:

            // class
            readClass( reader, tokenized );

            // skip spaces
            skipSpaces( reader );
            
            if ( !reader.empty )
            {
                c = reader.front;
                goto read_class;  // the last .class will be added to list after the prior .class
            }
        }
    }

    return tokenized;
}


bool readIndent( ref CharReader reader, size_t* indentLength )
{
    auto startState = reader.getState();

    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        if ( isWhite( s ) )
        {
            //
        }
        else

        {
            break;
        }
    }

    *indentLength = reader - startState; // size_t

    return *indentLength > 0;
}


bool isWhite( string s )
{
    import std.string : startsWith;
    return s.startsWith( " " );
}


bool readKeyword( ref CharReader reader, ref Tok[] tokenized )
{
    auto startState = reader.getState();

    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        if ( isWhite( s ) )
        {
            break;
        }
        else

        if ( s.startsWith( ":" ) )
        {
            break;
        }
    }


    //
    if ( reader != startState )
    {
        tokenized ~= Tok( TokType.keyword, reader.readedOf( startState ), 0, startState.pos );
        return true;
    }
    else
    {
        return false;
    }
}


bool readClass( ref CharReader reader, ref Tok[] tokenized )
{
    auto startState = reader.getState();

    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        if ( isWhite( s ) )
        {
            break;
        }
    }

    //
    if ( reader != startState )
    {
        tokenized ~= Tok( TokType.className, reader.readedOf( startState ), 0, startState.pos );
        return true;
    }
    else
    {
        return false;
    }
}


bool skipSpaces( ref CharReader reader )
{
    auto startState = reader.getState();

    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        if ( isWhite( s ) )
        {
            //
        }
        else

        {
            break;
        }
    }

    auto spaces = reader - startState; // size_t

    return spaces > 0;
}


bool skipWordToSpaces( ref CharReader reader )
{
    auto startState = reader.getState();

    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        if ( isWhite( s ) )
        {
            break;
        }
    }

    auto spaces = reader - startState; // size_t

    return spaces > 0;
}


bool readColon( ref CharReader reader, ref Tok[] tokenized )
{
    auto startState = reader.getState();

    if ( !reader.empty )
    if ( reader.front.startsWith( ":" ) )
    {
        reader.popFront();
    }

    //
    if ( reader != startState )
    {
        tokenized ~= Tok( TokType.colon, reader.readedOf( startState ), 0, startState.pos );
        return true;
    }
    else
    {
        return false;
    }
}


bool readKeywordArgs( ref CharReader reader, ref Tok[] tokenized )
{
    auto startState = reader.getState();
    auto argState   = reader.getState();

    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        if ( isWhite( s ) )
        {
            tokenized ~= Tok( TokType.propertyArg, reader.readedOf( argState ), 0, startState.pos );
            skipSpaces( reader );
            argState = reader.getState();
        }
        else

        if ( s.startsWith( "(" ) )
        {
            if ( readRoundBrackets( reader ) )
            {
                tokenized ~= Tok( TokType.propertyArg, reader.readedOf( argState ), 0, startState.pos );
                argState = reader.getState();
            }
            else
            {
                assert( 0, "error: got '(', but not got ')'" ~ argState.s );
            }
        }
        else

        if ( s.startsWith( "\"" ) )
        {
            if ( readDoubleQuoted( reader ) )
            {
                tokenized ~= Tok( TokType.propertyArg, reader.readedOf( argState ), 0, startState.pos );
                argState = reader.getState();
            }
            else
            {
                assert( 0, "error: got '\"', but not got '\"'" ~ argState.s );
            }
        }
    }

    // to EOF
    if ( reader != argState )
    {
        tokenized ~= Tok( TokType.propertyArg, reader.readedOf( argState ), 0, argState.pos );
    }

    return true;
}


bool readRoundBrackets( ref CharReader reader )
{
    auto startState = reader.getState();

    int opened = 0;
    int closed = 0;

    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        if ( s.startsWith( "(" ) )
        {
            opened++;
        }
        else

        if ( s.startsWith( ")" ) )
        {
            closed++;
            if ( closed == opened )
            {
                reader.popFront(); // read )
                return true;
            }
        }
        else

        if ( s.startsWith( "\"" ) )
        {
            if ( readDoubleQuoted( reader ) )
            {
                //
            }
            else
            {
                assert( 0, "error: got '\"', but not got '\"'" ~ startState.s );
            }
        }
    }

    return false;
}


bool readDoubleQuoted( ref CharReader reader )
{
    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        // escaped: \"
        // escaped: \\
        if ( s.startsWith( "\\" ) )
        {
            reader.popFront();
            continue; // iter.popFront() again
        }
        else

        if ( s.startsWith( "\"" ) )
        {
            reader.popFront(); // read last "
            return true;
        }
    }

    return false;
}


bool readId( ref CharReader reader, ref Tok[] tokenized )
{
    auto hashStart = reader.getState();

    // skip '#'
    reader.popFront();

    auto startState = reader.getState();

    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        if ( isWhite( s ) )
        {
            break;
        }
    }

    //
    if ( reader != startState )
    {
        tokenized ~= Tok( TokType.id, reader.readedOf( startState ), 0, startState.pos );
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

