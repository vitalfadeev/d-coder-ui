module ui.screen.glfw;

import glfw3.api;


struct Screen
{
    static
    int width()
    {
        GLFWmonitor* monitor = glfwGetPrimaryMonitor();
        
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
        GLFWmonitor* monitor = glfwGetPrimaryMonitor();
        
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

