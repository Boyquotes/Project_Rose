shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0, 1.0);
uniform float smooth_size : hint_range(0.0,1.0);
uniform sampler2D mask : filter_nearest;

void fragment()
{
	vec4 tex = texture(TEXTURE, UV);
	float value = texture(mask, UV).r;
	float alpha = smoothstep(cutoff, cutoff + smooth_size, value * (1.0 - smooth_size) + smooth_size);
	if (tex.a > 0.0) {
		COLOR = vec4(tex.rgb, alpha);
	}
}