/// @description Insert description here
// You can write your code in this editor

#region Z motion

var scale = 1;
if(!z_bouncing){
    // ===== APPROACH FROM HEIGHT =====
    z -= z * z_approach;
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
    zspeed *= 0.9;
    if(z <= 0){
        z = 0;
        zmaxspeed *= 0.9;
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


#endregion

if(particle_timer > -1){
	particle_timer --;
}

if(z_bouncing == false && z <= 1){
	var exp_pos = local_to_world(31, 31);
	explosion_create(30, [exp_pos[0], exp_pos[1]], stats.Damage, true, stats.Object, stats.Item_id);
}else{
	var exp_pos = local_to_world(31, 5);
	part_particles_create(global.ParticleSystem, exp_pos[0], exp_pos[1] - z, oParticleSystem.fire_particle, 1);
	part_particles_create(global.ParticleSystem, exp_pos[0], exp_pos[1] - z, oParticleSystem.FlameParticle, 1);
	if(particle_timer == -1){
		particle_timer = 30;
		create_fog(exp_pos[0], exp_pos[1], other.stats.Damage/5, random(360), 0.1, random_range(.1, .5), 
			clamp(ceil(other.stats.Damage/10), 5, 7.5), 
			clamp(other.stats.Damage/50, .5, .9), 
			clamp(other.stats.Damage/50, .1, .75), 2 * game_get_speed(gamespeed_fps)
		);
		
	}
}


