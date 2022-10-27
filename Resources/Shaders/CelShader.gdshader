shader_type canvas_item;

uniform vec3 cameraPosition = vec3(0.0f);
// Setting a color difference between unlit and specular.
uniform float shadowSubtract = 0.5f;
uniform vec4 unlitColorMix : source_color = vec4(0.0f, 0.0f, 0.0f, 1.0f);
uniform float unlitColorControl = 0.5f;

void fragment()
{
	vec4 spec = texture(SPECULAR_SHININESS_TEXTURE, UV);
	vec4 col = texture(TEXTURE, UV);
	if(spec.g < 0.5f)
	{
		//COLOR = vec4(col.r - specularAdd, col.g - specularAdd, col.b - specularAdd, col.a);
	}
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

    
	vec4 finalColor = (texture(TEXTURE, UV) + LIGHT_COLOR) / 2.0f;
	
    //Substracting the difference from the main color for the shaded part
    vec4 unlitColor = vec4(finalColor.x - shadowSubtract, finalColor.y - shadowSubtract, finalColor.z - shadowSubtract, 1);
    unlitColor = mix(unlitColor, unlitColorMix, unlitColorControl);
    // Adding the difference from the main color for the highlighted part vec4(finalColor.x + specularAdd, finalColor.y + specularAdd, finalColor.z + specularAdd, 1)
    vec4 specularColor = (SPECULAR_SHININESS + LIGHT_COLOR) / 2.0f;

    // An example simple lighting effect, taking the dot product of the normal
    // (which way this pixel is pointing) and a user generated light position
    float brightness = dot( worldNormal, lightVector );
    
    vec3 reflectance = normalize(2.0 * dot(lightVector,worldNormal)*worldNormal-lightVector);

	//vec4 shadowColor = unlitColor
    
    if(dot(lightVector,worldNormal)<0.3){
        LIGHT = unlitColor;
    } else {
        if (dot(worldNormal,lightVector)>0.0){
            LIGHT = finalColor;
            if (length(cameraVector - reflectance)<0.6){
					if (SPECULAR_SHININESS.r > 0.01){
						LIGHT = specularColor;
					}
            }
        }
    }
	//SHADOW_MODULATE = vec4(edgeColor);
}