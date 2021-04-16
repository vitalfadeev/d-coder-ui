import std.stdio;

// create .def
// dub build
//   read .def
//     parse
//     write generated/class.d
//     write generated/package.d
//       import all generated/*


void main()
{
    //parse_css();
    parse_t();
}


void parse_css()
{
    //import def.parser : parseDefFile;
    //parseDefFile( "stage.def" );
    //parseDefFile( "selected.def" );
}

void parse_t()
{
    import parse.t.parser : TParser;
    
    auto tparser = new TParser;
    tparser.parseFile( "app.t" );
}
