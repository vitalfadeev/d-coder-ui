module ui.walkindeep;

import ui.element : Node;
import ui.element : Element;


void walkInDeep( Element* root, void function( Element* ) callback )
{
    // documnent
    //   body
    //     e1
    //     e2
    //     e3
    //       e4
    //     e5
    // body, e1, e2, e3, e4, e5
    
    foreach ( node; root.children )
    {
        callback( node );

        // recursove
        walkInDeep( node, callback );
    }
}

// walkInDeep( &document.body, (node) => { writeln( node ); } );
