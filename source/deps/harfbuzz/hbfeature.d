module deps.harfbuzz.hbfeature;

version ( HarfBuzz ):
import bindbc.freetype;
public import bindbc.hb;
public import bindbc.hb.bind.ft;


struct hbfeature
{
    const hb_tag_t KernTag = HB_TAG( 'k', 'e', 'r', 'n' ); // kerning operations
    const hb_tag_t LigaTag = HB_TAG( 'l', 'i', 'g', 'a' ); // standard ligature substitution
    const hb_tag_t CligTag = HB_TAG( 'c', 'l', 'i', 'g' ); // contextual ligature substitution

    static hb_feature_t LigatureOff = { LigaTag, 0, 0, uint.max };
    static hb_feature_t LigatureOn  = { LigaTag, 1, 0, uint.max };
    static hb_feature_t KerningOff  = { KernTag, 0, 0, uint.max };
    static hb_feature_t KerningOn   = { KernTag, 1, 0, uint.max };
    static hb_feature_t CligOff     = { CligTag, 0, 0, uint.max };
    static hb_feature_t CligOn      = { CligTag, 1, 0, uint.max };
}
