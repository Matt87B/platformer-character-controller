shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0; // 0.0 = Open, 1.0 = Closed
uniform vec2 player_screen_position = vec2(0.5, 0.5);
uniform vec2 target_resolution = vec2(160.0, 90.0);
uniform vec4 circle_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 grid_uv = floor(UV * target_resolution) / target_resolution;
    vec2 center_uv = floor(player_screen_position * target_resolution) / target_resolution;
    vec2 aspect_uv = (grid_uv - center_uv) * vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0) + center_uv;

    float dist = distance(aspect_uv, center_uv);
    float max_radius = 1.5;
    float radius = (1.0 - progress) * max_radius;

    float mask = step(dist, radius);
    COLOR = vec4(circle_color.rgb, (1.0 - mask) * circle_color.a);
}