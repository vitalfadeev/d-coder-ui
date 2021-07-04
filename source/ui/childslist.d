module ui.childslist;

struct ChildsList
{
    Element* parentNode;
    Element* prevSibling;
    Element* nextSibling;
    Element* firstChild;
    Element* lastChild;

    void opAssign( Element*[] b )
    {
        //
    }
}

struct Child
{
    Element* parentNode;
    Element* prevSibling;
    Element* nextSibling;
    Element* firstChild;
    Element* lastChild;

    void opAssign( Element* b )
    {
        //
    }
}
