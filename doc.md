# Document
1. Document contains elements. Elements grouped to tree
2. Document contains field 'body'. 'body' is root of tree.
3. Application has global static var 'document'

# t-file
1. .t file is UI markup
2. .t file containts tree of elements
3. 'body' is keyword for root of tree
4. .t file containts element classes
5. Word from begin of the line is class name
6. Word from begin of the line after spaces is class property
7. .t file containts D code
8. '{' and '}' is open and close code block
9. .t file containts event handlers
10. '{' and '}' after indent and under 'on:' keyword is event handler code

# Element
1. Element is UI primitive
2. Elements grouped to tree
3. Element contains fields. Like CSS
4. Element contains child elements
5. Element contains sibling elements
6. Element contains event handlers
7. Element contains 'id'. 'id' is string
8. Element contains list of classes
9. Element draw: background, border, image, text

# Element class
1. Class contains fields. Like CSS
2. Class contains event handlers
3. Class contains child elements
4. Class name is string
5. Class compiled to D struct with fields 'name', 'setter', 'on'

#
- Search element: querySelector( "CSS selector" )
- Search elements: querySelectorAll( "CSS selector" )

# jQuery style
1. S("selector") is function for search elements. Like a jQuery $().
2. S!"selector" is template variant of the S("selector")
3. S() result is Element collection
```D
    S(".box")
        .each( (elem) => {
            elem
                .css(
                    "color", "#CCC",
                    "border", "1px solid #000"
                )
                .onclick( (el) => {
                    console.log( el, " clicked" );
                })
        });
```

```T
.box
    color:  #CCC
    border: 1px solid #000
    on: clicked
    {
        console.log( el, " clicked" );
    }
```
