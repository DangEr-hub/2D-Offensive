varying vec2 v_vTexcoord;
uniform vec2 lightDirection; // Direction from player to light
uniform float intensity; // Intensity based on distance

void main() {
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);

    // Calculate flare effect based on light direction and intensity
    // This is a simple example; you might want to use more complex math for a realistic effect
    vec2 flareDir = normalize(lightDirection - v_vTexcoord);
    float flare = dot(flareDir, lightDirection) * intensity;

    // Apply the flare effect
    vec4 flareColor = vec4(1.0, 1.0, 1.0, flare); // White flare
    gl_FragColor = texColor + flareColor;
}