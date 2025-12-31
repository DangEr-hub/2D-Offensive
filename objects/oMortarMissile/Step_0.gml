/// @description Insert description here
// You can write your code in this editor

#region Z motion

if(!z_bouncing){
    // ===== APPROACH FROM HEIGHT =====
    z -= z * z_approach;
    if(z < 5){
        z = 0;

        // inicializace bounce
        z_bouncing = true;
        zspeed = zmaxspeed;
    }
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
}

// vizuální měřítko
var scale = 1 + (z / 100);
image_xscale = scale;
image_yscale = scale;

#endregion

if(particle_timer > -1){
	particle_timer --;
}

if(z_bouncing == false && z <= 1){
	explosion_create(30, x, y, stats.Damage, false, stats.Object, stats.Item_id);
	instance_destroy(id);
}else{
	part_particles_create(global.ParticleSystem, x, y, oParticleSystem.fire_particle, 1);
	if(particle_timer == -1){
		particle_timer = 30;
		if(instance_number(oFog) < MAX_FOG){
			var Fog = instance_create_layer(x, y, "OtherO", oFog);
			with(Fog){
				smoke_effect_create(
					other.stats.Damage/5,
					random(360),
					0.1,
					random_range(.1, .5),
					clamp(ceil(other.stats.Damage/10), 5, 7.5),
					clamp(other.stats.Damage/50, .5, .9),
					clamp(other.stats.Damage/50, .1, .75),
					2 * game_get_speed(gamespeed_fps)
				);	
			}
		}
		
	}
}


