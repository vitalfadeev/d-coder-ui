module ui.parse.css.padding_top;

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

// https://developer.mozilla.org/en-US/docs/Web/CSS/padding-top
//
// <length> | <percentage>
//
// <length> values 
// padding-top: 0.5em;
// padding-top: 0;
// padding-top: 2cm;
//
// <percentage> value 
// padding-top: 10%;
//
// Global values 
// padding-top: inherit;
// padding-top: initial;
// padding-top: unset;

bool parse_padding_top( Tok[] tokenized, ref string[] setters )
{
    import std.range : front;
    import std.range : drop;
    import std.range : empty;

    auto args = tokenized[ 2 .. $ ]; // skip ["padding-tpp", ":"]
    ParseResult parseResult;

    // padding-top: arg
    if ( !args.empty )
    {
        auto word = args[0].s;

        if ( parse_padding_arg( tokenized, word, &parseResult ) )
        {
            parseResult.setterCallback( parseResult, "paddingTop",    setters );
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
