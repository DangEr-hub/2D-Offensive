// Set the shader
if(image_xscale > 0.5 && image_yscale > 0.5){
	shader_set(shd_Wave);
	shader_set_uniform_f(shader_get_uniform(shd_Wave, "time"), current_time / oDraw.wind.time_modifier);
	shader_set_uniform_f(shader_get_uniform(shd_Wave, "amplitude"), oDraw.wind.amplitude);
	shader_set_uniform_f(shader_get_uniform(shd_Wave, "strength"), oDraw.wind.strength);
}

// Draw the sprite
draw_self();

// Reset the shader
if(image_xscale > 0.5 && image_yscale > 0.5){
	shader_reset();
}
