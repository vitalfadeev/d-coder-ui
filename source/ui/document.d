module ui.document;

import ui;


struct DocumentMeta
{
    int width;
    int height;
    // style
    // show
}

struct DocumentHead
{
    string       title;
    DocumentMeta meta;
}

struct Document
{
    DocumentHead head;
    Element      body;

    Element* createElement( string tagName )
    {
        Element* element;

        if ( tagName == "e" )
        {
            element = createElement!Element();
            element.addClass( "e" );
        }

        return element;
    }
}

pragma( inline, true )
void createElement( T )()
{
    writeln( "Create element: ", T.stringof );
    Element* element = new T();
}


/*
app.tre
-------
head
  title: New window
meta 
  width:  640
  height: 640
  style:  fullscreen
  show:   maximized
body
  e .stage #dark
  e .stage #intro
  e .stage #rules
  e .stage #que-1
  e .stage .selector #que-1-ans
     e .a
     e .b
     e .c
     e .d
     e .separator
     e .friend
     e .peoles
     e .half

generated/app.d
---------------
struct AppDocument
{
    Document _doc =
    {
        head: 
        {
            title: "New window",
            meta:
            { 
                width: 640,
                height: 480
            }
        },
        body:
        {
            //
        }
    };

    alias _doc this;

    void initBody()
    {
        Element* element;        
        Element* par;

        //
        par = &body;

        // e .stage #dark
        with( element = createElement() )
        {
            addClass( "stage" );
            id = "dark";
            par.appendChild( element );
        }

        // e .stage #intro
        with( element = createElement() )
        {
            addClass( "stage" );
            id = "intro";
            par.appendChild( element );
        }

        // ...

        // e .stage .selector #que-1-ans
        with( element = createElement() )
        {
            addClass( "stage" );
            addClass( "selector" );
            id = "que-1-ans";
            par.appendChild( element );
        }

        par = element;

        // e .a
        with( element = createElement() )
        {
            addClass( "a" );
            par.appendChild( element );
        }

        //
        // par = par.parentNode;
        // par = par.par.parentNode;
    }
}

*/
