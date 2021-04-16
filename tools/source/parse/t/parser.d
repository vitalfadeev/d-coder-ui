module parse.t.parser;

//import ui : Element;
import parse.css.number : parse_number;


struct Doc
{
    ParsedElement body;
}

struct PropRecord
{
    string name;
    string value;
}

struct PropList
{
    PropRecord[] lst;
    alias lst this;
}

struct ParsedElement
{
    string           id;
    string[]         classes;
    PropList         properties;
    ParsedElement*   parent;
    ParsedElement*[] childs;
}


class TParser
{
    Doc doc;

    void parseFile( string fileName )
    {
        import std.stdio;
        import std.conv   : to;
        import std.string : strip;

        auto file = File( fileName ); // Open for reading

        auto range = file.byLine();

        string className;
        string[] lines;

        foreach ( lineNo, line; range )
        {
            parseLine( line, &doc );
        }
    }
}


void parseLine( string line, Doc* doc )
{
    import std.meta         : AliasSeq;
    import std.string       : stripRight;
    import parse.t.tokenize : tokenize;

    line = line.stripRight();

    if ( line.length == 0 )
        return;
    else

    if ( line.length >= 1 )
    {
        auto c = line[0];

        size_t indentLength;

        // head, meta, body
        if ( c != ' ' )
        {
            parseSection( line, 0, doc );
        }
        else

        // tag, e, property:value
        {
            parseKeyword( line, indentLength, &doc );
        }
    }
}


// body, head, meta
void parseSection( string s, int indent, Doc* doc )
{
    import std.range        : front;
    import parse.t.tokenize : tokenize;
    import parse.t.head     : parseSection_head;
    import parse.t.meta     : parseSection_meta;
    import parse.t.body     : parseSection_body;

    string[] sections = 
    [
        "head",
        "meta",
        "body",
    ];

    //
    auto tokenized = tokenize( line );

    auto word = tokenized.front;

    //
    static
    foreach ( SEC; sections )
    {
        if ( word == SEC )
        {
            mixin ( "parseSection_" ~ SEC ~ "( range, word, tokenized, parsed );" );
        }
    }
}


// border: ....
void parseKeyword( string s, int indent, Doc* doc )
{
    import parse.t.tokenize : tokenize;
    import std.range        : front;

    string[] properties = 
    [
        "border",
    ];

    Tok[] tokized = tokenize( s, indentLength );

    // property
    static
    foreach ( PROP; properties )
    {
        if ( tokenized.front == PROP )
        {
            mixin ( "parse_" ~ PROP ~ "( tokenized, parsed );" );
        }
    }

    // tag e
    if ( tokenized.front == "e" )
    {
        // parse_tag_e( tokenized, parsed );
    }    
}

