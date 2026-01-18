if(surface_exists(ParticleSurface)){
	surface_set_target(ParticleSurface);
	draw_clear_alpha(0, 0);
	surface_reset_target();
	surface_free(ParticleSurface);
}
if!(surface_exists(ParticleSurface)){
	ParticleSurface = surface_create(room_width, room_height);
	surface_set_target(ParticleSurface);
	draw_clear_alpha(0, 0);
	surface_reset_target();
}

if(surface_exists(gui_particle_surf)){
	surface_set_target(gui_particle_surf);
	draw_clear_alpha(0, 0);
	surface_reset_target();
	surface_free(gui_particle_surf);
}
if!(surface_exists(gui_particle_surf)){
	gui_particle_surf = surface_create(global.GuiW, global.GuiH);
	surface_set_target(gui_particle_surf);
	draw_clear_alpha(0, 0);
	surface_reset_target();
}
alarm[0] = global.clear_particles_timer;




