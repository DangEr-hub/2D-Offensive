/// @description Draw GUI elements above post-processing

shader_reset();
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_font(set_font("Console"));
draw_set_valign(fa_middle);

#region Crosshair
var draw_crosshair = instance_exists(global.local_player)
	&& !spectating
	&& RespawnMenu == false
	&& PauseMenu == false
	&& GameEndMenu == false
	&& !instance_exists(oBuyMenu)
	&& !instance_exists(oInventory)
	&& !instance_exists(oWeaponAttachments)
	&& !instance_exists(oMortarMenu)
	&& !instance_exists(oStatisticsTable)
	&& !instance_exists(oBotTab)
	&& !global.my_console[? "active"]
	&& global.local_player.player_can_shoot;

if(draw_crosshair){
with(oCrosshair){
	var x_scale = image_xscale * .5 * global.crosshair_scale;
	var y_scale = image_yscale * .5 * global.crosshair_scale;
	crosshair_x = (visual_x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
	crosshair_y = (visual_y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
	if(instance_exists(global.local_player)){
		if(HitMarker > -1){
			draw_sprite_ext(spr_HitMarker, HitMarker, crosshair_x, crosshair_y, y_scale, x_scale, image_angle, image_blend, global.CrosshairAlpha);
		}
		if(global.local_player.player_can_shoot == true && !global.my_console[? "active"] && global.ItemIndex[#global.Inventory[# global.local_player.WeaponID, Index.slot_id], ItemStat.WeaponTypeClass] != WEAPON_CLASS.SNIPER_RIFLE && global.local_player.ScopeIn == false){
			draw_sprite_ext(spr_StaticCrosshair, 0, crosshair_x, crosshair_y, y_scale, x_scale, image_angle, global.crosshair_color, global.CrosshairAlpha * AlphaMul);
			if(global.DynamicCrosshair == true){
				Gap = 25;
				draw_sprite_ext(
					spr_DynamicCrosshair,
					0,
					crosshair_x - Gap - inaccuracy_formula(global.Inventory[# global.local_player.WeaponID, Index.slot_id], global.local_player) * 2 + x_offset,
					crosshair_y,
					y_scale,
					x_scale,
					0,
					global.crosshair_color,
					global.CrosshairAlpha
				); ///Left
				draw_sprite_ext(
					spr_DynamicCrosshair,
					0,
					crosshair_x + Gap + inaccuracy_formula(global.Inventory[# global.local_player.WeaponID, Index.slot_id], global.local_player) * 2 + x_offset,
					crosshair_y,
					y_scale,
					x_scale,
					0,
					global.crosshair_color,
					global.CrosshairAlpha
				); ///Right
				draw_sprite_ext(
					spr_DynamicCrosshair,
					0,
					crosshair_x,
					crosshair_y - Gap - inaccuracy_formula(global.Inventory[# global.local_player.WeaponID, Index.slot_id], global.local_player) * 2 + y_offset,
					y_scale,
					x_scale,
					90,
					global.crosshair_color,
					global.CrosshairAlpha
				); ///Top
				draw_sprite_ext(
					spr_DynamicCrosshair,
					0,
					crosshair_x,
					crosshair_y + Gap + inaccuracy_formula(global.Inventory[# global.local_player.WeaponID, Index.slot_id], global.local_player) * 2 + y_offset,
					y_scale,
					x_scale,
					90,
					global.crosshair_color,
					global.CrosshairAlpha
				); ///Down
			}
		}
	}else{
		draw_sprite_ext(spr_StaticCrosshair, 0, crosshair_x, crosshair_y, y_scale, x_scale, image_angle, global.crosshair_color, global.CrosshairAlpha * AlphaMul);
		if(global.DynamicCrosshair == true){
			Gap = 25;
			draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x - Gap - 1 + x_offset, crosshair_y, y_scale, x_scale, 0, global.crosshair_color, global.CrosshairAlpha); ///Left
			draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x + Gap + 1 + x_offset, crosshair_y, y_scale, x_scale, 0, global.crosshair_color, global.CrosshairAlpha); ///Right
			draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x, crosshair_y - Gap - 1 + y_offset, y_scale, x_scale, 90, global.crosshair_color, global.CrosshairAlpha); ///Top
			draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x, crosshair_y + Gap + 1 + y_offset, y_scale, x_scale, 90, global.crosshair_color, global.CrosshairAlpha); ///Down
		}
	}

	if(has_attachment(Item.range_finder, Index.slot_barrel) && global.local_player.player_can_shoot == true){
		var text = "?";
		var col = c_red;
		if(global.local_player.Range <= global.ItemIndex[# global.local_player.wpn_id, ItemStat.Range]){
			text = string_format(global.local_player.Range, 0, 1) + " u";
			col = c_green;
		}

		draw_text_outlined(crosshair_x + max(64 * x_scale, 64), crosshair_y, text, col, c_black, 1);
	}
}
}
#endregion

/// @description Draw console
if(!instance_exists(global.local_player) || !global.local_player.terminal_opened){
	console_draw(global.my_console, global.ConsoleHeight * global.gui_scale,c_gray,c_silver,c_white,c_white, global.GUIHUDAlpha*2, global.ConsoleWidth * global.gui_scale);
}

#region Draw blood splash GUI
if(global.DrawParticles == true){
	if(instance_exists(oParticleSurface)){
	if(!surface_exists(oParticleSurface.gui_particle_surf)){
		oParticleSurface.gui_particle_surf = surface_create(global.GuiW, global.GuiH);
		surface_set_target(oParticleSurface.gui_particle_surf);
		draw_clear_alpha(0, 0);
		surface_reset_target();
	}

	draw_surface(oParticleSurface.gui_particle_surf, 0, 0);
	}
}
#endregion


#region Buy period message
if(buy_period_message_timer > 0){
	draw_set_font(set_font("GUI_small"));
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var tw = string_width("The buy period is over");
	draw_text_outlined(global.GuiW * .5 - tw/2, global.GuiH * .5, "The buy period is over", c_red, c_black, 1);
	draw_set_halign(fa_left);
	draw_set_font(set_font("Console"));
}
#endregion
