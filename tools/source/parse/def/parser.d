module parse.def.parser;

import std.json;
import std.conv  : to;
import std.stdio : writeln;
import ui.base   : Border;
import ui.base   : memberId;
import ui.base   : Pen;
import ui.base   : PenType;
import ui.base   : Props;
import ui        : Color;
import ui        : rgb;


struct DefParser
{
    void parse( string fileName )
    {
        parseDefFile( fileName );
    }
}


// stage
//   border: 1px solid #CCC
// to
//   o1.border = Border( Pen( 3, PenType.solid, 0xCCC.rgb ) );
void parseDefFile( string fileName )
{
    import std.stdio;
    import std.conv   : to;
    import std.string : strip;

    auto file = File( fileName ); // Open for reading

    auto range = file.byLine();

    string className;
    string[] lines;

    foreach ( line; range )
    {
        if ( line.length == 0 )
            continue;

        else
        if ( line[0] != ' ' )
        {
            if ( className )
            {
                parseFileBlock( className, lines );
            }

            className = line.to!string.strip;
            continue;
        }

        else
        if ( line[0] == ' ' || line[0] == '\t' )
        {
            lines ~= line.to!string.strip;
            continue;
        }
    }
}


void parseFileBlock( string className, string[] lines )
{
    import std.format : format;

    Props props;

    string classSource;

    writeln( "module generated.", className, ";"  );
    classSource ~= "module generated." ~ className ~ ";\n";
    classSource ~= "\n";

    writeln( "import ui;"  );
    classSource ~= "import ui;\n";
    classSource ~= "import ui.base : Border;\n";
    classSource ~= "import ui.base : Pen;\n";
    classSource ~= "import ui.base : PenType;\n";
    classSource ~= "import ui.classregistry : registerClass;\n";
    classSource ~= "\n";

    writeln( "struct ", className  );
    classSource ~= "struct " ~ className ~ "\n";

    writeln( "{" );
    classSource ~= "{\n";

    foreach( line; lines )
    {
        writeln( "  ", line );        
        parseFileBlockLine( line, &props );
    }


    // generate file
    foreach( mid; props.modified )
    {
        // color
        if ( mid == 1 ) 
        {
            continue;
        }
        else

        // border
        if ( mid == 2 )
        {
            classSource ~= 
                format!
                    "    Border border = Border( Pen( %d, PenType.%s, %s.rgb ) );\n"
                    ( props.border.pen.width, props.border.pen.type, props.border.pen.color.asHex );
        }
        else

        // end
        if ( mid == 0 )
        {
            break;
        }

    }

    writeln( "}" );
    classSource ~= "}\n";

    classSource ~= "\n";
    classSource ~= "static this() { registerClass!" ~ className ~ "(); }\n";

    writeln( classSource );
    
    import std.file;
    if ( !exists( "generated" ) )
        mkdir( "generated" );
    write( "generated/" ~ className ~ ".d", classSource );
}


void parseFileBlockLine( string line, Props* props )
{
    import std.array  : split;
    import std.string : strip;

    auto splits = line.split( ":" );

    if ( splits.length == 2 )
    {
        auto name  = splits[0].strip;
        auto value = splits[1].strip;

        if ( name == "border" )
        {
            if ( parseBorder( value, &props.border ) )
            {
                auto mid = memberId!( Props, "border" );
                props.modified[ props.modifiedLength ] = mid;
                props.modifiedLength += 1;
            }
        }
    }
    else
    {
        assert( 0, "error: Expected Line format: \"  name: value\": " ~ line );
    }
}


bool parseBorder( string s, Border* border )
{
    import std.array : split;

    // 1px solid #CCC;
    auto splits = s.split( " " );

    // 1px solid #CCC;
    if ( splits.length == 3 )
    {
        // parse pen width, type, color
        ParsePenWidth( splits[0], &border.pen.width );
        ParsePenType( splits[1], &border.pen.type );
        ParsePenColor( splits[2], &border.pen.color );
        return true;
    }
    else 

    // 1px solid;
    if ( splits.length == 2 )
    {
        // parse pen width, type
        ParsePenWidth( splits[0], &border.pen.width );
        ParsePenType( splits[1], &border.pen.type );
        return true;
    }
    else 

    // 1px;
    if ( splits.length == 1 )
    {
        // parse pen width
        ParsePenWidth( splits[0], &border.pen.width );
        return true;
    }

    return false;
}


bool ParsePenWidth( string s, typeof( Pen.width )* width )
{
    // 1px | 1

    import std.conv : to;
    import std.algorithm : endsWith;

    if ( s.endsWith( "px" ) )
    {
        writeln( s[ 0 .. $-2 ].to!( typeof( Pen.width ) ) );
        *width = s[ 0 .. $-2 ].to!( typeof( Pen.width ) );
        return true;
    }
    else
    {
        writeln( s.to!int );
        *width = s.to!( typeof( Pen.width ) );
        return true;
    }
}


bool ParsePenType( string s, typeof( Pen.type )* type )
{
    // none | solid

    if ( s == "none" )
    {
        writeln( "none" );
        *type = PenType.none;
        return true;
    } 
    if ( s == "solid" )
    {
        writeln( "solid" );
        *type = PenType.solid;
        return true;
    } 
    else
    {
        writeln( "error: unsupported pen type: " ~ s );
        return false;
    }
}


void ParsePenColor( string s, Color* color )
{
    // #ABC | #AABBCC
    writeln( s );
    parseColor( s, color );
}


bool parseColor( string s, Color* color )
{
    return parseColorString( s, color );
}


// ******************************************************************
void parseJsonFile( string fileName )
{
    import std.file;

    string text = readText( fileName );
    
    JSONValue j = parseJSON( text );

    writeln( j );

    foreach( string className, classContent; j )
    {
        parseJsonFileBlock( className, classContent );
    }
}


void parseJsonFileBlock( string className, JSONValue lines )
{
    writeln( "struct ", className  );
    writeln( "{" );
    foreach( string key, value; lines )
    {
        if ( key == "border" )
        {
            Border border;
            writeln( "  Border border = ", value, ";" );
            parseBorder( value.str, &border );
        }
        else
        if ( key == "color" )
        {
            writeln( "  Color color = ", value, ";" );
        }
    }
    writeln( "}" );
}


// 
bool parseColorString( string s, Color* color )
{
    import std.algorithm : startsWith;
    import std.string : strip;

    string striped = s.strip;

    if ( striped.length > 0 )
    {
        if ( striped[0] == '#' )
        {
            if ( striped.length == 4 )
            {
                return Hex3StringColor( striped, color );
            }
            else
            if ( striped.length == 7 )
            {
                return Hex6StringColor( striped, color );
            }
        }
        else
        if ( striped.startsWith( "rgb" ) )
        {
            return RGBStringColor( striped, color );
        }
        else
        {
            return NameStringColor( striped, color );
        }
    }

    return false;
}


bool Hex3StringColor( string s, Color* color )
{
    // #CCC

    *color = rgb(
        to!ubyte( to!ubyte( s[ 1 .. 2 ], 16 ) << 4 ),
        to!ubyte( to!ubyte( s[ 2 .. 3 ], 16 ) << 4 ),
        to!ubyte( to!ubyte( s[ 3 .. 4 ], 16 ) << 4 )
    );

    return true;
}


bool Hex6StringColor( string s, Color* color )
{
    // #CCDDEE

    *color = rgb(
        to!ubyte( s[ 1 .. 3 ], 16 ),
        to!ubyte( s[ 3 .. 5 ], 16 ),
        to!ubyte( s[ 5 .. 7 ], 16 )
    );

    return true;
}


bool RGBStringColor( string s, Color* color )
{
    // rgb( 255, 255, 255 )

    import std.array     : split;
    import std.array     : array;
    import std.algorithm : map;
    import std.string    : strip;

    string rgbValues = s[ 4 .. $-1 ]; // rgb( 255, 255, 255 ) -> "255, 255, 255"
    string[] splits = rgbValues.split(",").map!( a => a.strip ).array;

    *color = rgb(
        to!ubyte( splits[0], 10 ),
        to!ubyte( splits[1], 10 ),
        to!ubyte( splits[2], 10 )
    );

    return true;
}


bool NameStringColor( string s, Color* color )
{
    import ui.def.csscolors : CssColors;

    auto cssColor = s in CssColors;

    if ( cssColor !is null )
    {
        *color = *cssColor;

        return true;
    }

    return false;
}
