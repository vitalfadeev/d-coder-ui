module ui.classregistry;

import std.stdio  : writeln;
import ui.element : Element;
import ui.event   : Event;
import ui.base : MAX_CLASSES;
import ui.base : ClassId;


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
        return classes.get( className, null );
        //auto cls = className in classes;

        //if ( cls is null )
        //    return null;
        //else
        //    return *cls; // because obj*[string] returns obj**
    }
}


pragma( inline, true )
void registerClass( T )()
{
    writeln( "Register class: ", T.stringof );
    classRegistry.classes[ T.stringof ] = 
        new Class(
            T.stringof,
            getFunc!( T, "setter" ),
            getFunc!( T, "on" )
        );
}


pragma( inline, true )
auto getFunc( T, string FUNC )()
{
    static
    if ( __traits( hasMember, T, FUNC ) )
        return &__traits( getMember, T, FUNC );
    else
        return null;
}



version ( ClassList2 )
{
    struct Class
    {
        string  name;
        ClassId id;
        void function( Element* element ) setter;
        void function( Element* element, Event* event ) on;
    }

    struct ClassReg2
    {
        Class[ MAX_CLASSES ] classes;

        void registerClass( T )()
        {
            with ( classReg2.classes[ classId ] )
            {
                name   = T.init.name;
                id     = T.init.id;
                setter = getFunc!( T, "setter" );
                on     = getFunc!( T, "on" );
            }
        }

        bool has( ClassId classId )
        {
            return classes[ classId ].name.length != 0;
        }
    }

    void registerClass2( T )()
    {
        classReg2.registerClass!T;
    }

    // classId
    struct e
    {
        const string  name = "e";
        const ClassId id = 0b00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000001; // 64 bit
    }

    ClassReg2 classReg2;

    static
    this()
    {
        registerClass2!e;
    }
}


alias void function( Element* element ) ClassSetter;
alias void function( Element* element, Event* event ) ClassOn;

struct ee
{
    string name = "ee";
    ClassSetter setter = 
        ( Element* element )
        {
            //
        };
    ClassOn on =
        ( Element* element, Event* event )
        {
            //
        };
}

struct Clss
{
    union 
    {
        struct 
        {        
            ee ee_;
        };
        Class[ MAX_CLASSES ] classes;
    }
} 

Clss clss;
