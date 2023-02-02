shader_type canvas_item;
render_mode unshaded;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 d4 = abs(tex - vec4(.5));
    float d = max(max(d4.r, d4.g), d4.b);
    if(d < 0.1) {
		COLOR = vec4(0);
	}
}
