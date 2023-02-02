shader_type canvas_item;
render_mode unshaded;

uniform vec3 cameraPosition = vec3(0.0f);
uniform float lightColorFac = 0.5f;
// Setting a color difference between unlit and specular.
uniform float lightAdd = 0.5f;
uniform float shadowSubtract = 0.5f;
uniform vec4 unlitColorMix : source_color = vec4(0.5f, 0.5f, 0.5f, 1.0f);
uniform float unlitColorControl = 0.5f;
uniform float theta = 0.0;
uniform vec4 darkArea : source_color = vec4(1.0f, 0.0f, 0.0f, 1.0f);

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
	
	vec4 tex = texture(TEXTURE,  UV + offset);
	if (tex.a > 0.0){
		COLOR = tex + 1.0;
	}
}