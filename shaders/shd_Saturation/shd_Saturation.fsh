//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float saturation;

void main()
{
   // gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
    float avg = (color.r + color.g + color.b) / 3.0;
    color.rgb = mix(vec3(avg), color.rgb, saturation);
    gl_FragColor = color;
}
