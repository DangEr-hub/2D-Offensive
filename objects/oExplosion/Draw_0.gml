/// @description Insert description here
// You can write your code in this editor
if(Sprite != -1){
	if(oPlayer.ToggleInfraVision == true){
		shader_set(shd_InfraVision);
		shader_set_uniform_f(shader_get_uniform(shd_InfraVision, "u_intensity"), 2.0);
		draw_sprite_ext(Sprite, image_index, x, y, 1 * ExplosionPower, 1 * ExplosionPower, Angle, c_white, 1);
		shader_reset();
	}else{
		draw_sprite_ext(Sprite, image_index, x, y, 1 * ExplosionPower, 1 * ExplosionPower, Angle, c_white, 1);
	}
}