varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec3 size; //width,height,radius

const int Quality = 2;
const int Directions = 4;
const float Pi = 3.14;

void main()
{
    vec2 radius = size.z/size.xy;
    vec4 Color = texture2D( gm_BaseTexture, v_vTexcoord);
    for( float d=0.0;d<Pi;d+=Pi/float(Directions) )
    {
        for( float i=1.0/float(Quality);i<=1.0;i+=1.0/float(Quality) )
        {
            Color += texture2D( gm_BaseTexture, v_vTexcoord+vec2(cos(d),sin(d))*radius*i);
        }
    }
    Color /= float(Quality)*float(Directions)+1.0;

    // Grayscale effect
    vec3 lum = vec3(0.299, 0.587, 0.114);
    vec3 grayscale = vec3(dot(Color.rgb, lum));

    gl_FragColor = vec4(grayscale, Color.a) * v_vColour;
}