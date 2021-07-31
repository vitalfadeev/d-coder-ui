module deps.freetype.funcs;

version ( FreeType ):
public import bindbc.freetype;
import bc.string.string : tempCString;
import core.stdc.stdio  : printf;
import deps.freetype    : ft;


struct Glyph
{
    ubyte* buffer;
    uint   width;
    uint   height;
    float  bearing_x;
    float  bearing_y;
}


nothrow @nogc:

void loadFace( string fontName, int ptSize, int deviceHDPI, int deviceVDPI, FT_Face* face )
{
    FT_Error error = FT_New_Face( ft, fontName.tempCString(), 0, face );
    assert( error == 0, "Cannot open font file" );

    force_ucs2_charmap( *face );

    FT_Set_Char_Size( *face, 0, ptSize, deviceHDPI, deviceVDPI );
}


void freeFace( FT_Face face ) 
{
    FT_Done_Face( face );
}

//nothrow @nogc
//void freeGlyph( Glyph glyph ) 
//{
//    //delete glyph;
//}

int force_ucs2_charmap( FT_Face face ) 
{
    for ( int i = 0; i < face.num_charmaps; i++ ) 
    {
        if ((  (face.charmaps[i].platform_id == 0)
            && (face.charmaps[i].encoding_id == 3))
           || ((face.charmaps[i].platform_id == 3)
            && (face.charmaps[i].encoding_id == 1))) 
        {
                return FT_Set_Charmap( face, face.charmaps[i] );
        }
    }
    return -1;
}


void rasterize( FT_Face face, uint glyphIndex, Glyph* glyph )
{
    FT_Error error;

    // Load Glyph
    FT_Int32 flags =  FT_LOAD_DEFAULT;

    error = 
        FT_Load_Glyph( 
            face,
            glyphIndex, // the glyph_index in the font file
            flags
        );
    if ( error )
    {
        printf( "error: FreeType: FT_Load_Glyph()\n" );
        return; // skip glyph
    }

    // Render Glyph
    FT_GlyphSlot slot = face.glyph;

    error = 
        FT_Render_Glyph( 
            slot, 
            FT_RENDER_MODE_NORMAL 
        );
    if ( error )
    {
        printf( "error: FreeType: FT_Render_Glyph()\n" );
        return; // skip glyph
    }

    // Save Glyph into memory
    with ( slot )
    {
        glyph.bearing_x = bitmap_left;
        glyph.bearing_y = bitmap_top;
    }
    with ( slot.bitmap )
    {
        glyph.buffer    = cast( ubyte* ) buffer;
        glyph.width     = width;
        glyph.height    = rows;
    }
}
