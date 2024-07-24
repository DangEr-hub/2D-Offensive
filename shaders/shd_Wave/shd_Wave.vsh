//
// Simple passthrough vertex shader with wavy effect
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;
uniform float amplitude;
uniform float strength;

void main()
{
    // Apply a sine wave to the x position to simulate wind
    float wave = sin(in_Position.y * strength + time) * amplitude;
    
    // Adjust position with the wave effect
    vec4 object_space_pos = vec4( in_Position.x + wave, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}
