event_inherited();
tab_width = 1536;
tab_height = 1024;
draw_set_font(set_font("GUI_small"));
zui_set_size(tab_width, tab_height);

pos_x = zui_get_width() * .005;
pos_y = zui_get_height() * .07;
gap = 120 * global.GUIMultiplier;
gap_x = 160 * global.GUIMultiplier;
text_height = string_height("a")*2;
max_i = 21;

with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Sources";
	draggable = 1;
}

with (zui_create(zui_get_width() * .7, pos_y, objUILabel)) {
	color = c_white;
	caption = "Inspired by Counter-Strike, CS2D \nand Unturned.";
}


source_names = [
	"Headshot (1): ",
	"Headshot (2): ",
	"AWM: ",
	"Spas-12: ",
	"Empty magazine: ",
	"SSG 08: ",
	"Bullet nearby: ",
	"Glock-17: ",
	"USP unsilenced: ",
	"Metallic: ",
	"Explosion: ",
	"Birds: ",
	"Rain: ",
	"GUI engine: ",
	"Bloom shader: ",
	"Blur shader: ",
	"Armour hit: ",
	"Metal hit: ",
	"Hit no armour: ",
	"Footsteps: ",
	"Ear ring: ",
	"Wood hit: ",
	"Concrete hit: ",
	"Glass hit: ",
	"Airplane: ",
	"Falling bomb: ",
	"Few textures: ",
	"Snow flake: ",
	"Weapons (1): ",
	"Weapons (2): ",
	"Weapons (3): ",
	"Beep: ",
	"Machine gun: ",
	"SG550: ",
	"MK18: ",
	"P250: ",
	"MAC11: ",
	"Bot ref (1): ",
	"Bot ref (2): ",
	"M4A1: ",
	"Light engine: ",
	"Helper (1): ",
	"Desert Eagle: ",
	"GUI Icons: ",
	"Explosion: ",
	"Button: ",
	"MP5: ",
	"Five-seven: ",
	"Dragunov: ",
	"TEC-9: ",
	"SCAR: ",
	"Galil: ",
	"Leg anim.: ",
	"Console: ",
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
	"https://pixabay.com/sound-effects/falling-bomb-41038/",
	"https://free-game-assets.itch.io/tds-pixel-art-2d-kit",
	"https://opengameart.org/content/snow-flake",
	"https://arlantr.itch.io/free-guns-pixelart",
	"https://munstudios.itch.io/2d-pixel-guns-pack",
	"https://datdev.itch.io/pixel-guns-2d-weapon-pack",
	"https://pixabay.com/sound-effects/technology-beep-sound-8333/",
	"https://pixabay.com/sound-effects/film-special-effects-072807-heavy-machine-gun-50-caliber-39765/",
	"https://pixabay.com/sound-effects/film-special-effects-m249-sound-effects-244559/",
	"https://pixabay.com/sound-effects/film-special-effects-ak47-168856/",
	"https://pixabay.com/sound-effects/film-special-effects-gun-shot-350315/",
	"https://pixabay.com/sound-effects/film-special-effects-mp5-168858/",
	"https://www.pngaaa.com/detail/800857",
	"https://es.pixilart.com/art/top-down-sprite-sr2cf59db022b7e",
	"https://pixabay.com/sound-effects/film-special-effects-gun-shot-2-530789/",
	"https://github.com/JujuAdams/Bulb",
	"https://marketplace.gamemaker.io/assets/6355/sprite_getpixel-optimized",
	"https://pixabay.com/sound-effects/film-special-effects-desert-eagle-168857/",
	"https://game-icons.net/",
	"https://bananarana8.itch.io/pixel-art-explosion-effect",
	"https://pixabay.com/sound-effects/immersivecontrol-button-click-sound-463065/",
	"https://pixabay.com/sound-effects/film-special-effects-mp5-168858/",
	"https://pixabay.com/sound-effects/film-special-effects-072803-semi-auto-pistol-26934/",
	"https://pixabay.com/sound-effects/film-special-effects-perdition-1911-pistol-82365/",
	"https://pixabay.com/sound-effects/film-special-effects-gunfire-single-shot-colt-peacemaker-94951/",
	"https://pixabay.com/sound-effects/film-special-effects-ar15-168855/",
	"https://pixabay.com/sound-effects/film-special-effects-beretta-92fs-168853/",
	"https://opengameart.org/content/animated-top-down-survivor-player",
	"https://marketplace.gamemaker.io/assets/1356/developer-console",
	
	
	
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


