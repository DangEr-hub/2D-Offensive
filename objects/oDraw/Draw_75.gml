/// @description Draw console
console_draw(global.my_console, global.ConsoleHeight * global.GUIMultiplier,c_gray,c_silver,c_white,c_white, global.GUIHUDAlpha*2, global.ConsoleWidth * global.GUIMultiplier);

#region Draw blood splash GUI
if(global.DrawParticles == true){
	if(instance_exists(oParticleSurface)){
	if(!surface_exists(oParticleSurface.gui_particle_surf)){
		oParticleSurface.gui_particle_surf = surface_create(global.GuiW, global.GuiH);
		surface_set_target(oParticleSurface.gui_particle_surf);
		draw_clear_alpha(0, 0);
		surface_reset_target();
	}

	draw_surface(oParticleSurface.gui_particle_surf, 0, 0);
	}
}
#endregion







