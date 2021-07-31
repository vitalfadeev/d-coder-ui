module ui.drawelement.gl3.text;

version ( GL3 ):
import deps.gl3;

version ( FreeType )
version ( HarfBuzz ):
import deps.harfbuzz;
import deps.freetype   : ft;

import core.stdc.stdio : printf;
import ui.stackarray   : StackArray;
import ui.color;
import gl;


nothrow @nogc
void drawText( string text )
{
    glViewport( 0, 0, 800, 600 ); checkGlError( "glViewport" );

    auto latinShaper   = HBShaper( "fonts/DejaVuSerif.ttf", 50 );
    //auto arabicShaper  = HBShaper( "fonts/amiri-regular.ttf", 50 );
    //auto russianShaper = HBShaper( "fonts/DejaVuSerif.ttf", 50 );
    //auto hanShaper     = HBShaper( "fonts/fireflysung.ttf", 50 );
    //auto hindiShaper   = HBShaper( "fonts/Sanskrit2003.ttf", 50 );

    HBText hbt1 = {
        "ficellé fffffi. VAV.",
        "fr",
        HB_SCRIPT_LATIN,
        HB_DIRECTION_LTR
    };

    //HBText hbt2 = {
    //    "تسجّل يتكلّم",
    //    "ar",
    //    HB_SCRIPT_ARABIC,
    //    HB_DIRECTION_RTL
    //};

    //HBText hbt3 = {
    //    "Дуо вёжи дёжжэнтиюнт ут",
    //    "ru",
    //    HB_SCRIPT_CYRILLIC,
    //    HB_DIRECTION_LTR
    //};

    //HBText hbt4 = {
    //    "緳 踥踕",
    //    "ch",
    //    HB_SCRIPT_HAN,
    //    HB_DIRECTION_TTB
    //};

    //HBText hbt5 = {
    //    "हालाँकि प्रचलित रूप पूजा",
    //    "hi",
    //    HB_SCRIPT_DEVANAGARI,
    //    HB_DIRECTION_LTR
    //};

    //
    //latinShaper.addFeature( ui.hbfeature.KerningOn );

    //
    StackArray!(MyMesh, 30) meshes;

    // ask for some meshes, this is not optimal since every glyph has its
    // own texture, should use an atlas than contains glyph inside
    //       ->>>>>>> e.g. DON'T DO THIS <<<<<<<<<-
    latinShaper.drawText( &hbt1, 0, 0, &meshes );
    //arabicShaper.drawText( &hbt2, 20, 220, &meshes );
    //russianShaper.drawText( &hbt3, 20, 120, &meshes );
    //hanShaper.drawText( &hbt4, 700, 380, &meshes );
    //hindiShaper.drawText( &hbt5, 20, 20, &meshes );

    gl.render( &meshes );
}


