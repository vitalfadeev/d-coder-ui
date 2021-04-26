import std.stdio;
import parse.t.parser : Doc;
import std.stdio : File;
import std.file : exists;
import std.file : mkdir;
import std.path : buildPath;

// create .def
// dub build
//   read .def
//     parse
//     write generated/class.d
//     write generated/package.d
//       import all generated/*


void main()
{
    Doc doc;
    //parse_css();
    parse_t( &doc );
    generate_d( &doc );
}


void parse_css()
{
    //import def.parser : parseDefFile;
    //parseDefFile( "stage.def" );
    //parseDefFile( "selected.def" );
}

bool parse_t( Doc* doc )
{
    import parse.t.parser : TParser;
    
    auto tparser = new TParser;
    tparser.parseFile( "app.t" );

    *doc = tparser.doc;

    return true;
}


void generate_d( Doc* doc )
{
    import std.format : format;
    import std.conv : to;

    string s;

    s ~= "module generated.tree;\n";
    s ~= "\n";

    s ~= "import ui;\n";
    s ~= "\n";

    s ~= "void initUI()\n";
    s ~= "{\n";
    s ~= "  Document document;\n";
    s ~= "\n";
    s ~= "  Element* element;\n";
    s ~= "  Element* parentElement;\n";
    s ~= "  \n";

    s ~= "  // body \n";
    if ( doc.body.id.length > 0 )
    s ~= format!"  document.body.id      = %s;\n"( doc.body.id.quote() );
    foreach ( className; doc.body.classes )
    s ~= format!"  document.body.addClass!%s;\n"(  className );
    s ~= "  \n";

    foreach( element; doc.body.childs )
    {
        s ~= format!"    // %s\n"( element.tagName );
        s ~= format!"    element = document.createElement( %s );\n"( element.tagName.quote() );
        if ( element.id.length > 0 )
        s ~= format!"    element.id      = %s;\n"( element.id.quote() );
        foreach ( className; element.classes )
        s ~= format!"    element.addClass!%s;\n"(  className );
        s ~=        "    document.body.appendChilds( element );\n";
        s ~=        "    \n";

        if ( element.childs.length > 0 )
        s ~=        "    parentElement = element;\n";
        s ~=        "    \n";

        foreach( e; element.childs )
        {
            s ~= format!"      // %s\n"( e.tagName );
            s ~= format!"      element = document.createElement( %s );\n"( e.tagName.quote() );
            if ( e.id.length > 0 )
            s ~= format!"      element.id      = %s;\n"( e.id.quote() );
            foreach ( className; element.classes )
            s ~= format!"      element.addClass!%s;\n"(  className );
            s ~=        "      parentElement.appendChilds( element );\n";
            s ~=        "      \n";
        }
    }

    s ~= "}\n";

    writeln( s );

    // save file
    if ( !exists( buildPath( "source", "generated" ) ) )
    {
        mkdir( buildPath( "source", "generated" ) );
    }

    auto f = File( buildPath( "source", "generated", "tree.d" ), "w" );
    f.write( s );
    f.close();
}


string quote( string s )
{
    return '"' ~ s ~ '"';
}

