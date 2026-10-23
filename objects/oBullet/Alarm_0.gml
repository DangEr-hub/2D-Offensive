var impact_wall = instance_place(x, y, oParentTile);
var water_impact = position_meeting(x, y, oWater);
if(instance_exists(impact_wall) && instance_exists(oParticleSystem)){
	var wall_color = water_impact ? c_aqua : get_wall_impact_color(impact_wall, x, y);
	create_impact_line_particles(x, y, wall_color, stats.Damage, direction + 180, water_impact ? .75 : 1);
}

image_alpha = water_impact ? 0.75 : 1;

if(global.draw_other_models || global.draw_bullet_impact){
	if(instance_exists(oParticleSurface)){
		if(surface_exists(oParticleSurface.ParticleSurface)){
			var impact_col = c_black;

			if(water_impact){
				impact_col = c_aqua;
			}else if(instance_exists(impact_wall)){
				impact_col = get_wall_impact_color(impact_wall, x, y);
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
				var layers = water_impact ? 1 : clamp(2 + floor(stats.Damage / 50), 3, 10);

				for (var i = 0; i < layers; i++) {
				    var layer_scale = image_xscale * (1 - i * 0.20);
				    var layer_color = water_impact ? c_aqua : merge_color(impact_col, c_black, i * 0.2);
					var displacement = random_range(-2, 2);
					var angle = random(360);

				    draw_sprite_ext(sprite_index, 0,
				        x + displacement, y + displacement,
				        layer_scale, layer_scale,
				        angle,
				        layer_color, image_alpha);
				}
			}
			surface_reset_target();
		}
	}
}

instance_destroy(id);
