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
import std.range : front;
import std.string : splitLines;
import std.range : popFront;


struct Doc
{
    ParsedElement head  = { tagName: "head" };
    ParsedElement meta  = { tagName: "meta" };
    StyleSection  style;
    ParsedElement body  = { tagName: "body" };
}

struct ParsedClass
{
    string   className;
    string[] setters;
}

struct StyleSection
{
    ParsedClass*[] classes;
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
        import std.file : readText;


        string s = readText( fileName );

        auto sectionReader = new SectionReader( s );

        foreach ( section; sectionReader )
        {
            writeln(section);
            parseSection( section, 0, &doc );
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


// body, head, meta
void parseSection( string[] lines, size_t indent, Doc* doc )
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
        //"script",
        "body",
    ];

    //
    size_t indentLength;
    string line = lines.front;
    Tok[] tokenized = tokenize( line, &indentLength );

    auto word = tokenized.front.s;

    //
    static
    foreach ( SEC; sections )
    {
        if ( word == SEC )
        {
            mixin ( "parseSection_" ~ SEC ~ "( lines, tokenized, indentLength, doc );" );
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


class SectionReader
{
    string[] front;
    LineReader lineReader;

    this( string s )
    {
        lineReader = new LineReader( s );
        _fetch();
    }

    void popFront()
    {
        _fetch();
    }

    bool empty()
    {
        return lineReader.empty();
    }


    void _fetch()
    {
        front.length = 0;

        // read head
        auto line2 = lineReader.front;
        if ( !line2.front.isWhite() )
        {
            front ~= line2;
            popFront();
        }

        // read body
        foreach ( line; lineReader )
        {
            // section
            if ( line.front.isWhite() )
            {
                front ~= line;
            }
            else

            // 
            {
                break;
            }
        }
    }
}


bool isWhite( C )( C c )
{
    return c == ' ';
}


class LineReader
{
    string s;
    string front;

    this( string s )
    {
        this.s = s;

        if ( !empty() )
        {
            _fetch();
        }
    }

    void popFront()
    {
        s.popFront();

        if ( !empty() )
        {
            _fetch();
        }
    }

    bool empty()
    {
        return s.length > 0;
    }


    void _fetch()
    {
        s.findNL();
    }
}

size_t findNL( string s )
{
    import std.string : indexOf ;

    auto pos = s.indexOf( '\n' );

    return pos;
}

string getLine( ref string s )
{
    auto pos = s.findNL();

    // found
    if ( pos != -1 )
    {
        auto result = s[ 0 .. pos ];
        s = s[ pos + 1 .. $ ];
        return result;
    }
    else

    // not found. get tail
    {
        return s;
    }
}


void lineReader( string s )
{
    string line;

    while ( s.length > 0 )
    {
        line = getLine( s );

        // do
    }
}


void sectionReader( string s )
{
    string   line;
    string[] sectionLines;

    if ( s.length > 0 )
    {
        line = scrollToSectionStart( s );

        // section start
        if ( line.length > 0 )
        {
            get_section_body:
            sectionLines.length = 0;
            sectionLines ~= line;

            // read section body
            if ( s.length > 0 )
            {
                line = getLine( s );

                // body
                if ( line.front.isWhite() )
                {
                    sectionLines ~= line;
                }
                else

                // new section
                {
                    // do
                    callDelegate( sectionLines );

                    goto get_section_body;
                }
            }
            else

            // last line
            if ( sectionLines.length > 0 )
            {
                // do
                callDelegate( sectionLines );
            }
        }
    }
}


string scrollToSectionStart( ref string s )
{
    string line;

    // scan
    while ( s.length > 0 )
    {
        line = getLine( s );

        // section start
        if ( line.length > 0 )
        if ( !line.front.isWhite() )
        {
            return line;
        }
    }

    line.length = 0;

    return line;
}


// Aaaa Aaaa Aaaa
//   Aaaa
//   Aaaa
//   Aaaa

// Aaaa Bbbb Bbbb Aaaa Bbbb Bbbb
//   Aaaa
//   Bbbb
//   Bbbb
//
//   Aaaa
//   Bbbb
//   Bbbb

// BlockReader
//   Rule1
//   Rule2
//   delegate1 block
//   delegate2 block

// \n
// \n' '   // small block
// !\n' '  // large block

// char            // block
// char char \n    // block
// char char \n    // block | block
//   char char \n  // block |

// Find Block Start
// find '\n', !' '

// char, char
// line, line
// section, section


Char getChar( S )( S stream )
{
    S buf;

    while ( !stream.empty )
    {
        auto c = stream.front;

        buf ~= c;

        stream.popFront();
    }

    return c;
}


//
auto byLine( S )( S stream )
  // S is Char stream
{
    return byLineImpl!S( stream );
}

// at start cond
// at end cond
struct byLineImpl( S )
  // S is Char stream
{
    S stream;
    S buf;
    alias front = buf;

    this()
    {
        //_expectSectionHead();
        _fetch();
    }

    void popFront()
    {
        _fetch();
    }

    bool empty()
    {
        return stream.empty;
    }

    //private
    //void _expectSectionHead()
    //{
    //    while ( !stream.empty )
    //    {
    //        // non head. skip
    //        if ( stream.front.isNewLine() )
    //        {
    //            stream.popFront();
    //        }
    //        else

    //        // head
    //        {
    //            return;
    //        }
    //    }
    //}

    private
    void _fetch()
    {
        buf.length = 0;
        buf ~= stream.front;
        stream.popFront();

        while ( !stream.empty )
        {
            auto c = stream.front;
        
            // line body
            if ( c.isNewLine() )
            {
                buf ~= c;
            }
            else

            // line end
            {
                return; // section head keept in .front
            }

            stream.popFront();
        }
    }
}

bool isNewLine( C )( C c )
{
    return c == '\n';
}


//
auto bySection( S )( S stream )
  // S is Line stream
{
    return bySectionImpl!S( stream );
}

struct bySectionImpl( S )
  // S is Line stream
{
    S stream;
    S buf;
    alias front = buf;

    this()
    {
        _expectSectionHead();
        _fetch();
    }

    void popFront()
    {
        _fetch();
    }

    bool empty()
    {
        return stream.empty;
    }

    private
    void _expectSectionHead()
    {
        while ( !stream.empty )
        {
            // non head. skip
            if ( stream.front.startsWith!isWhite() )
            {
                stream.popFront();
            }
            else

            // head
            {
                return;
            }
        }
    }

    private
    void _fetch()
    {
        buf.length = 0;
        buf ~= stream.front;
        stream.popFront();

        while ( !stream.empty )
        {
            auto line = stream.front;
        
            // section body
            if ( line.startsWith!isWhite() )
            {
                buf ~= line;
            }
            else

            // new section 
            {
                return; // section head keept in .front
            }

            stream.popFront();
        }
    }
}

bool isWhite( C )( C c )
{
    return c == ' ';
}



// stream
// Reader
//  atStartCond
//  atEndCond
//
struct BaseReader( S, alias atStartCond = null, alias atEndcond = null )
  // S is stream
  // atStartCond !is null && atEndCond is null
  // atStartCond is null  && atEndCond !is null
{
    S stream;
    S buf;
    alias front = buf;

    this( S stream )
    {
        this.stream = stream;

        static 
        if ( atStartCond !is null )
        {
            _expectSectionHead()
        }

        _fetch();

    }

    void popFront()
    {
        _fetch();
    }

    bool empty()
    {
        return stream.empty;
    }

    private
    void _fetch()
      if ( atStartCond !is null )
    {
        buf.length = 0;
        buf ~= stream.front;
        stream.popFront();

        while ( !stream.empty )
        {
            auto a = stream.front;
        
            // block content
            if ( atStartCond( a ) )
            {
                buf ~= a;
            }
            else

            // block start
            {
                return; // block head keept in .front
            }

            stream.popFront();
        }
    }

    private
    void _fetch()
      if ( atEndtCond !is null )
    {
        buf.length = 0;
        buf ~= stream.front;
        stream.popFront();

        while ( !stream.empty )
        {
            auto a = stream.front;
        
            // end of the block
            if ( atEndCond( a ) )
            {
                return;
            }
            else

            // block content
            {
                buf ~= a;
            }

            stream.popFront();
        }
    }
}


alias BaseReader!( LineReader, not!isWhite )     SectionReader;
alias BaseReader!( CharReader, null, isNewLine ) LineReader;
// CharReader

