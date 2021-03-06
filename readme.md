# d-coder-ui

![dguilogo.png](docs/dguilogo.png)

D language GUI. 

Goals:
- native
- fast
- low RAM usage
- Windows / Linux / Android ( planned )
- CSS
- human-readable markup
- GDI / OpenGL / GLES
- API like Chrome / Firefox
- JS / jQuery selectors
- event handlers on D language


Example: [https://github.com/vitalfadeev/d-coder-ui-sample](https://github.com/vitalfadeev/d-coder-ui-sample)

Radmap: [roadmap.md](roadmap.md)

Support: [https://www.patreon.com/dgui](https://www.patreon.com/dgui)


## Details

### Render

![dlang-ui-gl.png](docs/dlang-ui-gl.png)

### Demo


![demo.gif](docs/demo.gif)

### Memory usage

![d-coder-ui-sample-RAM.png](docs/d-coder-ui-sample-RAM.png)

### Document

![d-ui-element-dom.png](docs/d-ui-element-dom.png)

### Element

![d-ui-element.png](docs/d-ui-element.png)

### GUI markup example

![roof.png](docs/roof.png)

```T
body
    e image
    e input roof
    e input angle
    e input wide

image
    width:    640px
    height:   540px
    position: absolute
    image:    docs/roof.png

input
    width: 120px
    height: 40px

roof
    disabled: true
    left: 486px
    top:  151px
    position: absolute

angle
    text: 60
    left: 486px
    top:  289px
    position: absolute

    on: changed
    {
        calculate();
    }

wide
    text: 2.50
    left: 198px
    top:  459px
    position: absolute

    on: changed
    {
        calculate();
    }

{
    void calculate()
    {
        // roof = wide / ( 2 * cos angle )

        import std.math;

        auto wide  = S("wide" ).text.to!float;
        auto angle = S("angle").text.to!float;

        S("root").text = 
            wide / ( 2 * cos( angle / 180 * PI ) );
    }
}
```

