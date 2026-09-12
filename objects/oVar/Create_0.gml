randomize();
global.bomb_time = 5 * game_get_speed(gamespeed_fps);
global.player_character_seed = irandom(2147483646);
global.my_console = console_create();
global.unlocked_items = ds_list_create();
global.local_player = oPlayer;
global.sudo = false;
global.InventoryEquipLeftTopCorner = [-1, -1];
global.InventoryEquipRightBottomCorner = [-1, -1];
global.InventoryLeftTopCorner = [-1, -1];
global.InventoryRightBottomCorner = [-1, -1];
global.FlashBangMaxDistance = 512;
global.HitBoxAlpha = .1;
global.ConsoleHeight = 384;
global.ConsoleWidth = 768;
global.GUIHUDAlpha = .75;
global.FieldOfView = 10;
global.CameraWidth = 1920/2;
global.CameraHeight = 1080/2;
global.ranked_game = false;
global.hard_mode = false;
global.Weather = 0;
global.time_step = 1;
global.bomb_planted = false;
global.bomb_timer = 0;
global.bomb_planter_pid = -1;



global.cases_cost = {
	AR_cases: 12,
	Pistol_cases: 8,
	Sniper_cases: 14,
	Smg_cases: 10,
	Heavy_cases: 10
};

global.player_stats = {
	Name: "DangEr",
	All_shots: 0,
	Headshots: 0,
	Kills: 0,
	Assists: 0,
	Hit_shots: 0,
	Deaths: 0,
	Diamonds: 1000,
	AR_cases: 100,
	Pistol_cases: 100,
	Sniper_cases: 100,
	Smg_cases: 100,
	Heavy_cases: 100,
	Player_team: choose(TEAM.POLICE, TEAM.TERRORIST),
    Get_KD: function() {
        return (Deaths != 0) ? (Kills / Deaths) : 0;
    },
	Get_headshot_percentage: function() {
		return (Kills != 0) ? (Headshots / Kills) * 100 : 0;
	},
	Get_accuracy: function() {
		return (All_shots > 0) ? clamp(Hit_shots / All_shots * 100, 0, 100) : 0;
	},
	Xp: 0,
	Max_xp: 50,
	Max_health: 100,
	Max_stamina: 100,
	Lvl: 1,
	Skill_points: 0,
	Unskill_points: 0,
	Money: ROUND_STARTING_MONEY,
	Weight: 0,
	Max_weight: 15,
	Armour: 0,
	Gold: false,
	Magenta: false,
	Red: false,
	Aqua: false,
	Green: false,
	Gray: false,
	White: false
	
};
global.game_struct = game_struct_create();

enum ICON{
	none, health, stamina, xp, kills, deaths, armour, kd, headshot_percentage, accuracy, time, game, tracking, won_game, lost_game, tied_game, 
	ammo, assists, total
}

enum TEAM{
	NONE,
	POLICE,
	TERRORIST
}

enum ATTACHMENTS {
	slot_scope, slot_barrel, slot_grip, slot_suppressor	
};

enum CALIBER{
	GAUGES,
	LOW,
	MEDIUM,
	HIGH,
	ROCKET
}

enum RARITY{
	COMMON, UNCOMMON, RARE, LEGENDARY
}

enum MATERIAL{
	CONCRETE,
	METAL,
	WOOD,
	GLASS
}

enum WEAPON_CLASS {
	PISTOL = 1,
	ASSAULT_RIFLE,
	SHOTGUN,
	SNIPER_RIFLE,
	SUBMACHINE_GUN,
	MISSILE,
	MACHINE_GUN,
	KNIFE,
	SHIELD
}

enum WEAPON_TYPE {
	PRIMARY, SECONDARY, TERTIARY	
};

enum WPN_ATTACHMENTS{
	weapon_scope, weapon_barrel, weapon_grip, weapon_suppressor, Total
}

for (var i = 0; i < 3; i++) {
    global.weapon_attachments[i] = array_create(WPN_ATTACHMENTS.Total, Item.None);
}

enum WEATHER{
	SUN,
	RAIN,
	SNOW
}



enum MAP_STAT{
	MapStartColor, MapEndColor, MapStartIntensity, MapEndIntensity, MapPeakIntensity, MapStartHours, MapEndHours, Name, EnemyAreas, MaxEnemies, Tile,
	FriendAreas, MaxFriends, BombAreas, HostageAreas, Total
}

enum MAP{
	Desert, RainForest, City, Nuclear, Total
}

global.map_rounds = [];
for (var i = 0; i < MAP.Total; i++) {
    global.map_rounds[i] = [];
    
    for (var j = 0; j < 3; j++) {
        global.map_rounds[i][j] = -1;
    }
}


global.MapID = MAP.Desert;
global.BotMatchStats = [];
global.MapProperties = ds_grid_create(MAP.Total, MAP_STAT.Total);
global.MapProperties[# MAP.Desert, MAP_STAT.Name] = "Desert";
global.MapProperties[# MAP.Desert, MAP_STAT.MapStartColor] = make_color_rgb(208, 141, 35);
global.MapProperties[# MAP.Desert, MAP_STAT.MapEndColor] = make_color_rgb(249, 151, 25);
global.MapProperties[# MAP.Desert, MAP_STAT.MapStartIntensity] = .25;
global.MapProperties[# MAP.Desert, MAP_STAT.MapEndIntensity] = 0;
global.MapProperties[# MAP.Desert, MAP_STAT.MapPeakIntensity] = .7;
global.MapProperties[# MAP.Desert, MAP_STAT.MapStartHours] = 7 * 60;
global.MapProperties[# MAP.Desert, MAP_STAT.MapEndHours] = 22 * 60;
global.MapProperties[# MAP.Desert, MAP_STAT.MaxEnemies] = 100;
global.MapProperties[# MAP.Desert, MAP_STAT.MaxFriends] = 5;
global.MapProperties[# MAP.Desert, MAP_STAT.Tile] = spr_Desert;

var desert_enemy_areas = ds_map_create();
ds_map_add(desert_enemy_areas, "area1", [100, 750, 450, 1200, 4]); //x1, y1, x2, y2, enemy number
ds_map_add(desert_enemy_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(desert_enemy_areas, "area3", [900, 100, 1900, 500, 5]);
ds_map_add(desert_enemy_areas, "area4", [2300, 400, 3000, 1000, 5]);
ds_map_add(desert_enemy_areas, "area5", [2000, 1000, 2900, 1500, 5]);
var desert_friend_areas = ds_map_create();
ds_map_add(desert_friend_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(desert_friend_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(desert_friend_areas, "area3", [900, 100, 1900, 500, 5]);
global.MapProperties[# MAP.Desert, MAP_STAT.EnemyAreas] = desert_enemy_areas;
global.MapProperties[# MAP.Desert, MAP_STAT.FriendAreas] = desert_friend_areas;

var desert_bomb_areas = ds_map_create();
ds_map_add(desert_bomb_areas, "area1", [3300, 1800, 3800, 2200]); //x1, y1, x2, y2
ds_map_add(desert_bomb_areas, "area2", [2700, 0, 3800, 500]);
global.MapProperties[# MAP.Desert, MAP_STAT.BombAreas] = desert_bomb_areas;

var desert_hostage_areas = ds_map_create();
ds_map_add(desert_hostage_areas, "area1", [200, 1200, 500, 1400]); //x1, y1, x2, y2
ds_map_add(desert_hostage_areas, "area2", [800, 1700, 1000, 2000]);
global.MapProperties[# MAP.Desert, MAP_STAT.HostageAreas] = desert_hostage_areas;


global.MapProperties[# MAP.RainForest, MAP_STAT.Name] = "Rain forest";
global.MapProperties[# MAP.RainForest, MAP_STAT.MapStartColor] = make_color_rgb(180, 142, 35);
global.MapProperties[# MAP.RainForest, MAP_STAT.MapEndColor]   = make_color_rgb(180, 156, 90);
global.MapProperties[# MAP.RainForest, MAP_STAT.MapStartIntensity] = 0.4;
global.MapProperties[# MAP.RainForest, MAP_STAT.MapEndIntensity] = 0;
global.MapProperties[# MAP.RainForest, MAP_STAT.MapPeakIntensity] = 0.7;
global.MapProperties[# MAP.RainForest, MAP_STAT.MapStartHours] = 10 * 60;
global.MapProperties[# MAP.RainForest, MAP_STAT.MapEndHours] = 20 * 60;
global.MapProperties[# MAP.RainForest, MAP_STAT.MaxEnemies] = 100;
global.MapProperties[# MAP.RainForest, MAP_STAT.MaxFriends] = 5;
global.MapProperties[# MAP.RainForest, MAP_STAT.Tile] = spr_RainForest;

var rainforest_enemy_areas = ds_map_create();
ds_map_add(rainforest_enemy_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(rainforest_enemy_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(rainforest_enemy_areas, "area3", [900, 100, 1900, 500, 5]);
ds_map_add(rainforest_enemy_areas, "area4", [2300, 400, 3000, 1000, 5]);
ds_map_add(rainforest_enemy_areas, "area5", [2000, 1000, 2900, 1500, 5]);
var rainforest_friend_areas = ds_map_create();
ds_map_add(rainforest_friend_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(rainforest_friend_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(rainforest_friend_areas, "area3", [900, 100, 1900, 500, 5]);
global.MapProperties[# MAP.RainForest, MAP_STAT.EnemyAreas] = rainforest_enemy_areas;
global.MapProperties[# MAP.RainForest, MAP_STAT.FriendAreas] = rainforest_friend_areas;

var rainforest_bomb_areas = ds_map_create();
ds_map_add(rainforest_bomb_areas, "area1", [3300, 1800, 3800, 2200]); //x1, y1, x2, y2
ds_map_add(rainforest_bomb_areas, "area2", [2700, 0, 3800, 500]);
global.MapProperties[# MAP.RainForest, MAP_STAT.BombAreas] = rainforest_bomb_areas;

var rainforest_hostage_areas = ds_map_create();
ds_map_add(rainforest_hostage_areas, "area1", [200, 1200, 500, 1400]); //x1, y1, x2, y2
ds_map_add(rainforest_hostage_areas, "area2", [800, 1700, 1000, 2000]);
global.MapProperties[# MAP.RainForest, MAP_STAT.HostageAreas] = rainforest_hostage_areas;

global.MapProperties[# MAP.City, MAP_STAT.MapStartColor] = c_white;
global.MapProperties[# MAP.City, MAP_STAT.Name] = "City";
global.MapProperties[# MAP.City, MAP_STAT.MapEndColor] = c_orange;
global.MapProperties[# MAP.City, MAP_STAT.MapStartIntensity] = 0.75;
global.MapProperties[# MAP.City, MAP_STAT.MapEndIntensity] = 0.5;
global.MapProperties[# MAP.City, MAP_STAT.MapPeakIntensity] = 1.5;
global.MapProperties[# MAP.City, MAP_STAT.MapStartHours] = 10 * 60;
global.MapProperties[# MAP.City, MAP_STAT.MapEndHours] = 20 * 60;
global.MapProperties[# MAP.City, MAP_STAT.MaxEnemies] = 100;
global.MapProperties[# MAP.City, MAP_STAT.MaxFriends] = 5;

var city_enemy_areas = ds_map_create();
ds_map_add(city_enemy_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(city_enemy_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(city_enemy_areas, "area3", [900, 100, 1900, 500, 5]);
ds_map_add(city_enemy_areas, "area4", [2300, 400, 3000, 1000, 5]);
ds_map_add(city_enemy_areas, "area5", [2000, 1000, 2900, 1500, 5]);
var city_friend_areas = ds_map_create();
ds_map_add(city_friend_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(city_friend_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(city_friend_areas, "area3", [900, 100, 1900, 500, 5]);
global.MapProperties[# MAP.City, MAP_STAT.EnemyAreas] = city_enemy_areas;
global.MapProperties[# MAP.City, MAP_STAT.FriendAreas] = city_friend_areas;

var city_bomb_areas = ds_map_create();
ds_map_add(city_bomb_areas, "area1", [3300, 1800, 3800, 2200]); //x1, y1, x2, y2
ds_map_add(city_bomb_areas, "area2", [2700, 0, 3800, 500]);
global.MapProperties[# MAP.City, MAP_STAT.BombAreas] = city_bomb_areas;

var city_hostage_areas = ds_map_create();
ds_map_add(city_hostage_areas, "area1", [200, 1200, 500, 1400]); //x1, y1, x2, y2
ds_map_add(city_hostage_areas, "area2", [800, 1700, 1000, 2000]);
global.MapProperties[# MAP.City, MAP_STAT.HostageAreas] = city_hostage_areas;


global.MapProperties[# MAP.Nuclear, MAP_STAT.MapStartColor] = c_white;
global.MapProperties[# MAP.Nuclear, MAP_STAT.Name] = "Nuclear";
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapEndColor] = c_orange;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapStartIntensity] = 0.75;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapEndIntensity] = 0.5;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapPeakIntensity] = 1.5;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapStartHours] = 10 * 60;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapEndHours] = 20 * 60;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MaxEnemies] = 100;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MaxFriends] = 5;

var nuclear_enemy_areas = ds_map_create();
ds_map_add(nuclear_enemy_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(nuclear_enemy_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(nuclear_enemy_areas, "area3", [900, 100, 1900, 500, 5]);
ds_map_add(nuclear_enemy_areas, "area4", [2300, 400, 3000, 1000, 5]);
ds_map_add(nuclear_enemy_areas, "area5", [2000, 1000, 2900, 1500, 5]);
var nuclear_friend_areas = ds_map_create();
ds_map_add(nuclear_friend_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(nuclear_friend_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(nuclear_friend_areas, "area3", [900, 100, 1900, 500, 5]);
global.MapProperties[# MAP.Nuclear, MAP_STAT.EnemyAreas] = nuclear_enemy_areas;
global.MapProperties[# MAP.Nuclear, MAP_STAT.FriendAreas] = nuclear_friend_areas;

var nuclear_bomb_areas = ds_map_create();
ds_map_add(nuclear_bomb_areas, "area1", [3300, 1800, 3800, 2200]); //x1, y1, x2, y2
ds_map_add(nuclear_bomb_areas, "area2", [2700, 0, 3800, 500]);
global.MapProperties[# MAP.Nuclear, MAP_STAT.BombAreas] = nuclear_bomb_areas;

var nuclear_hostage_areas = ds_map_create();
ds_map_add(nuclear_hostage_areas, "area1", [200, 1200, 500, 1400]); //x1, y1, x2, y2
ds_map_add(nuclear_hostage_areas, "area2", [800, 1700, 1000, 2000]);
global.MapProperties[# MAP.Nuclear, MAP_STAT.HostageAreas] = nuclear_hostage_areas;



enum KEY{
	Up, Left, Down, Right,
	Inventory, PickUp, CycleLeft,
	CycleRight, ShootMouse, Reload,
	GrenadeThrowMouse, Pause, ToggleNightVision, ChangeMode,
	Prone, WeaponAttachments, SelectBot, CommandBot, 
	BuyMenu, DropWeapon, Console,
	KnifeLight, KnifeHeavy, UseItem, Scope,
	Scoreboard, HostageTake, Defuse, Door,
	BotInfo, Run, Walk,
	Total
}

global.KeyBinds = ds_list_create();
ds_list_add(
	global.KeyBinds, 
	ord("W"), ord("A"), ord("S"), ord("D"),
	ord("I"), vk_space, ord("Q"), 
	ord("E"), mb_left, ord("R"),
	mb_left, vk_escape, ord("N"), ord("V"),
	ord("Y"), ord("T"), ord("X"), ord("C"),
	ord("B"), ord("G"), 192,
	mb_left, mb_right, mb_left, mb_right,
	vk_tab, vk_space, vk_space, vk_space,
	vk_shift, vk_lcontrol, vk_shift
);

global.DefaultKeyBinds = ds_list_create();
ds_list_copy(global.DefaultKeyBinds, global.KeyBinds);

enum TEXTURES{
	no_weapon, pistol, assault_rifle, death, flashed_weapon, flashed_no_weapon, reload, //0-6
	prone, prone_second, prone_third, flashed_prone, flashed_prone_second, flashed_prone_third, //7-12
	reload_prone, reload_prone_second, reload_prone_third, knife_prone, knife_prone_second, knife_prone_third, //13-18
	grenade_prone, grenade_prone_second, grenade_prone_third, grenade_throw, knife_attack //19-23
}


enum STATES_PLAYER{
	none_state,
	prone_state,
	machine_gun_state,
	mortar_state
}

enum HITBOX{
	Head,
	HeadFlashed,
	HeadProne,
	BodyNoWeapon,
	BodyPistol,
	BodyAR,
	BodyThrowReload,
	BodyFlashedWeapon,
	BodyFlashedNoWeapon,
	BodyProne,
	ArmNoWeapon,
	ArmPistol,
	ArmAR,
	ArmThrowReload,
	ArmFlashedWeapon,
	ArmFlashedNoWeapon,
	ArmProne,
	ArmProneFlashed,
	ArmProneReloading,
	ArmKnife,
	ArmProneKnife,
	ArmProneGrenade,
	LegProne,
	LegProne_second,
	LegProne_third,
}

enum STATES{
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
	MovePredictive,
	MoveCommand,
	NoMove,
	FleeDanger,
	Prone,
	MACHINE_GUN,
	Walk
}

rank_database();
InventoryInit();
load_game();
display_set_gui_size(1920, 1080);
ui_scale_set_window_size(global.window_width, global.window_height);
global.GuiW = display_get_gui_width();
global.GuiH = display_get_gui_height();
console_settings(global.my_console," ",false);
console_preset(global.my_console);
audio_master_gain(global.sound_gain/100);
window_resize();
room_goto_next();
