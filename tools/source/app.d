import std.stdio;
import parse.t.parser : Doc;

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

    s ~= "import ui.element : Element;\n";
    s ~= "\n";

    s ~= "Element* element;\n";
    s ~= "Element* parentElement;\n";
    s ~= "\n";

    s ~= "// body \n";
    s ~= "document.body.clsses = doc.body.classes;\n";
    s ~= "document.body.id     = doc.body.id;\n";
    s ~= "\n";

    foreach( element; doc.body.childs )
    {
        s ~=        "  // body's element\n";
        s ~= format!"  element = document.createElement( %s );\n"( element.tagName.quote() );
        s ~= format!"  element.id      = %s;\n"( element.id.quote() );
        s ~= format!"  element.classes = %s;\n"( element.classes.to!string );
        s ~=        "  document.body.appendChilds( element );\n";
        s ~=        "  parentElement = element;\n";
        s ~=        "  \n";

        foreach( e; element.childs )
        {
            s ~=        "    // element\n";
            s ~= format!"    element = document.createElement( %s );\n"( e.tagName.quote() );
            s ~= format!"    element.id      = %s;\n"( e.id.quote() );
            s ~= format!"    element.classes = %s;\n"( e.classes.to!string );
            s ~=        "    parentElement.appendChilds( element );\n";
            s ~=        "    \n";
        }
    }

    writeln( s );
}


string quote( string s )
{
    return '"' ~ s ~ '"';
}

