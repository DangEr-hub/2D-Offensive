image_xscale = min(1 + (stats.Damage/100), 1.5);
image_yscale = image_xscale;

if(global.draw_other_models || global.draw_bullet_impact){
	if(instance_exists(oParticleSurface)){
		if(surface_exists(oParticleSurface.ParticleSurface)){
			var impact_wall = instance_place(x, y, oParentTile);
			var impact_col = c_black;

			if(instance_exists(impact_wall)){
				if(impact_wall.sprite_index == spr_TileCollision){
					var clr = tilemap_get_pixel(
						layer_tilemap_get_id(layer_get_id("WallTiles")),
						global.MapProperties[# global.MapID, MAP_STAT.Tile],
						32,
						32,
						x,
						y
					);
					impact_col = make_color_rgb(clr[0], clr[1], clr[2]);
				}else{
					var hit_dx = x - impact_wall.x;
					var hit_dy = y - impact_wall.y;
					var hit_cos = dcos(impact_wall.image_angle);
					var hit_sin = dsin(impact_wall.image_angle);
					var sprite_x = (hit_dx * hit_cos - hit_dy * hit_sin) / impact_wall.image_xscale + sprite_get_xoffset(impact_wall.sprite_index);
					var sprite_y = (hit_dx * hit_sin + hit_dy * hit_cos) / impact_wall.image_yscale + sprite_get_yoffset(impact_wall.sprite_index);
					var arr = sprite_getpixel(impact_wall.sprite_index, impact_wall.image_index, sprite_x, sprite_y);
					impact_col = make_color_rgb(arr[0], arr[1], arr[2]);
				}
			}else{
				var background_layer = layer_get_id("Background");
				if(background_layer != -1){
					var background_element = layer_background_get_id(background_layer);
					var background_sprite = layer_background_get_sprite(background_element);
					if(sprite_exists(background_sprite)){
						var background_width = sprite_get_width(background_sprite);
						var background_height = sprite_get_height(background_sprite);
						var background_x = ((floor(x - layer_get_x(background_layer)) mod background_width) + background_width) mod background_width;
						var background_y = ((floor(y - layer_get_y(background_layer)) mod background_height) + background_height) mod background_height;
						var background_pixel = sprite_getpixel(background_sprite, 0, background_x, background_y);
						impact_col = make_color_rgb(background_pixel[0], background_pixel[1], background_pixel[2]);
					}
				}
			}

			surface_set_target(oParticleSurface.ParticleSurface);
			if(global.draw_other_models){
				draw_set_color(c_aqua);
				draw_circle(x, y, 1, false);
				draw_set_color(c_white);
			}
			if(global.draw_bullet_impact){
				//draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, image_angle, impact_col, 1);
				var layers = clamp(2 + floor(stats.Damage / 50), 3, 5);

				for (var i = 0; i < layers; i++) {
				    var layer_scale = image_xscale * (1 - i * 0.20);
				    var layer_color = merge_color(impact_col, c_black, i * 0.2);
					var displacement = random_range(-2, 2);
					var angle = random(360);

				    draw_sprite_ext(sprite_index, 0,
				        x + displacement, y + displacement,
				        layer_scale, layer_scale,
				        angle,
				        layer_color, 1);
				}
			}
			surface_reset_target();
		}
	}
}

instance_destroy(id);
