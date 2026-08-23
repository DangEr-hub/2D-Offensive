draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * .72, image_yscale * .72, image_angle, image_blend, image_alpha);

for(var i = 0; i < molotov_shape_points; i++){
	var draw_x = x + lengthdir_x(current_radius * molotov_shape_distance[i], molotov_shape_angle[i]);
	var draw_y = y + lengthdir_y(current_radius * molotov_shape_distance[i], molotov_shape_angle[i]);
	var draw_scale = image_xscale * molotov_shape_scale[i];
	draw_sprite_ext(
		sprite_index,
		image_index,
		draw_x,
		draw_y,
		draw_scale,
		draw_scale * molotov_shape_yscale[i],
		image_angle + molotov_shape_angle[i],
		image_blend,
		image_alpha * molotov_shape_alpha[i]
	);
}
