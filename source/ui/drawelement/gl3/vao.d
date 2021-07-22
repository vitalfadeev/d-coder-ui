module ui.drawelement.gl3.vao;

version ( GL3 ):
import bindbc.opengl.bind.types;
import bindbc.opengl;
import ui.drawelement.gl3.vertex : Vertex;


/** */
struct VAO
{
    GLuint vao;
    alias vao this;

    GLuint vbo;

    nothrow @nogc
    this( T )( T vertices )
    {
	// Upload data to GPU
	//GLuint vbo;
	glGenBuffers( 1, &vbo );
	glBindBuffer( GL_ARRAY_BUFFER, vbo );
	glBufferData( GL_ARRAY_BUFFER, vertices.sizeof, vertices.ptr, /*usage hint*/ GL_STATIC_DRAW );

	// Describe layout of data for the shader program
	//GLuint vao;
	glGenVertexArrays( 1, &vao );
	glBindVertexArray( vao );

	glEnableVertexAttribArray( 0 );
	glVertexAttribPointer(
	    /*location*/ 0, /*num elements*/ 2, /*base type*/ GL_FLOAT, /*normalized*/ GL_FALSE,
	    Vertex.sizeof, cast(void*) Vertex.position.offsetof
	);
	glEnableVertexAttribArray( 1 );
	glVertexAttribPointer(
	    /*location*/ 1, /*num elements*/ 3, /*base type*/ GL_FLOAT, /*normalized*/ GL_FALSE,
	    Vertex.sizeof, cast(void*) Vertex.color.offsetof
	);
    }

    nothrow @nogc
    ~this()
    {
        glDisableVertexAttribArray(1);
        glDisableVertexAttribArray(0);
        glDeleteBuffers( 1, &vbo );
        glDeleteVertexArrays( 1, &vao );
    }
}
