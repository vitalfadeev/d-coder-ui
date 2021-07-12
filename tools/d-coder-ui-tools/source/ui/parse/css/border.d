module ui.parse.css.border;

import std.stdio : writeln;
import ui.parse.t.tokenize : Tok;


bool parse_border( Tok[] tokenized, ref string[] setters )
{
    // https://developer.mozilla.org/ru/docs/Web/CSS/border

    /*
    // style
    border: solid;
    
    // style color 
    border: solid #777;
    
    // width style
    border: 1px solid;

    // width style color 
    border: 1px solid #777;
    
    // Global values 
    border: inherit;
    border: initial;
    border: unset;
    */

    import std.range : front;
    import std.range : drop;
    import std.range : empty;
    import ui.parse.css.border_style;
    import ui.parse.css.line_style;
    import ui.parse.css.line_width;
    import ui.parse.css.color;
    import ui.parse.css.types : LineStyle;
    import ui.parse.css.border_width : parse_border_width;
    import ui.parse.css.border_color : parse_border_color;

    auto args = tokenized[ 2 .. $ ]; // skip ["border", ":"]

    // border: args...
    if ( !args.empty )
    {
        auto word = args.front.s;

        // border: solid;
        // border: solid #777;
        if ( parse_border_style( word, setters ) ) // this.border_style = LineStyle.solid;
        {
            auto word2 = args.drop(1).front.s;
            if ( parse_border_color( word2, setters ) )
            {
                return true;
            }
        }
        else

        // border: 1px solid;
        // border: 1px solid #777;
        if ( parse_border_width( word, setters ) )
        {
            auto word2 = args.drop(1).front.s;
            if ( parse_border_style( word2, setters ) )
            {
                if ( args.length >= 3 )
                {
                    auto word3 = args.drop(2).front.s;
                    if ( parse_border_color( word3, setters ) )
                    {
                        return true;
                    }
                }

                return true;
            }
        }
        else

        // border: inherit;
        // border: initial;
        // border: unset;
        {
            //
            return true;
        }
    }
    else

    // border: <empty>
    {
        import std.conv : to;
        assert( 0, "error: expect border args: " ~ tokenized.to!string );
        //return false;
    }

    return false;
}

