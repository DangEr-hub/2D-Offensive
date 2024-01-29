varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float blur_radius;  // New uniform for blur radius
uniform vec2 blur_vector; // (1.0, 0.0) for horizontal, (0.0, 1.0) for vertical
uniform vec2 texel_size;  // Texture size in texels (1/width, 1/height)

void main() {
    vec4 result = vec4(0.0);
    vec2 offset = texel_size * blur_vector * blur_radius;

    // Gaussian weights
    float weights[5];
    weights[0] = 0.227027;
    weights[1] = 0.1945946;
    weights[2] = 0.1216216;
    weights[3] = 0.054054;
    weights[4] = 0.016216;

    // Center sample
    result += texture2D(gm_BaseTexture, v_vTexcoord) * weights[0];

    // Other samples
    for(int i = 1; i < 5; ++i) {
        result += texture2D(gm_BaseTexture, v_vTexcoord + offset * float(i)) * weights[i];
        result += texture2D(gm_BaseTexture, v_vTexcoord - offset * float(i)) * weights[i];
    }

    gl_FragColor = result * v_vColour;
}
