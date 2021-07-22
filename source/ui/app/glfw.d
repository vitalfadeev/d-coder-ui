module ui.app.glfw;

version ( GLFW ):
import glfw3.api;
import bindbc.opengl;
import core.stdc.stdio;
import core.stdc.stdlib : exit;
import core.stdc.stdio  : printf;
import std.conv    : to;
import std.string  : toStringz;
import ui.document : Document;
import ui.event    : EventType;
import ui.window   : Window;
import ui.base     : Display;
import ui.event    : Event;
import ui.loadui   : loadUI;
import std.stdio   : writeln;
import ui.window   : createMainWindow;
import ui.window   : MainWindow;

/*
int main_example()
{
    return App( "app.t" ).result;
}
*/


/** */
struct App()
{
    Document   document;
    MainWindow window;
    int        result;


    /** */
    nothrow @nogc
    this( string docName )
    {
        load();
        UI( docName );
        mainLoop();
    }


    /** */ 
    nothrow @nogc
    void load()
    {
        if ( loadUI() ) 
        {
            result = 1;
            printf( "error: loadUI()\n" );
            exit( 1 );
        }
    }


    /** */
    static nothrow @nogc
    auto createMainWindow( int w, int h, string name )
    {
        return .createMainWindow( w, h, name );
    }


    /** */
    static nothrow @nogc
    auto createWindow( int w, int h, string name )
    {
        return .createWindow( w, h, name );
    }


    /** */
    static nothrow @nogc
    auto createDocument( string name )
    {
        return .createDocument( name );
    }


    /** */ 
    nothrow @nogc
    void UI( string docName )
    {
        // create docuemtn
        //   create window if need
        //     window (width x height) = body ( width x height)

        import ui.compute.width   : compute_width;
        import ui.compute.height  : compute_height;
        import ui.compute.display : compute_display;

        document = createDocument( docName );
        compute_width( &document.body );
        compute_height( &document.body );
        compute_display( &document.body );

        with ( document.body )
        {        
            if ( computed.display == Display.window )
            if ( window is null )
            {
                window = 
                    createWindow(
                        computed.width, 
                        computed.height, 
                        "D UI example" // title
                    );
            }
        }
    }


    nothrow @nogc
    void draw()
    {
        //
    }


    /** */
    nothrow @nogc
    void eventLoop()
    {
        // Mouse buttons callback
        glfwSetMouseButtonCallback( window.glfwWindow, &mouseButtonCallback );
        // Mouse cursor move
        glfwSetCursorPosCallback( window.glfwWindow, &cursorPositionCallback );
        // Key callback
        glfwSetKeyCallback( window.glfwWindow, &keyCallback );

        //
        while ( ! glfwWindowShouldClose( window.glfwWindow ) ) 
        {
            draw();
            glfwSwapBuffers( window );
            glfwPollEvents();
        }

        result = 0;
    }    


    /** */
    nothrow @nogc
    ~this()
    {
        if ( document )
        if ( document.body.window )
            glfwDestroyWindow( document.body.window.glfwWindow );

        //glfwTerminate();
    }
}


extern(C) @nogc nothrow 
void errorCallback( int error, const(char)* description ) 
{
    fprintf( stderr, "Error: %s\n", description );
}


extern (C) nothrow @nogc
void mouseButtonCallback( GLFWwindow* glfwWindow, int button, int action, int mods )
{
    Window window = { glfwWindow: glfwWindow };

    Event event = 
        {
            type:     EventType.MouseKey,
            mouseKey: {
                window: &window,
                button: button,
                action: action,
                mods  : mods
            }
        };

    // Send event
    window.on( &event );
}

extern (C) static nothrow @nogc
void cursorPositionCallback( GLFWwindow* glfwWindow, double xpos, double ypos )
{
    Window window = { glfwWindow: glfwWindow };

    Event event = 
        {
            type:      EventType.MouseMove,
            mouseMove: {
                window: &window,
                xpos  : xpos,
                ypos  : ypos
            }
        };

    // Send event
    window.on( &event );
}


extern (C) nothrow @nogc
void keyCallback( GLFWwindow* glfwWindow, int key, int scancode, int action, int mods )
{
    Window window = { glfwWindow: glfwWindow };

    Event event = 
        {
            type:     EventType.KeyboardKey,
            keyboard: {
                window  : &window,
                key     : key,
                scancode: scancode,
                action  : action,
                mods    : mods
            }
        };

    // Send event
    window.on( &event );
}


static nothrow @nogc
auto createDocument( string name )
{
    Document document;

    import generated;
    generated.initUI( &document );

    return document;
}
