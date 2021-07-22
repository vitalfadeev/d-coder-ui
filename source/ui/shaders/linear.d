module ui.shaders.linear;

version( GL3 ):
import bindbc.opengl;
import bindbc.opengl.bind.types;
import std.container.array;
import core.stdc.stdlib : alloca;
import core.stdc.stdio  : printf;
import core.stdc.stdio  : fprintf;
import core.stdc.stdio  : stderr;


Shader!( vertexShaderSource, fragmentShaderSource ) linearShader;

 
nothrow @nogc
void loadLinearShader()
{
    linearShader.load();
}


immutable string vertexShaderSource = "#version 330
layout(location = 0) in vec2 position;
layout(location = 1) in vec3 color;
out vec3 fragColor;
void main() {
    gl_Position = vec4(position, 0.0, 1.00);
    fragColor = color;
}";

immutable string fragmentShaderSource = "#version 330
in vec3 fragColor;
out vec4 outColor;
void main() {
    outColor = vec4(fragColor, 1.0);
}";


struct Shader( string vertexShaderSource, string fragmentShaderSource )
{
    GLuint program;
    alias program this;

    nothrow @nogc
    load()
    {
        auto vertexShader   = _createShader( GL_VERTEX_SHADER,   vertexShaderSource );
        auto fragmentShader = _createShader( GL_FRAGMENT_SHADER, fragmentShaderSource );

        program = _createProgram( vertexShader, fragmentShader );

        glDeleteShader( fragmentShader );
        glDeleteShader( vertexShader );
    }

    nothrow @nogc
    ~this()
    {
        glDeleteProgram( program );
    }
}


nothrow @nogc
GLuint _createShader( GLenum type, string source )
{
    const GLint shader = glCreateShader( type );
    const GLint[1] lengths = [cast( int ) source.length];
    const(char)*[1] sources = [source.ptr];
    glShaderSource( shader, 1, sources.ptr, lengths.ptr );
    glCompileShader( shader );

    GLint status;
    glGetShaderiv( shader, GL_COMPILE_STATUS, &status );

    if ( status == GL_FALSE )
    {
        GLint infoLogLength;
        glGetShaderiv( shader, GL_INFO_LOG_LENGTH, &infoLogLength );

        void* mem = alloca( infoLogLength + 1 );
        GLchar* strInfoLog = cast( GLchar* ) mem;
        glGetShaderInfoLog( shader, infoLogLength, null, strInfoLog );

        string strShaderType;
        switch( type )
        {
            case GL_VERTEX_SHADER:   strShaderType = "vertex";   break;
            case GL_GEOMETRY_SHADER: strShaderType = "geometry"; break;
            case GL_FRAGMENT_SHADER: strShaderType = "fragment"; break;
            default:
                strShaderType = "unknown"; break;
        }
        
        fprintf( stderr, "error: Compile failure in %s shader:\n%s\n", strShaderType.ptr, strInfoLog );
    }

    return shader;
}


nothrow @nogc
GLuint _createProgram( ARGS... )( ARGS shaderList )
{
    GLuint program = glCreateProgram();
    
    static
    foreach( shader; shaderList )
    {
        glAttachShader( program, shader );
    }
    
    glLinkProgram( program );
    
    GLint status;
    glGetProgramiv( program, GL_LINK_STATUS, &status );

    if ( status == GL_FALSE )
    {
        GLint infoLogLength;
        glGetProgramiv( program, GL_INFO_LOG_LENGTH, &infoLogLength );
        
        void* mem = alloca( infoLogLength + 1 );
        GLchar* strInfoLog = cast( GLchar* ) mem;
        glGetProgramInfoLog( program, infoLogLength, null, strInfoLog );
        fprintf( stderr, "error: Linker failure: %s\n", strInfoLog );
    }
    
    static
    foreach( shader; shaderList )
    {
        glDetachShader( program, shader );
        glAttachShader( program, shader );
    }

    return program;
}
