module ui.parse.css.position;

// https://developer.mozilla.org/ru/docs/Web/CSS/position
// 
// static | relative | absolute | sticky | fixed

import std.stdio           : writeln;
import ui.parse.t.tokenize : Tok;
import std.format          : format;
import std.conv            : to;
import log                 : Log;
import std.range           : front;
import std.range           : drop;
import std.range           : empty;


/** */
bool parse_position( Tok[] tokenized, ref string[] setters )
{
    auto args = tokenized[ 2 .. $ ]; // skip ["position", ":"]

    // position: args...
    if ( !args.empty )
    {
        auto word = args[0].s;

        // static
        if ( word == "static" )
        {
            setters ~= "position = Position.static;";
            return true;
        }
        else

        // relative
        if ( word == "relative" )
        {
            setters ~= "position = Position.relative;";
            return true;
        }
        else

        // absolute
        if ( word == "absolute" )
        {
            setters ~= "position = Position.absolute;";
            return true;
        }
        else

        // sticky
        if ( word == "sticky" )
        {
            setters ~= "position = Position.sticky;";
            return true;
        }
        else

        // fixed
        if ( word == "fixed" )
        {
            setters ~= "position = Position.fixed;";
            return true;
        }
        else

        // miss
        {
            Log.error( "position: <miss>: " ~ tokenized.to!string );
        }
    }

    return false;
}
