module ui.nodelist;

import std.container : DList;
import ui.element    : Node;


/** */
class NodeList
{
    this()
    {
        this.lst = DList!( Node* )();
    }

    /** The number of nodes in the NodeList. */
    size_t length()
    {
        import std.range : walkLength;

        return lst[].walkLength;
    }

    /** Returns an item in the list by its index, or null if the index is out-of-bounds. */
    Node* item( size_t index )
    {
        import std.algorithm.searching : countUntil;
        import std.range : drop, empty, front;

        auto r = 
            lst[]
                .drop( index );

        if ( !r.empty )
            return r.front;
        else
            return null;
    }

    /** Returns an iterator, allowing code to go through all key/value pairs contained in the collection. (In this case, the keys are numbers starting from 0 and the values are nodes.) */
    //NodeIterator entries()
    //{
    //    return new NodeIterator( lst );
    //}

    /** Executes a provided function once per NodeList element, passing the element as an argument to the function. */
    void forEach( NodeForEachCallback1 callback, void* This=null )
    {
        foreach ( node; lst )
            callback( node );
    }

    void forEach( NodeForEachCallback2 callback, void* This=null )
    {
        import std.range : enumerate;

        foreach ( i, node; lst[].enumerate )
            callback( node, i );
    }

    void forEach( NodeForEachCallback3 callback, void* This=null )
    {
        import std.range : enumerate;

        foreach ( i, node; lst[].enumerate )
            callback( node, i, cast( DList!( Node* )* ) cast( void* ) this );
    }

    /** Returns an iterator, allowing code to go through all the keys of the key/value pairs contained in the collection. (In this case, the keys are numbers starting from 0.) */
    //KeysIterator keys()
    //{
    //    return new KeysIterator( _firstChild );
    //}

    /** Returns an iterator allowing code to go through all values (nodes) of the key/value pairs contained in the collection. */
    //ValuesIterator values()
    //{
    //    return new ValuesIterator( _firstChild );
    //}

    // foreach suppport
    //int opApply( int delegate( Node* currentValue ) dg ) const
    //{
    //    return lst.opApply( dg );
    //}

    //int opApply( int delegate( Node* currentValue, ref size_t currentIndex ) dg ) const
    //{
    //    return lst.opApply( dg );
    //}

    //int opApply( int delegate( Node* currentValue, ref size_t currentIndex, ref NodeList nodeList ) dg ) const
    //{
    //    return lst.opApply( dg );
    //}

    // Range support
    //bool empty()
    //{
    //    return lst.empty;
    //}

    //Node* front()
    //{
    //    return lst.front;
    //}

    //Node* back()
    //{
    //    return lst.back;
    //}

    //bool popFront()
    //{
    //    lst.popoBack();
    //}

    void insertBack( Node* node )
    {
        lst.insertBack( node );
    }

    NodeList opOpAssign( string op, Stuff )( Stuff rhs )
        if ( op == "~" && is(typeof(insertBack(rhs))) )
    {
        lst ~= rhs;
        return this;
    }


protected:
    DList!( Node* ) lst;
}


/** */
alias NodeForEachCallback1 = void delegate( Node* node );
alias NodeForEachCallback2 = void delegate( Node* node, size_t i );
alias NodeForEachCallback3 = void delegate( Node* node, size_t i, DList!( Node* )* lst );

