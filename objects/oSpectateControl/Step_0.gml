if(!instance_exists(global.local_player) || global.local_player.stats.Health_points > 0){
	instance_destroy();
	exit;
}

if(!instance_exists(oGameController) || !oGameController.round_ended){
	var living_teammate_found = false;
	for(var bot_index = 0; bot_index < array_length(candidate_bots); bot_index++){
		var candidate_bot = candidate_bots[bot_index];
		if(instance_exists(candidate_bot) && candidate_bot.stats.Team == global.local_player.stats.Team && candidate_bot.stats.Health_points > 0){
			living_teammate_found = true;
			break;
		}
	}
	if(!living_teammate_found){
		if(global.local_player.stats.Team != TEAM.TERRORIST
		|| (!global.bomb_planted && !oDraw.bomb_detonation_pending)){
			round_end("Loss");
			exit;
		}
		if(!global.sudo) exit;
	}
}

if(!oDraw.spectating) exit;

instance_activate_region(
	camera_get_view_x(CAM) - ACTIVATE_MARGIN,
	camera_get_view_y(CAM) - ACTIVATE_MARGIN,
	camera_get_view_width(CAM) + 2 * ACTIVATE_MARGIN,
	camera_get_view_height(CAM) + 2 * ACTIVATE_MARGIN,
	true
);

if(!instance_exists(oDraw.spectate_target) || oDraw.spectate_target.stats.Health_points <= 0){
	if(!select_next_bot()) show_menu();
	exit;
}

if(mouse_check_button_pressed(mb_left) && device_mouse_y_to_gui(0) < global.GuiH * .78){
	select_next_bot();
}

if(instance_exists(oGameController) && oGameController.round_ended) exit;
if(!keyboard_check_pressed(global.KeyBinds[| KEY.TakeBot])) exit;

var bot = oDraw.spectate_target;
var player = global.local_player;
if(!instance_exists(bot) || bot.stats.Health_points <= 0 || bot.stats.Team != player.stats.Team) exit;

var taken_machine_gun = bot.machine_gun_object;
var taken_prone = bot.State == STATES.Prone;
if(bot.State == STATES.MACHINE_GUN || instance_exists(bot.machine_gun_object)){
	with(bot) bot_release_machine_gun();
}

for(var weapon_slot = 0; weapon_slot < 2; weapon_slot++){
	var weapon_id = bot.WeaponID[weapon_slot];
	if(weapon_id != ITEM.None){
		insert_item_to_slot(OtherSlot.Primary + weapon_slot, weapon_id, 1,
			bot.Ammo[weapon_slot], bot.ClipAmmo[weapon_slot],
			global.ItemIndex[# weapon_id, ITEMSTATS.BaseDurability],
			bot.attachments[weapon_slot][ATTACHMENTS.scope],
			bot.attachments[weapon_slot][ATTACHMENTS.barrel],
			bot.attachments[weapon_slot][ATTACHMENTS.grip],
			bot.attachments[weapon_slot][ATTACHMENTS.suppressor], "Weapon");
	}
}

if(bot.ArmourID != ITEM.None){
	insert_item_to_slot(OtherSlot.Armour, bot.ArmourID, 1, 0, 0, bot.ArmourDurability[0],
		ITEM.None, ITEM.None, ITEM.None, ITEM.None, "Armour");
}
if(bot.HelmetID != ITEM.None){
	insert_item_to_slot(OtherSlot.Helmet, bot.HelmetID, 1, 0, 0, bot.ArmourDurability[1],
		ITEM.None, ITEM.None, ITEM.None, ITEM.None, "Helmet");
}

var grenade_ids = [ITEM.HEGrenade, ITEM.flashbang, ITEM.smoke, ITEM.molotov];
for(var grenade_index = 0; grenade_index < array_length(grenade_ids); grenade_index++){
	if(bot.Grenades[grenade_index] > 0){
		gain_item(grenade_ids[grenade_index], bot.Grenades[grenade_index], 0, 0, 0,
			ITEM.None, ITEM.None, ITEM.None, ITEM.None, false);
	}
}

var landmine_ids = [ITEM.HELandMine, ITEM.CELandMine, ITEM.LELandMine];
for(var landmine_index = 0; landmine_index < array_length(landmine_ids); landmine_index++){
	if(bot.LandMines[landmine_index] > 0){
		gain_item(landmine_ids[landmine_index], bot.LandMines[landmine_index], 0, 0, 0,
			ITEM.None, ITEM.None, ITEM.None, ITEM.None, false);
	}
}

global.player_stats.Weight = 0;
for(var inventory_slot = 0; inventory_slot < OtherSlot.Total; inventory_slot++){
	var item_id = global.Inventory[# inventory_slot, INDEX.slot_id];
	if(item_id != ITEM.None){
		global.player_stats.Weight += global.ItemIndex[# item_id, ITEMSTATS.Weight];
	}
}
global.player_stats.Weight = min(global.player_stats.Weight, global.player_stats.Max_weight);

player.x = bot.x;
player.y = bot.y;
player.RotationAngle = bot.RotationAngle;
player.sprite_index = bot.sprite_index;
player.image_index = taken_prone ? TEXTURES.prone : TEXTURES.no_weapon;
player.depth -= 1;
player.visible = true;
player.Visible = true;
if(instance_exists(player.Legs)){
	player.Legs.Visible = true;
	player.Legs.visible = true;
}
if(instance_exists(player.Knife)) player.Knife.visible = true;
player.stats.Health_points = bot.stats.Health_points;
player.stats.Max_health_points = bot.stats.Max_health_points;
player.stats.Damage_health_points = bot.stats.Health_points;
player.stats.Stamina_points = bot.stats.Stamina_points;
player.stats.Damage_stamina_points = bot.stats.Stamina_points;
player.WeaponNumber = bot.WeaponPositionID;
player.WeaponID = OtherSlot.Primary + bot.WeaponPositionID;
if(global.Inventory[# player.WeaponID, INDEX.slot_id] == ITEM.None){
	player.WeaponID = global.Inventory[# OtherSlot.Primary, INDEX.slot_id] != ITEM.None
		? OtherSlot.Primary : OtherSlot.Secondary;
	player.WeaponNumber = player.WeaponID - OtherSlot.Primary;
}
player.weapon_shooting_mode = 0;
player.moving_state = taken_prone ? STATES_PLAYER.prone_state : STATES_PLAYER.none_state;
player.LegHB.visible = taken_prone;
player.Legs.visible = !taken_prone;
player.WX = taken_prone ? 64 : 8;
player.WY = taken_prone ? 64 : 8;
if(taken_prone){
	player.HeadHB.image_index = HITBOX.HeadProne;
	player.BodyHB.image_index = HITBOX.BodyProne;
	player.ArmHB.image_index = HITBOX.ArmProne;
	player.LegHB.image_index = HITBOX.LegProne;
}
player.Reloading = false;
player.ReloadTime = 0;
player.ReloadTimer = -1;
player.equip_timer = -1;
player.shooting = false;
player.CanShoot = true;
player.ShootTimer = -1;
player.ScopeIn = false;
player.player_can_shoot = true;
player.death_handled = false;
player.selected_bot = noone;
player.bot_select_index = -1;

if(instance_exists(taken_machine_gun)){
	player.machine_gun_take_loadout = {
		gun: taken_machine_gun,
		primary: array_create(INDEX.Total, 0),
		weapon_slot: player.WeaponID
	};
	for(var slot_index = 0; slot_index < INDEX.Total; slot_index++){
		player.machine_gun_take_loadout.primary[slot_index] = global.Inventory[# OtherSlot.Primary, slot_index];
	}
	if(!mount_local_player_to_machine_gun(player, taken_machine_gun)){
		player.machine_gun_take_loadout = undefined;
	}
}

var bot_parts = [bot.Weapon, bot.Legs, bot.HeadHB, bot.BodyHB, bot.ArmHB, bot.LegHB];
for(var part_index = 0; part_index < array_length(bot_parts); part_index++){
	if(instance_exists(bot_parts[part_index])) instance_destroy(bot_parts[part_index]);
}
instance_destroy(bot);

with(objZUIMain) zui_destroy();
oDraw.spectating = false;
oDraw.spectate_target = noone;
oDraw.RespawnMenu = false;
oDraw.BackGround = -1;
oDraw.alarm[0] = -1;
instance_destroy();
