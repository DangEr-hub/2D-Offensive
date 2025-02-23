//
// Fragment shader s rozostřením, bloomem, chromatickou aberací a saturací
//

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Uniform proměnné nastavované z GML
uniform vec3 size;                 // (šířka, výška, intenzita rozmazání)
uniform float color_saturation;    // intenzita barev (1.0 = normální, méně = šedší, více = sytější)
uniform float bloom_intensity;     // síla bloomu (dodatečné "záření" světlých částí)
uniform float bloom_darken;        // jak moc ztmavit základní barvu před aplikací bloomu
uniform float bloom_saturation;    // saturace barvy bloomu
uniform sampler2D bloom_texture;   // textura obsahující již vytvořený bloom efekt
uniform float aberration_strength; // síla chromatické aberace (rozdělení barev RGB od sebe)
uniform float vignette_strength;   // jak silně zatmavit okraje obrazovky

const int Quality = 2;    // kolik vzorků na směr při rozostření (vyšší = lepší, ale pomalejší)
const int Directions = 2; // počet směrů bluru
const float Pi = 3.1415926535; // hodnota pi


void main()
{
    vec2 uv = v_vTexcoord;
    vec2 aberration_offset = (uv - 0.5) * aberration_strength; // uv je od 0 do 1 přes obrazovku, tudíž -0.5 zajistí vzdálenost od středu obrazovky
    vec2 radius = size.z / size.xy;

    // Aplikace chromatické aberace na UV souřadnice
    vec2 uv_r = uv + aberration_offset; // posuv červené složky pixelu
    vec2 uv_b = uv - aberration_offset; // posuv modré složky pixelu

    // Blur vzorkování (aplikováno na každý kanál zvlášť pro aberaci)
    vec4 col_r = texture2D(gm_BaseTexture, uv_r);
    vec4 col_g = texture2D(gm_BaseTexture, uv);
    vec4 col_b = texture2D(gm_BaseTexture, uv_b);

    // Blur vzorkování
    for (float d = 0.0; d < Pi; d += Pi / float(Directions)) 
    {
        vec2 dir = vec2(cos(d), sin(d)) * radius;
        for (float i = 1.0 / float(Quality); i <= 1.0; i += 1.0 / float(Quality)) 
        {
            vec2 offset = dir * i;
            col_r += texture2D(gm_BaseTexture, uv + aberration_offset + offset);
            col_g += texture2D(gm_BaseTexture, uv + offset);
            col_b += texture2D(gm_BaseTexture, uv - aberration_offset + offset);
        }
    }

    float blur_factor = float(Quality * Directions) + 1.0;
    col_r /= blur_factor;
    col_g /= blur_factor;
    col_b /= blur_factor;
	
    // Sloučení barevných složek do finálního barevného výstupu
    vec4 base_col = vec4(col_r.r, col_g.g, col_b.b, col_g.a); // bereme alphu ze zelené složky, protože s tou jsme nijak nehýbali

    // Bloom efekt
	vec3 bloom_col = texture2D(bloom_texture, uv).rgb;
		
	float lum = dot(bloom_col, vec3(0.299, 0.587, 0.114)); // výpočet jasu pixelu pomocí skalárního součinu barevných složek pixelu a nějakých "vah" (0.299, 0.587, 0.114)
	// výsledek je lum od 0 do 1
	bloom_col = mix(vec3(lum), bloom_col, bloom_saturation); // interpolace mezi hodnotami jasu, barev pixelu a saturace
		
	base_col.rgb = base_col.rgb * bloom_darken + bloom_col + bloom_intensity;
		
	// Saturace barev
	float avg = (base_col.r + base_col.g + base_col.b) / 3.0; // průměrná barva pixelu
	base_col.rgb = mix(vec3(avg), base_col.rgb, color_saturation); // interpolace barev pixelu
		
    // Vignette efekt
    vec2 vignette_uv = uv - 0.5;
    float vignette_dist = length(vignette_uv) * vignette_strength;
    float vignette = smoothstep(1.2, 0.3, vignette_dist); // od 0.3 vzdálenosti ze středu nebude žádné ztmavení a od 1.2 bude 100% ztmavení, smoothstep zajišťuje plynulý přechod mezi
	// těmito hodnotami
    base_col.rgb *= vignette; // Výnasobení všech tří složek pixelu

    gl_FragColor = v_vColour * base_col;
}



/*varying vec2 v_vTexcoord;
varying vec4 v_vColour;


uniform float color_saturation;


uniform float bloom_intensity;
uniform float bloom_darken;
uniform float bloom_saturation;

uniform sampler2D bloom_texture;

uniform float aberration_strength;

void main()
{
		
	    vec2 uv = v_vTexcoord;
	    vec2 aberration_offset = (uv - 0.5) * aberration_strength; // Směr od středu obrazovky
    
	    // Vzorkování s aberací (r, g, b odděleně)
	    vec4 base_col;
	    base_col.r = texture2D(gm_BaseTexture, uv + aberration_offset).r;
	    base_col.g = texture2D(gm_BaseTexture, uv).g;
	    base_col.b = texture2D(gm_BaseTexture, uv - aberration_offset).b;
	    base_col.a = texture2D(gm_BaseTexture, uv).a;
	
		vec3 bloom_col = texture2D(bloom_texture, uv).rgb;
		
		float lum = dot(bloom_col, vec3(0.299, 0.587, 0.114));
		bloom_col = mix(vec3(lum), bloom_col, bloom_saturation);
		
		base_col.rgb = base_col.rgb * bloom_darken + bloom_col + bloom_intensity;
		
	    // Apply color saturation enhancement
	    float avg = (base_col.r + base_col.g + base_col.b) / 3.0;
	    base_col.rgb = mix(vec3(avg), base_col.rgb, color_saturation);
		
		gl_FragColor = v_vColour * base_col;
}*/