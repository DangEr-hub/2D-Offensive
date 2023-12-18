varying vec2 v_vTexcoord;
uniform vec4 blendColor;  // Added uniform

void main()
{
    vec4 baseColor = texture2D(gm_BaseTexture, v_vTexcoord);   
    if(baseColor.a == 1.0) {
        gl_FragColor = mix(baseColor, blendColor, .9);
    } else {
        gl_FragColor = baseColor;
    }
}