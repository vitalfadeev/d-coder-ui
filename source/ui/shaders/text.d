module ui.shaders.text;

version( GL3 ):
import deps.gl3;
import ui.shaders.shader : Shader;


Shader!( vertexTextShaderSrc, fragmentTextShaderSrc ) textShader;

 
nothrow @nogc
void loadTextShader()
{
    textShader.load();
}


immutable string vertexTextShaderSrc = "#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;
layout (location = 2) in vec2 aTexCoord;

out vec3 ourColor;
out vec2 TexCoord;

void main()
{
    gl_Position = vec4(aPos, 1.0);
    ourColor = aColor;
    TexCoord = vec2(aTexCoord.x, aTexCoord.y);
}
";


immutable dstring fragmentTextShaderSrc = "#version 330 core
out vec4 FragColor;
  
in vec3 ourColor;
in vec2 TexCoord;

uniform sampler2D ourTexture;

void main()
{
    //FragColor = texture(ourTexture, TexCoord) * vec4(ourColor, 1.0);  
    FragColor = texture(ourTexture, TexCoord);  
}
";
