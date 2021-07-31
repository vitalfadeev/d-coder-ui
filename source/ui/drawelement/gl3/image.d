module ui.drawelement.gl3.image;


version ( GL3 ):
import bindbc.opengl.bind.types;
import bindbc.opengl;
import core.stdc.stdio  : printf;
import core.stdc.stdlib : exit;
import core.stdc.stdio  : sscanf;
import ui.color;
import dlib;
import bc.string.string : tempCString;
import std.math : ceil;
import std.math : floor;
import std.math : log;
import std.math : pow;
import core.math : rndtol;
import core.stdc.stdlib : alloca;
import std.typecons : RefCounted, RefCountedAutoInitialize;
import ui.vectorcpp : VectorCPP;
import ui.shaders.shader : Shader;
version ( FreeImage )
import bindbc.freeimage;
import ui.shaders : imageShader;
import ui.shaders : linearShader;
import gl : checkGlError;


static GLuint texture;
static GLuint VBO, VAO /* , EBO */;

//
float[4*8] vertices = 
[
    // positions          // colors           // texture coords
     0.5f,  0.5f, 0.0f,   1.0f, 0.0f, 0.0f,   1.0f, 1.0f,   // top right
     0.5f, -0.5f, 0.0f,   0.0f, 1.0f, 0.0f,   1.0f, 0.0f,   // bottom right
    -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f,   0.0f, 0.0f,   // bottom left
    -0.5f,  0.5f, 0.0f,   1.0f, 1.0f, 0.0f,   0.0f, 1.0f    // top left 
];

nothrow @nogc
void drawImage_load()
{
    // VBO
    glGenBuffers( 1, &VBO ); checkGlError( "glGenBuffers" );
    glBindBuffer( GL_ARRAY_BUFFER, VBO ); checkGlError( "glBindBuffer" );
    glBufferData( GL_ARRAY_BUFFER, vertices.sizeof, vertices.ptr, GL_STATIC_DRAW ); checkGlError( "glBufferData" );

    // VAO
    glGenVertexArrays( 1, &VAO ); checkGlError( "glGenVertexArrays" );
    glBindVertexArray( VAO ); checkGlError( "glBindVertexArray" );

    // position attribute
    glVertexAttribPointer( 0, 3, GL_FLOAT, GL_FALSE, 8 * GLfloat.sizeof, cast(void*)0 ); checkGlError( "glVertexAttribPointer" );
    glEnableVertexAttribArray( 0 ); checkGlError( "glEnableVertexAttribArray" );
    // color attribute position attribute
    glVertexAttribPointer( 1, 3, GL_FLOAT, GL_FALSE, 8 * GLfloat.sizeof, cast(void*)(3 * GLfloat.sizeof) ); checkGlError( "glVertexAttribPointer" );
    glEnableVertexAttribArray( 1 ); checkGlError( "glEnableVertexAttribArray" );
    // texture coord attribute
    glVertexAttribPointer( 2, 2, GL_FLOAT, GL_FALSE, 8 * GLfloat.sizeof, cast(void*)(6 * GLfloat.sizeof) ); checkGlError( "glVertexAttribPointer" );
    glEnableVertexAttribArray( 2 ); checkGlError( "glEnableVertexAttribArray" );

    // load and create a texture 
    loadTexture2D( "texture.jpg", &texture );

    // tell opengl for each sampler to which texture unit it belongs to (only has to be done once)
    // -------------------------------------------------------------------------------------------
    glUseProgram( imageShader ); checkGlError( "glUseProgram" ); // don't forget to activate/use the shader before setting uniforms!
    // either set it manually like so:
    glUniform1i( glGetUniformLocation( imageShader, "ourTexture" ), 0 ); checkGlError( "glUniform1i" );
}


nothrow @nogc
void drawImage()
{
    // bind textures on corresponding texture units
    glActiveTexture( GL_TEXTURE0 ); checkGlError( "glActiveTexture" );
    glBindTexture( GL_TEXTURE_2D, texture ); checkGlError( "glBindTexture" );

    // render container
    glUseProgram( imageShader ); checkGlError( "glUseProgram" );
    glBindVertexArray( VAO ); checkGlError( "glBindVertexArray" );
    glDrawArrays( GL_TRIANGLE_FAN , /*first*/ 0, /*count*/ cast( int ) vertices.length ); checkGlError( "glDrawArrays" );
    glBindVertexArray( 0 ); // unbind
    glUseProgram( 0 );
}




// FreeImage
nothrow @nogc
bool loadTexture2D( string texture2DFileName, GLuint* textureID )
{
    auto fileName = cast( char* ) texture2DFileName.tempCString();

    FREE_IMAGE_FORMAT fif = FreeImage_GetFileType( fileName );

    if ( fif == FIF_UNKNOWN )
    {
        fif = FreeImage_GetFIFFromFilename( fileName );
    }
    
    if ( fif == FIF_UNKNOWN )
    {
        printf( "error: loading file: %s: fif is FIF_UNKNOWN\n", fileName );
        return false;
    }

    FIBITMAP *dib = null;

    if ( FreeImage_FIFSupportsReading( fif ) )
    {
        dib = FreeImage_Load( fif, fileName );
    }
    
    if ( dib is null )
    {
        printf( "error: loading file: %s: dib is NULL\n", fileName );
        return false;
    }

    int width  = FreeImage_GetWidth( dib ), oWidth = width;
    int height = FreeImage_GetHeight( dib ), oHeight = height;
    int pitch  = FreeImage_GetPitch( dib );
    int bpp    = FreeImage_GetBPP( dib );

    if ( width == 0 || height == 0 )
    {
        printf( "error: loading file: %s: Width or Height is 0\n", fileName );
        return false;
    }

    int gl_max_texture_size = 0;
    glGetIntegerv( GL_MAX_TEXTURE_SIZE, &gl_max_texture_size ); checkGlError( "glGetIntegerv" );

    if ( width  > gl_max_texture_size ) width  = gl_max_texture_size;
    if ( height > gl_max_texture_size ) height = gl_max_texture_size;

    //if ( !GLEW_ARB_texture_non_power_of_two )
    //{
        //width = 1 << cast( int )floor( ( log( cast( float )width) / log( 2.0f ) ) + 0.5f ); 
        //height = 1 << cast( int )floor( ( log( cast( float )height) / log( 2.0f ) ) + 0.5f );
    //}

    if ( width != oWidth || height != oHeight )
    {
        FIBITMAP *rdib = FreeImage_Rescale( dib, width, height, FILTER_BICUBIC );

        FreeImage_Unload( dib );

        dib = rdib;

        if ( dib is null )
        {
            printf( "error: loading file: %s: rdib is NULL\n", fileName );
            return false;
        }

        pitch = FreeImage_GetPitch( dib );
    }

    BYTE* data = FreeImage_GetBits( dib );

    if ( data is null )
    {
        printf( "error: loading file: %s: Data is NULL\n", fileName );
        return false;
    }

    GLenum format = 0;

    if ( bpp == 32) format = GL_BGRA;
    if ( bpp == 24) format = GL_BGR;

    if ( format == 0 )
    {
        FreeImage_Unload( dib );
        printf( "error: loading file: %s: Format is 0\n", fileName );
        return false;
    }

    glGenTextures( 1, textureID ); checkGlError( "glGenTextures" );
    glBindTexture( GL_TEXTURE_2D, *textureID ); checkGlError( "glBindTexture" );

    // set the texture wrapping/filtering options (on the currently bound texture object)
    //glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT ); checkGlError( "glTexParameteri" );
    //glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT ); checkGlError( "glTexParameteri" );
    //glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR ); checkGlError( "glTexParameteri" );
    //glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR ); checkGlError( "glTexParameteri" );

    glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, format, GL_UNSIGNED_BYTE, data ); checkGlError( "glTexImage2D" );
    glGenerateMipmap( GL_TEXTURE_2D ); checkGlError( "glGenerateMipmap" );

    FreeImage_Unload( dib );

    return true;
}

