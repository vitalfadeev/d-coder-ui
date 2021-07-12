module ui.parse.css.margin_right;

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

// https://developer.mozilla.org/en-US/docs/Web/CSS/margin-right
//
// <length> | <percentage>
//
// <length> values 
// margin-right: 0.5em;
// margin-right: 0;
// margin-right: 2cm;
//
// <percentage> value 
// margin-right: 10%;
//
// Global values 
// margin-right: inherit;
// margin-right: initial;
// margin-right: unset;

bool parse_margin_right( Tok[] tokenized, ref string[] setters )
{
    import std.range : front;
    import std.range : drop;
    import std.range : empty;

    auto args = tokenized[ 2 .. $ ]; // skip ["margin-tpp", ":"]
    ParseResult parseResult;

    // margin-right: arg
    if ( !args.empty )
    {
        auto word = args[0].s;

        if ( parse_margin_arg( tokenized, word, &parseResult ) )
        {
            parseResult.setterCallback( parseResult, "marginRight",    setters );
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
