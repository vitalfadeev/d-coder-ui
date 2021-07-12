module ui.parse.css.margin;

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

// https://developer.mozilla.org/en-US/docs/Web/CSS/margin
//
// space between its content and its border.
//
// <length> | <percentage>
// 
// Apply to all four sides
// margin: 1em;
//
// vertical | horizontal
// margin: 5% 10%;
//
// top | horizontal | bottom
// margin: 1em 2em 2em;
//
// top | right | bottom | left
// margin: 5px 1em 0 2em;
//
// Global values
// margin: inherit;
// margin: initial;
// margin: unset;

bool parse_margin( Tok[] tokenized, ref string[] setters )
{
    import std.range : front;
    import std.range : drop;
    import std.range : empty;

    auto args = tokenized[ 2 .. $ ]; // skip ["margin", ":"]

    ParseResult parseResult;
    string[]    _setters;

    // margin: args...
    if ( !args.empty )
    {
        // margin: arg
        if ( args.length == 1 )
        {
            auto word = args[0].s;
            if ( parse_margin_arg( tokenized, word, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "marginTop",    _setters );
                parseResult.setterCallback( parseResult, "marginRight",  _setters );
                parseResult.setterCallback( parseResult, "marginBottom", _setters );
                parseResult.setterCallback( parseResult, "marginLeft",   _setters );
                setters ~= _setters;
                return true;
            }
            else
            {
                Log.error( format!"margin arg uncorrect: %s. Tokens: %s"( word, tokenized ) );
                return false;
            }
        }
        else

        // margin: arg arg
        if ( args.length == 2 )
        {
            // arg1 - top bottom
            // arg2 - left right
            auto word1 = args[0].s;
            if ( parse_margin_arg( tokenized, word1, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "marginTop",    _setters );
                parseResult.setterCallback( parseResult, "marginBottom", _setters );                
            }
            else
            {
                Log.error( format!"margin arg1 uncorrect: %s. Tokens: %s"( word1, tokenized ) );
                return false;
            }

            //
            auto word2 = args[1].s;
            if ( parse_margin_arg( tokenized, word2, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "marginRight",  _setters );
                parseResult.setterCallback( parseResult, "marginLeft",   _setters );
                setters ~= _setters;
                return true;
            }
            else
            {
                Log.error( format!"margin arg2 uncorrect: %s. Tokens: %s"( word2, tokenized ) );
                return false;
            }
        }
        else

        // margin: arg arg arg
        if ( args.length == 3 )
        {
            // arg1 - top
            // arg2 - left right
            // arg3 - bottom
            auto word1 = args[0].s;
            if ( parse_margin_arg( tokenized, word1, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "marginTop",    _setters );
            }
            else
            {
                Log.error( format!"margin arg1 uncorrect: %s. Tokens: %s"( word1, tokenized ) );
                return false;
            }

            //
            auto word2 = args[1].s;
            if ( parse_margin_arg( tokenized, word2, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "marginRight",  _setters );
                parseResult.setterCallback( parseResult, "marginLeft",   _setters );
            }
            else
            {
                Log.error( format!"margin arg2 uncorrect: %s. Tokens: %s"( word2, tokenized ) );
                return false;
            }

            //
            auto word3 = args[2].s;
            if ( parse_margin_arg( tokenized, word3, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "marginBottom", _setters );
                setters ~= _setters;
                return true;
            }
            else
            {
                Log.error( format!"margin arg3 uncorrect: %s. Tokens: %s"( word3, tokenized ) );
                return false;
            }
        }
        else

        // margin: arg arg arg arg
        if ( args.length == 4 )
        {
            // arg1 - top
            // arg2 - left
            // arg3 - bottom
            // arg4 - right
            auto word1 = args[0].s;
            if ( parse_margin_arg( tokenized, word1, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "marginTop",    _setters );
            }
            else
            {
                Log.error( format!"margin arg1 uncorrect: %s. Tokens: %s"( word1, tokenized ) );
                return false;
            }

            //
            auto word2 = args[1].s;
            if ( parse_margin_arg( tokenized, word2, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "marginLeft",   _setters );
            }
            else
            {
                Log.error( format!"margin arg2 uncorrect: %s. Tokens: %s"( word2, tokenized ) );
                return false;
            }

            //
            auto word3 = args[2].s;
            if ( parse_margin_arg( tokenized, word3, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "marginBottom", _setters );
            }
            else
            {
                Log.error( format!"margin arg3 uncorrect: %s. Tokens: %s"( word3, tokenized ) );
                return false;
            }

            //
            auto word4 = args[1].s;
            if ( parse_margin_arg( tokenized, word4, &parseResult ) )
            {
                parseResult.setterCallback( parseResult, "marginRight",  _setters );
                setters ~= _setters;
                return true;
            }
            else
            {
                Log.error( format!"margin arg4 uncorrect: %s. Tokens: %s"( word4, tokenized ) );
                return false;
            }
        }
    }
    else

    // margin: <empty>
    {
        Log.error( format!"margin arg expected. Tokens: %s"( tokenized ) );
        return false;
    }

    return false;
}


alias void delegate( ParseResult parseResult, string prop, ref string[] setters ) SetterCallback;

bool parse_margin_arg( Tok[] tokenized, string word, ParseResult* parseResult )
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

    // margin: inherit;
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

    // margin: initial;
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

    // margin: unset;
    if ( word == "unset" )
    {
        return true;
    }
    else

    // miss
    {
        Log.error( "expect margin args: <length> | <percentage> | inherit | initial | unset: " ~ tokenized.to!string );
        return false;
    }
}


struct ParseResult
{
    Length len;
    Percentage perc;
    SetterCallback setterCallback;
}
