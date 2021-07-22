module ui.drawelement.gl3.text;

version ( GL3 ):
import bindbc.opengl.bind.types;
import bindbc.opengl;
import ui.color;
import dlib;


nothrow @nogc
void drawText( string text )
{
    //
}


/** */
struct Character 
{
    uint textureID;  // ID handle of the glyph texture
    vec2 size;       // Size of glyph
    vec2 bearing;    // Offset from baseline to left/top of glyph
    uint advance;    // Offset to advance to next glyph
};

alias Characters = Character[ char ];


/*
nothrow @nogc
void renderText( Shader s, string text, float x, float y, float scale, vec3 color )
{
    // activate corresponding render state  
    s.Use();
    glUniform3f( glGetUniformLocation(s.Program, "textColor"), color.x, color.y, color.z );
    glActiveTexture( GL_TEXTURE0 );
    glBindVertexArray( VAO );

    // iterate through all characters
    foreach ( c; text )
    {
        Character ch = Characters[*c];

        float xpos = x + ch.bearing.x * scale;
        float ypos = y - (ch.size.y - ch.bearing.y) * scale;

        float w = ch.size.x * scale;
        float h = ch.size.y * scale;
        // update VBO for each character
        float[6][4] vertices = 
        [
            [ xpos,     ypos + h,   0.0f, 0.0f ],            
            [ xpos,     ypos,       0.0f, 1.0f ],
            [ xpos + w, ypos,       1.0f, 1.0f ],

            [ xpos,     ypos + h,   0.0f, 0.0f ],
            [ xpos + w, ypos,       1.0f, 1.0f ],
            [ xpos + w, ypos + h,   1.0f, 0.0f ]           
        ];
        // render glyph texture over quad
        glBindTexture(GL_TEXTURE_2D, ch.textureID);
        // update content of VBO memory
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertices), vertices); 
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        // render quad
        glDrawArrays(GL_TRIANGLES, 0, 6);
        // now advance cursors for next glyph (note that advance is number of 1/64 pixels)
        x += (ch.advance >> 6) * scale; // bitshift by 6 to get value in pixels (2^6 = 64)
    }
    glBindVertexArray(0);
    glBindTexture(GL_TEXTURE_2D, 0);
}
*/
