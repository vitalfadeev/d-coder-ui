# Element

```
Element
-------
Properties
  text
  image
  color
  ...
Computed Properties
  text
  image
  color
  ...
Tree Properties
  parentNode
  prevSibling
  nextSibling
  ...
Event Handlers
  onclick
  onkeyup
  onkeydown
  ...
Classes
  classes
```


## Properties

```
Element
-------
text
image
color
background
border
padding
margin
left
top
right
bottom
width
height
display
position
hidden
tabIndex
zIndex
id
```

## Computed Properties

```
Element
-------
width     = Auto / 1.px / 50.percent / inherit / initial
-------
computed
  width   = 1
```

```
Element
-------
computed
  text
  color
  background
  border
  padding
  margin
  image
  left
  top
  right
  bottom
  width
  height
  display
  position
  hidden
  tabIndex
  zIndex
  type
```

## Tree Properties

```
Element
-------
parentNode
prevSibling
nextSibling
firstChild
lastChild

// Helpers
children
child
```

## Event Handlers
```
Element
-------
onclick
onkeydown
onkeyup
onfocus
onfocusin
onfocusout
onmousedown
onmouseup
onmouseenter
onmouseleave
onmousemove
onmouseout
onmouseover
onwheel
onscroll
onpaste
oncut
oncopy
onselect
ontouchstart
ontouchmove
ontouchend
oncontextmenu
```

## Classes

```
Element
-------
classes
```

### display
- none
- block
- inline
- inline-block
- grid
- flex
- window - create OS window, draw content in window, window size is (width x height)


### type
- button
- checkbox
- color
- date
- datetime-local
- email
- file
- hidden
- image
- month
- number
- password
- radio
- range
- reset
- search
- submit
- tel
- text
- time
- url
- week 


#### Element computed properties

Element read each class and compute properties for drawing

```D
// Element
//   width
//   height
//   color
//   background
//
//   computed               // properties for drawing element
//     width
//     height
//     color
//     background

struct Element 
{
    CSSValue width;
    CSSValue height;
    CSSValue color;
    CSSValue background;

    Computed computed;
}
```

#### Classes

Class has "setter" for set properies

```D
// Class
//   setter():
//     set width
//     set height
//     set color

struct Class
{
    void setter( Element* element )
    {
        with ( element )
        {
            width  = 100.px;
            height = 100.px;
        }
    }
}
```

#### Units

Properties has units, like a CSS

```D
// width: 1px
width = 1.px;
```

