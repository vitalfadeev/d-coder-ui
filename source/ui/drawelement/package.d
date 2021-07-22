module ui.drawelement;

version ( GL3 )
  public import ui.drawelement.gl3;
version ( GDI )
  public import ui.drawelement.gdi;
