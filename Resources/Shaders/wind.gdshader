shader_type canvas_item;

uniform sampler2D windMap: filter_nearest, repeat_enable;
uniform vec4 scale = vec4(1.0);
uniform vec4 velocity = vec4(1.0);
uniform float strength = 1.0;

void fragment() {
	vec2 dist_coords = UV;
	dist_coords /= scale.xy;
	dist_coords += TIME * velocity.xy;
	
	vec2 dist_dir = texture(windMap, dist_coords).rg;
	vec2 offset = dist_dir * .01 * strength;
	
	COLOR = texture(TEXTURE, UV + offset);
}