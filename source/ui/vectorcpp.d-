module ui.vectorcpp;

import std.container.array;


struct VectorCPP( T )
{
    Array!T arr;
    alias arr this;

    void push_back( ref T b )
    {
        arr ~= b;
    }

    auto size()
    {
        return arr.length;
    }


    bool empty()
    {
        return arr.empty;
    }
}


