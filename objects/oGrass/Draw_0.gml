// Set the shader
shader_set(shd_Wave);
shader_set_uniform_f(shader_get_uniform(shd_Wave, "time"), current_time / time_modifier);
shader_set_uniform_f(shader_get_uniform(shd_Wave, "amplitude"), amplitude);
shader_set_uniform_f(shader_get_uniform(shd_Wave, "strength"), strength);

// Draw the sprite
draw_self();

// Reset the shader
shader_reset();
