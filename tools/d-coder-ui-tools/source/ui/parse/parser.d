module ui.parse.parser;

import std.stdio;
import ui.parse.t.parser     : Doc;
import std.range             : empty;
import std.range             : front;
import std.stdio             : File;
import std.file              : exists;
import std.file              : mkdir;
import std.path              : buildPath;
import std.range             : drop;
import std.string            : stripLeft;
import std.string            : startsWith;
import ui.parse.t.parser     : EventCallback;
import ui.parse.t.tokenize   : Tok;
import ui.parse.t.charreader : CharReader;
import ui.parse.t.tokenize   : TokType;
import ui.parse.t.tokenize   : isWhite;
import ui.parse.t.tokenize   : skipSpaces;
import ui.parse.t.tokenize   : readRoundBrackets;
import ui.parse.t.tokenize   : readDoubleQuoted;
import std.string : indexOf;
import std.string : leftJustify;

// create .def
// dub build
//   read .def
//     parse
//     write generated/class.d
//     write generated/package.d
//       import all generated/*


bool parse( string fileName )
{
    Doc doc;

    remove_pre_generated();

    parse_t( fileName, &doc );

    generate_style( &doc );
    generate_body( &doc );
    generate_package( &doc );

    return true;
}


void remove_pre_generated()
{
    import std.file  : rmdirRecurse;

    if ( exists( buildPath( "source", "generated" ) ) )
    {
        rmdirRecurse( buildPath( "source", "generated" ) );
    }
}

bool parse_t( string fileName, Doc* doc )
{
    import ui.parse.t.parser : TParser;
    
    auto tparser = new TParser;
    tparser.parseFile( fileName );

    *doc = tparser.doc;

    return true;
}


void generate_body( Doc* doc )
{
    import std.format : format;
    import std.conv : to;

    string s;

    s ~= "module generated.tree;\n";
    s ~= "\n";
    s ~= "\n";

    s ~= "import ui;\n";
    s ~= "import generated.style;\n";
    s ~= "\n";

    s ~= "void initUI( Document* document )\n";
    s ~= "{\n";
    s ~= "  Element* element;\n";
    s ~= "  Element* parentElement;\n";
    s ~= "  \n";

    s ~= "  // body \n";
    foreach ( className; doc.body.classes )
    s ~= format!"  document.body.addClass!%s;\n"(  className );
    s ~= "  \n";

    foreach ( element; doc.body.childs )
    {
        s ~= format!"    // %s\n"( element.tagName );
        s ~= format!"    element = document.createElement( %s );\n"( element.tagName.quote() );
        foreach ( className; element.classes )
        s ~= format!"    element.addClass!%s;\n"(  className );
        s ~=        "    document.body.appendChild( element );\n";
        s ~=        "    \n";

        if ( element.childs.length > 0 )
        s ~=        "    parentElement = element;\n";
        s ~=        "    \n";

        foreach ( e; element.childs )
        {
            s ~= format!"      // %s\n"( e.tagName );
            s ~= format!"      element = document.createElement( %s );\n"( e.tagName.quote() );
            foreach ( className; element.classes )
            s ~= format!"      element.addClass!%s;\n"(  className );
            s ~=        "      parentElement.appendChild( element );\n";
            s ~=        "      \n";
        }
    }

    s ~= "}\n";

    writeln( s );

    //
    createFolder( buildPath( "source", "generated" ) );

    // save file
    writeText( buildPath( "source", "generated", "tree.d" ), s );
}


string quote( string s )
{
    return '"' ~ s ~ '"';
}


void generate_style( Doc* doc )
{
    import std.format : format;
    import std.conv : to;

    string s;

    s ~= "module generated.style;\n";
    s ~= "\n";
    s ~= "\n";
    s ~= "import ui;\n";
    s ~= "\n";

    foreach ( cls; doc.style.classes )
    {
    s ~= format!"struct %s\n"( cls.className );
    s ~=        "{\n";
    s ~= format!"    string name = %s;\n"( cls.className.quote );
    s ~=        "    \n";
    s ~=        "    static\n";
    s ~= format!"    void setter( Element* element )\n";
    s ~=        "    {\n";
    s ~=        "        with ( element.computed )\n";
    s ~=        "        {\n";
    reformat_setters( cls.setters );
    foreach ( setter; cls.setters )
    {
    s ~= format!"            %s\n"( setter );
    }
    s ~=        "        }\n";
    s ~=        "    }\n";
    s ~=        "    \n";
    if ( cls.eventCallbacks.length > 0 )
    s ~= format!"%s\n"( generate_on( doc, cls.eventCallbacks ) );
    s ~=        "}\n";
    s ~=        "\n";
    } // foreach doc.style.classes

    // register classes
    s ~=        "static\n";
    s ~=        "this()\n";
    s ~=        "{\n";
    foreach ( cls; doc.style.classes )
    s ~= format!"    registerClass!%s();\n"( cls.className );
    s ~=        "}\n";


    writeln( s );

    //
    createFolder( buildPath( "source", "generated" ) );

    // save file
    writeText( buildPath( "source", "generated", "style.d" ), s );
}

void createFolder( string path )
{
    if ( !exists( path ) )
    {
        mkdir( path );
    }
}

void writeText( string path, string text )
{
    auto f = File( path, "w" );
    f.write( text );
    f.close();
}

void generate_package( Doc* doc )
{
    import std.format : format;
    import std.conv : to;

    string s;

    s ~= "module generated;\n";
    s ~= "\n";
    s ~= "public import generated.style;\n";
    s ~= "public import generated.tree;\n";
    s ~= "\n";

    writeln( s );

    //
    createFolder( buildPath( "source", "generated" ) );

    // save file
    writeText( buildPath( "source", "generated", "package.d" ), s );
}


string generate_on( Doc* doc, ref EventCallback[] eventCallbacks )
{
    import ui.parse.t.tokenize : Tok;
    import std.format : format;

    string s;
    Tok[] tokenized;

    // grouped name arg1
    //   on
    //   on WM_KEYDOWN
    //   on WM_KEYDOWN VK_SPACE
    alias NAME = string;
    alias ARG1 = string;

    GroupedEventCallbacks grouped;

    foreach ( ref cb; eventCallbacks )
    {
        grouped ~= &cb;
    }

    // on()
    s ~=        "    static\n";
    s ~=        "    void on( Element* element, Event* event )\n";
    s ~=        "    {\n";
    s ~=        "        switch ( event.type )\n";
    s ~=        "        {\n";
    foreach ( eventName; grouped.orderedKeys )
    s ~= format!"            case %s: on_%s( element, event ); break;\n"( eventName, eventName );
    s ~=        "            default:\n";
    s ~=        "        }\n";
    s ~=        "    }\n";
    s ~=        "    \n";
    // end on()

    // on_XXXXXX()
    foreach ( eventName; grouped.orderedKeys )
    {
    s ~=        "    static\n";
    s ~= format!"    void on_%s( Element* element, Event* event )\n"( eventName );
    s ~=        "    {\n";
    auto byArg = grouped.array[ eventName ];
    foreach ( eventArg; byArg.orderedKeys )
    {
    auto byArgGroup = byArg.array[ eventArg ];
    if ( eventArg == "" )
    {
    s ~=        "        with ( element )\n";
    s ~=        "        {\n";
    foreach ( ecb; byArgGroup )
    {
    s ~= format!"            // %s\n"( ecb.src );
    s ~=        generate_event_code( "            ", ecb );
    }
    s ~=        "            return;\n";
    s ~=        "        }\n";
    s ~=        "        \n";
    }
    else // eventArg != ""
    {
    s ~= format!"        if ( event.arg1 == %s )\n"( eventArg );
    s ~=        "        with ( element )\n";
    s ~=        "        {\n";
    foreach ( ecb; byArgGroup )
    {
    s ~= format!"            // %s\n"( ecb.src );
    s ~=        generate_event_code( "            ", ecb );
    }
    s ~=        "            return;\n";
    s ~=        "        }\n";
    } //     if eventArg
    } //   foreach eventArg
    s ~=        "    }\n";
    s ~=        "    \n";
    } // foreach eventName
    // end on_XXXXXX()

    return s;
}


//
struct OrderedAssocArray( T )
{
    string[] orderedKeys;
    T[ string ] array;

    void opOpAssign( string op : "~" )( T b )
    {
        auto key = keyFunc( b );
        auto x = key in array;
        if ( x !is null )
        {
            array[ key ] = b;
        }
        else

        {
            orderedKeys ~= key;
            array[ key ] = b;
        }
    }

    auto keyFunc( T b )
    {
        return b.name;
    }

    void each()
    {
        foreach( key; orderedKeys )
        {
            // auto x = array[ key ];
        }
    }
}

//
struct GroupedOrderedAssocArray( T, alias keyFunc )
{
    string[] orderedKeys;
    T[][ string ] array;

    void opOpAssign( string op : "~" )( T b )
    {
        auto key = keyFunc( b );
        auto group = key in array;
        if ( group !is null )
        {
            *group ~= b;
        }
        else

        {
            orderedKeys ~= key;
            array[ key ] = [ b ];
        }
    }

    void each()
    {
        foreach ( key; orderedKeys )
        {
            writeln( "  ", !key.empty ? key : "." );
            auto group = array[ key ];

            foreach ( x; group )
            {
                writeln( "    ", *x );
            }
        }
    }
}


alias GroupedOrderedAssocArray!( EventCallback*, b => b.arg1  ) ByArg1;

struct GroupedEventCallbacks
{
    string[] orderedKeys;
    ByArg1[ string ] array; // by Name

    void opOpAssign( string op : "~" )( EventCallback* b )
    {
        auto key = keyFunc( b );
        
        auto group = key in array;

        if ( group !is null )
        {
            *group ~= b;
        }
        else

        {
            orderedKeys ~= key;
            auto byArg = ByArg1();
            byArg ~= b;
            array[ key ] = byArg;
        }
    }

    // get name
    auto keyFunc( TB )( TB b )
    {
        return b.name;
    }


    void each()
    {
        foreach ( key; orderedKeys )
        {
            writeln( key );
            auto byArg = array[ key ];
            byArg.each();
        }
    }
}


string generate_event_code( string indent, EventCallback* ecb )
{
    import std.format : format;

    string s;

    if ( isNativeCode( ecb ) )
    s ~=        generate_native_code( ecb, indent );
    else
    s ~=        generate_meta_code( ecb, indent );

    return s;
}


bool isNativeCode( EventCallback* ecb )
{
    import std.range  : empty;
    import std.range  : front;
    import std.string : stripLeft;
    import std.string : startsWith;

    return !ecb.eventBody.empty && ecb.eventBody.front.stripLeft.startsWith( "{" );
}

auto generate_native_code( EventCallback* ecb, string indent )
{
    import std.range  : front;
    import std.string : indexOf;

    string s;

    size_t blockIndent = ecb.eventBody.front.indexOf( "{" );

    foreach ( line; ecb.eventBody )
    {
        // remove indent for beauty code
        s ~= indent ~ line[ blockIndent .. $ ] ~ "\n";
    }

    return s;
}

auto generate_meta_code( EventCallback* ecb, string indent )
{
    import std.format : format;

    string s;
    Tok[]  tokenized;
    size_t indentLength;

    foreach ( line; ecb.eventBody )
    {
        tokenized = tokenize_meta_code( line, &indentLength );
        writeln( "tokenized: ", tokenized );

        if ( tokenized.length > 0 )
        if ( tokenized.front.type == TokType.operator )
        {
            auto operator = translateOperator( tokenized.front.s );
            // args
            if ( tokenized.length >= 2 )
            {
                if ( operator == "addClass" ||
                     operator == "delClass" || 
                     operator == "hasClass" || 
                     operator == "toggleClass" )
                {
                    auto operatorArg = tokenized.drop(1).front.s;
                    s ~= format!"%s%s!%s();\n"( indent, operator, operatorArg );
                }
            }
            else 

            // operator only
            {
                s ~= format!"%s%s();\n"( indent, operator );
            }
        }        
    }

    return s;
}

auto translateOperator( string s )
{
    switch ( s )
    {
        case "+": return "addClass";
        case "-": return "delClass";
        case "?": return "hasClass";
        case "~": return "toggleClass";
        default: return s;
    }
}

Tok[] tokenize_meta_code( string s, size_t* indentLength )
{
    // ~selected
    //   read indent
    //   read operator
    //   read args
    import std.range : back;
    import ui.parse.t.tokenize : readIndent;
    import ui.parse.t.tokenize : readKeyword;
    import ui.parse.t.tokenize : skipSpaces;

    Tok[] tokenized;

    auto reader = CharReader( s );

    // indent
    readIndent( reader, indentLength );

    // keyword
    readOperator( reader, tokenized );

    // skip spaces
    skipSpaces( reader );

    // has args
    if ( !reader.empty )
    {
        auto c = reader.front;

        read_operator_arg:

        // class
        readOperatorArg( reader, tokenized );

        // skip spaces
        skipSpaces( reader );
        
        if ( !reader.empty )
        {
            c = reader.front;
            goto read_operator_arg;  // the last .class will be added to list after the prior .class
        }
    }

    return tokenized;
}


bool readOperator( ref CharReader reader, ref Tok[] tokenized )
{
    auto startState = reader.getState();

    const
    string[] operators =
    [
        "+",
        "-",
        "?",
        "~",
    ];

    reader_loop:
    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        if ( isWhite( s ) )
        {
            break;
        }
        else

        static
        foreach ( OP; operators )
        {        
            if ( s.startsWith( OP ) )
            {
                reader.popFront(); // skip operator
                break reader_loop;
            }
        }
    }


    //
    if ( reader != startState )
    {
        tokenized ~= Tok( TokType.operator, reader.readedOf( startState ), 0, startState.pos );
        return true;
    }
    else
    {
        return false;
    }
}

bool readOperatorArg( ref CharReader reader, ref Tok[] tokenized )
{
    auto startState = reader.getState();
    auto argState   = reader.getState();

    for ( string s; !reader.empty; reader.popFront() )
    {
        s = reader.front;

        if ( isWhite( s ) )
        {
            tokenized ~= Tok( TokType.operatorArg, reader.readedOf( argState ), 0, startState.pos );
            skipSpaces( reader );
            argState = reader.getState();
        }
        else

        if ( s.startsWith( "(" ) )
        {
            if ( readRoundBrackets( reader ) )
            {
                tokenized ~= Tok( TokType.operatorArg, reader.readedOf( argState ), 0, startState.pos );
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
                tokenized ~= Tok( TokType.operatorArg, reader.readedOf( argState ), 0, startState.pos );
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
        tokenized ~= Tok( TokType.operatorArg, reader.readedOf( argState ), 0, argState.pos );
    }

    return true;
}


void reformat_setters( ref string[] setters )
{
    size_t max_eq_pos;

    // fin max =
    foreach ( s; setters )
    {
        auto eq_pos = s.indexOf( '=' );
        if ( eq_pos != -1 )
        if ( eq_pos > max_eq_pos )
        {
            max_eq_pos = eq_pos;
        }
    }

    // format
    foreach ( ref s; setters )
    {
        auto eq_pos = s.indexOf( '=' );
        if ( eq_pos != -1 )
        {
            s = s[ 0 .. eq_pos ].leftJustify( max_eq_pos, ' ' ) ~ s[ eq_pos .. $ ];
        }
    }
}
