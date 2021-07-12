module ui.parse.css.width;

import std.stdio : writeln;
import ui.parse.t.tokenize : Tok;


bool parse_width( Tok[] tokenized, ref string[] setters )
{
    import std.range                   : front;
    import std.range                   : drop;
    import std.range                   : empty;
    import ui.parse.css.types          : Length;
    import ui.parse.css.types          : LengthUnit;
    import ui.parse.css.stringiterator : StringIterator;
    import ui.parse.css.length         : parse_length;
    import std.format                  : format;

    auto args = tokenized[ 2 .. $ ]; // skip ["border", ":"]

    if ( !args.empty )
    {
        auto word = args.front.s;

        Length length;

        if ( parse_length( new StringIterator( word ), &length ) )
        {
            setters ~= format!"width = (%f).%s;"( length.length, length.unit );
            return true;
        }
    }
    else

    // width: <empty>
    {
        import std.conv : to;
        assert( 0, "error: expect width args: " ~ tokenized.to!string );
        //return false;
    }

    return false;
}

