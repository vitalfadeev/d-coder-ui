module ui.parse.css.display;

// https://developer.mozilla.org/en-US/docs/Web/CSS/display
// grid: https://developer.mozilla.org/ru/docs/Web/CSS/CSS_Grid_Layout
// flex: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout
// flow: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flow_Layout
//
// [ <display-outside> || <display-inside> ]", "<display-listitem>", "<display-internal>", "<display-box>", "<display-legacy>
//
// <display-outside> = block | inline | run-in
// <display-inside> = flow | flow-root | table | flex | grid | ruby
// <display-listitem> = <display-outside>? && [ flow | flow-root ]? && list-item
// <display-internal> = table-row-group | table-header-group | table-footer-group | table-row | table-cell | table-column-group | table-column | table-caption | ruby-base | ruby-text | ruby-base-container | ruby-text-container
// <display-box> = contents | none
// <display-legacy> = inline-block | inline-list-item | inline-table | inline-flex | inline-grid
//
//
// /* legacy values */
// display: block;
// display: inline;
// display: inline-block;
// display: flex;
// display: inline-flex;
// display: grid;
// display: inline-grid;
// display: flow-root;
// 
// /* box generation */
// display: none;
// display: contents;
// 
// /* two-value syntax */
// display: block flow;
// display: inline flow;
// display: inline flow-root;
// display: block flex;
// display: inline flex;
// display: block grid;
// display: inline grid;
// display: block flow-root;
// 
// /* other values */
// display: table;
// display: table-row; /* all table elements have an equivalent CSS display value */
// display: list-item;
//
// * Global values */
// display: inherit;
// display: initial;
// display: unset;


import std.stdio : writeln;
import ui.parse.t.tokenize : Tok;
import std.range : chain;


bool parse_display( Tok[] tokenized, ref string[] setters )
{
    const string[] display_outside = 
    [
        "block", 
        "inline",
        "run-in"
    ];

    const string[] display_inside = 
    [
        "flow", 
        "flow-root", 
        "table", 
        "flex", 
        "grid", 
        "ruby"
    ];

    const string[] display_listitem = 
    [
        "list-item", 
    ];

    const string[] display_box = 
    [
        "contents",
        "none"
    ];

    const string[] display_internal = 
    [
        "table-row-group", 
        "table-header-group", 
        "table-footer-group", 
        "table-row", 
        "table-cell", 
        "table-column-group", 
        "table-column", 
        "table-caption", 
        "ruby-base", 
        "ruby-text", 
        "ruby-base-container", 
        "ruby-text-container"
    ];

    const string[] display_legacy = 
    [
        "inline-block",
        "inline-list-item",
        "inline-table",
        "inline-flex",
        "inline-grid"
    ];

    auto args = tokenized[ 2 .. $ ]; // skip ["display", ":"]

    // display: args...
    if ( !args.empty )
    {
        if ( args.length == 1 )
        {        
            auto word = args[0].s;

            static
            foreach ( ARG; display_outside )
            {
                if ( word == ARG )
                {
                    setters ~= format!"outerDisplay = Display.%s;"( ARG );
                    //setters ~= format!"innerDisplay = Display.flow;"();
                    return true;
                }
            }

            static
            foreach ( ARG; display_inside )
            {
                if ( word == ARG )
                {
                    //setters ~= format!"outerDisplay = Display.block;"();
                    setters ~= format!"innerDisplay = Display.%s;"( ARG );
                    return true;
                }
            }

            static
            foreach ( ARG; display_listitem )
            {
                if ( word == ARG )
                {
                    setters ~= format!"outerDisplay = Display.block;"();
                    setters ~= format!"innerDisplay = Display.%s;"( ARG );
                    return true;
                }
            }

            static
            foreach ( ARG; display_internal )
            {
                if ( word == ARG )
                {
                    setters ~= format!"outerDisplay = Display.%s;"( ARG );
                    //setters ~= format!"innerDisplay = Display.%s;"( ARG );
                    return true;
                }
            }

            static
            foreach ( ARG; display_box )
            {
                if ( word == ARG )
                {
                    setters ~= format!"outerDisplay = Display.%s;"( ARG );
                    //setters ~= format!"innerDisplay = Display.%s;"( ARG );
                    return true;
                }
            }

            static
            foreach ( ARG; display_legacy )
            {
                static
                if ( ARG == "inline-block" )
                {
                    if ( word == ARG )
                    {
                        setters ~= format!"outerDisplay = Display.inline;"();
                        setters ~= format!"innerDisplay = Display.flow_root;"();
                        return true;
                    }
                }
                else
                {
                    if ( word == ARG )
                    {
                        setters ~= format!"outerDisplay = Display.inline;"();
                        setters ~= format!"innerDisplay = Display.%s;"( ARG );
                        return true;
                    }
                }
            }
            else

            // inherit
            if ( word == "inherit" )
            {
                setters ~= format!"innerDisplay = inherit!\"innerDisplay\"( this );"();
                return true;
            }
            else

            // initial
            if ( word == "initial" )
            {
                setters ~= format!"innerDisplay = initial!\"innerDisplay\"( this );"();
                return true;
            }
            else

            // unset
            if ( word == "unset" )
            {
                setters ~= format!"innerDisplay = unset!\"innerDisplay\"( this );"();
                return true;
            }
            else

            // miss
            {
                //
            }
        }
        else

        // outside inside
        if ( args.length == 2 )
        {        
            auto wor1 = args[0].s;

            static
            foreach ( ARG; display_outside )
            {
                if ( word == ARG )
                {
                    setters ~= format!"outerDisplay = Display.%s;"( ARG );
                }
            }
                else
                {
                    // FAIL
                }

            auto wor2 = args[1].s;
            static
            foreach ( ARG; display_inside )
            {
                if ( word == ARG )
                {
                    setters ~= format!"innerDisplay = Display.%s;"( ARG );
                    return true;
                }
            }
                else
                {
                    // FAIL
                }
        }
        else

        // display: <empty>
        {
            Log.error( "no args for display: " ~ tokenized.to!string );
        }
    }

    return false;
}

