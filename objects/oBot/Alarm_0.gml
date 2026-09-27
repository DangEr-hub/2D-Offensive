/// @description Post-create event
equipment_level = EQUIPMENT_LEVEL.FIRST;
if(global.ranked_game == false){
	ArmourID = choose(ITEM.None, ITEM.KevlarVest, ITEM.MilitaryVest, ITEM.SpecOpsVest);
	HelmetID = choose(ITEM.None, ITEM.KevlarHelm, ITEM.MilitaryHelm, ITEM.SpecOpsHelm);
}else{
	var streak_team_index = global.local_player.stats.Team - TEAM.POLICE;
	var lost_rounds = global.game_struct.Loss_streak[streak_team_index];
	var won_rounds = global.game_struct.Win_streak[streak_team_index];
	if(global.game_struct.Current_round <= 0){
		LandMines = [0, 0, 0];
		Grenades = [1, 1, 1, 1]; //HEGrenades, FlashGrenades, SmokeGrenades, MolotovGrenades
		// First round equipment
		equipment_level = EQUIPMENT_LEVEL.FIRST;
		/*WeaponID[0] = choose(ITEM.None, ITEM.MAC11);
		WeaponID[1] = choose(ITEM.Glock, ITEM.DesertEagle, ITEM.usp, ITEM.p250, ITEM.tec9*/
		ArmourID = percent_chance(75) ? ITEM.None : ITEM.KevlarVest;
		HelmetID = ITEM.None;
	}else{
		if(lost_rounds == 2 || won_rounds >= 3){
			equipment_level = stats.Team == global.local_player.stats.Team ? EQUIPMENT_LEVEL.LOW : EQUIPMENT_LEVEL.HIGH;
			// Equipment if player lost two last rounds or won three or more last rounds (1nd best equipment)
			/*WeaponID[0] = choose(ITEM.SG550, ITEM.AKM, ITEM.SSG08, ITEM.Spas, ITEM.m4a1, ITEM.awm, ITEM.galil, ITEM.MK18, ITEM.famas);
			WeaponID[1] = choose(ITEM.DesertEagle, ITEM.CZ75, ITEM.tec9);*/
			ArmourID = percent_chance(75) ? ITEM.MilitaryVest : ITEM.SpecOpsVest; 
			HelmetID = percent_chance(75) ? ITEM.MilitaryHelm : ITEM.SpecOpsHelm;
		}else if(lost_rounds >= 4 || won_rounds == 1){
			equipment_level = stats.Team == global.local_player.stats.Team ? EQUIPMENT_LEVEL.HIGH : EQUIPMENT_LEVEL.LOW;
			// Equipment if player lost three last rounds or won one last round (3nd best equipment)
			/*WeaponID[0] = choose(ITEM.None, ITEM.SG550, ITEM.AKM, ITEM.SSG08, ITEM.Spas, ITEM.m4a1, ITEM.awm, ITEM.galil, ITEM.MK18, ITEM.famas);
			WeaponID[1] = choose(ITEM.Glock, ITEM.usp, ITEM.DesertEagle, ITEM.p250, ITEM.CZ75, ITEM.tec9);*/
			ArmourID = percent_chance(75) ? ITEM.KevlarVest : ITEM.None;
			HelmetID = percent_chance(75) ? ITEM.KevlarHelm : ITEM.None;
		}else{
			// Equipment if player lost one last round or won last two rounds (2nd best equipment)
			equipment_level = EQUIPMENT_LEVEL.MED;
			ArmourID = choose(ITEM.KevlarVest, ITEM.MilitaryVest);
			HelmetID = choose(ITEM.KevlarHelm, ITEM.MilitaryHelm);
		}
	}
	if (equipment_level == EQUIPMENT_LEVEL.FIRST && percent_chance(75)) {
	    WeaponID[0] = ITEM.None;
	} else {
	    WeaponID[0] = choose_weighted_weapon(
	        equipment_level,
	        WEAPON_TYPE.PRIMARY
	    );
	}

	WeaponID[1] = choose_weighted_weapon(
	    equipment_level,
	    WEAPON_TYPE.SECONDARY
	);
}

ShieldID = ITEM.None;

#region Attachments
for(var weapon_slot = 0; weapon_slot < 2; weapon_slot++){
	var preattached = global.ItemIndex[# WeaponID[weapon_slot], ITEMSTATS.preattached];
	if(is_struct(preattached)){
		attachments[weapon_slot][ATTACHMENTS.scope] = preattached[$ "scope"] ?? ITEM.None;
		attachments[weapon_slot][ATTACHMENTS.barrel] = preattached[$ "barrel"] ?? ITEM.None;
		attachments[weapon_slot][ATTACHMENTS.grip] = preattached[$ "grip"] ?? ITEM.None;
		attachments[weapon_slot][ATTACHMENTS.suppressor] = preattached[$ "suppressor"] ?? ITEM.None;
	}
}

if(percent_chance(10 * rank_boost)){
	weapon_attachment_equip(ITEM.suppressor, ATTACHMENTS.suppressor, id, choose(0, 1));
}

if(percent_chance(10 * rank_boost)){
	var barrel_item = choose(ITEM.adaptive_chambering, ITEM.range_finder, ITEM.laser);
	weapon_attachment_equip(barrel_item, ATTACHMENTS.barrel, id, choose(0, 1));
}

if(percent_chance(10 * rank_boost)){
	var grip_item = choose(ITEM.vertical_grip, ITEM.horizontal_grip, ITEM.bipod);
	weapon_attachment_equip(grip_item, ATTACHMENTS.grip, id, choose(0, 1));
}

if(percent_chance(10 * rank_boost)){
	var scope_item = choose(ITEM.red_dot_scope, ITEM.two_scope);
	weapon_attachment_equip(scope_item, ATTACHMENTS.scope, id, 0);
}
#endregion

var equipment_cost = global.ItemIndex[# WeaponID[0], ITEMSTATS.Cost]
	+ global.ItemIndex[# WeaponID[1], ITEMSTATS.Cost]
	+ global.ItemIndex[# ArmourID, ITEMSTATS.Cost]
	+ global.ItemIndex[# HelmetID, ITEMSTATS.Cost];
stats.Money = max(0, stats.Money - equipment_cost);

Ammo[0] = global.ItemIndex[#WeaponID[0], ITEMSTATS.MaxAmmo];
ClipAmmo[0] = global.ItemIndex[#WeaponID[0], ITEMSTATS.ClipAmmo];
MaxAmmo[0] = global.ItemIndex[#WeaponID[0], ITEMSTATS.MaxAmmo];
Ammo[1] = global.ItemIndex[#WeaponID[1], ITEMSTATS.MaxAmmo];
ClipAmmo[1] = global.ItemIndex[#WeaponID[1], ITEMSTATS.ClipAmmo];
MaxAmmo[1] = global.ItemIndex[#WeaponID[1], ITEMSTATS.MaxAmmo];
ArmourDurability = [global.ItemIndex[#ArmourID, ITEMSTATS.BaseDurability], global.ItemIndex[#HelmetID, ITEMSTATS.BaseDurability], global.ItemIndex[# ShieldID, ITEMSTATS.BaseDurability]];	












