//
// Fragment shader s rozostřením, bloomem, chromatickou aberací a saturací
//

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Uniform proměnné nastavované z GML
uniform vec3 size;                 // (šířka, výška, intenzita rozmazání)
uniform float color_saturation;    // intenzita barev (1.0 = normální, méně = šedší, více = sytější)
uniform float bloom_intensity;     // síla záře vybraných světlých částí
uniform float bloom_darken;        // jak moc ztmavit základní barvu před aplikací bloomu
uniform float bloom_saturation;    // saturace barvy bloomu
uniform sampler2D bloom_texture;   // textura obsahující již vytvořený bloom efekt
uniform vec2 bloom_texel_size;     // velikost pixelu bloom surface v UV souřadnicích
uniform float bloom_neighbor_strength; // síla přímého vzorkování okolních světlých pixelů
uniform float bloom_neighbor_radius;   // vzdálenost vzorků v pixelech
uniform float bloom_threshold;
uniform float bloom_range;
uniform float aberration_strength; // síla chromatické aberace (rozdělení barev RGB od sebe)
uniform float vignette_strength;   // jak silně zatmavit okraje obrazovky

const int Quality = 2;    // kolik vzorků na směr při rozostření (vyšší = lepší, ale pomalejší)
const int Directions = 2; // počet směrů bluru
const float Pi = 3.1415926535; // hodnota pi

vec3 bright_neighbor(vec2 sample_uv)
{
	vec3 source_col = texture2D(gm_BaseTexture, clamp(sample_uv, vec2(0.0), vec2(1.0))).rgb;
	float source_lum = dot(source_col, vec3(0.299, 0.587, 0.114));
	return source_col * smoothstep(bloom_threshold, bloom_threshold + bloom_range, source_lum);
}

void main()
{
    vec2 uv = v_vTexcoord;
	
    // Aplikace chromatické aberace na UV souřadnice
    vec2 aberration_offset = (uv - 0.5) * aberration_strength; // uv je od 0 do 1 přes obrazovku, tudíž -0.5 zajistí vzdálenost od středu obrazovky
    vec2 radius = size.z / size.xy;
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

	vec3 bloom_col = texture2D(bloom_texture, uv).rgb;
	vec3 neighbor_col = vec3(0.0);
	if (bloom_neighbor_strength > 0.0) {
		vec2 neighbor_step = bloom_texel_size * bloom_neighbor_radius;
		neighbor_col += bright_neighbor(uv + vec2(neighbor_step.x, 0.0));
		neighbor_col += bright_neighbor(uv - vec2(neighbor_step.x, 0.0));
		neighbor_col += bright_neighbor(uv + vec2(0.0, neighbor_step.y));
		neighbor_col += bright_neighbor(uv - vec2(0.0, neighbor_step.y));
		neighbor_col *= 0.25;
	}
		
	vec3 combined_glow = bloom_col * bloom_intensity + neighbor_col * bloom_neighbor_strength;
	float lum = dot(combined_glow, vec3(0.299, 0.587, 0.114));
	combined_glow = mix(vec3(lum), combined_glow, bloom_saturation);
		
	base_col.rgb *= bloom_darken;
	vec3 glow = clamp(combined_glow, vec3(0.0), vec3(1.0));
	base_col.rgb += glow * (vec3(1.0) - clamp(base_col.rgb, vec3(0.0), vec3(1.0)));
		
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
