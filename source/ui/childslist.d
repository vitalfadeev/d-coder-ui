module ui.childslist;

import ui.element : Element;


struct ChildsList
{
    Element* parentNode;
    Element* prevSibling;
    Element* nextSibling;
    Element* firstChild;
    Element* lastChild;

    ref ChildsList opAssign( Element*[] b ) return
    {
        return this;
    }

    int opApply( int delegate( Element* ) dg )
    {
        int result;

        if ( firstChild )
        for ( auto c = firstChild; c !is null; c = c.nextSibling )
        {
            result = dg( c );

            if ( result )
                break;
        }

        return result;
    }

    int opApply( int delegate( size_t i, Element* ) dg )
    {
        int    result;
        size_t i;

        if ( firstChild )
        for ( auto c = firstChild; c !is null; c = c.nextSibling, i += 1 )
        {
            result = dg( i, c );

            if ( result )
                break;
        }

        return result;
    }
}

struct Child
{
    Element* parentNode;
    Element* prevSibling;
    Element* nextSibling;
    Element* firstChild;
    Element* lastChild;

    ref Child opAssign( Element* b ) return
    {
        return this;
    }
}
