module ui.parse.css.background;

// https://developer.mozilla.org/en-US/docs/Web/CSS/background

/+
[ <bg-layer> , ]* <final-bg-layer>
where 
<bg-layer> = <bg-image> || <bg-position> [ / <bg-size> ]? || <repeat-style> || <attachment> || <box> || <box>
<final-bg-layer> = <'background-color'> || <bg-image> || <bg-position> [ / <bg-size> ]? || <repeat-style> || <attachment> || <box> || <box>

where 
<bg-image> = none | <image>
<bg-position> = [ [ left | center | right | top | bottom | <length-percentage> ] | [ left | center | right | <length-percentage> ] [ top | center | bottom | <length-percentage> ] | [ center | [ left | right ] <length-percentage>? ] && [ center | [ top | bottom ] <length-percentage>? ] ]
<bg-size> = [ <length-percentage> | auto ]{1,2} | cover | contain
<repeat-style> = repeat-x | repeat-y | [ repeat | space | round | no-repeat ]{1,2}
<attachment> = scroll | fixed | local
<box> = border-box | padding-box | content-box

where 
<image> = <url> | <image()> | <image-set()> | <element()> | <paint()> | <cross-fade()> | <gradient>
<length-percentage> = <length> | <percentage>

where 
<image()> = image( <image-tags>? [ <image-src>? , <color>? ]! )
<image-set()> = image-set( <image-set-option># )
<element()> = element( <id-selector> )
<paint()> = paint( <ident>, <declaration-value>? )
<cross-fade()> = cross-fade( <cf-mixing-image> , <cf-final-image>? )
<gradient> = <linear-gradient()> | <repeating-linear-gradient()> | <radial-gradient()> | <repeating-radial-gradient()> | <conic-gradient()>

where 
<image-tags> = ltr | rtl
<image-src> = <url> | <string>
<color> = <rgb()> | <rgba()> | <hsl()> | <hsla()> | <hex-color> | <named-color> | currentcolor | <deprecated-system-color>
<image-set-option> = [ <image> | <string> ] <resolution>
<id-selector> = <hash-token>
<cf-mixing-image> = <percentage>? && <image>
<cf-final-image> = <image> | <color>
<linear-gradient()> = linear-gradient( [ <angle> | to <side-or-corner> ]? , <color-stop-list> )
<repeating-linear-gradient()> = repeating-linear-gradient( [ <angle> | to <side-or-corner> ]? , <color-stop-list> )
<radial-gradient()> = radial-gradient( [ <ending-shape> || <size> ]? [ at <position> ]? , <color-stop-list> )
<repeating-radial-gradient()> = repeating-radial-gradient( [ <ending-shape> || <size> ]? [ at <position> ]? , <color-stop-list> )
<conic-gradient()> = conic-gradient( [ from <angle> ]? [ at <position> ]?, <angular-color-stop-list> )

where 
<rgb()> = rgb( <percentage>{3} [ / <alpha-value> ]? ) | rgb( <number>{3} [ / <alpha-value> ]? ) | rgb( <percentage>#{3} , <alpha-value>? ) | rgb( <number>#{3} , <alpha-value>? )
<rgba()> = rgba( <percentage>{3} [ / <alpha-value> ]? ) | rgba( <number>{3} [ / <alpha-value> ]? ) | rgba( <percentage>#{3} , <alpha-value>? ) | rgba( <number>#{3} , <alpha-value>? )
<hsl()> = hsl( <hue> <percentage> <percentage> [ / <alpha-value> ]? ) | hsl( <hue>, <percentage>, <percentage>, <alpha-value>? )
<hsla()> = hsla( <hue> <percentage> <percentage> [ / <alpha-value> ]? ) | hsla( <hue>, <percentage>, <percentage>, <alpha-value>? )
<side-or-corner> = [ left | right ] || [ top | bottom ]
<color-stop-list> = [ <linear-color-stop> [, <linear-color-hint>]? ]# , <linear-color-stop>
<ending-shape> = circle | ellipse
<size> = closest-side | farthest-side | closest-corner | farthest-corner | <length> | <length-percentage>{2}
<position> = [ [ left | center | right ] || [ top | center | bottom ] | [ left | center | right | <length-percentage> ] [ top | center | bottom | <length-percentage> ]? | [ [ left | right ] <length-percentage> ] && [ [ top | bottom ] <length-percentage> ] ]
<angular-color-stop-list> = [ <angular-color-stop> [, <angular-color-hint>]? ]# , <angular-color-stop>

where 
<alpha-value> = <number> | <percentage>
<hue> = <number> | <angle>
<linear-color-stop> = <color> <color-stop-length>?
<linear-color-hint> = <length-percentage>
<angular-color-stop> = <color> && <color-stop-angle>?
<angular-color-hint> = <angle-percentage>

where 
<color-stop-length> = <length-percentage>{1,2}
<color-stop-angle> = <angle-percentage>{1,2}
<angle-percentage> = <angle> | <percentage>
+/

/+
/* Using a <background-color> */
background: green;

/* Using a <bg-image> and <repeat-style> */
background: url("test.jpg") repeat-y;

/* Using a <box> and <background-color> */
background: border-box red;

/* A single image, centered and scaled */
background: no-repeat center/80% url("../img/image.png");
+/

import ui.parse.css.background_attachment;
import ui.parse.css.background_clip;
import ui.parse.css.background_color;
import ui.parse.css.background_image;
import ui.parse.css.background_origin;
import ui.parse.css.background_position;
import ui.parse.css.background_repeat;
import ui.parse.css.background_size;

