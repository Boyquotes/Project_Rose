shader_type canvas_item;
render_mode light_only;

uniform vec4 color : source_color = vec4(0.0f, 0.0f, 0.0f, 1.0f);
uniform float angle : hint_range(0,360);
uniform float len : hint_range(0,1000) = 300;
uniform vec4 unlitColorMix : source_color = vec4(0.0f, 0.0f, 0.0f, 1.0f);

void fragment() {
	vec2 ps = TEXTURE_PIXEL_SIZE;
	vec2 offset = vec2(cos(radians(angle)) * len, -sin(radians(angle)) * len);
	vec4 shadow = vec4(color.rgb, texture(TEXTURE, UV - offset * ps).a * color.a);
	vec4 col = texture(TEXTURE, UV);
	COLOR = mix(shadow, col, col.a);
}