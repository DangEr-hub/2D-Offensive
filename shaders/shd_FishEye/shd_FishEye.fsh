varying vec2 v_vTexcoord;
uniform float u_zoomFactor; // Pass in the zoom factor

void main() {
    vec2 uv = v_vTexcoord;
    vec2 uv_ndc = uv * 2.0 - 1.0; // Normalize to [-1, 1]

    // Apply fisheye effect for zoom-in in the middle
    float dist = length(uv_ndc);
	// The scope opening has half the radius of the sampled square.
	// Do not draw the untouched application surface outside the lens.
	if (dist > 0.5) {
		gl_FragColor = vec4(0.0);
		return;
	}

    if (dist < 1.0) {
        float theta = atan(uv_ndc.y, uv_ndc.x);
        dist = pow(dist, u_zoomFactor); // Adjust this value to control the fisheye strength
        uv_ndc = vec2(cos(theta), sin(theta)) * dist;
    }

    // Convert back to texture coordinates
    uv = (uv_ndc + 1.0) * 0.5;
    vec4 pixelColor = texture2D(gm_BaseTexture, uv);

    gl_FragColor = vec4(pixelColor.rgb, 1.0);
}
