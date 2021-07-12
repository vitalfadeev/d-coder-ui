module ui.parse.css.margin_bottom;

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

// https://developer.mozilla.org/en-US/docs/Web/CSS/margin-bottom
//
// <length> | <percentage>
//
// <length> values 
// margin-bottom: 0.5em;
// margin-bottom: 0;
// margin-bottom: 2cm;
//
// <percentage> value 
// margin-bottom: 10%;
//
// Global values 
// margin-bottom: inherit;
// margin-bottom: initial;
// margin-bottom: unset;

bool parse_margin_bottom( Tok[] tokenized, ref string[] setters )
{
    import std.range : front;
    import std.range : drop;
    import std.range : empty;

    auto args = tokenized[ 2 .. $ ]; // skip ["margin-tpp", ":"]
    ParseResult parseResult;

    // margin-bottom: arg
    if ( !args.empty )
    {
        auto word = args[0].s;

        if ( parse_margin_arg( tokenized, word, &parseResult ) )
        {
            parseResult.setterCallback( parseResult, "marginBottom",    setters );
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
