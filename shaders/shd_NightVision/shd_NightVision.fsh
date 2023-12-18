precision mediump float;

varying vec2 v_vTexcoord;
uniform float intensity_strength;
uniform float noise_strength;

void main()
{
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);

    // Apply a green tint
    float greenTint = (color.r + color.g + color.b) / 3.0;
    color.rgb = vec3(0.2 * greenTint, greenTint, 0.2 * greenTint);

    // Amplify brightness more for bright pixels
    float amplificationFactor = (1.0 + greenTint*2.0) * intensity_strength;  // Amplification depends on the brightness
    color.rgb = clamp(color.rgb * amplificationFactor, 0.0, 1.0);

    // Add grainy noise
    float noise = fract(sin(dot(v_vTexcoord ,vec2(12.9898,78.233))) * 43758.5453);
    color.rgb += noise * 0.025 * noise_strength;  // Adjust the noise level if necessary

    gl_FragColor = color;
}