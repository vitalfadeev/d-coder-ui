module ui.classregistry;

import std.stdio  : writeln;
import ui.element : Element;


ClassRegistry classRegistry;


struct Class
{
    string name;
    void function( Element* This ) applier;
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
            &applyClassMembers!T
        );
}


void applyClassMembers( T )( Element* This )
{
    static 
    foreach ( name; __traits( allMembers, T ) ) 
    {
        mixin ( "This.computed." ~ name ~ " = __traits( getMember, T.init, \"" ~ name ~ "\" ); " );
    }    
}


