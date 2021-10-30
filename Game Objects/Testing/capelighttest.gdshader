shader_type canvas_item;

uniform sampler2D norm;
void fragment() {
	//COLOR = vec4(0.5, 1.0, 1.0, 1.0);
	NORMAL = 2.0 * texture(norm, UV).rgb - 1.0;
	NORMAL.y = -NORMAL.y;
}

void light() {
	
}