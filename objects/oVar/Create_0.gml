randomize();
global.my_console = console_create();
global.gold_color = make_color_rgb(255, 215, 0);
global.clear_particles_timer = 10 * game_get_speed(gamespeed_fps);
global.aberration_level = 0;
global.saturation_level = 1.9;
global.InventoryEquipLeftTopCorner = [-1, -1];
global.InventoryEquipRightBottomCorner = [-1, -1];
global.InventoryLeftTopCorner = [-1, -1];
global.InventoryRightBottomCorner = [-1, -1];
global.FlashBangMaxDistance = 512;
global.DynamicCrosshair = false;
global.CrosshairAlpha = 1;
global.BulletSpeed = 75;
global.DrawBulletImpact = false;
global.AdminHUD = false;
global.HitBoxAlpha = .1;
global.EnemyCanMove = true;
global.GodMode = false;
global.Hostage = false;
global.ConsoleHeight = 256;
global.ConsoleWidth = 512;
global.GUIHUDAlpha = .33;
global.FieldOfView = 10;
global.BloomShader = true;
global.TimeSpeed = 15;
global.ViewShake = true;
global.PlayerInaccuracy = 1;
global.DrawParticles = true;
global.CameraWidth = 1920/2;
global.CameraHeight = 1080/2;
global.GUIMultiplier = clamp(display_get_width()/global.CameraWidth, 1, 2);
global.selected_bots = ds_list_create();
global.current_selected_bot = -1;
global.enemy_visibility = false;
global.anti_aliasing = 0;
global.sound_gain = 100;
global.ranked_game = false;
global.hard_mode = false;
global.window_width = 1920;
global.window_height = 1080;
global.draw_other_models = false;
global.Weather = "sun";
global.crosshair_color = c_white;
global.sound_emitters = ds_map_create();
display_set_gui_size(1920, 1080);
global.GuiW = display_get_gui_width();
global.GuiH = display_get_gui_height();

global.player_stats_struct = {
	Name: "DangEr",
	All_shots: 0,
	Headshots: 0,
	Kills: 0,
	Hit_shots: 0,
	Deaths: 0,
    Get_KD: function() {
        return (Deaths != 0) ? (Kills / Deaths) : 0;
    },
	Get_headshot_percentage: function() {
		return (Kills != 0) ? (Headshots / Kills) * 100 : 0;
	},
	Get_accuracy: function() {
		return (All_shots != 0) ? Hit_shots / All_shots * 100 : 0;
	},
	Xp: 0,
	Max_xp: 50,
	Max_health: 100,
	Max_stamina: 100,
	Lvl: 1,
	Skill_points: 0,
	Unskill_points: 0,
	Money: 1000,
	Weight: 0,
	Max_weight: 15,
	Armour: 0
	
};
global.player_elo_struct = ini_player_struct_create();

enum icons{
	none, health, stamina, xp, kills, deaths, armour, kd, headshot_percentage, accuracy, time, game, tracking, total
}

enum weapon_attachments{
	weapon_scope, weapon_barrel, weapon_grip, weapon_suppressor, Total
}

for (var i = 0; i < 3; i++) {
    global.weapon_attachments[i] = array_create(weapon_attachments.Total, Item.None);
}


enum MapProperty{
	MapStartColor, MapEndColor, MapStartIntensity, MapEndIntensity, MapPeakIntensity, MapStartHours, MapEndHours, Name, SpawnAreas, MaxEnemies, Total
}

enum MapIndex{
	Desert, RainForest, City, Nuclear, Total
}

global.map_rounds = [];
for (var i = 0; i < MapIndex.Total; i++) {
    global.map_rounds[i] = [];
    
    for (var j = 0; j < 3; j++) {
        global.map_rounds[i][j] = -1;
    }
}


global.MapID = -1;
global.MapProperties = ds_grid_create(MapIndex.Total, MapProperty.Total);
global.MapProperties[#MapIndex.Desert, MapProperty.Name] = "Desert";
global.MapProperties[#MapIndex.Desert, MapProperty.MapStartColor] = make_color_rgb(178, 141, 35);
global.MapProperties[#MapIndex.Desert, MapProperty.MapEndColor] = make_color_rgb(229, 181, 45);
global.MapProperties[#MapIndex.Desert, MapProperty.MapStartIntensity] = .25;
global.MapProperties[#MapIndex.Desert, MapProperty.MapEndIntensity] = 0;
global.MapProperties[#MapIndex.Desert, MapProperty.MapPeakIntensity] = .8;
global.MapProperties[#MapIndex.Desert, MapProperty.MapStartHours] = 7 * 60;
global.MapProperties[#MapIndex.Desert, MapProperty.MapEndHours] = 22 * 60;
global.MapProperties[#MapIndex.Desert, MapProperty.MaxEnemies] = 100;

var desert_spawn_areas = ds_map_create();
ds_map_add(desert_spawn_areas, "area1", [800, 800, 1300, 1000, 2]);
ds_map_add(desert_spawn_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(desert_spawn_areas, "area3", [900, 100, 1900, 500, 5]);
ds_map_add(desert_spawn_areas, "area4", [2300, 400, 3000, 1000, 5]);
ds_map_add(desert_spawn_areas, "area5", [2000, 1000, 2900, 1500, 5]);
global.MapProperties[# MapIndex.Desert, MapProperty.SpawnAreas] = desert_spawn_areas;

global.MapProperties[#MapIndex.RainForest, MapProperty.MapStartColor] = MAIN_COLOR;
global.MapProperties[#MapIndex.RainForest, MapProperty.Name] = "Rain forest";
global.MapProperties[#MapIndex.RainForest, MapProperty.MapStartColor] = make_color_rgb(229, 181, 45);
global.MapProperties[#MapIndex.RainForest, MapProperty.MapEndColor] = make_color_rgb(229, 199, 114);
global.MapProperties[#MapIndex.RainForest, MapProperty.MapStartIntensity] = 0.5;
global.MapProperties[#MapIndex.RainForest, MapProperty.MapEndIntensity] = 0.25;
global.MapProperties[#MapIndex.RainForest, MapProperty.MapPeakIntensity] = 0.75;
global.MapProperties[#MapIndex.RainForest, MapProperty.MapStartHours] = 10 * 60;
global.MapProperties[#MapIndex.RainForest, MapProperty.MapEndHours] = 20 * 60;

global.MapProperties[#MapIndex.City, MapProperty.MapStartColor] = c_white;
global.MapProperties[#MapIndex.City, MapProperty.Name] = "City";
global.MapProperties[#MapIndex.City, MapProperty.MapEndColor] = c_orange;
global.MapProperties[#MapIndex.City, MapProperty.MapStartIntensity] = 0.75;
global.MapProperties[#MapIndex.City, MapProperty.MapEndIntensity] = 0.5;
global.MapProperties[#MapIndex.City, MapProperty.MapPeakIntensity] = 1.5;
global.MapProperties[#MapIndex.City, MapProperty.MapStartHours] = 10 * 60;
global.MapProperties[#MapIndex.City, MapProperty.MapEndHours] = 20 * 60;

global.MapProperties[#MapIndex.Nuclear, MapProperty.MapStartColor] = c_white;
global.MapProperties[#MapIndex.Nuclear, MapProperty.Name] = "Nuclear";
global.MapProperties[#MapIndex.Nuclear, MapProperty.MapEndColor] = c_orange;
global.MapProperties[#MapIndex.Nuclear, MapProperty.MapStartIntensity] = 0.75;
global.MapProperties[#MapIndex.Nuclear, MapProperty.MapEndIntensity] = 0.5;
global.MapProperties[#MapIndex.Nuclear, MapProperty.MapPeakIntensity] = 1.5;
global.MapProperties[#MapIndex.Nuclear, MapProperty.MapStartHours] = 10 * 60;
global.MapProperties[#MapIndex.Nuclear, MapProperty.MapEndHours] = 20 * 60;



enum KeyBind{
	KeyUp, KeyLeft, KeyDown, KeyRight,
	KeyInventory, KeyPickUp, KeyCycleLeft,
	KeyCycleRight, KeyCycleUp, KeyShootMouse, KeyReload,
	KeyGrenadeThrowMouse, KeyPause, KeyToggleNightVision, KeyChangeMode,
	KeyProne, KeyWeaponAttachments, KeyCommand, KeyGo, 
	KeyBuyMenu, KeyHoldStamina, KeyDropWeapon, KeyCycleDown, 
	KeyCycleInvLeft, KeyCycleInvRight, KeyCycleInvUp, KeyCycleInvDown,
	Total
}

global.KeyBinds = ds_list_create();
ds_list_add(
	global.KeyBinds, 
	ord("W"), ord("A"), ord("S"), ord("D"),
	ord("I"), vk_space, ord("Q"), 
	ord("E"), ord("F"), mb_left, ord("R"),
	mb_left, vk_escape, ord("N"), ord("V"),
	ord("Y"), ord("T"), ord("X"), ord("H"),
	ord("B"), vk_shift, ord("G"), ord("C"),
	ord("A"), ord("D"), ord("W"), ord("S"),
);

enum player_textures{
	no_weapon, pistol, assault_rifle, death, flashed_weapon, flashed_no_weapon, reload, 
	prone, prone_second, prone_third, flashed_prone, flashed_prone_second, flashed_prone_third, 
	reload_prone, reload_prone_second, reload_prone_third, knife_prone, knife_prone_second, knife_prone_third, knife
}

enum player_states{
	none_state,
	prone_state,
	machine_gun_state,
	mortar_state
}

enum HitBox{
	Head,
	HeadProne,
	BodyWithoutWeapon,
	BodyReloading,
	BodyProne,
	ArmWithoutWeapon,
	ArmWithPistol,
	ArmWithAssaultRifle,
	ArmWithWeaponFlashed,
	ArmWithoutWeaponFlashed,
	ArmReloading,
	ArmProne,
	ArmProneFlashed,
	ArmProneReloading,
	LegProne,
	LegProne_second,
	LegProne_third,
	ArmKnife,
	ArmProneKnife,
}

enum States{
	Idle,
	MoveShoot,
	Move,
	Chase,
	Death,
	MoveAway,
	MoveAwayFromGrenade,
	MoveToward,
	ThrowGrenade,
	MoveFlashed,
	MoveInSmoke,
	LayDownLandMine,
	MoveHealing,
	MoveTowardPoint,
	MovePredictive,
	NoMove
}

enum Hit{
	Hits, Damage, Total
}

rank_database();
InventoryInit();
load_game();
console_settings(global.my_console," ",false);
console_preset(global.my_console);
audio_master_gain(global.sound_gain/100);
room_goto_next();