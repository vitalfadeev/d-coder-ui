module ui.element;

import ui;
import ui.classlist     : ClassList;
import ui.base          : Computed;
import ui.base          : Border;
import ui.base          : memberId;
import ui.classregistry : registerClass;


/** */
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

    // Scrolling
    POS   scrollLeft;
    POS   scrollTop;

    //
    bool live;  // for delete Mag in array storage and prevent reallocationg storage

    //
    void* data; // payload

    //
    //void delegate( IDrawer drawer ) _vid;
    //bool delegate( Point p        ) _hitTest;


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


    bool isPositioned()
    {
        return 
            computed.position == Position.relative || 
            computed.position == Position.absolute || 
            computed.position == Position.fixed ||
            computed.position == Position.sticky;
    }

    bool isReltivePositioned()
    {
        return computed.position == Position.relative;
    }

    bool isAbsolutePositioned()
    {
        return 
            computed.position == Position.absolute ||
            computed.position == Position.fixed;
    }

    bool isStickyPositioned()
    {
        return computed.position == Position.sticky;
    }

    void wh()
    {
        // position: absolute 
        //   width  = auto = content width
        //   height = auto = content height
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
        scroll();
        vid_center( drawer );
        vid_border( drawer );
        //drawer.pen( computed.color, computed.borderWidth );
        //drawer.moveTo( 0, 0 );
        //drawer.lineTo( 100, 100 );
        vid_childs( drawer );
    }

/*
    void box_model()
    {
        // https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Box_Model/Introduction_to_the_CSS_box_model
        // https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/The_box_model
        //
        final
        switch ( computed.outerDisplay )
        {
            case DisplayType.inline       : inline_box(); break;
            case DisplayType.block        : block_box(); break;
            case DisplayType.inline_block : inline_block_box(); break;

            case DisplayType.flex         : break;
            case DisplayType.grid         : break;
            case DisplayType.magnetic     : break;
        }

        Size contentBox;
        Size paddingBox;
        Size borderBox;
        Size marginBox;
    }

    void block_box()
    {
        // https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/The_box_model
        //
        // break as NL
        // extend in inline-direction. space limited by container. size = container size
        // .width and .height
        // .padding, .margin, .border - whole box, push away other from box

        POS getWidth()
        {
            with ( computed )
            {
                // boxModel
                final
                switch ( boxSizing )
                {
                    // standart
                    case BoxSizing.content_box : return standartWidth;
                    // alternative
                    case BoxSizing.border_box  : return alternativeWidth;
                }
                
            }
        }

        POS standartWidth()
        {
            with ( computed )
            {
                return 
                    contentWidth + 
                    paddingLeft + paddingRight + 
                    borderLeftWidth + borderRightWidth;
            }
        }

        POS alternativeWidth()
        {
            with ( computed )
            {
                return contentWidth;
            }
        }

        POS contentWidth()
        {
            // text
            // image
            // video player
            // childs
            with ( computed )
            {
                return width;
            }
        }
    }

    void inline_box()
    {
        // https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/The_box_model
        //
        // not break line
        // ignore .width and .height
        // vertical .padding, .margin, .border applied, but not cause to other boxes
        // horizontal .padding, .margin, .border push away other from box

        POS getWidth()
        {
            with ( computed )
            {
                // boxModel
                final
                switch ( boxSizing )
                {
                    // standart
                    case BoxSizing.content_box : return standartWidth;
                    // alternative
                    case BoxSizing.border_box  : return alternativeWidth;
                }
                
            }
        }

        POS standartWidth()
        {
            with ( computed )
            {
                return 
                    contentWidth + 
                    paddingLeft + paddingRight + 
                    borderLeftWidth + borderRightWidth;
            }
        }

        POS alternativeWidth()
        {
            with ( computed )
            {
                return contentWidth;
            }
        }

        POS contentWidth()
        {
            with ( computed )
            {
                return getContentWidth();
            }
        }

        POS getContentWidth()
        {
            // sum childs
            // text width
            return 0;
        }
    }

    void inline_block_box()
    {
        // https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/The_box_model
        //
        // not break line
        // .width and .height
        // .padding, .margin, .border - whole box, push away other from box
        POS getWidth()
        {
            with ( computed )
            {
                // boxModel
                final
                switch ( boxSizing )
                {
                    // standart
                    case BoxSizing.content_box : return standartWidth;
                    // alternative
                    case BoxSizing.border_box  : return alternativeWidth;
                }
                
            }
        }

        POS standartWidth()
        {
            with ( computed )
            {
                return 
                    contentWidth + 
                    paddingLeft + paddingRight + 
                    borderLeftWidth + borderRightWidth;
            }
        }

        POS alternativeWidth()
        {
            with ( computed )
            {
                return contentWidth;
            }
        }

        POS contentWidth()
        {
            with ( computed )
            {
                return getContentWidth();
            }
        }

        POS getContentWidth()
        {
            // sum childs
            // text width
            return 0;
        }
    }


    void normalFlow()
    {
        // https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Normal_Flow
    }
*/

    pragma( inline, true )
    void vid_childs( IDrawer drawer )
    {
        // set clipping
        drawer.clipRect( computed.centerX, computed.centerY, computed.width, computed.height );

        // childs
        if ( firstChild !is null )
        for ( auto e = firstChild; e !is null; e = e.nextSibling )
        {
            // in view
            if ( inView( e ) )
            {
                e.vid( drawer );
            }
        }
    }

    bool inView( Element* child )
    {
        if ( isIntersected( child ) )
        {
            return true;
        }

        return false;
    }

    bool isIntersected( Element* child )
    {
        POS x1 = computed.centerX - computed.width / 2  + scrollLeft;
        POS y1 = computed.centerY - computed.height / 2 + scrollTop;
        POS x2 = x1 + computed.width;
        POS y2 = y1 + computed.height;

        POS cx1 = child.computed.centerX - child.computed.width / 2;
        POS cy1 = child.computed.centerY - child.computed.height / 2;
        POS cx2 = cx1 + child.computed.width;
        POS cy2 = cy1 + child.computed.height;

        if ( 
             cx1.between( x1, x2 ) && cy1.between( y1, y2 ) ||
             cx2.between( x1, x2 ) && cy1.between( y1, y2 ) ||
             cx2.between( x1, x2 ) && cy2.between( y1, y2 ) ||
             cx1.between( x1, x2 ) && cy2.between( y1, y2 )
           )
        {
            return true;
        }

        return false;
    }


    /** */
    void vid_center( IDrawer drawer )
    {
        drawer.point( computed.centerX, computed.centerY, computed.color ); // point at: 0, 0 ( center )
    }


    /** */
    void vid_margin( IDrawer drawer )
    {
        //auto marginArea = boxModel_marginArea;
        // drawer.rectangleFilled( marginArea.left, marginArea.top, marginArea.right, marginArea.bottom, 0x333333.rgb );
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
                drawer.moveTo( computed.centerX + -w, computed.centerY + h );  // left  top
                drawer.lineTo( computed.centerX +  w, computed.centerY + h );  // right top
            }

            if ( computed.borderRightWidth )
            {
                drawer.pen( computed.borderRightColor, computed.borderRightWidth );
                drawer.moveTo( computed.centerX + w, computed.centerY +  h );  // right top
                drawer.lineTo( computed.centerX + w, computed.centerY + -h );  // right bottom
            }

            if ( computed.borderBottomWidth )
            {
                drawer.pen( computed.borderBottomColor, computed.borderBottomWidth );
                drawer.moveTo( computed.centerX +  w, computed.centerY + -h );  // right bottom
                drawer.lineTo( computed.centerX + -w, computed.centerY + -h );  // left  bottom
            }
            
            if ( computed.borderLeftWidth )
            {
                drawer.pen( computed.borderLeftColor, computed.borderLeftWidth );
                drawer.moveTo( computed.centerX + -w, computed.centerY + -h );  // left bottom
                drawer.lineTo( computed.centerX + -w, computed.centerY +  h );  // left top
            }
        }
    }

    /** */
    void vid_pading( IDrawer drawer )
    {
        //auto paddingArea = boxModel_paddingArea;
        //drawer.rectangleFilled( paddingArea.left, paddingArea.top, paddingArea.right, paddingArea.bottom, 0x888888.rgb );
    }

    /** */
    void vid_content( IDrawer drawer )
    {
        //auto contentArea = boxModel_contentArea;
        //drawer.rectangleFilled( contentArea.left, contentArea.top, contentArea.right, contentArea.bottom, 0xCCCCCC.rgb );
    }

    /** */
    void vid_symbol( IDrawer drawer )
    {
        drawer.pen( 0xCCCCCC.rgb, 3 );
        drawer.moveTo( 0, 0 );  // center
        //drawer.symbol( 'A', m, -( cast( int ) m )/2, m, m/2 );
    }

    //Rect boxModel_marginArea()
    //{
    //    with ( computed )
    //    {
    //        auto l = centerX - contentLeft   - paddingLeft   - borderLeftWidth   - marginLeft  ;
    //        auto t = centerY - contentTop    - paddingTop    - borderTopWidth    - marginTop   ;
    //        auto r = centerX + contentRight  + paddingRight  + borderRightWidth  + marginRight ;
    //        auto b = centerY + contentBottom + paddingBottom + borderBottomWidth + marginBottom;
    //    }

    //    return Rect( l, t, r ,b );
    //}

    //Rect boxModel_borderArea()
    //{
    //    with ( computed )
    //    {
    //        auto l = centerX - contentLeft   - paddingLeft   - borderLeftWidth  ;
    //        auto t = centerY - contentTop    - paddingTop    - borderTopWidth   ;
    //        auto r = centerX + contentRight  + paddingRight  + borderRightWidth ;
    //        auto b = centerY + contentBottom + paddingBottom + borderBottomWidth;
    //    }

    //    return Rect( l, t, r ,b );
    //}

    //Rect boxModel_paddingArea()
    //{
    //    with ( computed )
    //    {
    //        auto l = centerX - contentLeft   - paddingLeft  ;
    //        auto t = centerY - contentTop    - paddingTop   ;
    //        auto r = centerX + contentRight  + paddingRight ;
    //        auto b = centerY + contentBottom + paddingBottom;
    //    }

    //    return Rect( l, t, r ,b );
    //}

    //Rect boxModel_contentArea()
    //{
    //    with ( computed )
    //    {
    //        // renderWidth;
    //        // renderHeight;
    //        auto l = centerX - contentLeft  ;
    //        auto t = centerY - contentTop   ;
    //        auto r = centerX + contentRight ;
    //        auto b = centerY + contentBottom;
    //    }

    //    return Rect( l, t, r ,b );
    //}


    /** */
    bool hitTest( Point p )
    {
        return 
            ( abs( p.x - computed.centerX ) <= abs( computed.width / 2 ) ) &&
            ( abs( p.y - computed.centerY ) <= abs( computed.height / 2 ) );
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


    pragma( inline, true )
    void resetToDefault()
    {
        computed = Computed.init;
    }


    pragma( inline, true )
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


    pragma( inline, true )
    void applyElementMembers()
    {
        if ( instanceClass.setter !is null )
        {
            instanceClass.setter( &this );  // call setClassMembers( T )( Element* this )
        }
    }

    pragma( inline, true )
    void scroll()
    {
        if ( parentNode )
        {
            with ( computed )
            {
                computed.centerX -= parentNode.scrollLeft;
                computed.centerY += parentNode.scrollTop;
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

version ( ClassList2 )
{
    bool hasClass( ClassId classId )
    {
        return classes.has( classId );
    }

    bool hasClass( T )()
          if ( is( T == struct ) )
    {
        return hasClass( T.init.classId );
    }

    void addClass( ClassId classId )
    {
        classes.add( classId );
    }

    void addClass( T )()
          if ( is( T == struct ) )
    {
        addClass( T.init.classId );
    }

    void delClass( ClassId classId )
    {
        classes.remove( classId );
    }

    void delClass( T )()
          if ( is( T == struct ) )
    {
        delClass( T.init.classId );
    }

    void toggleClass( ClassId classId )
    {
        if ( classes.hasClass( classId ) )
            classes.delClass( classId );
        else
            classes.addClass( classId );
    }

    void toggleClass( T )()
          if ( is( T == struct ) )
    {
        if ( hasClass!T )
            delClass!classId;
        else
            addClass!classId;
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


// Element class
struct e
{
    string name = "e";
    //void setter( Element* element );
    //void on( Element* element, Event* event );
}

static
this()
{
    registerClass!e();
}

