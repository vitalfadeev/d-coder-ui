module ui.parse.css.margin_left;

import std.stdio                   : writeln;
import ui.parse.t.tokenize         : Tok;
import ui.parse.css.types          : Length;
import ui.parse.css.types          : Percentage;
import ui.parse.css.length         : parse_length;
import ui.parse.css.percentage     : parse_percentage;
import ui.parse.css.stringiterator : StringIterator;
import std.format                  : format;
import std.conv                    : to;
import log                         : Log;
import ui.parse.css.margin : parse_margin_arg;
import ui.parse.css.margin : ParseResult;

// https://developer.mozilla.org/en-US/docs/Web/CSS/margin-left
//
// <length> | <percentage>
//
// <length> values 
// margin-left: 0.5em;
// margin-left: 0;
// margin-left: 2cm;
//
// <percentage> value 
// margin-left: 10%;
//
// Global values 
// margin-left: inherit;
// margin-left: initial;
// margin-left: unset;

bool parse_margin_left( Tok[] tokenized, ref string[] setters )
{
    import std.range : front;
    import std.range : drop;
    import std.range : empty;

    auto args = tokenized[ 2 .. $ ]; // skip ["margin-tpp", ":"]
    ParseResult parseResult;

    // margin-left: arg
    if ( !args.empty )
    {
        auto word = args[0].s;

        if ( parse_margin_arg( tokenized, word, &parseResult ) )
        {
            parseResult.setterCallback( parseResult, "marginLeft",    setters );
            return true;
        }
        else
        {
            Log.error( format!"margin arg uncorrect: %s. Tokens: %s"( word, tokenized ) );
            return false;
        }
    }
    else

    // margin: <empty>
    {
        Log.error( format!"margin arg expected. Tokens: %s"( tokenized ) );
        return false;
    }

    //return false;
}
