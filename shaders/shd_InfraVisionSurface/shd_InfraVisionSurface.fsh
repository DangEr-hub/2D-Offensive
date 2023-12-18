// Fragment shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 pixelColor = texture2D(gm_BaseTexture, v_vTexcoord);

    // Calculate brightness
    float brightness = dot(pixelColor.rgb, vec3(0.299, 0.587, 0.114));

    // Check for exclusion colors (orange, yellow, red)
    if (pixelColor.r > 0.8 && pixelColor.g > 0.4 && pixelColor.g < 0.9 && pixelColor.b < 0.2) {
        gl_FragColor = pixelColor;
    } else {
        // Define magenta and navy colors
        vec3 magenta = vec3(1.0, 0.0, 1.0);
        vec3 navy = vec3(0.0, 0.0, 0.5);

        // Blend the original color with magenta or navy based on brightness
        // The blending factor controls how much of the tint is applied
        float blendFactor = 0.5; // Adjust this value for more or less tint
        vec3 tintedColor = mix(pixelColor.rgb, (brightness > 0.5 ? navy : magenta), blendFactor * brightness);

        gl_FragColor = vec4(tintedColor, pixelColor.a);
    }
}
