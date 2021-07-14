module ui.app.glfw;

version ( GLFW ):
import glfw3.api;
import bindbc.opengl;
import core.stdc.stdio;
import core.stdc.stdlib : exit;
import std.conv    : to;
import std.string  : toStringz;
import ui.document : Document;
import ui.event    : EventType;
import ui.window   : Window;
import ui.base     : Display;
import ui.event    : Event;
import std.stdio   : writeln;

/*
void main_example()
{
    auto app = 
        App!()()
            .init_()
            .UI()
            .eventLoop()
            .exit_();
}
*/


/** */
struct App()
{
    Document* document;


    /** */ 
    auto init_()
    {
        version ( RENDER_BGFX )
        {        
            import bindbc.bgfx;

            loadBgfx(); // required with dynamically linked bgfx

            bgfx_init_t init;
            bgfx_init_ctor(&init);

            bgfx_init(&init);
            bgfx_reset(1280, 720, BGFX_RESET_NONE, init.resolution.format);

            bgfx_shutdown();
            unloadBgfx(); // optional, only needed with dynamically linked bgfx
        }

        glfwSetErrorCallback( &errorCallback );

        if ( ! glfwInit() ) 
        {
            exit( 1 );
        }

        return this;
    }


    /** */
    static
    Window* createWindow( int w, int h, string name )
    {
        GLFWwindow* glfwWindow;

        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);

        glfwWindow = glfwCreateWindow( w, h, name.toStringz, null, null );
        if ( ! glfwWindow ) 
        {
            return null;
        }

        glfwMakeContextCurrent( glfwWindow );
        glfwSwapInterval( 1 ); // Set vsync on so glfwSwapBuffers will wait for monitor updates.
                               // note: 1 is not a boolean! Set e.g. to 2 to run at half the monitor refresh rate.

        GLSupport retVal = loadOpenGL();
        if ( retVal == GLSupport.badLibrary || retVal == GLSupport.noLibrary ) 
        {
            glfwDestroyWindow( glfwWindow );
            return null;
        }

        return new Window( glfwWindow );
    }


    /** */
    Document* createDocument( string name )
    {
        import generated;

        auto doc = new Document();

        generated.initUI( doc );

        return doc;
    }


    /** */ 
    auto UI()
    {
        // create docuemtn
        //   create window if need
        //     window (width x height) = body ( width x height)

        import ui.compute.width   : compute_width;
        import ui.compute.height  : compute_height;
        import ui.compute.display : compute_display;

        this.document = createDocument( "app.t" );
        compute_width( &this.document.body );
        compute_height( &this.document.body );
        compute_display( &this.document.body );

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

        return this;
    }


    /** */
    auto eventLoop()
    {
        Shaders shaders;
        const GLuint program     = shaders.getProgram();
        const GLuint vaoTriangle = shaders.getTriangleVao();
        auto window = document.body.window;

        // Mouse buttons callback
        glfwSetMouseButtonCallback(window.glfwWindow, &mouseButtonCallback);
        // Mouse cursor move
        glfwSetCursorPosCallback(window.glfwWindow, &cursorPositionCallback);
        // Key callback
        glfwSetKeyCallback(window.glfwWindow, &keyCallback);

        while ( ! glfwWindowShouldClose( window.glfwWindow ) )
        {
            int width, height;
            glfwGetFramebufferSize( window.glfwWindow, &width, &height );
            glViewport( 0, 0, width, height );

            glClearColor ( 1.0f, 1.0f, 1.0f, 1.0f );
            glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

            glUseProgram( program );
            glBindVertexArray( vaoTriangle );
            glDrawArrays( GL_TRIANGLES, /*first*/ 0, /*count*/ 3 );

            glfwSwapBuffers( window.glfwWindow );
            glfwPollEvents(); // calling mouseButtonCallback, cursorPositionCallback, keyCallback
        }

        return this;
    }    


    /** */
    auto exit_()
    {
        if ( document )
        if ( document.body.window )
            glfwDestroyWindow( document.body.window.glfwWindow );

        glfwTerminate();

        return this;
    }
}


extern(C) @nogc nothrow 
void errorCallback( int error, const(char)* description ) 
{
    fprintf( stderr, "Error: %s\n", description );
}


// SHADER PROGRAM /////////////////////////
struct Shaders
{
    immutable string vertexShaderSource = "#version 330
    layout(location = 0) in vec2 position;
    layout(location = 1) in vec3 color;
    out vec3 fragColor;
    void main() {
        gl_Position = vec4(position, 0.0, 1.0);
        fragColor = color;
    }";

    immutable string fragmentShaderSource = "#version 330
    in vec3 fragColor;
    out vec4 outColor;
    void main() {
        outColor = vec4(fragColor, 1.0);
    }";

    GLuint getProgram() 
    {
        const GLint vertexShader = glCreateShader(GL_VERTEX_SHADER);
        {
            const GLint[1]  lengths = [vertexShaderSource.length.to!GLint];
            const(char)*[1] sources = [vertexShaderSource.ptr];
            glShaderSource(vertexShader, 1, sources.ptr, lengths.ptr);
            glCompileShader(vertexShader);
        }
        const GLint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        {
            const GLint[1] lengths = [fragmentShaderSource.length.to!GLint];
            const(char)*[1] sources = [fragmentShaderSource.ptr];
            glShaderSource(fragmentShader, 1, sources.ptr, lengths.ptr);
            glCompileShader(fragmentShader);
        }

        const GLuint program = glCreateProgram();
        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);
        glLinkProgram(program);

        return program;
    }

    // MODEL /////////////////////////

    struct Vertex {
        float[2] position;
        float[3] color;
    }

    immutable Vertex[3] vertices = [
        Vertex([-0.6f, -0.4f], [1.0f, 0.0f, 0.0f]),
        Vertex([ 0.6f, -0.4f], [0.0f, 1.0f, 0.0f]),
        Vertex([ 0.0f,  0.6f], [0.0f, 0.0f, 1.0f]),
    ];

    GLuint getTriangleVao() {
        // Upload data to GPU
        GLuint vbo;
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, vertices.sizeof, vertices.ptr, /*usage hint*/ GL_STATIC_DRAW);

        // Describe layout of data for the shader program
        GLuint vao;
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        glEnableVertexAttribArray(0);
        glVertexAttribPointer(
            /*location*/ 0, /*num elements*/ 2, /*base type*/ GL_FLOAT, /*normalized*/ GL_FALSE,
            Vertex.sizeof, cast(void*) Vertex.position.offsetof
        );
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(
            /*location*/ 1, /*num elements*/ 3, /*base type*/ GL_FLOAT, /*normalized*/ GL_FALSE,
            Vertex.sizeof, cast(void*) Vertex.color.offsetof
        );

        return vao;
    }    
}


extern (C) nothrow @nogc
void mouseButtonCallback(GLFWwindow* glfwWindow, int button, int action, int mods)
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
void cursorPositionCallback(GLFWwindow* glfwWindow, double xpos, double ypos)
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
void keyCallback(GLFWwindow* glfwWindow, int key, int scancode, int action, int mods)
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

