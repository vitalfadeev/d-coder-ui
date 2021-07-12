module ui.app.gdi;

version (window):
struct App
{
    OSWindow window;
    bool     doLoop = true;

    /** */ 
    void init_()
    {
        //
    }


    /** */ 
    void UI()
    {
        import generated   : initUI;

        auto document = new Document;

        initUI( document );

        window = new OSWindow( document );
    }


    /** */
    void eventLoop()
    {
        import core.sys.windows.windows;

        MSG msg;

       while ( doLoop && GetMessage( &msg, NULL, 0, 0 ) )
       {
           //TranslateMessage( &msg );
           DispatchMessage( &msg );
       }
    }    
}
