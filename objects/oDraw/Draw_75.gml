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
		if(HitMarker > -1){
			draw_sprite_ext(spr_HitMarker, HitMarker, crosshair_x, crosshair_y, y_scale, x_scale, image_angle, image_blend, global.CrosshairAlpha);
		}
		if(instance_exists(global.local_player) && global.Inventory[# global.local_player.WeaponID, INDEX.slot_scope] != ITEM.two_scope && global.local_player.ScopeIn == false){
			draw_sprite_ext(spr_StaticCrosshair, 0, crosshair_x, crosshair_y, y_scale, x_scale, image_angle, global.crosshair_color, global.CrosshairAlpha * AlphaMul);
			if(global.local_player.player_can_shoot == true && !global.my_console[? "active"]){
				//draw_sprite_ext(spr_StaticCrosshair, 0, crosshair_x, crosshair_y, y_scale, x_scale, image_angle, global.crosshair_color, global.CrosshairAlpha * AlphaMul);
				if(global.DynamicCrosshair == true){
					Gap = 25;
					draw_sprite_ext(
						spr_DynamicCrosshair,
						0,
						crosshair_x - Gap - inaccuracy_formula(global.Inventory[# global.local_player.WeaponID, INDEX.slot_id], global.local_player) * 2 + x_offset,
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
						crosshair_x + Gap + inaccuracy_formula(global.Inventory[# global.local_player.WeaponID, INDEX.slot_id], global.local_player) * 2 + x_offset,
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
						crosshair_y - Gap - inaccuracy_formula(global.Inventory[# global.local_player.WeaponID, INDEX.slot_id], global.local_player) * 2 + y_offset,
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
						crosshair_y + Gap + inaccuracy_formula(global.Inventory[# global.local_player.WeaponID, INDEX.slot_id], global.local_player) * 2 + y_offset,
						y_scale,
						x_scale,
						90,
						global.crosshair_color,
						global.CrosshairAlpha
					); ///Down
				}
			}
		}else{
			if(global.DynamicCrosshair == true){
				Gap = 25;
				draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x - Gap - 1 + x_offset, crosshair_y, y_scale, x_scale, 0, global.crosshair_color, global.CrosshairAlpha); ///Left
				draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x + Gap + 1 + x_offset, crosshair_y, y_scale, x_scale, 0, global.crosshair_color, global.CrosshairAlpha); ///Right
				draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x, crosshair_y - Gap - 1 + y_offset, y_scale, x_scale, 90, global.crosshair_color, global.CrosshairAlpha); ///Top
				draw_sprite_ext(spr_DynamicCrosshair, 0, crosshair_x, crosshair_y + Gap + 1 + y_offset, y_scale, x_scale, 90, global.crosshair_color, global.CrosshairAlpha); ///Down
			}
		}

		if(global.local_player.player_can_shoot == true){
			if(has_attachment(ITEM.range_finder, INDEX.slot_barrel)){
				var text = "?";
				var col = c_red;
				if(global.local_player.Range <= global.ItemIndex[# global.local_player.wpn_id, ITEMSTATS.Range]){
					text = string_format(global.local_player.Range, 0, 1) + " u";
					col = c_green;
				}

				draw_text_outlined(crosshair_x + max(64 * x_scale, 64), crosshair_y, text, col, c_black, 1);
			}
			if(has_attachment(ITEM.laser, INDEX.slot_barrel) && global.local_player.Flashed == false && (global.local_player.ScopeIn == false || global.local_player.player_has_scope != 0)){
				var laser_pos = local_to_world(56, 16, global.local_player.Weapon.image_angle, global.local_player.Weapon);
				var laser_gui_x = (laser_pos[0] - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
				var laser_gui_y = (laser_pos[1] - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);
				var laser_dx = crosshair_x - laser_gui_x;
				var laser_dy = crosshair_y - laser_gui_y;
				var laser_length = max(1, point_distance(laser_gui_x, laser_gui_y, crosshair_x, crosshair_y));
				var offset_x = -laser_dy / laser_length;
				var offset_y = laser_dx / laser_length;
				draw_set_color(c_red);
				for(var glow_offset = 3; glow_offset >= 1; glow_offset--){
					draw_set_alpha(0.08 * (4 - glow_offset));
					draw_line(laser_gui_x + offset_x * glow_offset, laser_gui_y + offset_y * glow_offset,
						crosshair_x + offset_x * glow_offset, crosshair_y + offset_y * glow_offset);
					draw_line(laser_gui_x - offset_x * glow_offset, laser_gui_y - offset_y * glow_offset,
						crosshair_x - offset_x * glow_offset, crosshair_y - offset_y * glow_offset);
				}
				draw_set_alpha(1);
				draw_line(laser_gui_x, laser_gui_y, crosshair_x, crosshair_y);
			}
		}
	}
}
#endregion

/// @description Draw console
if(!instance_exists(oTerminal)){
	console_draw(global.my_console, max(global.ConsoleHeight * global.gui_scale, 384),c_gray,c_silver,c_white,c_white, global.gui_alpha*2, max(global.ConsoleWidth * global.gui_scale, 768));
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
	var t= tr("Buy_over");
	var tw = string_width(t);
	draw_text_outlined(global.GuiW * .5 - tw/2, global.GuiH * .5, t, c_red, c_black, 1);
	draw_set_halign(fa_left);
	draw_set_font(set_font("Console"));
}
#endregion
