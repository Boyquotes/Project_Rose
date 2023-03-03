shader_type canvas_item;
//render_mode unshaded;

uniform sampler2D bg: filter_nearest;
uniform sampler2D bg_height: filter_nearest;
uniform sampler2D bg_normal: filter_nearest;
uniform float depthMod = 0.0;
uniform float depthRemap = 1.0;
uniform float depthBrightness = 0.0;
uniform vec4 shadeMix : source_color = vec4(0.5f, 0.5f, 0.5f, 1.0f);
//uniform vec3 directionalLightNotionalPosition = vec3(1);
//uniform float fg_height = 0.0;

void fragment()
{
	vec4 tex = texture(TEXTURE, UV);
	vec4 d4 = abs(tex - vec4(.5));
    float d = max(max(d4.r, d4.g), d4.b);
    if(d > 0.1) {
		COLOR = vec4(0);
	}
	else {
		COLOR = texture(bg, UV);
	}
}

float remap(float val, float i1, float i2, float o1, float o2) {
	return (val - i1) / (o1 - i1) * (o2 - i2) + i2;
}

void light()
{
	vec4 heightTex = texture(bg_height, UV);
	float depth = heightTex.x;
	// (1.0 - depth): b/c LightDirection is in opposite direction, we need to 
	// "flip" the depth
	// The mix call is to reinterpret the resulting depth to a smaller range
	// [0,1] is too large and results in huge shadows even at depths of .7
	vec4 normalTex = texture(bg_normal, UV);
	//vec2 sample = UV + (LIGHT_DIRECTION.xy * (mix(0.0, depthRemap, (1.0 - depth)) + depthMod)) - vec2(normalTex.r - .5, normalTex.g - .5) * depthMod;
	vec2 lightDir = vec2(LIGHT_DIRECTION.x, LIGHT_DIRECTION.y);
	vec2 sample = UV - (-lightDir * ((1.0 - depth) + normalTex.b * depthMod)) - vec2(normalTex.r, normalTex.g) * depthMod;
	vec4 grab = texture(TEXTURE, sample);
	vec4 d4 = abs(grab - vec4(.5));
	float d = max(max(d4.r, d4.g), d4.b);
    if(d >= 0.1) {
		LIGHT = LIGHT_COLOR;
	}
	else {
		LIGHT = vec4(0.0);
	}
}