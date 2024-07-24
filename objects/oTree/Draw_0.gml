// Assuming you have the shader set up as shd_Wave
shader_set(shd_Wave);

// Pass the time uniform
shader_set_uniform_f(shader_get_uniform(shd_Wave, "time"), current_time / time_modifier);
shader_set_uniform_f(shader_get_uniform(shd_Wave, "amplitude"), amplitude);
shader_set_uniform_f(shader_get_uniform(shd_Wave, "strength"), strength);

// Draw the sprite
draw_self();

shader_reset();