precision mediump float;

varying vec2 v_vTexcoord;
uniform float intensity_strength;
uniform float noise_strength;
uniform vec2 u_resolution; // Application surface resolution

void main()
{
    vec2 uv = v_vTexcoord;

    // Convert texture coordinates to normalized device coordinates (-1 to 1)
    vec2 uv_ndc = uv * 2.0 - 1.0;

    // Apply fisheye effect for zoom-in in the middle
    float dist = length(uv_ndc);
    if (dist < 1.0)
    {
        float theta = atan(uv_ndc.y, uv_ndc.x);
        dist = pow(dist, 1.1);
        uv_ndc = vec2(cos(theta), sin(theta)) * dist;
    }

    // Convert back to texture coordinates
    uv = (uv_ndc + 1.0) * 0.5;

    vec4 color = texture2D(gm_BaseTexture, uv);

    // Apply a green tint
    float greenTint = (color.r + color.g + color.b) / 3.0;
    color.rgb = vec3(0.2 * greenTint, greenTint, 0.2 * greenTint);

    // Amplify brightness more for bright pixels
    float amplificationFactor = (1.0 + greenTint * 2.0) * intensity_strength;  // Amplification depends on the brightness
    color.rgb = clamp(color.rgb * amplificationFactor, 0.0, 1.0);

    // Add grainy noise
    float noise = fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
    color.rgb += noise * 0.025 * noise_strength;  // Adjust the noise level if necessary

    // Apply vignette effect
    float vignette = smoothstep(0.7, 1.0, dist); // Adjust the values to control vignette size and softness
    color.rgb *= (1.0 - vignette);

    gl_FragColor = color;
}



/*precision mediump float;

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
}*/