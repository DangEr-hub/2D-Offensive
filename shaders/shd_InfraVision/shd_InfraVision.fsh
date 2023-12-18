varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float u_intensity; // For the color interpolation

void main() {
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    float avg = (texColor.r + texColor.g + texColor.b) / 3.0;

    // Interpolation between red and orange
    vec4 warmColor = vec4(1.0, 0.0, 0.0, texColor.a);
    vec4 coolColor = vec4(1.0, 0.5, 0.0, texColor.a);
    vec4 interpolatedColor = mix(coolColor, warmColor, avg) * u_intensity;
	
    gl_FragColor = interpolatedColor * v_vColour;
}