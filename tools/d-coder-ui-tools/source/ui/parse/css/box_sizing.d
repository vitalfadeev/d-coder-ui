module ui.parse.css.box_sizing;

import std.stdio : writeln;
import ui.parse.t.tokenize : Tok;

// https://developer.mozilla.org/en-US/docs/Web/CSS/box-sizing
//
// content-box | border-box
//
// content-box:
//   width: 100px
//   contentBox = 100px
//   renderWidth = 100px + padding + border
//   calculatedWidth = contentBox
//
// border-box:
//   width: 100px
//   contentBox = 100px - padding - border
//   renderWidth = 100px
//   calculatedWidth =  border + padding + contentBox

bool parse_box_sizing( Tok[] tokenized, ref string[] setters )
{
    import std.range  : empty;
    import std.range  : front;
    import std.range  : back;
    import std.range  : drop;
    import std.range  : popFront;
    import std.format : format;
    import std.conv   : to;

    auto args = tokenized[ 2 .. $ ]; // skip ["box-sizing", ":"]

    // box-sizing: args...
    if ( !args.empty )
    {
        auto word = args.front.s;

        // box-sizing: content-box
        if ( word == "content-box" )
        {
            setters ~= format!"boxSizing = BoxSizingType.content_box;"();
            return true;
        }
        else

        // box-sizing: border-box
        if ( word == "border-box" )
        {
            setters ~= format!"boxSizing = BoxSizingType.border_box;"();
            return true;
        }
        else

        // miss
        {
            assert( 0, "error: expect box-sizing args is content-box | border-box: " ~ tokenized.to!string  );
            //return false;
        }
    }
    else

    // box-sizing: <empty>
    {
        import std.conv : to;
        assert( 0, "error: expect box-sizing args: " ~ tokenized.to!string );
        //return false;
    }

//    return false;
}
