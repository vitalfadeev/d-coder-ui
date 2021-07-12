module ui.parse.t.on;

import ui.parse.t.tokenize   : Tok;
import ui.parse.t.parser     : EventCallback;
import ui.parse.t.charreader : CharReader;
import std.stdio : writeln;


bool parse_on( R )( ref R range, Tok[] tokenized, size_t parentIndent, ref EventCallback[] eventCallbacks )
{
    import std.range : empty;
    import std.range : front;
    import std.range : popFront;

    auto args = tokenized[ 2 .. $ ]; // skip ["event", ":"]

    // event: args...
    if ( !args.empty )
    {
        auto eventName = args.front.s;                          // = WM_KEYDOWN
        auto eventArgs = args.length > 1 ? args[ 1 .. $ ] : []; // = VK_SPACE

        //
        auto src = range.front;
        range.popFront(); // skip on: ...
        auto eventBody = read_event_body( range, parentIndent );

        eventCallbacks ~= EventCallback( eventName, eventArgs, eventBody, src );
    }

    return true;
}

/*
    void process_KeyboardKeyEvent( Element* element, KeyboardKeyEvent event )
    {
        if ( event.code == VK_SPACE )
        {
            element.addClass( "selected" );
        }
    }
*/

string[] read_event_body( R )( ref R range, size_t parentIndent )
{
    import std.range : empty;
    import std.range : front;
    import std.range : popFront;
    import ui.parse.t.style    : tokenize;
    import ui.parse.parser     : quote;
    import ui.parse.t.tokenize : readIndent;

    string[] eventBody;
    Tok[]    tokenized;
    size_t   indentLength;

    if ( !range.empty )
    for ( string line; !range.empty; range.popFront() )
    {
        line = range.front;

        auto reader = CharReader( line );
        readIndent( reader, &indentLength );

        if ( indentLength > parentIndent )
        {
            eventBody ~= line;
        }
        else

        {
            break;
        }
    }

    return eventBody;
}
