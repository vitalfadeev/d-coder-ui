module ui.parse.css.padding;

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

// https://developer.mozilla.org/en-US/docs/Web/CSS/padding
//
// space between its content and its border.
//
// <length> | <percentage>
// 
// Apply to all four sides
// padding: 1em;
//
// vertical | horizontal
// padding: 5% 10%;
//
// top | horizontal | bottom
// padding: 1em 2em 2em;
//
// top | right | bottom | left
// padding: 5px 1em 0 2em;
//
// Global values
// padding: inherit;
// padding: initial;
// padding: unset;

bool parse_padding( Tok[] tokenized, ref string[] setters )
{
    import std.range : front;
    import std.range : drop;
    import std.range : empty;

    auto args = tokenized[ 2 .. $ ]; // skip ["padding", ":"]

    ParseResult parseResult;
    string[]    _setters;

    // padding: args...
    if ( !args.empty )
    {
        // padding: arg
        if ( args.length == 1 )
        {
            auto word = args[0].s;
            if ( parse_padding_arg( tokenized, word, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "paddingTop",    _setters );
                parseResult.setterCallback( parseResult, "paddingRight",  _setters );
                parseResult.setterCallback( parseResult, "paddingBottom", _setters );
                parseResult.setterCallback( parseResult, "paddingLeft",   _setters );
                setters ~= _setters;
                return true;
            }
            else
            {
                Log.error( format!"padding arg uncorrect: %s. Tokens: %s"( word, tokenized ) );
                return false;
            }
        }
        else

        // padding: arg arg
        if ( args.length == 2 )
        {
            // arg1 - top bottom
            // arg2 - left right
            auto word1 = args[0].s;
            if ( parse_padding_arg( tokenized, word1, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "paddingTop",    _setters );
                parseResult.setterCallback( parseResult, "paddingBottom", _setters );                
            }
            else
            {
                Log.error( format!"padding arg1 uncorrect: %s. Tokens: %s"( word1, tokenized ) );
                return false;
            }

            //
            auto word2 = args[1].s;
            if ( parse_padding_arg( tokenized, word2, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "paddingRight",  _setters );
                parseResult.setterCallback( parseResult, "paddingLeft",   _setters );
                setters ~= _setters;
                return true;
            }
            else
            {
                Log.error( format!"padding arg2 uncorrect: %s. Tokens: %s"( word2, tokenized ) );
                return false;
            }
        }
        else

        // padding: arg arg arg
        if ( args.length == 3 )
        {
            // arg1 - top
            // arg2 - left right
            // arg3 - bottom
            auto word1 = args[0].s;
            if ( parse_padding_arg( tokenized, word1, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "paddingTop",    _setters );
            }
            else
            {
                Log.error( format!"padding arg1 uncorrect: %s. Tokens: %s"( word1, tokenized ) );
                return false;
            }

            //
            auto word2 = args[1].s;
            if ( parse_padding_arg( tokenized, word2, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "paddingRight",  _setters );
                parseResult.setterCallback( parseResult, "paddingLeft",   _setters );
            }
            else
            {
                Log.error( format!"padding arg2 uncorrect: %s. Tokens: %s"( word2, tokenized ) );
                return false;
            }

            //
            auto word3 = args[2].s;
            if ( parse_padding_arg( tokenized, word3, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "paddingBottom", _setters );
                setters ~= _setters;
                return true;
            }
            else
            {
                Log.error( format!"padding arg3 uncorrect: %s. Tokens: %s"( word3, tokenized ) );
                return false;
            }
        }
        else

        // padding: arg arg arg arg
        if ( args.length == 4 )
        {
            // arg1 - top
            // arg2 - left
            // arg3 - bottom
            // arg4 - right
            auto word1 = args[0].s;
            if ( parse_padding_arg( tokenized, word1, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "paddingTop",    _setters );
            }
            else
            {
                Log.error( format!"padding arg1 uncorrect: %s. Tokens: %s"( word1, tokenized ) );
                return false;
            }

            //
            auto word2 = args[1].s;
            if ( parse_padding_arg( tokenized, word2, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "paddingLeft",   _setters );
            }
            else
            {
                Log.error( format!"padding arg2 uncorrect: %s. Tokens: %s"( word2, tokenized ) );
                return false;
            }

            //
            auto word3 = args[2].s;
            if ( parse_padding_arg( tokenized, word3, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "paddingBottom", _setters );
            }
            else
            {
                Log.error( format!"padding arg3 uncorrect: %s. Tokens: %s"( word3, tokenized ) );
                return false;
            }

            //
            auto word4 = args[1].s;
            if ( parse_padding_arg( tokenized, word4, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "paddingRight",  _setters );
                setters ~= _setters;
                return true;
            }
            else
            {
                Log.error( format!"padding arg4 uncorrect: %s. Tokens: %s"( word4, tokenized ) );
                return false;
            }
        }
    }
    else

    // padding: <empty>
    {
        Log.error( format!"padding arg expected. Tokens: %s"( tokenized ) );
        return false;
    }

    return false;
}


alias void delegate( ParseResult parseResult, string prop, ref string[] setters ) SetterCallback;

bool parse_padding_arg( Tok[] tokenized, string word, ParseResult* parseResult )
{
    // length
    if ( parse_length( new StringIterator( word ), &parseResult.len ) )
    {
        void callback( ParseResult parseResult, string prop, ref string[] setters )
        {
            setters ~= format!"%s = (%s).%s;"( prop, parseResult.len.length, parseResult.len.unit );
        }

        parseResult.setterCallback = &callback;
        return true;
    }
    else

    // percentage
    if ( parse_percentage(  new StringIterator( word ), &parseResult.perc ) )
    {
        void callback( ParseResult parseResult, string prop, ref string[] setters )
        {
            setters ~= format!"%s = (%s).perc;"( prop, parseResult.perc );
        }

        parseResult.setterCallback = &callback;
        return true;
    }
    else

    // padding: inherit;
    if ( word == "inherit" )
    {
        void callback( ParseResult parseResult, string prop, ref string[] setters )
        {
            setters ~= format!"if ( parentNode !is null ) %s = parentNode.computed.%s;"( prop, prop );
        }

        parseResult.setterCallback = &callback;
        return true;
    }
    else

    // padding: initial;
    if ( word == "initial" )
    {
        void callback( ParseResult parseResult, string prop, ref string[] setters )
        {
            setters ~= format!"%s = Computed.init.%s;"( prop, prop );
        }

        parseResult.setterCallback = &callback;
        return true;
    }
    else

    // padding: unset;
    if ( word == "unset" )
    {
        return true;
    }
    else

    // miss
    {
        Log.error( "expect padding args: <length> | <percentage> | inherit | initial | unset: " ~ tokenized.to!string );
        return false;
    }
}


struct ParseResult
{
    Length len;
    Percentage perc;
    SetterCallback setterCallback;
}
