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
