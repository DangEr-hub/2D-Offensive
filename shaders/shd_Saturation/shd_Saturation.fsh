//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float color_saturation;

void main()
{	
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
    float avg = (color.r + color.g + color.b) / 3.0;
    color.rgb = mix(vec3(avg), color.rgb, color_saturation);
    gl_FragColor = color;
}
