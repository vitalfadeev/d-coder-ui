module parse.t.parser;

//import ui : Element;
import parse.css.number : parse_number;
import parse.t.tokenize : Tok;
import std.traits : ReturnType;
import std.stdio;
import std.conv : to;
import std.string : stripRight;
import std.algorithm : startsWith;
import std.stdio : writefln;
import std.stdio : writeln;


struct Doc
{
    ParsedElement head  = { tagName: "head" };
    ParsedElement meta  = { tagName: "meta" };
    ParsedElement style = { tagName: "style" };
    ParsedElement body  = { tagName: "body" };
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
    size_t           indentLength;
    string           tagName;
    string           id;
    string[]         classes;
    string[]         setters;
    //PropList         properties;
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

        auto range = new ByLineIterator( fileName );

        string className;
        string[] lines;

        foreach ( line; range )
        {
            parseLine( range, line.to!string, &doc );
        }

        dump( &doc );
    }
}


void dump( Doc* doc )
{
    writeln( "doc: ", doc );

    foreach( element; doc.body.childs )
    {
        writeln( "  ", *element );

        foreach( e; element.childs )
        {
            writeln( "    ", *e );
        }
    }
}


void parseLine( R )( R range, string line, Doc* doc )
{
    if ( line.length == 0 )
        return;
    else

    if ( line.length >= 1 )
    {
        auto c = line[0];

        size_t indentLength;

        // head, meta, style, body
        if ( c != ' ' )
        {
            parseSection( range, line, 0, doc );
        }
        else

        // tag, e, property:value
        {
            assert( 0, "error: section expected, but got: " ~ line );
        }
    }
}


// body, head, meta
void parseSection( R )( R range, string line, size_t indent, Doc* doc )
{
    import std.range        : front;
    import parse.t.tokenize : tokenize;
    import parse.t.head     : parseSection_head;
    import parse.t.meta     : parseSection_meta;
    import parse.t.style    : parseSection_style;
    import parse.t.body     : parseSection_body;

    const
    string[] sections = 
    [
        "head",
        "meta",
        "style",
        "body",
    ];

    //
    size_t indentLength;
    Tok[] tokenized = tokenize( line, &indentLength );

    auto word = tokenized.front.s;

    //
    static
    foreach ( SEC; sections )
    {
        if ( word == SEC )
        {
            mixin ( "parseSection_" ~ SEC ~ "( range, tokenized, indentLength, &doc." ~ SEC ~ " );" );
        }
    }
}


void attachTo( ParsedElement* newElement, ParsedElement* preElement )
{
    // pre
    //   new
    if ( newElement.indentLength > preElement.indentLength )
    {
        preElement.childs ~= newElement;
        newElement.parent  = preElement;
    }
    else

    // pre
    // new
    if ( newElement.indentLength == preElement.indentLength )
    {
        preElement.parent.childs ~= newElement;
        newElement.parent         = preElement.parent;
    }
    else
    
    //   pre
    // new
    if ( newElement.indentLength < preElement.indentLength )
    {
        // find parent
        auto parent = preElement.parent;
        while ( parent !is null )
        {
            if ( newElement.indentLength > parent.indentLength )
            {
                break;
            }

            parent = parent.parent;
        }

        //
        if ( parent !is null )
        {
            parent.childs ~= newElement;
            newElement.parent = parent;
        }
        else
        {
            assert( 0, "error: can not find parent for: " ~ newElement.tagName );
        }
    }
}


class ByLineIterator
{
    string front;
    char[] buf;
    size_t readed;
    File   _file;

    this( string fileName )
    {
        _file = File( fileName );
        readed = _file.readln( buf );

        if ( readed >= 3 )
        {
            // remove ROM
            if ( buf[0] == 0xEF && buf[1] == 0xBB  && buf[2] == 0xBF )
            {
                front = buf[ 3 .. readed ].stripRight.to!string;
            }
            else

            // remove ROM
            if ( buf[0] == 0xFE && buf[1] == 0xFF )
            {
                front = buf[ 2 .. readed ].stripRight.to!string;
            }
            else

            // remove ROM
            if ( buf[0] == 0xFF && buf[1] == 0xFE )
            {
                front = buf[ 2 .. readed ].stripRight.to!string;
            }
            else

            {
                front = buf[ 0 .. readed ].stripRight.to!string;
            }
        }
        else
        {
            front = buf[ 0 .. readed ].stripRight.to!string;
        }
    }

    void popFront()
    {
        readed = _file.readln( buf );
        front = buf[ 0 .. readed ].stripRight.to!string;
    }

    bool empty()
    {
        return _file.eof();
    }
}
