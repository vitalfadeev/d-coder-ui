module ui.classregistry;

import std.stdio  : writeln;
import ui.element : Element;


ClassRegistry classRegistry;


struct Class
{
    string name;
    void function( Element* element ) setter;
    void function( Element* element, Event* event ) on;
}


struct ClassRegistry
{
    Class*[ string ] classes;


    Class* find( string className )
    {
        auto cls = className in classes;

        if ( cls is null )
            return null;
        else
            return *cls; // because obj*[string] returns obj**
    }
}


pragma( inline, true )
void registerClass( T )()
{
    writeln( "Register class: ", T.stringof );
    classRegistry.classes[ T.stringof ] = 
        new Class(
            T.stringof,
            &T.setter,
            getFunc!( T, "on" )
        );
}


pragma( inline, true )
auto getFunc( T, string FUNC )()
{
    static
    if ( __trait( hasMember, T, FUNC ) )
        return __trait( getMember, T, FUNC );

    return null;
}

