event_inherited();
tab_width = max(784 * global.GUIMultiplier, 1200);
tab_height = max(405 * global.GUIMultiplier, 590);
bw = 64 * global.GUIMultiplier;
bh = 32 * global.GUIMultiplier;
image_size = 64 * global.GUIMultiplier;

draw_set_font(set_font("GUI_small"));
zui_set_size(tab_width, tab_height);

text_h = string_height("a") * 1.1;

ar_cases_x = zui_get_width() * .075;
sniper_cases_x = zui_get_width() * .225;
pistol_cases_x = zui_get_width() * .375;
smg_cases_x = zui_get_width() * 0.525;
heavy_cases_x = zui_get_width() * 0.675;
cases_y = zui_get_height() * .175;

#region AR case
ar_case_callback = function(){
	var active = false;
	if(instance_exists(objUILottery)){
		with(objUILottery){
			if(lottery_active == false){
				zui_destroy();
			}else{
				active = true;
			}
		}
	}
	
	if(active == false){		
		with(zui_create(zui_get_width() * .2, zui_get_height() * .5, objUILottery)){
			zui_set_anchor(0, 0); 			
			lottery_weapon_pool = [
				Item.AKM,
				Item.MK18,
				Item.m4a1,
				Item.famas,
				Item.galil
			];
		}
		global.player_stats.AR_cases --;
	}
};

ar_count_str = "Assault rifles - " + string(global.player_stats.AR_cases) + "x";
ar_count = zui_create(ar_cases_x + bw/2 - string_width(ar_count_str)/2, cases_y - text_h*2, objUILabel);
with(ar_count){caption = oCasesTab.ar_count_str; }

with(zui_create(ar_cases_x + bw/2, cases_y, objUIImage)){
	zui_set_size(other.image_size, other.image_size);
	sprite = spr_Cases;
	sprite_image_index = 0;
	sprite_width_size = other.image_size;
	sprite_height_size = other.image_size;
}

ar_cost = zui_create(ar_cases_x + bw/2, cases_y + image_size/2.5, objUILabel);
with(ar_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(global.cases_cost.AR_cases); }


with(zui_create(ar_cases_x, cases_y + image_size/4 + text_h*1.5, objUIButton)){
	zui_set_anchor(0, 0);
	zui_set_size(other.bw, other.bh);

	caption = "Buy";
	callback = function(){
		if(global.player_stats.Diamonds >= global.cases_cost.AR_cases){
			global.player_stats.AR_cases += 1;	
			global.player_stats.Diamonds -= global.cases_cost.AR_cases;
		}
	};
}

with(zui_create(ar_cases_x, cases_y + image_size/4 + text_h*1.5 + bh*1.1, objUIButton)){
	zui_set_anchor(0, 0);
	zui_set_size(other.bw, other.bh);

	caption = "Open";
	callback = other.ar_case_callback;
}
#endregion

#region Sniper case
sniper_case_id = 1;
sniper_case_callback = function(){
	var active = false;
	if(instance_exists(objUILottery)){
		with(objUILottery){
			if(lottery_active == false){
				zui_destroy();
			}else{
				active = true;
			}
		}
	}
	
	if(active == false){		
		with(zui_create(zui_get_width() * .2, zui_get_height() * .5, objUILottery)){
			zui_set_anchor(0, 0); 			
			lottery_weapon_pool = [
				Item.awm,
				Item.SSG08,
				Item.Dragunov
			];
		}
		global.player_stats.Sniper_cases --;
	}
};

sniper_count_str = "Sniper rifles - " + string(global.player_stats.Sniper_cases) + "x";
sniper_count = zui_create(sniper_cases_x + bw/2 - string_width(sniper_count_str)/2, cases_y - text_h*2, objUILabel);
with(sniper_count){caption = oCasesTab.sniper_count_str; }

with(zui_create(sniper_cases_x + bw/2, cases_y, objUIImage)){
	zui_set_size(other.image_size, other.image_size);
	sprite = spr_Cases;
	sprite_image_index = oCasesTab.sniper_case_id;
	sprite_width_size = other.image_size;
	sprite_height_size = other.image_size;
}

sniper_cost = zui_create(sniper_cases_x + bw/2, cases_y + image_size/2.5, objUILabel);
with(sniper_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(global.cases_cost.Sniper_cases); }


with(zui_create(sniper_cases_x, cases_y + image_size/4 + text_h*1.5, objUIButton)){
	zui_set_anchor(0, 0);
	zui_set_size(other.bw, other.bh);

	caption = "Buy";
	callback = function(){
		if(global.player_stats.Diamonds >= global.cases_cost.Sniper_cases){
			global.player_stats.Sniper_cases += 1;	
			global.player_stats.Diamonds -= global.cases_cost.Sniper_cases;
		}
	};
}

with(zui_create(sniper_cases_x, cases_y + image_size/4 + text_h*1.5 + bh*1.1, objUIButton)){
	zui_set_anchor(0, 0);
	zui_set_size(other.bw, other.bh);

	caption = "Open";
	callback = other.sniper_case_callback;
}
#endregion


#region Pistol case
pistol_case_id = 2;
pistol_case_callback = function(){
	var active = false;
	if(instance_exists(objUILottery)){
		with(objUILottery){
			if(lottery_active == false){
				zui_destroy();
			}else{
				active = true;
			}
		}
	}
	
	if(active == false){		
		with(zui_create(zui_get_width() * .2, zui_get_height() * .5, objUILottery)){
			zui_set_anchor(0, 0); 			
			lottery_weapon_pool = [
				Item.Glock,
				Item.usp,
				Item.DesertEagle,
				Item.p250,
				Item.tec9,
				Item.p250
			];
		}
		global.player_stats.Pistol_cases --;
	}
};

pistol_count_str = "Pistols - " + string(global.player_stats.Pistol_cases) + "x";
pistol_count = zui_create(pistol_cases_x + bw/2 - string_width(pistol_count_str)/2, cases_y - text_h*2, objUILabel);
with(pistol_count){caption = oCasesTab.pistol_count_str; }

with(zui_create(pistol_cases_x + bw/2, cases_y, objUIImage)){
	zui_set_size(other.image_size, other.image_size);
	sprite = spr_Cases;
	sprite_image_index = oCasesTab.pistol_case_id;
	sprite_width_size = other.image_size;
	sprite_height_size = other.image_size;
}

pistol_cost = zui_create(pistol_cases_x + bw/2, cases_y + image_size/2.5, objUILabel);
with(pistol_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(global.cases_cost.Pistol_cases); }


with(zui_create(pistol_cases_x, cases_y + image_size/4 + text_h*1.5, objUIButton)){
	zui_set_anchor(0, 0);
	zui_set_size(other.bw, other.bh);

	caption = "Buy";
	callback = function(){
		if(global.player_stats.Diamonds >= global.cases_cost.Pistol_cases){
			global.player_stats.Pistol_cases += 1;	
			global.player_stats.Diamonds -= global.cases_cost.Pistol_cases;
		}
	};
}

with(zui_create(pistol_cases_x, cases_y + image_size/4 + text_h*1.5 + bh*1.1, objUIButton)){
	zui_set_anchor(0, 0);
	zui_set_size(other.bw, other.bh);

	caption = "Open";
	callback = other.pistol_case_callback;
}
#endregion

#region SMG case
smg_case_id = 3;
smg_case_callback = function(){
	var active = false;
	if(instance_exists(objUILottery)){
		with(objUILottery){
			if(lottery_active == false){
				zui_destroy();
			}else{
				active = true;
			}
		}
	}
	
	if(active == false){		
		with(zui_create(zui_get_width() * .2, zui_get_height() * .5, objUILottery)){
			zui_set_anchor(0, 0); 			
			lottery_weapon_pool = [
				Item.MAC11,
				Item.MP9,
				Item.MP7,
				Item.P90
			];
		}
		global.player_stats.Smg_cases --;
	}
};

smg_count_str = "Submachine guns - " + string(global.player_stats.Smg_cases) + "x";
smg_count = zui_create(smg_cases_x + bw/2 - string_width(smg_count_str)/2, cases_y - text_h*2, objUILabel);
with(smg_count){caption = oCasesTab.smg_count_str; }

with(zui_create(smg_cases_x + bw/2, cases_y, objUIImage)){
	zui_set_size(other.image_size, other.image_size);
	sprite = spr_Cases;
	sprite_image_index = oCasesTab.smg_case_id;
	sprite_width_size = other.image_size;
	sprite_height_size = other.image_size;
}

smg_cost = zui_create(smg_cases_x + bw/2, cases_y + image_size/2.5, objUILabel);
with(smg_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(global.cases_cost.Smg_cases); }


with(zui_create(smg_cases_x, cases_y + image_size/4 + text_h*1.5, objUIButton)){
	zui_set_anchor(0, 0);
	zui_set_size(other.bw, other.bh);

	caption = "Buy";
	callback = function(){
		if(global.player_stats.Diamonds >= global.cases_cost.Smg_cases){
			global.player_stats.Smg_cases += 1;	
			global.player_stats.Diamonds -= global.cases_cost.Smg_cases;
		}
	};
}

with(zui_create(smg_cases_x, cases_y + image_size/4 + text_h*1.5 + bh*1.1, objUIButton)){
	zui_set_anchor(0, 0);
	zui_set_size(other.bw, other.bh);

	caption = "Open";
	callback = other.smg_case_callback;
}
#endregion

#region Heavy case
heavy_case_id = 4;
heavy_case_callback = function(){
	var active = false;
	if(instance_exists(objUILottery)){
		with(objUILottery){
			if(lottery_active == false){
				zui_destroy();
			}else{
				active = true;
			}
		}
	}
	
	if(active == false){		
		with(zui_create(zui_get_width() * .2, zui_get_height() * .5, objUILottery)){
			zui_set_anchor(0, 0); 			
			lottery_weapon_pool = [
				Item.Javelin,
			];
		}
		global.player_stats.Heavy_cases --;
	}
};

heavy_count_str = "Heavy guns - " + string(global.player_stats.Heavy_cases) + "x";
heavy_count = zui_create(heavy_cases_x + bw/2 - string_width(heavy_count_str)/2, cases_y - text_h*2, objUILabel);
with(heavy_count){caption = oCasesTab.heavy_count_str; }

with(zui_create(heavy_cases_x + bw/2, cases_y, objUIImage)){
	zui_set_size(other.image_size, other.image_size);
	sprite = spr_Cases;
	sprite_image_index = oCasesTab.heavy_case_id;
	sprite_width_size = other.image_size;
	sprite_height_size = other.image_size;
}

heavy_cost = zui_create(heavy_cases_x + bw/2, cases_y + image_size/2.5, objUILabel);
with(heavy_cost){ icon_after = false; icon_sprite_index = spr_Coin; sprite_scale = 2; icon_image_index = 1; caption = string(global.cases_cost.Heavy_cases); }


with(zui_create(heavy_cases_x, cases_y + image_size/4 + text_h*1.5, objUIButton)){
	zui_set_anchor(0, 0);
	zui_set_size(other.bw, other.bh);

	caption = "Buy";
	callback = function(){
		if(global.player_stats.Diamonds >= global.cases_cost.Heavy_cases){
			global.player_stats.Heavy_cases += 1;	
			global.player_stats.Diamonds -= global.cases_cost.Heavy_cases;
		}
	};
}

with(zui_create(heavy_cases_x, cases_y + image_size/4 + text_h*1.5 + bh*1.1, objUIButton)){
	zui_set_anchor(0, 0);
	zui_set_size(other.bw, other.bh);

	caption = "Open";
	callback = other.heavy_case_callback;
}
#endregion


with (zui_create(0, 0, objUIWindowCaption)) {
	caption = "Weapon cases";
	draggable = 1;
}