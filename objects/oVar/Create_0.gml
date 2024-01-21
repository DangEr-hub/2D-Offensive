global.my_console = console_create();
global.InventoryLeftTopCorner = [-1, -1];
global.InventoryRightBottomCorner = [-1, -1];
global.FlashBangMaxDistance = 512;
global.DynamicCrosshair = false;
global.CrosshairAlpha = 1;
global.weapon_id = [Item.None, Item.None, Item.None];
global.InventorySize = 26;
global.Ammo = [0, 0, 0];
global.MaxAmmo = [0, 0, 0];
global.ClipAmmo = [0, 0, 0];
global.BulletSpeed = 75;
global.DrawBulletImpact = false;
global.AdminHUD = false;
global.HitBoxAlpha = .1;
global.EnemyCanMove = true;
global.GodMode = false;
global.Hostage = false;
global.ConsoleHeight = 256;
global.ConsoleWidth = 512;
global.GoldColor = make_color_rgb(255, 215, 0);
global.GUIHUDAlpha = .33;
global.ArmourDurability = [0, 0];
global.ArmourID = [Item.None, Item.None];
global.CameraWidth = 960;
global.CameraHeight = 540;
global.FieldOfView = 15;
global.BloomShader = true;
global.TimeSpeed = 15;
global.ViewShake = true;
global.PlayerInaccuracy = 1;
global.DrawParticles = true;
global.sound_gain = 100;
global.ranked_game = false;
global.hard_mode = false;
global.window_width = 1920;
global.window_height = 1080;
global.draw_other_models = false;
global.Weather = "sun";
global.crosshair_color = c_white;

global.player_stats_struct = {
	All_shots: 0,
	Headshots: 0,
	Kills: 0,
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
	Money: 0,
	Weight: 0,
	Max_weight: 15,
	Armour: 0
	
};
global.player_elo_struct = ini_player_struct_create();










global.GUIMultiplier = display_get_width()/global.CameraWidth;
camera_set_view_size(view_camera[0], global.CameraWidth, global.CameraHeight);

enum icons{
	health, stamina, xp, kills, deaths, armour, kd, headshot_percentage, accuracy, total	
}

enum weapon_attachments{
	weapon_scope, weapon_barrel, weapon_grip, weapon_suppressor, Total
}

for (var i = 0; i < 2; i++) {
    global.weapon_attachments[i] = array_create(weapon_attachments.Total, Item.None);
}


enum MapProperty{
	MapStartColor, MapEndColor, MapStartIntensity, MapEndIntensity, MapPeakIntensity, MapStartHours, MapEndHours, Total
}

enum MapIndex{
	Desert, RainForest, Total
}

global.MapID = MapIndex.Desert;
global.MapProperties = ds_grid_create(MapIndex.Total, MapProperty.Total);
global.MapProperties[#MapIndex.Desert, MapProperty.MapStartColor] = $FFFFFFFF;
global.MapProperties[#MapIndex.Desert, MapProperty.MapEndColor] = $FF00FFFF;
global.MapProperties[#MapIndex.Desert, MapProperty.MapStartIntensity] = 0.75;
global.MapProperties[#MapIndex.Desert, MapProperty.MapEndIntensity] = 0.1;
global.MapProperties[#MapIndex.Desert, MapProperty.MapPeakIntensity] = 1.3;
global.MapProperties[#MapIndex.Desert, MapProperty.MapStartHours] = 7 * 60;
global.MapProperties[#MapIndex.Desert, MapProperty.MapEndHours] = 22 * 60;

global.MapProperties[#MapIndex.RainForest, MapProperty.MapStartColor] = $FFFFFFFF;
global.MapProperties[#MapIndex.RainForest, MapProperty.MapEndColor] = $FF00FFFF;
global.MapProperties[#MapIndex.RainForest, MapProperty.MapStartIntensity] = 0.75;
global.MapProperties[#MapIndex.RainForest, MapProperty.MapEndIntensity] = 0.5;
global.MapProperties[#MapIndex.RainForest, MapProperty.MapPeakIntensity] = 1.5;
global.MapProperties[#MapIndex.RainForest, MapProperty.MapStartHours] = 10 * 60;
global.MapProperties[#MapIndex.RainForest, MapProperty.MapEndHours] = 20 * 60;



enum KeyBind{
	KeyUp, KeyLeft, KeyDown, KeyRight, KeyDropMouse, KeyDrop, KeyInventory, KeyPickUp, KeyCycleLeft, KeyCycleRight, KeyUse, KeyShootMouse,
	KeyReload, KeyRunning, KeyGrenadeThrowMouse, KeyPause, KeyToggleNightVision, KeyChangeMode, KeyProne, KeyWeaponAttachments, Total	
}

global.KeyBinds = ds_list_create();
ds_list_add(
	global.KeyBinds, ord("W"), ord("A"), ord("S"), ord("D"),
	mb_right, vk_shift, ord("I"), ord("G"), ord("Q"), ord("E"),
	ord("F"), mb_left, ord("R"), vk_shift, mb_left, vk_escape,
	ord("N"), ord("V"), ord("Y"), ord("T")
);

enum player_textures{
	no_weapon, pistol, assault_rifle, death, flashed_weapon, flashed_no_weapon, reload, 
	prone, prone_second, prone_third, flashed_prone, flashed_prone_second, flashed_prone_third, 
	reload_prone, reload_prone_second, reload_prone_third
}

enum player_states{
	none_state,
	running_state,
	prone_state
}

enum HitBox{
	Head,
	HeadProne,
	BodyWithoutWeapon,
	BodyWithWeapon,
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
	LegProne_third
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
	MoveHealing
}

enum Hit{
	Hits, Damage, Total
}

display_set_gui_size(1920, 1080);
global.GuiW = display_get_gui_width();
global.GuiH = display_get_gui_height();

rank_database();
window_set_fullscreen(true);
InventoryInit();
load_game();
console_settings(global.my_console," ",false);
console_preset(global.my_console);
room_goto_next();