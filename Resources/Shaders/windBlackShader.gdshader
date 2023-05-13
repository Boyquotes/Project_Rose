shader_type canvas_item;
render_mode unshaded;

uniform sampler2D windMap: filter_nearest, repeat_enable;
uniform vec4 scale = vec4(1.0);
uniform vec4 velocity = vec4(1.0);
uniform float strength = 1.0;

uniform sampler2D windMask: filter_nearest, repeat_enable;
uniform float redMaskStrength = 1.0;
uniform float greenMaskStrength = 1.0;
uniform float blueMaskStrength = 1.0;

uniform float normalIntensity = 1.0;
uniform float normalSpeed = 1.0;

void fragment() {
	vec4 windMaskTex = texture(windMask, UV);
	
	float greenish = texture(TEXTURE, UV).g;
	
	vec2 dist_coords = UV;
	dist_coords /= scale.xy;
	dist_coords += TIME * velocity.xy;
	windMaskTex *= .01 * strength * greenish;
	float windrgb = windMaskTex.r * redMaskStrength
		+ windMaskTex.g * greenMaskStrength + windMaskTex.b * blueMaskStrength;
	vec2 dist_dir = texture(windMap, dist_coords).rg;
	vec2 offset = dist_dir * windrgb;//.01 * strength * greenish;
	
	COLOR = texture(TEXTURE, UV + offset);
	if(COLOR.a > 0.0)
	{
		COLOR -= vec4(1, 1, 1, 0);
	}
	NORMAL += normalIntensity * sin(TIME * normalSpeed * 5.0) * texture(TEXTURE, UV + offset).xyz;
}