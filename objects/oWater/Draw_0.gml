
var _time =  shader_get_uniform(shd_topdownwater,"TIME");
var uiResolution =  shader_get_uniform(shd_topdownwater,"iResolution");
var uiPosition =  shader_get_uniform(shd_topdownwater,"iPosition");
var strength = shader_get_uniform(shd_topdownwater,"water_strength");

shader_set(shd_topdownwater);
shader_set_uniform_f(_time,current_time/1000);
shader_set_uniform_f(uiResolution,sprite_width,sprite_height,0);
shader_set_uniform_f(uiPosition,x,y,0);
shader_set_uniform_f(strength, 5.0);
draw_set_alpha(.25);
draw_self();
draw_set_alpha(1);
shader_reset();