shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0; // 0.0 = Transparent, 1.0 = Opaque
uniform vec4 fade_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    COLOR = vec4(fade_color.rgb, progress * fade_color.a);
}