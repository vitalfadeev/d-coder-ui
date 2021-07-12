module ui.element;

import std.meta         : AliasSeq;
import ui.base          : Border;
import ui.color         : Color;
import ui.base          : Computed;
import ui.base          : LineStyle;
import ui.base          : memberId;
import ui.base          : POS;
import ui.classlist     : ClassList;
import ui.classregistry : Class;
import ui.classregistry : registerClass;
import ui.cssvalue      : CSSValue;
import ui.event         : Event;
import ui.nodelist      : NodeList;
import ui.point         : Point;
import ui.rendercontext : RenderContext;
import ui.window        : Window;
import ui.base          : Position;
import ui.tools         : between;
import std.math         : abs;
import ui.classregistry : classRegistry;
import std.stdio        : writeln;
import ui.childslist    : ChildsList;


/** */
struct Element
{
    // Properties
    // textContent
    string textContent;
    // background
    //   [ <bg-layer> , ]* <final-bg-layer>
    //   where 
    //     <bg-layer> = <bg-image> || <bg-position> [ / <bg-size> ]? || <repeat-style> || <attachment> || <box> || <box>
    //     <final-bg-layer> = <'background-color'> || <bg-image> || <bg-position> [ / <bg-size> ]? || <repeat-style> || <attachment> || <box> || <box>
    CSSValue background;
    // border
    void border( string s )        { /* parse s, set borderWidth, borderStyle, borderColor */ }
    void border( POS w )           { /* parse s, set borderWidth, borderStyle, borderColor */ }
    void border( LineStyle style ) { /* parse s, set borderWidth, borderStyle, borderColor */ }
    void border( Color c )         { /* parse s, set borderWidth, borderStyle, borderColor */ }
    // border width
    //   <length> | thin | medium | thick | initial | revert | unset
    CSSValue borderTopWidth;
    CSSValue borderRightWidth;
    CSSValue borderBottomWidth;
    CSSValue borderLeftWidth;
    // border Style
    //   <line-style> = none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset | initial | revert | unset
    CSSValue borderTopStyle;
    CSSValue borderRightStyle;
    CSSValue borderBottomStyle;
    CSSValue borderLeftStyle;
    // border color
    //   <color> = <rgb()> | <rgba()> | <hsl()> | <hsla()> | <hex-color> | <named-color> | currentcolor | <deprecated-system-color> | initial | revert | unset
    CSSValue borderTopColor;
    CSSValue borderRightColor;
    CSSValue borderBottomColor;
    CSSValue borderLeftColor;
    // bottom
    //   <length> | <percentage> | auto
    CSSValue bottom;
    // color
    //   <color> = <rgb()> | <rgba()> | <hsl()> | <hsla()> | <hex-color> | <named-color> | currentcolor | <deprecated-system-color> | initial | revert | unset
    CSSValue color;
    // display
    //   [ <display-outside> || <display-inside> ] | <display-listitem> | <display-internal> | <display-box> | <display-legacy>
    CSSValue display;
    // height
    //   auto | <length> | <percentage> | min-content | max-content | fit-content | fit-content(<length-percentage>)
    CSSValue height;
    // hidden
    //   visible | hidden | collapse
    CSSValue hidden;
    // id
    string   id;
    // image
    //   string | Image
    CSSValue image;
    // left
    //   <length> | <percentage> | auto
    CSSValue left;
    // margin
    void margin( string s ) {}
    CSSValue marginLeft;
    CSSValue marginTop;
    CSSValue marginRight;
    CSSValue marginBottom;
    // padding
    void padding( string s ) {}
    CSSValue paddingLeft;
    CSSValue paddingTop;
    CSSValue paddingRight;
    CSSValue paddingBottom;
    //
    CSSValue position;
    // right
    //   <length> | <percentage> | auto
    CSSValue right;
    // tabIndex
    int      tabIndex;
    // top
    //   <length> | <percentage> | auto
    CSSValue top;
    // width
    //   auto | <length> | <percentage> | min-content | max-content | fit-content | fit-content(<length-percentage>)
    CSSValue width;
    // z-index
    //   auto | <integer>
    CSSValue zIndex;

    // Node properties
    union {
        struct {
            Element* parentNode;
            Element* prevSibling;
            Element* nextSibling;
            Element* firstChild;
            Element* lastChild;
        };
        ChildsList children;
        //ChildsList child;
    }

    // Draw properties
    // classes
    ClassList classes;

    //
    // Computed properties
    //   default properties + class-level properties + element-level properties
    Computed computed;

    // Event Handlers
    EventHandler onload;
    EventHandler onclick;

    // setter assigned to the Element
    void function( Element* element ) setter;
    void function( Element* element, Event* event ) on;

    //
    // Window
    //   for display = window
    Window* window;

    //
    // Scrolling
    POS   scrollLeft;
    POS   scrollTop;

    //
    bool  live;  // for delete Mag in array storage and prevent reallocationg storage

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

    /** 
     * ctx: CanvasRenderingContext2D
     */
    void draw( RenderContext* ctx )
    {
        draw_border( ctx );
        draw_text( ctx );
    }

    //private
    void draw_border( RenderContext* ctx )
    {
        //
    }

    /** 
     * ctx: CanvasRenderingContext2D
     */
    //private
    void draw_text( RenderContext* ctx )
    {
        /*
        // offset RenderContext in Document. 
        // Element -> | (x,y) transform | -> RenderContext -> Window
        RenderContextCoordTransformator tr;
        tr.rect = ctx.rectInDocument;
        Rect eRect = tr.transform( computed.absoluteRect ); // Element rect in Rendercontext coords

        // set clipping
        auto region = new Path2D();
        region.rect( 
            eRect.left, 
            eRect.top, 
            eRect.right  - eRect.left, 
            eRect.bottom - eRect.top );
        ctx.clip( region );

        // draw text ( clipped )
        ctx.fillText( 
            _textContent, 
            eRect.left, 
            eRect.top );
        */
    }


    /** */
    Element* querySelector( string selector )
    {
        import std.string : strip;

        auto cleaned_selector = selector.strip( ". ", " " );

        return selectByClass( cleaned_selector );
    }


    /** */
    NodeList querySelectorAll( string selector )
    {
        import std.string : strip;

        auto cleaned_selector = selector.strip( ". ", " " );

        return selectByClassAll( cleaned_selector );
    }


    /** */
    //string textContent()
    //{
    //    return "";
    //}

    /** */
    // element.text = "1";
    // element.text = true;
    // element.text = 1;
    // element.text = -1;
    // element.text = 1.0;
    //void textContent( string s )
    //{
    //    _textContent = s;
    //}
    //static
    //foreach( T; AliasSeq!( bool, byte, ubyte, short, ushort, int, uint, long, ulong, float, double ) )
    //{
    //    void text( T a )
    //    {
    //        import std.conv : to;
    //        _textContent = a.to!string;
    //    }
    //}
    

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
    void draw_childs( RenderContext* ctx )
    {
        /*
        // set clipping
        ctx.clip( computed.centerX, computed.centerY, computed.width, computed.height );

        // childs
        if ( firstChild !is null )
        for ( auto e = firstChild; e !is null; e = e.nextSibling )
        {
            // in view
            if ( inView( e ) )
            {
                e.draw( ctx );
            }
        }
        */
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
        /*
        if ( instanceClass.setter !is null )
        {
            instanceClass.setter( &this );  // call setClassMembers( T )( Element* this )
        }
        */
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

//private:
    Element* selectByClass( string className )
    {
        // document 
        //   body
        //     e1
        //     e2
        //     e3
        //       e4
        //     e5
        // [body, e1, e2, e3, e4, e5]
        import std.container : DList;
        import ui.walkindeep : walkInDeep;

        auto lst = new NodeList();

        walkInDeep( &this, ( element ) => {
            lst ~= element;
        } );

        if ( lst.length > 0 )
            return lst.item( 0 );
        else
            return null;
    }

    NodeList selectByClassAll( string className )
    {
        // document 
        //   body
        //     e1
        //     e2
        //     e3
        //       e4
        //     e5
        // [body, e1, e2, e3, e4, e5]
        import std.container : DList;
        import ui.walkindeep : walkInDeep;

        auto lst = new NodeList();

        walkInDeep( &this, ( element ) => {
            lst ~= element;
        } );

        return lst;
    }
}

alias Node = Element;


/** */
struct EventHandler
{
    void delegate( Event* event ) handler;
    alias handler this;

    void opCall()
    {
        if ( handler !is null )
        {
            Event event;
            handler( &event );
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

