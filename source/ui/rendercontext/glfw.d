module ui.rendercontext.glfw;

version ( GLFW ):
import ui.color  : Color;
import ui.base   : POS;
import ui.path2d : Path2D;
import ui.rect   : Rect;

/** */
// RenderContext
// Windows GDI
struct CanvasRenderingContext2D
{
    /**
     color:    A DOMString parsed as CSS <color> value.
     gradient: A CanvasGradient object (a linear or radial gradient).
     pattern:  A CanvasPattern object (a repeating image).     

     var ctx = canvas.getContext('2d');
     ctx.strokeStyle = 'green';
     ctx.strokeRect(10, 10, 100, 100);
     */
    void strokeStyle( Color color )
    {
        //
    }
    void strokeStyle( string color )
    {
        //
    }
    //void strokeStyle( string gradient )
    //{
    //    //
    //}
    //void strokeStyle( string pattern )
    //{
    //    //
    //}

    /**
     x:      The x-axis coordinate of the rectangle's starting point.
     y:      The y-axis coordinate of the rectangle's starting point.
     width:  The rectangle's width. Positive values are to the right, and negative to the left.
     height: The rectangle's height. Positive values are down, and negative are up.

     const ctx = canvas.getContext('2d');
     ctx.strokeStyle = 'green';
     ctx.strokeRect(20, 10, 160, 100);
     */
    void strokeRect( POS x, POS y, POS width, POS height )
    {
        //
    }

    /** 
     text:       A DOMString specifying the text string to render into the context. The text is rendered using the settings specified by font, textAlign, textBaseline, and direction.
     x:          The x-axis coordinate of the point at which to begin drawing the text, in pixels.
     y:          The y-axis coordinate of the baseline on which to begin drawing the text, in pixels.
     [maxWidth]: The maximum number of pixels wide the text may be once rendered. If not specified, there is no limit to the width of the text. However, if this value is provided, the user agent will adjust the kerning, select a more horizontally condensed font (if one is available or can be generated without loss of quality), or scale down to a smaller font size in order to fit the text in the specified width.
    */
    void fillText( string text, POS x, POS y )
    {
        // Clipping 
        // by clip()
        // by CSS "text-overflow: clip":
        // - clip
        // - ellipsis
        // - "-"
        // - ""
        // and CSS "overflow: hidden"
        // - visible
        // - hidden
        // - scroll
        // - auto
        // and CSS "white-space: nowrap"
        // - normal
        // - nowrap
        // - pre
        // - pre-wrap
        // - pre-line
        // - pre-wrap
        // - break-spaces

        import ui.utf : toLPWSTR;

        auto options = ETO_CLIPPED;

        ExtTextOutW(
            _hdc,
            x,
            y,
            options,
            &clipRect.windowsRECT,
            text.toLPWSTR,
            text.length,
            NULL
        );
    }

    void fillText( string text, POS x, POS y, int maxWidth )
    {
        //
    }

    /** */
    void clip()
    {
        //
    }

    void clip( FillRule fillRule )
    {
        //
    }

    void clip( Path2D path )
    {
        _clipPath = path;
    }

    void clip( Path2D path, FillRule fillRule )
    {
        //
    }

private:
    Path2D _clipPath;

    Rect clipRect()
    {
        Rect rect;

        POS minx;
        POS miny;
        POS maxx;
        POS maxy;

        foreach ( p; _clipPath )
        {
            if ( minx > p.x )
                minx = p.x;
            if ( miny > p.y )
                miny = p.y;
            if ( maxx > p.x )
                maxx = p.x;
            if ( maxy > p.y )
                maxy = p.y;
        }

        rect = Rect( minx, miny, maxx, maxy );

        return rect;
    }
}

alias RenderContext = CanvasRenderingContext2D;

enum FillRule
{
    nonzero,
    evenodd
}

