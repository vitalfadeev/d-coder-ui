module ui.classregistry;

import std.stdio  : writeln;
import ui.element : Element;


ClassRegistry classRegistry;


struct Class
{
    string name;
    void function( Element* element ) setter;
    void function( Element* element, ref KeyboardKeyEvent event ) process_KeyboardKeyEvent;
}


struct ClassRegistry
{
    Class*[ string ] classes;


    Class* find( string className )
    {
        auto cls = className in classes;

        if ( cls is null )
        {
            return null;
        }
        else
        {
            return *cls; // because obj*[string] returns obj**
        }
    }
}


void registerClass( T )()
{
    writeln( "Register class: ", T.stringof );
    classRegistry.classes[ T.stringof ] = 
        new Class(
            T.stringof,
            &T.setter,
            getFunc!( T, "process", "KeyDownEvent" )
        );
}


auto getFunc( T, string FUNC, string ARG )()
{
    return null;
}
