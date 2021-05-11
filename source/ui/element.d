module ui.element;

import ui;
import ui.classlist : ClassList;
import ui.base      : Computed;
import ui.base      : Border;
import ui.base      : memberId;


struct Element
{
    string id;

    // Node properties
    Element* parentNode;
    Element* prevSibling;
    Element* nextSibling;
    Element* firstChild;
    Element* lastChild;

    // Draw properties
    // classes
    ClassList classes;

    // Element Instance Class
    // void function( Element* element ) setter;
    // void function( Ekement* element, Event* event ) on;
    Class instanceClass = { name: "e" };

    // computed properties: default properties + class-level properties + element-level properties
    Computed computed;

    // Magnetic properties
    POS   centerX;  // px, center: relative from the parent center
    POS   centerY;  // px, center: relative from the parent center
    POWER m;        // m-power: -N .. +N

    //
    bool live;  // for delete Mag in array storage and prevent reallocationg storage

    //
    void* data; // payload

    //
    //void delegate( IDrawer drawer ) _vid;
    //bool delegate( Point p        ) _hitTest;


    // Magnetic helpers
    // For fast calculation in set()
    // ...for prevent memory allocation, reserve space here
    // ...for useing CPU cache
    int inPowerLeft  =  100;  // to childs
    int inPowerRight =  100;  // to childs
    int powerLeft    =  100;  // to sibling
    int powerRight   =  100;  // to sibling


    /** */
    string toString()
    {
        import std.conv : to;

        return 
            "Element" ~ "\n" ~
            "  classes     : " ~ classes.to!string ~ "\n" ~
            "  color       : " ~ computed.color.to!string ~ "\n" ~
            "  borderWidth : " ~ computed.borderWidth.to!string ~ "\n" ~
            "  background  : " ~ computed.background.to!string ;
    }


    void set()
    {
        import ui.setmagnetic : set_magnetic;
        set_magnetic( &this );
    }

    void vid( IDrawer drawer )
    {
        update();
        set();
        vid_center( drawer );
        vid_border( drawer );
        //drawer.pen( computed.color, computed.borderWidth );
        //drawer.moveTo( 0, 0 );
        //drawer.lineTo( 100, 100 );

        // childs
        if ( firstChild !is null )
        for ( auto e = firstChild; e !is null; e = e.nextSibling )
        {
            e.vid( drawer );
        }
    }


    /** */
    void vid_center( IDrawer drawer )
    {
        drawer.point( centerX, centerY, computed.color ); // point at: 0, 0 ( center )
    }


    /** */
    void vid_border( IDrawer drawer )
    {
        auto w = computed.width / 2;
        auto h = computed.height / 2;

        if ( w > 0 && h > 0 ) 
        {
            if ( computed.borderTopWidth )
            {
                drawer.pen( computed.borderTopColor, computed.borderTopWidth );
                drawer.moveTo( centerX + -w, centerY + h );  // left  top
                drawer.lineTo( centerX +  w, centerY + h );  // right top
            }

            if ( computed.borderRightWidth )
            {
                drawer.pen( computed.borderRightColor, computed.borderRightWidth );
                drawer.moveTo( centerX + w, centerY +  h );  // right top
                drawer.lineTo( centerX + w, centerY + -h );  // right bottom
            }

            if ( computed.borderBottomWidth )
            {
                drawer.pen( computed.borderBottomColor, computed.borderBottomWidth );
                drawer.moveTo( centerX +  w, centerY + -h );  // right bottom
                drawer.lineTo( centerX + -w, centerY + -h );  // left  bottom
            }
            
            if ( computed.borderLeftWidth )
            {
                drawer.pen( computed.borderLeftColor, computed.borderLeftWidth );
                drawer.moveTo( centerX + -w, centerY + -h );  // left bottom
                drawer.lineTo( centerX + -w, centerY +  h );  // left top
            }
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
            ( abs( p.x - centerX ) <= abs( computed.width / 2 ) ) &&
            ( abs( p.y - centerY ) <= abs( computed.height / 2 ) );
    }


    /** */
    void update()
    {
        // init
        resetToDefault();

        // classes
        applyClassMembers();

        // element
        applyElementMembers();
    }


    void resetToDefault()
    {
        computed = Computed.init;
    }


    void applyClassMembers()
    {
        foreach ( cls; classes )
        {
            if ( cls.setter !is null )
            {
                cls.setter( &this );  // call setClassMembers( T )( Element* this )
            }
        }
    }


    void applyElementMembers()
    {
        if ( instanceClass.setter !is null )
        {
            instanceClass.setter( &this );  // call setClassMembers( T )( Element* this )
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
            foreach ( TCLASS; __traits( allMembers, generated ) ) 
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

        //
        if ( cls is null )
        {
            import ui.classregistry : registerClass;
            registerClass!TCLASS;
            cls = classRegistry.find( TCLASS.stringof );
        }

        //
        if ( cls !is null && !this.classes.has( cls ) )
        {
            this.classes ~= cls;
        }
    }


    void toggleClass( TCLASS )()
    {
        auto cls = classRegistry.find( TCLASS.stringof );

        //
        if ( cls is null )
        {
            import ui.classregistry : registerClass;
            registerClass!TCLASS;
            cls = classRegistry.find( TCLASS.stringof );
        }

        //
        if ( hasClass!TCLASS )
            this.delClass( TCLASS.stringof );
        else
            this.classes ~= cls;
    }


    void toggleClass( string className )
    {
        auto cls = classRegistry.find( className );

        //
        if ( cls is null )
        {
            assert( 0, "error: unregistered class: " ~ className );
        }

        //
        if ( hasClass( cls ) )
            delClass( cls );
        else
            classes ~= cls;
    }


    bool hasClass( TCLASS )()
    {
        auto cls = classRegistry.find( TCLASS.stringof );

        if ( cls && this.classes.has( cls ) )
            return true;
        else
            return false;
    }


    bool hasClass( string className )
    {
        auto cls = classRegistry.find( className );

        assert ( cls !is null );

        if ( this.classes.has( cls ) )
            return true;
        else
            return false;
    }


    bool hasClass( Class* cls )
    {
        assert ( cls !is null );

        if ( this.classes.has( cls ) )
            return true;
        else
            return false;
    }


    void delClass( string className )
    {
        auto cls = classRegistry.find( className );

        if ( cls && this.classes.has( cls ) )
        {
            auto pos = this.classes.countUntil( cls );

            if ( pos != -1 )
            {
                this.classes.deleteInPlace( pos, pos+1 );
            }
        }
        else
        {
            assert( 0, "class not found: " ~ className );
        }
    }


    void delClass( Class* cls )
    {
        assert ( cls !is null );

        if ( classes.has( cls ) )
        {
            auto pos = classes.countUntil( cls );

            if ( pos != -1 )
            {
                classes.deleteInPlace( pos, pos+1 );
            }
        }
    }


    // Properties
    /** */
    void border( Border val ) 
    {
        //props.border = val;

        //auto mid = memberId!( Props, "border" );
        //auto modPos = props.modifiedOrder[ mid ];

        //// not modified before
        //if ( modPos == 0 )
        //{
        //    // add mod at last pos
        //    props.modified[ props.modifiedLength ] = mid;
        //    props.modifiedOrder[ mid ] = props.modifiedLength;
        //    // save modifies length
        //    props.modifiedLength += 1;
        //}
        //else // was modified
        //{
        //    // remove prior mods
        //    import std.algorithm.mutation : moveEmplaceAll;
        //    moveEmplaceAll( props.modified[ mid+1 .. $ ], props.modified[ mid .. $ ] );
        //    // add mod at last pos
        //    props.modified[ props.modifiedLength ] = mid;
        //    props.modifiedOrder[ mid ] = props.modifiedLength;
        //}

    }

    //void borderTopWidth( T )( T a )
    //{
    //    props.borderTopWidth = a;
    //}

    @property
    void borderWidth( int a )
    {
        // instanceClass.setter
        //   ~= Setter( set_borderWidth, a );
        //
        // struct Setter
        // {
        //     int a;
        //
        //     void set() 
        //     {
        //         borderWidth = a;
        //     }
        // }
        computed.borderWidth = a;
    }


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


    /** */
    void dump( int level = 0 )
    {
        import std.array : replicate;

        writeln( " ".replicate( level ), &this, ": ", firstChild );

        // childs
        if ( firstChild !is null )
        for ( auto e = firstChild; e !is null; e = e.nextSibling )
        {
            e.dump( level+2 );
        }
    }
}

