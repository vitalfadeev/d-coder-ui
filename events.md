# Events

- by class
- by celement

```T
body 
  e stage selected

style
  stage 
    on click {}
  
  selected 
    on click {}
```

## By class

```T
body 
  e stage selected

style
  stage 
    on click {}
  
  selected 
    on click {}  
```

```
    // event phase
    foreach cls in e.classes
      cls.on_click()

    // e.on_click()
    // stage.on_click()
    // selected.on_click()

```

## By Element

```T
body 
  e stage selected

style
  stage 
    on click {}
  
  selected 
    on click {}  
```

```
    // apply phase
    foreach cls in e.classes
      e.on_click = cls.on_click()

    // event phase
    e.on_click()
```


## Phases

- init
- tick
- apply
- event

```
loop
  event
    set element properties
    set element classes
    fire new event -> push to event queue

  update
    position
    size
    layout
    inherit

  render
```

## Keyboard events

Only in focused
Hotkeys in focused

Global key events
Hotkeys in Global

Merge Hotkeys. Override by focused.


## Event handlers

```
e
  onclick

Document
  onclick

Window
  onclick
```

### Event argument

If you GLFW user, you keep thinking in GLFW keywords.

GLFW_KEY_

When GLFW application compilled for GDI, then all keywords GLFW_KEY_* will be replaced to windows VK_*. 
We have conversion table:
```D
map = 
[
  "GLFW_KEY_A", "VK_A", "SDL_SCANCODE_A", "A",
  ...
];

```

Also with events:
```D
map = 
[
  "GLFW_MOUSE_KEY", "WM_LBUTTONDOWN", "SDL_MOUSEBUTTONDOWN", "clicked",
  ...
];

```
