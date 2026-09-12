/// @description Post-create event
equipment_level = EQUIPMENT_LEVEL.FIRST;
if(global.ranked_game == false){
	ArmourID = choose(Item.None, Item.KevlarVest, Item.MilitaryVest, Item.SpecOpsVest);
	HelmetID = choose(Item.None, Item.KevlarHelm, Item.MilitaryHelm, Item.SpecOpsHelm);
}else{
	var streak_team_index = global.local_player.stats.Team - TEAM.POLICE;
	var lost_rounds = global.game_struct.Loss_streak[streak_team_index];
	var won_rounds = global.game_struct.Win_streak[streak_team_index];
	if(global.game_struct.Current_round <= 0){
		// First round equipment
		equipment_level = EQUIPMENT_LEVEL.FIRST;
		/*WeaponID[0] = choose(Item.None, Item.MAC11);
		WeaponID[1] = choose(Item.Glock, Item.DesertEagle, Item.usp, Item.p250, Item.tec9*/
		ArmourID = percent_chance(75) ? Item.None : Item.KevlarVest;
		HelmetID = Item.None;
	}else{
		if(lost_rounds == 2 || won_rounds >= 3){
			equipment_level = stats.Team == global.local_player.stats.Team ? EQUIPMENT_LEVEL.LOW : EQUIPMENT_LEVEL.HIGH;
			// Equipment if player lost two last rounds or won three or more last rounds (1nd best equipment)
			/*WeaponID[0] = choose(Item.SG550, Item.AKM, Item.SSG08, Item.Spas, Item.m4a1, Item.awm, Item.galil, Item.MK18, Item.famas);
			WeaponID[1] = choose(Item.DesertEagle, Item.CZ75, Item.tec9);*/
			ArmourID = percent_chance(75) ? Item.MilitaryVest : Item.SpecOpsVest; 
			HelmetID = percent_chance(75) ? Item.MilitaryHelm : Item.SpecOpsHelm;
		}else if(lost_rounds >= 4 || won_rounds == 1){
			equipment_level = stats.Team == global.local_player.stats.Team ? EQUIPMENT_LEVEL.HIGH : EQUIPMENT_LEVEL.LOW;
			// Equipment if player lost three last rounds or won one last round (3nd best equipment)
			/*WeaponID[0] = choose(Item.None, Item.SG550, Item.AKM, Item.SSG08, Item.Spas, Item.m4a1, Item.awm, Item.galil, Item.MK18, Item.famas);
			WeaponID[1] = choose(Item.Glock, Item.usp, Item.DesertEagle, Item.p250, Item.CZ75, Item.tec9);*/
			ArmourID = percent_chance(75) ? Item.KevlarVest : Item.None;
			HelmetID = percent_chance(75) ? Item.KevlarHelm : Item.None;
		}else{
			// Equipment if player lost one last round or won last two rounds (2nd best equipment)
			equipment_level = EQUIPMENT_LEVEL.MED;
			ArmourID = choose(Item.KevlarVest, Item.MilitaryVest);
			HelmetID = choose(Item.KevlarHelm, Item.MilitaryHelm);
		}
	}
	if (equipment_level == EQUIPMENT_LEVEL.FIRST && percent_chance(75)) {
	    WeaponID[0] = Item.None;
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

ShieldID = Item.None;

#region Attachments
if(percent_chance(10 * rank_boost)){
	weapon_attachment_equip(Item.advanced_suppressor, ATTACHMENTS.slot_suppressor, id, choose(0, 1));
}

if(percent_chance(10 * rank_boost)){
	var barrel_item = choose(Item.adaptive_chambering, Item.range_finder);
	weapon_attachment_equip(barrel_item, ATTACHMENTS.slot_barrel, id, choose(0, 1));
}

if(percent_chance(10 * rank_boost)){
	var grip_item = choose(Item.vertical_grip, Item.horizontal_grip);
	weapon_attachment_equip(grip_item, ATTACHMENTS.slot_grip, id, choose(0, 1));
}

if(percent_chance(10 * rank_boost)){
	var scope_item = choose(Item.red_dot_scope, Item.two_scope);
	weapon_attachment_equip(scope_item, ATTACHMENTS.slot_scope, id, 0);
}
#endregion

var equipment_cost = global.ItemIndex[# WeaponID[0], ItemStat.Cost]
	+ global.ItemIndex[# WeaponID[1], ItemStat.Cost]
	+ global.ItemIndex[# ArmourID, ItemStat.Cost]
	+ global.ItemIndex[# HelmetID, ItemStat.Cost];
stats.Money = max(0, stats.Money - equipment_cost);

Ammo[0] = global.ItemIndex[#WeaponID[0], ItemStat.MaxAmmo];
ClipAmmo[0] = global.ItemIndex[#WeaponID[0], ItemStat.ClipAmmo];
MaxAmmo[0] = global.ItemIndex[#WeaponID[0], ItemStat.MaxAmmo];
Ammo[1] = global.ItemIndex[#WeaponID[1], ItemStat.MaxAmmo];
ClipAmmo[1] = global.ItemIndex[#WeaponID[1], ItemStat.ClipAmmo];
MaxAmmo[1] = global.ItemIndex[#WeaponID[1], ItemStat.MaxAmmo];
ArmourDurability = [global.ItemIndex[#ArmourID, ItemStat.BaseDurability], global.ItemIndex[#HelmetID, ItemStat.BaseDurability], global.ItemIndex[# ShieldID, ItemStat.BaseDurability]];	












