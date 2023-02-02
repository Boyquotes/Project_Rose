shader_type canvas_item;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	if (tex.a > 0.0){
		COLOR = vec4(1);
	}
}
