shader_type canvas_item;
render_mode unshaded;

void fragment() {
	if(COLOR.a > 0.0)
	{
		COLOR = vec4(0,0,0,1);
	}
}
