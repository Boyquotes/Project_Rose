shader_type canvas_item;

uniform sampler2D norm;
uniform float theta = 0.0;

uniform vec2 true_pos;

uniform vec2 light_position0 = vec2(-100000);
uniform vec2 light_position1 = vec2(-100000);
uniform vec2 light_position2 = vec2(-100000);
uniform vec2 light_position3 = vec2(-100000);
uniform vec2 light_position4 = vec2(-100000);

uniform float light_energy0;
uniform float light_energy1;
uniform float light_energy2;
uniform float light_energy3;
uniform float light_energy4;

vec4 calc_light(vec2 light_pos, float light_en, sampler2D tex, vec2 uv, vec4 col, vec2 point_coord, vec3 normal)
{
	vec2 temp_pos = vec2(light_pos.x / 10.0, light_pos.y / -10.0);
	float tempx = temp_pos.x;
	float tempy = temp_pos.y;
	temp_pos.x = tempx * cos(theta) - tempy * sin(theta);
	temp_pos.y = tempx * sin(theta) + tempy * cos(theta);
	vec4 fin_color = min(texture(tex, uv), col);
	col = fin_color;
	vec2 light_vec = normalize(temp_pos - point_coord);
	float brightness = dot(normal.xy, light_vec) * light_en/1.0;
	float fade = max(distance(temp_pos, point_coord), 1.0);
	brightness = max(fin_color.a - brightness / fade, 0.0);
	return vec4(fin_color.rgb, brightness);
}

void fragment() {
	vec2 light_positions[5] = {light_position0, light_position1, light_position2, light_position3, light_position4};
	float light_energies[5] = {light_energy0, light_energy1, light_energy2, light_energy3, light_energy4};
	
	for (int i = 0; i < light_positions.length(); i++)
	{
		if(light_positions[i] != vec2(-100000))
		{
			NORMAL = 2.0 * texture(norm, UV).rgb - 1.0;
			COLOR = COLOR * calc_light(light_positions[i], light_energies[i] / max(1.0, distance(light_positions[i], FRAGCOORD.xy) / 1000.0), TEXTURE, UV, COLOR, POINT_COORD, NORMAL);
		}
		else
		{
			COLOR = COLOR * min(texture(TEXTURE, UV), COLOR);
		}
	}
}



















