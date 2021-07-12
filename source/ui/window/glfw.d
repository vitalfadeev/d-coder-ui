module ui.window.glfw;

version( GLFW ):
import glfw3.api;
import bindbc.opengl;
import core.stdc.stdio;
import ui.event : Event;


struct Window
{
    GLFWwindow* glfwWindow;
    alias glfwWindow this;


    nothrow @nogc
    int on( Event* event )
    {
        return 0;
    }    
}

