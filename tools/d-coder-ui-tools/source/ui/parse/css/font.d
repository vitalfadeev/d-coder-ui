module ui.parse.css.font;

// https://developer.mozilla.org/en-US/docs/Web/CSS/font

/*
[ [ <'font-style'> || <font-variant-css21> || <'font-weight'> || <'font-stretch'> ]? <'font-size'> [ / <'line-height'> ]? <'font-family'> ] | caption | icon | menu | message-box | small-caption | status-bar
where 
<font-variant-css21> = [ normal | small-caps ]
*/


import ui.parse.css.font_style;
import ui.parse.css.font_variant_css21;
import ui.parse.css.font_weight;
import ui.parse.css.font_stretch;
import ui.parse.css.font_size;
import ui.parse.css.line_height;
import ui.parse.css.font_family;

