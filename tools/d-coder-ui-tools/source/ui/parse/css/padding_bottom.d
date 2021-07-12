module ui.parse.css.padding_bottom;

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
import ui.parse.css.padding : parse_padding_arg;
import ui.parse.css.padding : ParseResult;

// https://developer.mozilla.org/en-US/docs/Web/CSS/padding-bottom
//
// <length> | <percentage>
//
// <length> values 
// padding-bottom: 0.5em;
// padding-bottom: 0;
// padding-bottom: 2cm;
//
// <percentage> value 
// padding-bottom: 10%;
//
// Global values 
// padding-bottom: inherit;
// padding-bottom: initial;
// padding-bottom: unset;

bool parse_padding_bottom( Tok[] tokenized, ref string[] setters )
{
    import std.range : front;
    import std.range : drop;
    import std.range : empty;

    auto args = tokenized[ 2 .. $ ]; // skip ["padding-tpp", ":"]
    ParseResult parseResult;

    // padding-bottom: arg
    if ( !args.empty )
    {
        auto word = args[0].s;

        if ( parse_padding_arg( tokenized, word, &parseResult ) )
        {
            parseResult.setterCallback( parseResult, "paddingBottom",    setters );
            return true;
        }
        else
        {
            Log.error( format!"padding arg uncorrect: %s. Tokens: %s"( word, tokenized ) );
            return false;
        }
    }
    else

    // padding: <empty>
    {
        Log.error( format!"padding arg expected. Tokens: %s"( tokenized ) );
        return false;
    }

    //return false;
}
