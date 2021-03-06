module ui.event.glfw;

version( GLFW ):
import deps.glfw;
import ui.window : Window;


/** */
enum EventType
{
    MouseKey,
    MouseMove,
    MouseWheel,
    KeyboardKey
}


/** */
struct Event
{
    EventType type;  // WM_KEYDOWN, WM_KEYUP
    union
    {
        MouseKeyEvent    mouseKey;
        MouseMoveEvent   mouseMove;
        MouseWheelEvent  mouseWheel;
        KeyboardKeyEvent keyboard;
    }

    string name()
    {
        return type.stringof;
    }

    auto arg1()
    {
        switch ( type )
        {
            case EventType.KeyboardKey: 
                return keyboard.scancode;
            default: 
                return 0;
        }
    }
}


mixin template ControlKeys()
{
    pragma( inline )
    bool ctrlPressed()
    {
        return ( mods & GLFW_MOD_CONTROL ) != 0;
    }


    pragma( inline )
    bool altPressed()
    {
        return ( mods & GLFW_MOD_ALT ) != 0;
    }


    pragma( inline )
    bool shiftPressed()
    {
        return ( mods & GLFW_MOD_SHIFT ) != 0;
    }


    pragma( inline )
    bool winPressed()
    {
        return ( mods & GLFW_MOD_SUPER ) != 0;
    }

    /** */
    uint controlKeys()
    {
        return mods; // shoft, control, alt, super, caps, numlock
    }
}


/** */
struct MouseKeyEvent
{
    Window* window;
    int     button;
    int     action;
    int     mods;


    mixin ControlKeys;


    bool leftKeyPressed()
    {
        return ( action == GLFW_PRESS && button == GLFW_MOUSE_BUTTON_LEFT );
    }


    bool rightKeyPressed()
    {
        return ( action == GLFW_PRESS && button == GLFW_MOUSE_BUTTON_RIGHT );
    }


    bool middleKeyPressed()
    {
        return ( action == GLFW_PRESS && button == GLFW_MOUSE_BUTTON_MIDDLE );
    }


    bool x1KeyPressed()
    {
        return ( action == GLFW_PRESS && button == GLFW_MOUSE_BUTTON_4  );
    }


    bool x2KeyPressed()
    {
        return ( action == GLFW_PRESS && button == GLFW_MOUSE_BUTTON_5  );
    }
}


/** */
struct MouseMoveEvent
{
    Window* window;
    double  xpos;
    double  ypos;
}


/** */
struct MouseWheelEvent
{
    Window* window;
}


/** */
struct KeyboardKeyEvent
{
    Window* window;
    int     key;
    int     scancode;
    int     action;
    int     mods;

    mixin ControlKeys;    
}


alias WM_KEYDOWN = EventType.KeyboardKey;
alias WM_LBUTTONDOWN = EventType.MouseKey;

alias VK_SPACE = GLFW_KEY_SPACE;
