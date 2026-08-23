/// @description Insert description here
// You can write your code in this editor

#region Z motion

var scale = 1;
if(!z_bouncing){
    // ===== APPROACH FROM HEIGHT =====
    z -= z * z_approach * global.time_step;
    if(z < 5){
        z = 0;

        // inicializace bounce
        z_bouncing = true;
        zspeed = zmaxspeed;
    }
	
	// vizuální měřítko
	scale = 1 + (z / 40);

}else{
    // ===== BOUNCE =====
    z += zspeed - zgravity;
    zspeed *= 0.9 * global.time_step;
    if(z <= 0){
        z = 0;
        zmaxspeed *= 0.9 * global.time_step;
        zspeed = zmaxspeed;

        // ukončení bouncu
        if(zmaxspeed < 1){
            z_bouncing = false;
        }
    }

	// vizuální měřítko
	scale = 1 + (z / 75);
}

image_xscale = scale;
image_yscale = scale;

if (audio_emitter_exists(Emitter)) {
	var listener_target = get_audio_listener_target();
	var emitter_x = instance_exists(listener_target) ? get_spatial_audio_x(x, listener_target) : x;
	audio_emitter_position(Emitter, emitter_x, y - z, 0);
	if (instance_exists(global.local_player)) {
		audio_emitter_gain(Emitter, clamp(global.local_player.muffled_sounds, 0, 1));
		audio_emitter_pitch(Emitter, max(1 / 256, global.local_player.muffled_sounds * global.time_step));
	}
}


#endregion

if(particle_timer > -1){
	particle_timer -= global.time_step;
}

if(z_bouncing == false && z <= 1){
	if (network_visual_only) {
		instance_destroy();
		exit;
	}

	if (IS_NET && network_authority && oNetworkManager.is_server) {
		server_process_airplane_bomb_explode(id);
	}

	var exp_pos = local_to_world(31, 31);
	var explosion_owner_name = stats.Owner_name;
	if(explosion_owner_name == ""){
		explosion_owner_name = "Aircraft";
	}
	var explosion_attribution = {
		object_index: stats.Object_index,
		owner_name: explosion_owner_name,
		owner_id: variable_struct_exists(stats, "Owner_id") ? stats.Owner_id : -1
	};
	explosion_create(30, [exp_pos[0], exp_pos[1]], stats.Damage, true, stats.Object, stats.Item_id, 2, max(power(stats.Damage / 10, 2), 256), explosion_attribution);
}else{
	var draw_x = x;
	var draw_y = y - z;
	draw_x -= (image_xscale - 1) * sprite_xoffset;
	draw_y -= (image_yscale - 1) * sprite_yoffset;
	part_particles_create(global.ParticleSystem, draw_x, draw_y, oParticleSystem.fire_particle, 1);
	part_particles_create(global.ParticleSystem, draw_x, draw_y, oParticleSystem.flame_particle, 1);
	if(particle_timer == -1){
		particle_timer = 30;
		create_fog(draw_x, draw_y, other.stats.Damage/5, random(360), 0.1, random_range(.1, .5), 
			clamp(round(other.stats.Damage/10), 5, 7.5), 
			clamp(other.stats.Damage/50, .5, .9), 
			clamp(other.stats.Damage/50, .1, .75), 2 * game_get_speed(gamespeed_fps)
		);
		
	}
}


