


//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

//uni
uniform float Time;
uniform sampler2D Noise;

uniform vec2 NoiseSize;

//const
//const float Speed = 0.01;
//const float Size = 0.001;
//const float Freq = 0.4;
uniform float Speed;
uniform float Size;
uniform float Freq;

void main()
{
    //Tex
    vec4 Tex = texture2D(Noise, v_vTexcoord/Freq);

    //Waves
    vec2 Wave;
    //Wave.x = sin(Time*Speed + v_vTexcoord.y*Freq) * Size;
    //Wave.y = sin(Time*Speed + v_vTexcoord.x*Freq) * Size;
    Wave.x = sin((Time*Speed) + Tex.r*40.0) * Size;
    Wave.y = sin((Time*Speed) + Tex.g*40.0) * Size;
    
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord + Wave);
}

