## Canvas 

```D
auto canvas = document.querySelector('canvas');
auto ctx = canvas.getContext('2d');
ctx.fillStyle = 'green';
ctx.fillRect(10, 10, 100, 100);
```

## RenderingContext

### CanvasRenderingContext2D

```D
const canvas = document.getElementById('my-house');
const ctx = canvas.getContext('2d');
```

```D
// Set line width
ctx.lineWidth = 10;

// Wall
ctx.strokeRect(75, 140, 150, 110);

// Door
ctx.fillRect(130, 190, 40, 60);

// Roof
ctx.beginPath();
ctx.moveTo(50, 140);
ctx.lineTo(150, 60);
ctx.lineTo(250, 140);
ctx.closePath();
ctx.stroke();
```

CanvasRenderingContext2D
  // Drawing rectangles
  clearRect()
  fillRect()
  strokeRect()

  // Drawing Text
  fillText()
  strokeText()
  measureText()

  // Line styles
  lineWidth
  lineCap
  lineJoin
  miterLimit
  getLineDash()
  setLineDash()
  lineDashOffset

  // Text styles
  font
  textAlign
  textBaseline
  direction

  // Fill and stroke styles
  fillStyle
  strokeStyle

  // Gradients and patterns
  createConicGradient()
  createLinearGradient()
  createRadialGradient()
  createPattern()

  // Shadows
  shadowBlur
  shadowColor
  shadowOffsetX
  shadowOffsetY

  // Paths
  beginPath()
  closePath()
  moveTo()
  lineTo()
  bezierCurveTo()
  quadraticCurveTo()
  arc()
  arcTo()
  ellipse()
  rect()

  // Drawing paths
  fill()
  stroke()
  drawFocusIfNeeded()
  scrollPathIntoView()
  clip()
  isPointInPath()
  isPointInStroke()

  // Transformations
  getTransform()
  rotate()
  scale()
  translate()
  transform()
  setTransform()
  resetTransform() 

  // Compositing
  globalAlpha
  globalCompositeOperation

  // Drawing images
  drawImage()

  // Pixel manipulation
  createImageData()
  getImageData()
  putImageData()

  // Image smoothing
  imageSmoothingEnabled 
  imageSmoothingQuality 

  // The canvas state
  save()
  restore()
  canvas
  getContextAttributes()

  // Hit regions
  addHitRegion() 
  removeHitRegion() 
  clearHitRegions() 

  // Filters
  filter

  // Non-standard APIs


WebGL2RenderingContext
    // State information
    getIndexedParameter()

    // Buffers
    bufferData()
    bufferSubData()
    copyBufferSubData()
    getBufferSubData()

    // Framebuffers
    blitFramebuffer()
    framebufferTextureLayer()
    invalidateFramebuffer()
    invalidateSubFramebuffer()
    readBuffer()

    // Renderbuffers
    getInternalformatParameter()
    renderbufferStorageMultisample()

    // Textures
    texStorage2D()
    texStorage3D()
    texImage3D()
    texSubImage3D()
    copyTexSubImage3D()
    compressedTexImage3D()
    compressedTexSubImage3D()

    // Programs and shaders
    getFragDataLocation()

    // Uniforms and attributes
    uniform[1234][uif][v]()
    uniformMatrix[234]x[234]fv()
    vertexAttribI4[u]i[v]()
    vertexAttribIPointer()

    // Drawing buffers
    vertexAttribDivisor()
    drawArraysInstanced()
    drawElementsInstanced()
    drawRangeElements()
    drawBuffers()
    clearBuffer[fiuv]()

    // Query objects
    createQuery()
    deleteQuery()
    isQuery()
    beginQuery()
    endQuery()
    getQuery()
    getQueryParameter()

    // Sampler objects
    createSampler()
    deleteSampler()
    bindSampler()
    isSampler()
    samplerParameter[if]()
    getSamplerParameter()

    // Sync objects
    fenceSync()
    isSync()
    deleteSync()
    clientWaitSync()
    waitSync()
    getSyncParameter()

    // Transform feedback
    createTransformFeedback()
    deleteTransformFeedback()
    isTransformFeedback()
    bindTransformFeedback()
    beginTransformFeedback()
    endTransformFeedback()
    transformFeedbackVaryings()
    getTransformFeedbackVarying()
    pauseTransformFeedback()
    resumeTransformFeedback()

    // Uniform buffer objects
    bindBufferBase()
    bindBufferRange()
    getUniformIndices()
    getActiveUniforms()
    getUniformBlockIndex()
    getActiveUniformBlockParameter()
    getActiveUniformBlockName()
    uniformBlockBinding()

    // Vertex array objects
    createVertexArray()
    deleteVertexArray()
    isVertexArray()
    bindVertexArray()


```D
void draw() {
  auto canvas = document.getElementById('canvas');
  if (canvas.getContext) {
    auto ctx = canvas.getContext('2d');

    ctx.beginPath();
    ctx.moveTo(75, 50);
    ctx.lineTo(100, 75);
    ctx.lineTo(100, 25);
    ctx.fill();
  }
}
```



## Focus

e 
  canFocus
  isFocused
  focus

Document
  focusedElement


## Document
  
              +--------------------------+ (0,0) x (documentW,documentH)
Document  ->  | DocumentRenderContext    |
              |   ViewportRenderContext  |
  body        |--------------------------| (scrollX,scrollY) x (viewportW,viewportH)
    e     ->  |     ElementRenderContext |
    e         |      +--+                | (elementX, elementY) x (elementW,elementH)
    e         |      |  |                |
    e         |      +--+                |
      e       |                          |
              +--------------------------+


## Clippint

Viewport clipping

Element clipping
  - Text clipping
  - path clipping
  - image clipping

## Transformations

Vector graphics
- draw path
- draw text
- draw image

Transformations
- scale
- rotate
- translate

Transformationds in each element
Transform functions in RenderContext

## OS RenderContext

### Linux

```D
struct RenderContext
{
    //
}
```

### Windows

```D
struct RenderContext
{
    HDC _hdc;

    void fillRect( ref Rect rect )
    {
        FilledRect( _hdc, rect.windowsRECT );
    }
}
```

### Android

```D
struct RenderContext
{
    //
}
```

### Document, Window, Rendercontext
```
+-----------------------------+
| Document                    |
|                             |
| +-------------------------+ |
| | Window                  | |
| |                         | |
| |                +------+ | |
| |                | RC   | | | <-- RenderContext
| |                +------+ | |     ( x, y, x2, y2 )
| |                         | |     ( x, y ) from Document
| |                         | |
| +-------------------------+ |     transform Document (x,y) to RenderContext (x, y)
|                             |     then draw in RenderContext
|                             |     then copy RenderContext to Window
|                             |     (is Back buffer version)
|                             |
|                             |
+-----------------------------+
```


### Document, Viewport
```
+-----------------------------+
| Document                    |
|                             |
| +-------------------------+ |  -->  +-------------------------+   Translate Element Document coordinates
| | Viewport                | |       | Window                  |   to Viewport coordinates
| |                         | |       |                         |   ( x, y ) -->  ( x, y )
| |                         | |       |                         |
| |                         | |       |                         |   element_in_viewport__left = element.absolute.left - viewport.left
| |                         | |       |                         |   element_in_viewport__top  = element.absolute.top  - viewport.top
| |                         | |       |                         |
| |                         | |       |                         |   element_in_viewport__rect = element.absolute.rect - viewport.rect
| +-------------------------+ |       +-------------------------+
|                             |
|                             |
|                             |
|                             |
|                             |
+-----------------------------+


Viewport
  left        // left position relative at Document
  top
  right
  bottom

Element
  computed
    absolute
      left    // left position relative at Document
      top
      right
      bottom
```

### Element Shape
1. Element can be any shape. 
2. Shape is 2D path. Shape is closed 2D path.
3. shape() is function for define Element Shape.
```D
.shape( Path2D( [ 1, 1,  2, 2,  3, 3,  4, 4 ] ) )

```
4. background affected to the Shape
```D
background: #CCC; // is fill Shape with color #CCC.
```
5. Mouse 'onclick' function checks for cursor is in Shape

