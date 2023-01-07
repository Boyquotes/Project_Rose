shader_type canvas_item;

uniform vec3 cameraPosition = vec3(0.0f);
uniform float lightColorFac = 0.5f;
// Setting a color difference between unlit and specular.
uniform float lightAdd = 0.5f;
uniform float shadowSubtract = 0.5f;
uniform vec4 unlitColorMix : source_color = vec4(0.0f, 0.0f, 0.0f, 1.0f);
uniform float unlitColorControl = 0.5f;
uniform float theta = 0.0;
uniform vec4 darkArea : source_color = vec4(0.0f, 0.0f, 1.0f, 1.0f);
uniform float segmentation = 1.0f;
uniform vec4 aaa : source_color;
void fragment()
{
	NORMAL = NORMAL;
}

void light() {
    // Calculate the real position of this pixel in 3d space, taking into account
    // the rotation and scale of the model. It's a useful formula for some effects.
    // This could also be done in the vertex shader
    vec3 worldPosition = FRAGCOORD.xyz;

    // Calculate the normal including the model rotation and scale
    vec3 worldNormal = NORMAL.xyz;
	vec3 lightVector = normalize( LIGHT_POSITION - worldPosition );
    vec3 cameraVector = normalize(LIGHT_POSITION - cameraPosition - worldPosition );
	if( LIGHT_IS_DIRECTIONAL) {
		lightVector = LIGHT_DIRECTION;
		cameraVector = LIGHT_DIRECTION;
	}
	float tempx = lightVector.x;
	float tempy = lightVector.y;
	lightVector.x = tempx * cos(theta) - tempy * sin(theta);
	lightVector.y = tempx * sin(theta) + tempy * cos(theta);
    
	vec4 finalColor = mix(COLOR + lightAdd, LIGHT_COLOR, lightColorFac);
	
    //Substracting the difference from the main color for the shaded part
    vec4 unlitColor = COLOR - shadowSubtract;
    unlitColor = mix(unlitColor, unlitColorMix, unlitColorControl);
    // Adding the difference from the main color for the highlighted part vec4(finalColor.x + specularAdd, finalColor.y + specularAdd, finalColor.z + specularAdd, 1)
    vec4 specularColor = SPECULAR_SHININESS;//(SPECULAR_SHININESS + LIGHT_COLOR) / 2.0f;

    // An example simple lighting effect, taking the dot product of the normal
    // (which way this pixel is pointing) and a user generated light position
    float brightness = dot( worldNormal, lightVector );
    
    vec3 reflectance = normalize(2.0 * dot(lightVector,worldNormal)*worldNormal-lightVector);
    int responseIndex = int((brightness) * 6.0);
    
    // translate this back to a float for light calculation
    // response value is 0 to 1 on 0.1 increments
    float floatIndex = float(responseIndex) * 0.2;
    
    // log(x^2 + 1) falloff
    float falloffValue = max(log(floatIndex * floatIndex * floatIndex  + 3.0) / segmentation, 1.0);
	
	//vec4 shadowColor = unlitColor
    if(dot(lightVector,worldNormal)<0.3){
        LIGHT = unlitColor;
    } else {
        if (dot(worldNormal,lightVector)>0.0){
            LIGHT = finalColor;// * falloffValue;
            if (length(cameraVector - reflectance)<0.6){
					if (SPECULAR_SHININESS.r > 0.01){
						LIGHT = specularColor;
					}
			}
		}
	}
	vec4 d4 = abs(COLOR - darkArea);
    float d = max(max(d4.r, d4.g), d4.b);
    if(d < .01) {
		LIGHT = unlitColor;
    }
	
	SHADOW_MODULATE = unlitColor;
}