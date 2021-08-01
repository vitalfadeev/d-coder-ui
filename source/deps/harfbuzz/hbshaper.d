module deps.harfbuzz.hbshaper;

version ( HarfBuzz ):
import bindbc.hb;
import bindbc.hb.bind.ft;
import deps.freetype    : ft;
import deps.freetype    : Glyph;
import deps.freetype;
import core.stdc.string : memcpy;
import std.math         : ceil;
import std.math         : floor;
import std.math         : log;
import std.math         : pow;
import core.stdc.stdlib : alloca;
import core.stdc.stdlib : malloc;
import core.stdc.stdio  : printf;
import bc.string.string : tempCString;
import ui.stackarray    : StackArray;
import gl;
import gl               : MyMesh;


FontCache fontCache;


alias FeaturesArray = StackArray!( hb_feature_t, 6 );

struct HBShaper 
{
    FT_Face       face;
    hb_font_t*    font;
    hb_buffer_t*  buffer;
    FeaturesArray features;
    string        fontFile;
    int           fontSize;

    @disable this();

    nothrow @nogc
    this( string fontFile, int fontSize ) 
    {
        this.fontFile = fontFile;
        this.fontSize = fontSize;
        int deviceHDPI = 96; // defauls: Linux: 96, Windows:96, MacL: 72
        loadFace( fontFile, fontSize * 64, deviceHDPI, deviceHDPI, &face );

        font   = hb_ft_font_create( face, null );
        buffer = hb_buffer_create();

        hb_buffer_allocation_successful( buffer );
    }


    nothrow @nogc
    void addFeature( hb_feature_t feature ) 
    {
        features ~= feature;
    }

    nothrow @nogc
    void drawText( HBText* text, float x, float y, StackArray!(MyMesh, 30)* meshes ) 
    {
        uint windowWidth = 800;
        uint windowHeight = 600;
        uint viewportWidth = 800;
        uint windowedViewportCenterX = 400;
        uint viewportHeight = 600;
        uint windowedViewportCenterY = 300;

        float windowedX = x;
        float windowedY = y;

        hb_buffer_reset( buffer );

        hb_buffer_set_direction( buffer, text.direction );
        hb_buffer_set_script( buffer, text.script );
        hb_buffer_set_language( buffer, hb_language_from_string( text.language.tempCString(), cast( int ) text.language.length ) );

        hb_buffer_add_utf8( buffer, text.data.ptr, cast( int ) text.data.length, 0, cast( int ) text.data.length );

        // harfbuzz shaping
        hb_shape( font, buffer, features.empty ? null : features.arr.ptr, cast( uint ) features.length );

        //
        uint glyphCount;
        hb_glyph_info_t*     glyphInfo = hb_buffer_get_glyph_infos( buffer, &glyphCount );
        hb_glyph_position_t* glyphPos  = hb_buffer_get_glyph_positions( buffer, &glyphCount );

        //
        Glyph* glyphPtr;
        ubyte* tdata;

        for ( int i = 0; i < glyphCount; ++i )
        {
            // look in cache
            auto glyphIndex  = glyphInfo[i].codepoint;
            auto cachedGlyph = fontCache.get( fontFile, fontSize, glyphIndex );

            if ( cachedGlyph !is null )
            {
                // from cache
                glyphPtr = cachedGlyph;
            }
            else
            {
                // no in cache. put
                glyphPtr = fontCache.createRec( fontFile, fontSize, glyphIndex );
                deps.freetype.rasterize( face, glyphIndex, glyphPtr );

                // 2^N aligned
                glyphPtr.twidth  = cast( int ) ( pow( 2, ceil( log( glyphPtr.width  ) / log( 2 ) ) ) );
                glyphPtr.theight = cast( int ) ( pow( 2, ceil( log( glyphPtr.height ) / log( 2 ) ) ) );

                // buffer for transfer to texture. alligned to 2^N
                tdata = cast( ubyte* ) alloca( glyphPtr.twidth * glyphPtr.theight );

                for ( int iy = glyphPtr.height; iy >= 0; iy-- ) 
                {
                    memcpy( tdata + iy * glyphPtr.twidth, glyphPtr.buffer + iy * glyphPtr.width, glyphPtr.width );
                }

                //
                glyphPtr.buffer = tdata;
            }

            //
            float s0 = 0.0;
            float t0 = 0.0;
            float s1 = cast( float ) glyphPtr.width  / glyphPtr.twidth;  // -1.0 .. 1.0
            float t1 = cast( float ) glyphPtr.height / glyphPtr.theight; // -1.0 .. 1.0
            float xa = cast( float ) glyphPos[i].x_advance / 64;
            float ya = cast( float ) glyphPos[i].y_advance / 64;
            float xo = cast( float ) glyphPos[i].x_offset / 64;
            float yo = cast( float ) glyphPos[i].y_offset / 64;
            float x0 = windowedX + xo + glyphPtr.bearing_x;
            float y0 = floor( windowedY + yo + glyphPtr.bearing_y );
            float x1 = x0 + glyphPtr.width;
            float y1 = floor( y0 - glyphPtr.height );

            // flip Y axe
            auto tmpY = y0;
            y0 = fontSize + y1;
            y1 = fontSize - tmpY;
            auto tmpT = t0;
            t0 = t1;
            t1 = tmpT;

            // convert to GL device coords: -1.0 .. 1.0
            pragma( inline, true )
            auto deviceX( float windowedX )
            {
                return ( cast( float ) windowedX - windowedViewportCenterX ) / viewportWidth * 2;
            }

            pragma( inline, true )
            auto deviceY( float windowedY )
            {
                return ( cast( float ) windowHeight - windowedY - windowedViewportCenterY ) / viewportHeight * 2;
            }

            // to device coord: -1.0 .. 1.0
            x0 = deviceX( x0 );
            y0 = deviceY( y0 );
            x1 = deviceX( x1 );
            y1 = deviceY( y1 );

            //
            auto m = meshes.createOne();

            m.vertices = 
            [
                // positions    // colors           // texture coords
                x0, y0, 0.0f,   1.0f, 0.0f, 0.0f,   s0, t0,   // top left 
                x1, y0, 0.0f,   0.0f, 1.0f, 0.0f,   s1, t0,   // top right
                x1, y1, 0.0f,   0.0f, 0.0f, 1.0f,   s1, t1,   // bottom right
                x0, y1, 0.0f,   1.0f, 1.0f, 0.0f,   s0, t1    // bottom left
            ];

            // don't do this!! use atlas texture instead
            gl.uploadTexture( glyphPtr.twidth, glyphPtr.theight, tdata, &m.textureId );

            //printf( "tex: %d\n", m.textureId );
            //printf( "x0, y0: %f, %f\n", x0, y0 );
            //printf( "x1, y1: %f, %f\n", x1, y1 );
            //printf( "s0, t0: %f, %f\n", s0, t0 );
            //printf( "s1, t1: %f, %f\n", s1, t1 );
            //printf( "twidth x theight: %d, %d\n", twidth, theight );

            windowedX += xa;
            windowedY += ya;
        }
    }


    nothrow @nogc
    ~this() 
    {
        deps.freetype.freeFace( face );

        hb_buffer_destroy( buffer );
        hb_font_destroy( font );
    }
};


struct HBText
{
    string         data;
    string         language;
    hb_script_t    script;
    hb_direction_t direction;
}


struct FontCache
{
    ByFontNameCacheRec* byFontName;

    nothrow @nogc:
    Glyph* get( string fontName, uint fontSize, uint glyphIndex )
    {
        if ( byFontName is null )
        {
            // empty cache. add new record
        }
        else
        {
            auto byFontNameCacheRec = getByFontName( fontName, byFontName );
            if ( byFontNameCacheRec !is null )
            {
                auto byFontSizeCacheRec = getByFontSize( fontSize, byFontNameCacheRec.byFontSize );
                if ( byFontSizeCacheRec !is null )
                {
                    auto byGlyphIndexCacheRec = getByGlyphIndex( fontSize, byFontSizeCacheRec.byGlyphIndex );
                    if ( byGlyphIndexCacheRec !is null )
                    {
                        return &byGlyphIndexCacheRec.glyph;
                    }
                }
            }
        }

        return null;
    }


    Glyph* createRec( string fontName, uint fontSize, uint glyphIndex )
    {
        return cast( Glyph* ) malloc( Glyph.sizeof );
    }


    auto getByFontName( string fontName, ByFontNameCacheRec* first )
    {
        for ( auto cur = first; cur !is null; cur = cur.next )
        {
            if ( cur.fontName == fontName )
            {
                return cur;
            }
        }

        return null;
    }


    auto getByFontSize( uint fontSize, ByFontSizeCacheRec* first )
    {
        for ( auto cur = first; cur !is null; cur = cur.next )
        {
            if ( cur.fontSize == fontSize )
            {
                return cur;
            }
        }

        return null;
    }


    auto getByGlyphIndex( uint glyphIndex, ByGlyphIndexCacheRec* first )
    {
        for ( auto cur = first; cur !is null; cur = cur.next )
        {
            if ( cur.glyphIndex == glyphIndex )
            {
                return cur;
            }
        }

        return null;
    }

    struct ByFontNameCacheRec
    {
        string              fontName;
        ByFontSizeCacheRec* byFontSize;
        ByFontNameCacheRec* next;
    }

    struct ByFontSizeCacheRec
    {
        uint                  fontSize;
        ByGlyphIndexCacheRec* byGlyphIndex;
        ByFontSizeCacheRec*   next;
    }

    struct ByGlyphIndexCacheRec
    {
        uint                  glyphIndex;
        ByGlyphIndexCacheRec* next;
        Glyph                 glyph;
    }
}

