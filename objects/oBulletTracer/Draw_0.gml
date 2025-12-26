/// @description Insert description here
// You can write your code in this editor
//draw_text(x, y - 50, HitList);
if(global.local_player.ToggleInfraVision == true){
	shader_set(shd_InfraVision);
	shader_set_uniform_f(shader_get_uniform(shd_InfraVision, "u_intensity"), 2.0);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	shader_reset();
}else{
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}