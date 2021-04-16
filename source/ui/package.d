module ui;

// Standart
public import std.stdio  : writeln;
public import std.conv   : to;
public import std.format : format;
public import std.math   : abs;
public import std.math   : round;
public import std.math   : floor;

// Base types
alias int POWER;
alias int POS;

// Helpers
public import ui.utf     : toLPWSTR;
public import ui.meta    : instanceof;
public import ui.tools   : min;
public import ui.tools   : max;
public import ui.tools   : GET_X_LPARAM;
public import ui.tools   : GET_Y_LPARAM;
public import ui.color   : rgb;

// Vid
//public import ui.vidpipe : touch;

// Structs
public import ui.rect    : Rect;
public import ui.size    : Size;
public import ui.color   : Color;
public import ui.text    : TextSet;
public import ui.point   : Point;
public import ui.font    : Font;
public import ui.base    : Pen;
public import ui.base    : PenType;

// Class
public import ui.classregistry  : Class;
public import ui.classregistry  : classRegistry;

// Events
public import ui.event   : MouseKeyEvent;
public import ui.event   : MouseMoveEvent;
public import ui.event   : MouseWheelEvent;
public import ui.event   : KeyboardKeyEvent;
public import ui.keycodes;

// Base classes
public import ui.element : Element;
public import ui.drawer  : IDrawer;

// Thread locals

