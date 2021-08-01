module ui.shaders.linear;

version( GL3 ):
import deps.gl3;
import ui.shaders.shader : Shader;


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
