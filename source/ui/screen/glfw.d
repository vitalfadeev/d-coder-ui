module ui.screen.glfw;

import glfw3.api;


struct Screen
{
    static
    int width()
    {
        GLFWmonitor* primary = glfwGetPrimaryMonitor();
        
        int _xpos;
        int _ypos;
        int _width;
        int _height;

        glfwGetMonitorWorkarea(
            monitor,
            &_xpos,
            &_ypos,
            &_width,
            &_height 
        );

        return _width;
    }


    static
    int height()
    {
        GLFWmonitor* primary = glfwGetPrimaryMonitor();
        
        int _xpos;
        int _ypos;
        int _width;
        int _height;

        glfwGetMonitorWorkarea(
            monitor,
            &_xpos,
            &_ypos,
            &_width,
            &_height 
        );

        return _height;
    }
}

