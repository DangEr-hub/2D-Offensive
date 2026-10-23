function draw_crosshair(xx, yy){
	var previous_color = draw_get_color();
	var previous_alpha = draw_get_alpha();
	var spread = global.cs_conf.spread * global.cs_conf.scale;
	var draw_center = global.cs_conf.dynamic && global.cs_conf.type != CS_TYPE.DOT && instance_exists(global.local_player);
	if(draw_center){
		var weapon_id = global.Inventory[# global.local_player.WeaponID, INDEX.slot_id];
		var outward_shift = inaccuracy_formula(weapon_id, global.local_player) * 2;
		spread += global.cs_conf.type == CS_TYPE.CIRC ? outward_shift : outward_shift * 2;
	}
	var w = global.cs_conf.width * global.cs_conf.scale;
	var h = global.cs_conf.height * global.cs_conf.scale;
	var o = global.cs_conf.outline ? max(0, global.cs_conf.outline_w * global.cs_conf.scale) : 0;
	var center_spread = min(12 * global.cs_conf.scale, spread/2);
	var draw_count = draw_center ? 2 : 1;

	draw_set_alpha(global.cs_conf.alpha);
	for(var draw_pass = 0; draw_pass < draw_count; draw_pass++){
		if(draw_pass == 1) spread = center_spread;
		if(global.cs_conf.type == CS_TYPE.CLASSIC){
			var crosshair_position = [
				[xx - spread/2 - w, yy - h/2, xx - spread/2, yy + h/2], // left
				[xx + spread/2, yy - h/2, xx + spread/2 + w, yy + h/2], // right
				[xx - h/2, yy - spread/2 - w, xx + h/2, yy - spread/2], // top
				[xx - h/2, yy + spread/2, xx + h/2, yy + spread/2 + w]  // bottom
			];

			if(o > 0){
				draw_set_color(global.cs_conf.outline_color);
				draw_rectangle(crosshair_position[0][0] - o, crosshair_position[0][1] - o, crosshair_position[0][2], crosshair_position[0][3] + o, false);
				draw_rectangle(crosshair_position[1][0], crosshair_position[1][1] - o, crosshair_position[1][2] + o, crosshair_position[1][3] + o, false);
				draw_rectangle(crosshair_position[2][0] - o, crosshair_position[2][1] - o, crosshair_position[2][2] + o, crosshair_position[2][3], false);
				draw_rectangle(crosshair_position[3][0] - o, crosshair_position[3][1], crosshair_position[3][2] + o, crosshair_position[3][3] + o, false);
			}

			draw_set_color(global.cs_conf.color);
			draw_rectangle(crosshair_position[0][0], crosshair_position[0][1], crosshair_position[0][2] - o, crosshair_position[0][3], false);
			draw_rectangle(crosshair_position[1][0] + o, crosshair_position[1][1], crosshair_position[1][2], crosshair_position[1][3], false);
			draw_rectangle(crosshair_position[2][0], crosshair_position[2][1], crosshair_position[2][2], crosshair_position[2][3] - o, false);
			draw_rectangle(crosshair_position[3][0], crosshair_position[3][1] + o, crosshair_position[3][2], crosshair_position[3][3], false);
		}else if(global.cs_conf.type == CS_TYPE.CIRC){
			var ring_width = min(h, spread);
			var ring_radius = spread - ring_width/2;
			if(o > 0){
				draw_circular_bar(xx, yy, ring_radius, 0, 1, global.cs_conf.outline_color, global.cs_conf.outline_color, ring_width + 2*o, global.cs_conf.alpha);
			}
			draw_circular_bar(xx, yy, ring_radius, 0, 1, global.cs_conf.color, global.cs_conf.color, ring_width, global.cs_conf.alpha);
		}else if(global.cs_conf.type == CS_TYPE.RECT){
			for(var frame_pass = 0; frame_pass < 2; frame_pass++){
				if(frame_pass == 0 && o <= 0) continue;
				var frame_padding = frame_pass == 0 ? o : 0;
				var outer_half = spread/2 + frame_padding;
				var inner_half = max(0, spread/2 - h - frame_padding);
				draw_set_color(frame_pass == 0 ? global.cs_conf.outline_color : global.cs_conf.color);
				draw_rectangle(xx - outer_half, yy - outer_half, xx + outer_half, yy - inner_half, false);
				draw_rectangle(xx - outer_half, yy + inner_half, xx + outer_half, yy + outer_half, false);
				draw_rectangle(xx - outer_half, yy - inner_half, xx - inner_half, yy + inner_half, false);
				draw_rectangle(xx + inner_half, yy - inner_half, xx + outer_half, yy + inner_half, false);
			}
		}else if(global.cs_conf.type == CS_TYPE.DOT){
			var half_width = w/2;
			var half_height = h/2;
			if(o > 0){
				draw_set_color(global.cs_conf.outline_color);
				draw_ellipse(xx - half_width - o, yy - half_height - o, xx + half_width + o, yy + half_height + o, false);
			}
			draw_set_color(global.cs_conf.color);
			draw_ellipse(xx - half_width, yy - half_height, xx + half_width, yy + half_height, false);
		}
	}
	draw_set_color(previous_color);
	draw_set_alpha(previous_alpha);
}

function draw_lens_flare() {
    var obj_main = argument0; // The light source
    var obj_target = argument1; // The object to draw lens flare towards
    var sprite = argument2; // The sprite used for the flare elements
    var min_size = argument3; // The minimum size of the flare elements
    var max_size = argument4; // The maximum size of the flare elements
    var min_alpha = argument5; // The minimum alpha of the flare elements
    var max_alpha = argument6; // The maximum alpha of the flare elements
    var offset_amount = argument7; // The offset amount for the flare elements

    // Distance between light source and target
    var dist = point_distance(obj_main.x, obj_main.y, obj_target.x, obj_target.y);
    var num_sprites = max(2, round(dist / (sprite_get_width(sprite)))); // Adjust the divisor to control sprite spacing

    // Loop through each flare element
    for (var i = 0; i < num_sprites - 1; i++) {
        // Calculate the position of each sprite along the line
		var target_x = (obj_main.x + obj_target.x) / 2;
		var target_y = (obj_main.y + obj_target.y) / 2;
        var ratio = i / (num_sprites - 1);
        var base_pos_x = lerp((obj_main.x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW), 
                              (target_x - oDraw.ViewX) * (global.GuiW / oDraw.ViewW), ratio);
        var base_pos_y = lerp((obj_main.y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH), 
                              (target_y - oDraw.ViewY) * (global.GuiH / oDraw.ViewH), ratio);

        // Apply offset based on whether the index is odd or even
        var pos_x = base_pos_x + (i % 2 == 0 ? -offset_amount : offset_amount);
        var pos_y = base_pos_y;

        // Calculate the size and alpha of each sprite based on its position
        var size_ratio = 1 - abs(0.5 - ratio) * 2; // Creates larger sprites in the middle of the line
        var sprite_size = lerp(min_size, max_size, size_ratio);
		
        // Calculate the alpha for each sprite, increasing with each iteration
        var alpha_ratio = (i*1.5 + 1) / (num_sprites - 1); // This ensures alpha increases with each sprite
        var sprite_alpha = lerp(min_alpha, max_alpha, alpha_ratio);

        if (i == 0 || dist < 768) {
            shader_set(shd_Blur1Pass);
            shader_set_uniform_f(oDraw.usize, 128, 128, .5);
            draw_sprite_ext(sprite, 0, pos_x, pos_y, sprite_size, sprite_size, 0, c_white, sprite_alpha);
            shader_reset();
        }
    }
}
	
function draw_sprite_outlined_ext(sprite, subimg, x, y, outline_color, outline_width, xscale, yscale, angle, alpha) {
    var original_color = draw_get_color();
	
    draw_sprite_ext(sprite, subimg, x - outline_width, y, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x + outline_width, y, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x, y - outline_width, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x, y + outline_width, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x - outline_width, y - outline_width, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x + outline_width, y - outline_width, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x - outline_width, y + outline_width, xscale, yscale, angle, outline_color, alpha);
    draw_sprite_ext(sprite, subimg, x + outline_width, y + outline_width, xscale, yscale, angle, outline_color, alpha);
	
    draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, angle, original_color, alpha);
}

function draw_string_line(x, y, text, number, color, text_last_string, text_color = c_white, outline_color = c_black, outline_distance = 1) {
    var number_sign = (number >= 0) ? "+" : "";
    draw_text_outlined(x, y, text, text_color, outline_color, outline_distance);
    draw_text_outlined(x + string_width(text), y, number_sign + string(number), color, outline_color, outline_distance);	
    draw_text_outlined(x + string_width(text) + string_width(number_sign + string(number)), y, text_last_string, color, outline_color, outline_distance);
}

function draw_circular_bar(x, y, radius, value, max_value, bar_color, background_color, thickness = 4, alpha = 1, start_angle = -90) {
	var previous_color = draw_get_color();
	var previous_alpha = draw_get_alpha();
	var safe_radius = max(1, radius);
	var safe_thickness = clamp(thickness, 1, safe_radius);
	var inner_radius = max(0, safe_radius - safe_thickness * .5);
	var outer_radius = safe_radius + safe_thickness * .5;
	var progress = max_value > 0 ? clamp(value / max_value, 0, 1) : 0;
	// Two vertices per segment; keep each triangle strip below 512 vertices.
	var segments = clamp(ceil(outer_radius * 3), 96, 240);
	var safe_alpha = clamp(alpha, 0, 1);

	draw_set_alpha(1);
	draw_primitive_begin(pr_trianglestrip);
	for(var i = 0; i <= segments; i++) {
		var angle = start_angle + (i / segments) * 360;
		draw_vertex_color(
			x + lengthdir_x(outer_radius, angle),
			y + lengthdir_y(outer_radius, angle),
			background_color,
			safe_alpha
		);
		draw_vertex_color(
			x + lengthdir_x(inner_radius, angle),
			y + lengthdir_y(inner_radius, angle),
			background_color,
			safe_alpha
		);
	}
	draw_primitive_end();

	if(progress > 0) {
		var filled_segments = ceil(segments * progress);
		draw_primitive_begin(pr_trianglestrip);
		for(var i = 0; i <= filled_segments; i++) {
			var progress_position = min(i / segments, progress);
			var angle = start_angle + progress_position * 360;
			draw_vertex_color(
				x + lengthdir_x(outer_radius, angle),
				y + lengthdir_y(outer_radius, angle),
				bar_color,
				safe_alpha
			);
			draw_vertex_color(
				x + lengthdir_x(inner_radius, angle),
				y + lengthdir_y(inner_radius, angle),
				bar_color,
				safe_alpha
			);
		}
		draw_primitive_end();
	}

	draw_set_color(previous_color);
	draw_set_alpha(previous_alpha);
}

function draw_text_outlined(position_x, position_y, text, text_color, outline_color, outline_width) {
	draw_set_halign(fa_left);
	var xx = position_x;
	var yy = position_y;
	var str = text;
	draw_set_colour(outline_color);
	draw_text(xx-outline_width, yy, string_hash_to_newline(str));
	draw_text(xx+outline_width, yy, string_hash_to_newline(str));
	draw_text(xx, yy-outline_width, string_hash_to_newline(str));
	draw_text(xx, yy+outline_width, string_hash_to_newline(str));
	draw_set_colour(text_color);
	draw_text(xx, yy, string_hash_to_newline(str));
	draw_set_colour(c_white);
}

function draw_text_outlined_ext(position_x, position_y, text, text_color, outline_color, outline_width, separate, width) {
	draw_set_halign(fa_left);
	var xx = position_x;
	var yy = position_y;
	var str = text;
	draw_set_colour(outline_color);
	draw_text_ext(xx-outline_width, yy, string_hash_to_newline(str), separate, width);
	draw_text_ext(xx+outline_width, yy, string_hash_to_newline(str), separate, width);
	draw_text_ext(xx, yy-outline_width, string_hash_to_newline(str), separate, width);
	draw_text_ext(xx, yy+outline_width, string_hash_to_newline(str), separate, width);
	draw_set_colour(text_color);
	draw_text_ext(xx, yy, string_hash_to_newline(str), separate, width);
	draw_set_colour(c_white);
}
	
function draw_weapon_attachments(weapon_inst, muzzle_distance, suppressor_id, barrel_id, scope_id, draw_alpha = 1){
	if(suppressor_id != ITEM.None){
		var suppressor_uvs = sprite_get_uvs(spr_Items, suppressor_id);
		var suppressor_distance = muzzle_distance - (suppressor_uvs[4] - sprite_get_xoffset(spr_Items)) * .5;
		draw_sprite_ext(spr_Items, suppressor_id,
			weapon_inst.x + lengthdir_x(suppressor_distance, weapon_inst.image_angle),
			weapon_inst.y + lengthdir_y(suppressor_distance, weapon_inst.image_angle),
			.5, .5, weapon_inst.image_angle, c_white, draw_alpha);
	}

	if(barrel_id != ITEM.None){
		draw_sprite_ext(spr_Attachments, global.ItemIndex[# barrel_id, ITEMSTATS.AmmoSpriteID],
			weapon_inst.x, weapon_inst.y, 1, 1, weapon_inst.image_angle, c_white, draw_alpha);
	}
	if(scope_id != ITEM.None){
		draw_sprite_ext(spr_Attachments, global.ItemIndex[# scope_id, ITEMSTATS.AmmoSpriteID],
			weapon_inst.x, weapon_inst.y, 1, 1, weapon_inst.image_angle, c_white, draw_alpha);
	}
}

function draw_blur_2d(sprite, subimg, position_x, position_y, xscale, yscale, rot, col, alpha, blur_radius) {
    var surf_horizontal = surface_create(sprite_get_width(sprite) * xscale, sprite_get_height(sprite) * yscale);
    var surf_vertical = surface_create(sprite_get_width(sprite) * xscale, sprite_get_height(sprite) * yscale);

    // Apply shader and set uniforms
    shader_set(shd_Blur2Pass);
    var texelWidth = 1.0 / sprite_get_width(sprite);
    var texelHeight = 1.0 / sprite_get_height(sprite);
    shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "texel_size"), texelWidth, texelHeight);
    shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "blur_radius"), blur_radius);

    // First pass: horizontal blur
    shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "blur_vector"), 1.0, 0.0);
    surface_set_target(surf_horizontal);
    draw_clear_alpha(c_black, 0);
    draw_sprite_ext(sprite, subimg, 0, 0, xscale, yscale, rot, col, alpha);
    surface_reset_target();

    // Second pass: vertical blur
    shader_set_uniform_f(shader_get_uniform(shd_Blur2Pass, "blur_vector"), 0.0, 1.0);
    surface_set_target(surf_vertical);
    draw_clear_alpha(c_black, 0);
    draw_surface(surf_horizontal, 0, 0);
    surface_reset_target();
    shader_reset();

    // Draw final blurred sprite
    draw_surface(surf_vertical, position_x, position_y);

    // Clean up surfaces
    surface_free(surf_horizontal);
    surface_free(surf_vertical);
}
	
function draw_impact_trace(x1, y1, x2, y2){
    var segments = 6; // kolik „zlomů“
    var last_x = x1;
    var last_y = y1;

    for(var i = 1; i <= segments; i++){
        var t = i / segments;

        var nx = lerp(x1, x2, t);
        var ny = lerp(y1, y2, t);

        // náhodné vychýlení
        nx += random_range(-2, 2);
        ny += random_range(-2, 2);

        draw_line_width(last_x, last_y, nx, ny, 1);

        last_x = nx;
        last_y = ny;
    }
}

function draw_compass(xx, yy, w, h){
    draw_set_alpha(global.gui_alpha * 0.75);

    draw_set_color(c_black);
    draw_rectangle(xx, yy, xx + w, yy + h, true);

    draw_set_color(MENU_COLOR);
    draw_rectangle(xx + 1, yy + 1, xx + w - 1, yy + h - 1, false);

    var center_x = xx + w * 0.5;
    var center_y = yy + h * 0.5;
    var v_angle = 180;
    var player_angle = global.local_player.RotationAngle;

    draw_set_color(MAIN_COLOR);

    var n = 18;
    var spacing = w / n;

    for(var i = 1; i < n; i++){
        draw_line(xx + i * spacing, yy, xx + i * spacing, yy + h);
    }

    draw_set_font(set_font("GUI_grid"));

    var directions = ["E", "NE", "N", "NW", "W", "SW", "S", "SE"];

	draw_set_alpha(1);
    for(var i = 0; i < array_length(directions); i++){
        var direction_angle = i * 45;
        var angle_diff = angle_difference(player_angle, direction_angle);

        if(abs(angle_diff) <= v_angle){
            var text_value = directions[i];
            var text_x = center_x + (angle_diff / v_angle) * (w * 0.5);

            draw_text_outlined(
                text_x - string_width(text_value) * 0.5,
                yy + h,
                text_value,
                c_white,
                c_black,
                1
            );
        }
    }

    with(oBot){
        if(Visible == true){
            var enemy_dir = point_direction(global.local_player.x, global.local_player.y, x, y);
            var angle_diff = angle_difference(global.local_player.RotationAngle, enemy_dir);
            var marker_x = center_x + (angle_diff / v_angle) * (w * 0.5);
			var col = stats.Team == TEAM.POLICE ? c_blue : c_red;

            if(abs(angle_diff) <= v_angle){
                draw_set_color(col);
                draw_circle(marker_x, center_y, 4 * global.gui_scale, false);
            }
        }
    }

	with(oHostage){
		if(global.local_player.stats.Team != TEAM.POLICE || Visible){
			var hostage_dir = point_direction(global.local_player.x, global.local_player.y, x, y);
			var angle_diff = angle_difference(global.local_player.RotationAngle, hostage_dir);
			var marker_x = center_x + (angle_diff / v_angle) * (w * 0.5);

			if(abs(angle_diff) <= v_angle){
				draw_set_color(c_green);
				draw_circle(marker_x, center_y, 4 * global.gui_scale, false);
			}
		}
	}

	with(oBomb){
		if(global.local_player.stats.Team != TEAM.POLICE || Visible){
			var bomb_dir = point_direction(global.local_player.x, global.local_player.y, x, y);
			var angle_diff = angle_difference(global.local_player.RotationAngle, bomb_dir);
			var marker_x = center_x + (angle_diff / v_angle) * (w * 0.5);

			if(abs(angle_diff) <= v_angle){
				draw_set_color(c_red);
				var size = 4 * global.gui_scale;
				draw_rectangle(marker_x - size, center_y - size, marker_x + size, center_y + size, false);
			}
		}
	}

	if(instance_exists(global.local_player)){
	    with(oPlayer){
	        if(is_remote && Visible == true && stats.Health_points > 0){
	            var remote_dir = point_direction(global.local_player.x, global.local_player.y, x, y);
	            var remote_angle_diff = angle_difference(global.local_player.RotationAngle, remote_dir);
	            var remote_marker_x = center_x + (remote_angle_diff / v_angle) * (w * 0.5);
				var remote_col = stats.Team == global.local_player.stats.Team ? c_blue : c_red;

	            if(abs(remote_angle_diff) <= v_angle){
	                draw_set_color(remote_col);
	                draw_circle(remote_marker_x, center_y, 4 * global.gui_scale, false);
	            }
	        }
	    }
	}

    draw_set_alpha(1);
    draw_set_color(c_white);
}
