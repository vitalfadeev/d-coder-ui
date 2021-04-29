module ui.element;

import ui;
import ui.classlist : ClassList;
import ui.base : Props;
import ui.base : Computed;
import ui.base : Border;
import ui.base : memberId;


struct Element
{
    string tagName;
    string id;

    // Node properties
    Element* parentNode;
    Element* prevSibling;
    Element* nextSibling;
    Element* firstChild;
    Element* lastChild;

    // Draw properties
    ClassList classes;   // classes
    Props     props;     // element-level properties
    Computed  computed;  // computed properties: default properties + class-level properties + element-level properties

    // Magnetic properties
    POS centerX;  // px, center: relative from the parent center
    POS centerY;  // px, center: relative from the parent center
    POWER m;      // m-power: -N .. +N

    //
    bool live;  // for delete Mag in array storage and prevent reallocationg storage

    //
    void* data; // payload

    //
    void delegate( IDrawer drawer ) _vid;
    bool delegate( Point p )  _hitTest;
    void delegate( ref MouseKeyEvent    event ) _processMouseKey;
    void delegate( ref MouseMoveEvent   event ) _processMouseMove;
    void delegate( ref MouseWheelEvent  event ) _processMouseWheel;
    void delegate( ref KeyboardKeyEvent event ) _processKeyboardKey;

    // For fast calculation in set()
    // ...for prevent memory allocation, reserve space here
    // ...for useing CPU cache
    int _cd_power;
    POS _cd_offset;
    int _gh_power;
    POS _gh_offset;


    /** */
    string toString()
    {
        import std.conv : to;

        return 
            "Element" ~ "\n" ~
            "  classes    : " ~ classes.to!string ~ "\n" ~
            "  color      : " ~ computed.color.to!string ~ "\n" ~
            "  border     : " ~ computed.border.to!string ~ "\n" ~
            "  background : " ~ computed.background.to!string ;
    }


    void vid( IDrawer drawer )
    {
        vid_center( drawer );
        vid_border( drawer );
        drawer.color( 0xCCCCCC.rgb );
        drawer.moveTo( 0, 0 );
        drawer.lineTo( 100, 100 );
    }


    /** */
    void vid_center( IDrawer drawer )
    {
        drawer.point( 0, 0, 0xCCCCCC.rgb ); // point at: 0, 0 ( center )
    }


    /** */
    void vid_border( IDrawer drawer )
    {
        if ( computed.border.pen.type )
        {
            drawer.pen( computed.border.pen );
            drawer.moveTo( 0, 0 );  // center
            drawer.rectangle( m+m, m+m );
        }
    }


    /** */
    void vid_border_mag( IDrawer drawer )
    {
        drawer.moveTo( 0, 0 );  // center

        // m
        if ( m == 0 )
            drawer.pen( 0xCCCCCC.rgb, 3 );
        else
        if ( m < 0 )
            drawer.pen( 0x0000CC.rgb, 3 );
        else // c > 0
            drawer.pen( 0xCC0000.rgb, 3 );

        drawer.rectangle( m+m, m+m );
    }


    /** */
    void vid_symbol( IDrawer drawer )
    {
        drawer.pen( 0xCCCCCC.rgb, 3 );
        drawer.moveTo( 0, 0 );  // center
        //drawer.symbol( 'A', m, -( cast( int ) m )/2, m, m/2 );
    }


    /** */
    bool hitTest( Point p )
    {
        return 
            ( abs( p.x ) <= abs( m ) ) &&
            ( abs( p.y ) <= abs( m ) );
    }


    void update()
    {
        // init
        resetToDefault();

        // classes
        foreach( cls; classes )
        {
            // apply class members
            applyClassMembers( cls );
        }

        // element
        applyElementMembers();
    }


    void applyClassMembers( Class* cls )
    {
        cls.applier( &this );  // call applyClassMembers( T )( Element* this )
    }


    void resetToDefault()
    {
        computed = Computed.init;
    }


    void applyElementMembers()
    {
        import std.traits : hasMember;

        foreach( nameId; this.props.modified )
        {
            static 
            foreach ( i, name; __traits( allMembers, Props ) ) 
            {
                static 
                if ( hasMember!( Computed, name ) )
                {                
                    if ( nameId == i )
                    {
                        // this.computed.name = props.value;
                        mixin( "this.computed." ~ name ~ " = __traits( getMember, this.props, \"" ~ name ~ "\" );" );
                    }
                }
            }
        }    
    }


    // Class List
    /** */
    void addClass( string className )
    {
        version ( COMPILETIMEGENERATION )
        {
            import generated;

            static
            foreach( TCLASS; __traits( allMembers, generated ) ) 
            {
                static 
                if ( is( TCLASS == struct ) )
                {
                    if ( className == TCLASS.stringof )
                    {
                        .addClass!TCLASS( this );
                    }
                }
            }        
        }
        else
        {
            auto c = className in classRegistry.classes;

            if ( c )
            {
                this.classes ~= *c;
            }
            else
            {
                assert( 0, "error: class not registered: " ~ className );
            }
        }
    }


    void addClass( TCLASS )()
    {
        auto cls = classRegistry.find( TCLASS.stringof );

        if ( cls && !this.classes.has( cls ) )
        {
            this.classes ~= cls;
        }
    }


    void delClass( string className )
    {
        import std.algorithm : countUntil;
        import std.array     : replaceInPlace;

        auto cls = classRegistry.find( className );

        if ( cls && this.classes.has( cls ) )
        {
            auto pos = this.classes.countUntil( cls );

            if ( pos != -1 )
            {
                this.classes.replaceInPlace( pos, pos+1, cast( typeof( this.classes ) )[] );
            }
        }
        else
        {
            assert( 0, "class not found: " ~ className );
        }
    }


    // Properties
    /** */
    void border( Border val ) 
    {
        props.border = val;

        auto mid = memberId!( Props, "border" );
        auto modPos = props.modifiedOrder[ mid ];

        // not modified before
        if ( modPos == 0 )
        {
            // add mod at last pos
            props.modified[ props.modifiedLength ] = mid;
            props.modifiedOrder[ mid ] = props.modifiedLength;
            // save modifies length
            props.modifiedLength += 1;
        }
        else // was modified
        {
            // remove prior mods
            import std.algorithm.mutation : moveEmplaceAll;
            moveEmplaceAll( props.modified[ mid+1 .. $ ], props.modified[ mid .. $ ] );
            // add mod at last pos
            props.modified[ props.modifiedLength ] = mid;
            props.modifiedOrder[ mid ] = props.modifiedLength;
        }

    }

    //void borderTopWidth( T )( T a )
    //{
    //    props.borderTopWidth = a;
    //}


    // Node
    /** */
    Element* appendChild( Element* child )
    {
        // Remove from parent
        if ( child.parentNode !is null )
        {
            parentNode.removeChild( child );
        }

        child.parentNode = &this;

        // Add
        if ( firstChild is null )
        {
            firstChild = child;
            lastChild  = child;
        } 
        else // firstChild !is null
        {
            child.prevSibling     = lastChild;
            lastChild.nextSibling = child;
            lastChild             = child;
        }

        return child;
    }


    /** */
    Element* removeChild( Element* c )
    {
        assert( c !is null );

        // Parent
        c.parentNode = null;

        // Siblings
        auto prev = c.prevSibling;
        auto next = c.nextSibling;

        if ( prev !is null )
        {
            prev.nextSibling = next;
        }

        if ( next !is null )
        {
            next.prevSibling = prev;
        }

        // Childs
        if ( firstChild == c )
        {
            firstChild = next;
        }

        if ( lastChild == c )
        {
            lastChild = prev;
        }

        //
        c.prevSibling = null;
        c.nextSibling = null;

        return c;
    }


    // Events
    /** */
    void process( ref MouseKeyEvent event )
    {
        //
    }


    void process( ref MouseMoveEvent event )
    {
        //
    }


    void process( ref MouseWheelEvent event )
    {
        //
    }


    void process( ref KeyboardKeyEvent event )
    {
        //
    }
}

