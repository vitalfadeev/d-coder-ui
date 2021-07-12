void main()
{
    writeln("Hello world!");
}


//
struct Element
{
    Element* element;

    void addChild()
    {
        //
    }
}

//
   auto e = Element();
   e.addChild();


  ( event ) => ( writeln( event.code ) );


  ( event ) => { asm {
    mov  RAX, event.code;
    movq xmm0, RAX;
  } };


//
auto email = document.getElementById( ID_EMAIL );
auto email = document.getElementById( "email" );
auto email = document.getElementByClass( "email" );

// text: "text" | getText()
struct Element
{
    string text;

    string rawText;
    string getText() 
    { 
        if ( getTextPtr !is unll )
            return (*getTextPtr)(); 
        else
            return rawText;
    }

    string function() getTextPtr;
    void*  ptrData;
    void*  ptrDataClass; // for using: data_record.text()
}

// data
// Element.text -> Data.struct.text
struct DataStruct
{
    string a;
    string b;

    string text()
    {
        return a;
    }
}

