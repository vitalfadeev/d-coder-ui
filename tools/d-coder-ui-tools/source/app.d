import std.stdio;
import ui.parse.t.parser : Doc;
import std.stdio : File;
import std.file  : exists;
import std.file  : mkdir;
import std.path  : buildPath;

// create .def
// dub build
//   read .def
//     parse
//     write generated/class.d
//     write generated/package.d
//       import all generated/*


void main()
{
    import ui.parse.parser : parse;

    parse( "app.t" );
}
