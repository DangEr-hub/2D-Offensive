//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float color_saturation;  // New uniform for color saturation adjustment


uniform float bloom_intensity;
uniform float bloom_darken;
uniform float bloom_saturation;

uniform sampler2D bloom_texture;

void main()
{
		vec4 base_col = texture2D( gm_BaseTexture, v_vTexcoord );
		vec3 bloom_col = texture2D(bloom_texture, v_vTexcoord).rgb;
		
		float lum = dot(bloom_col, vec3(0.299, 0.587, 0.114));
		bloom_col = mix(vec3(lum), bloom_col, bloom_saturation);
		
		base_col.rgb = base_col.rgb * bloom_darken + bloom_col + bloom_intensity;
		
	    // Apply color saturation enhancement
	    float avg = (base_col.r + base_col.g + base_col.b) / 3.0;
	    base_col.rgb = mix(vec3(avg), base_col.rgb, color_saturation);
		
		gl_FragColor = v_vColour * base_col;
}

