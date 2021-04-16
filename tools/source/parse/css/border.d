module parse.css.border;


bool parse_border( string[] tokenized, ref string[] setters )
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
    import parse.css.border_style;
    import parse.css.line_style;
    import parse.css.line_width;
    import parse.css.color;
    import parse.css.types : LineStyle;
    import parse.css.border_width : parse_border_width;

    string[] args = tokenized[ 2 .. $ ]; // skip ["border", ":"]

    // border: args...
    if ( !args.empty )
    {
        auto word = args.front;

        // border: solid;
        // border: solid #777;
        if ( parse_border_style( word, setters ) ) // this.border_style = LineStyle.solid;
        {
            auto word2 = args.drop(1).front;
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
            //parse_border_style();
            //parse_color();
            return true;
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
        return false;
    }
}

