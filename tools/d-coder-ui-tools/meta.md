# Meta

head
    title: Sample
style
    base
        border: 3px solid #ccc

        on: WM_KEYDOWN VK_SPACE
            addClass selected

    selected
        border: 3px solid #0c0
body
  e base
    border: 3px solid


// style.d
struct base
{
    string name = "base";

    static
    void setter( Element* element )
    {
        with ( element.computed )
        {
            borderWidth = 3.px;
            borderStyle = LineStyle.solid;
            borderColor = Color( #ccc );
        }
    }

    static
    void on( Element* element, Event* event )
    {
        // route by event type
        switch ( event.type )
        {
            case WM_KEYDOWN: on_WM_KEYDOWN( element, event ); break;
            default:
        }
    }

    static
    void on_WM_KEYDOWN( Element* element, Event* event )
    {
        if ( event.code == VK_SPACE )
        {
            element.addClass( "selected" );
        }
    }
}


// default element
struct e_1
{
    Element _element = { 
      computed: { 
        borderWidth: 3.px,
        borderStyle: LineStyle.solid
      }
    };
    alias _element this;

}
  

// variations
style
    base
        on WM_KEYDOWN 
          VK_SPACE
            addClass selected
          VK_ESCAPE
            addClass selected

        on
          WM_KEYDOWN 
            VK_SPACE
              addClass selected
            VK_ESCAPE
              addClass selected

        on WM_ADDCLASS
          log this event

        on WM_ADDCLASS selected
          log selected

        on WM_FOCUSED
          log focused

body
  on WM_KEYDOWN VK_SPACE
      {
          addClass( "selected" );
      }

  on WM_KEYDOWN VK_SPACE
      selected
        - selected
        next
          + selected
      body
        send keyPressed VK_SPACE

// selector
selected - by class name
next     - next sibling element in tree
body     - by class name

//  setters
border: 1px solid #ccc
    // settters
    borderTopWidth         = 1.px;
    borderRightWidth       = 1.px;
    borderBottomWidth      = 1.px;
    borderLeftWidth        = 1.px;
    borderTopLeftWidth     = 1.px;
    borderTopRightWidth    = 1.px;
    borderBottomLeftWidth  = 1.px;
    borderBottomRightWidth = 1.px;

    computed.border_top_style          = LineStyle.solid;
    computed.border_right_style        = LineStyle.solid;
    computed.border_bottom_style       = LineStyle.solid;
    computed.border_left_style         = LineStyle.solid;
    computed.border_top_left_style     = LineStyle.solid;
    computed.border_top_right_style    = LineStyle.solid;
    computed.border_bottom_left_style  = LineStyle.solid;
    computed.border_bottom_right_style = LineStyle.solid;

    computed.border_top_color          = 0xccc.rgb;
    computed.border_right_color        = 0xccc.rgb;
    computed.border_bottom_color       = 0xccc.rgb;
    computed.border_left_color         = 0xccc.rgb;
    computed.border_top_left_color     = 0xccc.rgb;
    computed.border_top_right_color    = 0xccc.rgb;
    computed.border_bottom_left_color  = 0xccc.rgb;
    computed.border_bottom_right_color = 0xccc.rgb;

1px solid #ccc
    1px
    solid
    #ccc

1px solid #ccc
    width 1px
    style solid
    color #ccc

// css
parse_border           ( in: tokens, out: setters )
    parse_border_width

parse_border_top       ( in: tokens, out: setters )
    parse_border_width

parse_border_top_width ( in: tokens, out: setters )
    parse_border_width

parse_border_width     ( in: tokens, out: setters )
    parse_line_width

parse_line_width ( in: string, out Width( Length ) )
    parse_length

parse_length ( in: string, out Length( float, Unit ) )


//
deps/
  d-coder-ui/
generated/
  classes.d
  tree.d
source/
  app.d
app.t

app.d
-----
import ui;
import generated;

void main()
{
    initUI();
}


// events
window
  WM_KEYDOWN
    focused element
      // class
      foreach ( cls; classes )
        if ( cls.on )
          cls.on( element, event )
      // element
        if ( element.on )
          element.on( element, event )

  // window
  on( event )
  on_WM_KEYDOWN( event )

// event
window
  WM_LBUTTONDOWN
    window.on()
      body.on()
        element.on()
          WM_LBUTTONDOWN_ed
        element.on()
      body.on()
    window.on()

