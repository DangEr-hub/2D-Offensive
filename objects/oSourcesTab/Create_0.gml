event_inherited();
tab_width = 768 * global.GUIMultiplier;
tab_height = 512 * global.GUIMultiplier;
draw_set_font(set_font("Menu_small"));
zui_set_size(tab_width, tab_height);

pos_x = zui_get_width() * .01;
pos_y = zui_get_height() * .1;
gap = 170 * global.GUIMultiplier;
gap_x = 210 * global.GUIMultiplier;
text_height = string_height("a")*2;
max_i = 17;

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Sources";
	draggable = 1;
}

with (zui_create(zui_get_width() * .75, pos_y, objUILabel)) {
	color = c_white;
	caption = "Inspired by Counter-Strike, \nUnturned and CS2D.";
}


source_names = [
	"Headshot sound (1): ",
	"Headshot sound (2): ",
	"AWM sound: ",
	"Spas-12 sound: ",
	"Empty magazine sound: ",
	"SSG 08 sound: ",
	"Bullet nearby sound: ",
	"Glock-17 sound: ",
	"USP unsilenced sound: ",
	"Metallic sound: ",
	"Explosion sound: ",
	"Birds sound: ",
	"Rain sound: ",
	"GUI engine: ",
	"Bloom shader: ",
	"Blur shader: ",
	"Armour hit sound: ",
	"Metal hit sound: ",
	"Hit no armour: ",
	"Footsteps sound: ",
	"Ear ring sound: ",
	"Wood hit: ",
	"Concrete hit: ",
	"Glass hit: ",
	"Airplane sound: ",
	"Falling bomb sound: "
];

sources = [
	"https://pixabay.com/sound-effects/bulletimpact1-442717/",
	"https://pixabay.com/sound-effects/bullethit-449809/",
	"https://pixabay.com/sound-effects/sniper-rifle-5989/",
	"https://pixabay.com/sound-effects/shotgun-firing-4-6746/",
	"https://pixabay.com/sound-effects/empty-gun-shot-6209/",
	"https://pixabay.com/sound-effects/gun-shot-1-176892/",
	"https://pixabay.com/sound-effects/visceralbulletimpacts-6738/",
	"https://freesound.org/people/JD_Brick_Productions/sounds/678527/",
	"https://freesound.org/people/JD_Brick_Productions/sounds/678527/",
	"https://pixabay.com/sound-effects/metal-slam-5-189786/",
	"https://pixabay.com/sound-effects/medium-explosion-40472/",
	"https://pixabay.com/sound-effects/birds-chirping-75156/",
	"https://pixabay.com/sound-effects/real-rain-sound-379215/",
	"https://marketplace.gamemaker.io/assets/649/zui-engine",
	"https://www.youtube.com/watch?v=qbIkMMFxX3g&",
	"https://github.com/GameMakerDiscord/blur-shaders",
	"https://pixabay.com/sound-effects/080891-bullet-hit-39871/",
	"https://pixabay.com/sound-effects/metal-hit-12-193278/",
	"https://pixabay.com/sound-effects/bullethit-449809/",
	"https://pixabay.com/sound-effects/concrete-footsteps-6752/",
	"https://pixabay.com/sound-effects/ear-ring-104945/",
	"https://pixabay.com/sound-effects/hitting-wood-6791/",
	"https://pixabay.com/sound-effects/bullet-gunshot-impact-390253/",
	"https://pixabay.com/sound-effects/glass-breaking-386153/",
	"https://pixabay.com/sound-effects/fighter-jet-overhead-355468/",
	"https://pixabay.com/sound-effects/falling-bomb-41038/"
	
	
	
];


for(i = 0; i < array_length(sources); i++){
    
    var col_i = i div max_i;
    var row_i = i mod max_i;

    var extra_x = col_i * gap_x;

    src_but = zui_create(
        pos_x + gap + extra_x,
        pos_y - text_height/4 + text_height * row_i,
        objUIButton
    );
    with(src_but){
        zui_set_anchor(0.5, 0);
        zui_set_width(64 * global.GUIMultiplier);
        zui_set_height(16 * global.GUIMultiplier);
        caption = "Open";

        link_url = other.sources[other.i];

        callback = function(){
            url_open(link_url);
        };
    }
	
	with(zui_create(
        pos_x + extra_x,
        pos_y + text_height * row_i,
        objUILabel
    )){
		color = c_white;
		caption = other.source_names[other.i];
	}
}


