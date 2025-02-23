precision mediump float;

varying vec2 v_vTexcoord;

uniform float u_zoomFactor; // This will control the zoom amount

void main()
{
    vec2 zoomedTexCoords = 0.5 + (v_vTexcoord - 0.5) / u_zoomFactor;
    gl_FragColor = texture2D(gm_BaseTexture, zoomedTexCoords);
}
