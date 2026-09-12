age += global.time_step;

var spread_progress = clamp(age / spread_time, 0, 1);
current_radius = lerp(start_radius, max_radius, spread_progress);

var impact_scale = (current_radius * 2) / sprite_get_width(sprite_index);
image_xscale = impact_scale;
image_yscale = impact_scale;

if!(audio_is_playing(snd_Fire)){
	play_sound(x, y, snd_Fire);	
}

if(age > life_time){
	image_alpha = lerp(.22, 0, clamp((age - life_time) / fade_time, 0, 1));
}

if(LightObject != noone){
	LightObject.x = x;
	LightObject.y = y;
	LightObject.xscale = current_radius / 64;
	LightObject.yscale = current_radius / 64;
	LightObject.alpha = max(image_alpha * 2, 0);
}

if(molotov_particle_emitter_created && instance_exists(oParticleSystem)){
	part_emitter_region(
		global.ParticleSystem,
		molotov_particle_emitter,
		x - current_radius * .42,
		x + current_radius * .42,
		y - current_radius * .42,
		y + current_radius * .42,
		ps_shape_ellipse,
		ps_distr_linear
	);
	part_emitter_burst(global.ParticleSystem, molotov_particle_emitter, oParticleSystem.flame_particle, max(4, round(current_radius / 5)));
	part_emitter_burst(global.ParticleSystem, molotov_particle_emitter, oParticleSystem.fire_particle, max(3, round(current_radius / 8)));
	
	for(var p = 0; p < 3; p++){
		var shape_index = irandom(molotov_shape_points - 1);
		var pocket_radius = current_radius * molotov_shape_scale[shape_index] * random_range(.32, .58);
		var pocket_x = x + lengthdir_x(current_radius * molotov_shape_distance[shape_index], molotov_shape_angle[shape_index]);
		var pocket_y = y + lengthdir_y(current_radius * molotov_shape_distance[shape_index], molotov_shape_angle[shape_index]);
		
		part_emitter_region(
			global.ParticleSystem,
			molotov_particle_emitter,
			pocket_x - pocket_radius,
			pocket_x + pocket_radius,
			pocket_y - pocket_radius,
			pocket_y + pocket_radius,
			ps_shape_ellipse,
			ps_distr_linear
		);
		part_emitter_burst(global.ParticleSystem, molotov_particle_emitter, oParticleSystem.flame_particle, 6);
		part_emitter_burst(global.ParticleSystem, molotov_particle_emitter, oParticleSystem.fire_particle, 4);
	}
	
	part_type_life(oParticleSystem.fog_particle, 20, 45);
	part_type_alpha1(oParticleSystem.fog_particle, .12);
	part_type_size(oParticleSystem.fog_particle, .22, .55, 0, .015);
	part_type_speed(oParticleSystem.fog_particle, .15, .7, 0, .05);
	part_emitter_burst(global.ParticleSystem, molotov_particle_emitter, oParticleSystem.fog_particle, 2);
	part_type_size(oParticleSystem.fog_particle, .5, 1, 0, .05);
	part_type_alpha1(oParticleSystem.fog_particle, .25);
	part_type_speed(oParticleSystem.fog_particle, 1, 2, 0, .5);
	part_type_life(oParticleSystem.fog_particle, camera_get_view_width(CAM), camera_get_view_width(CAM));
}

if(can_damage){
	var hitbox_count = ds_list_create();
	var damage_radius = current_radius * .75;
	var hit_count = collision_circle_list(x, y, damage_radius, oHitBox, false, true, hitbox_count, false);
	
	for(var i = 0; i < hit_count; i++){
		var hitbox = hitbox_count[| i];
		if(!instance_exists(hitbox)){
			continue;
		}
		
		var hit_object = hitbox.MainObject;
		if(!instance_exists(hit_object)){
			continue;
		}
		
		if(hit_object.stats.Health_points <= 0){
			continue;
		}

		if(point_distance(x, y, hit_object.x, hit_object.y) > damage_radius){
			continue;
		}
		
		var hit_key = string(hit_object.id);
		if(ds_map_exists(damage_hits, hit_key)){
			if(age - damage_hits[? hit_key] < damage_interval){
				continue;
			}
		}
		
		var armour_id = Item.None;
		var helmet_id = Item.None;
		var shield_id = Item.None;
		
		if(hit_object.object_index == oPlayer){
			armour_id = global.Inventory[# OtherSlot.Armour, Index.slot_id];
			helmet_id = global.Inventory[# OtherSlot.Helmet, Index.slot_id];
			shield_id = global.Inventory[# OtherSlot.Shield, Index.slot_id];
		}else if(hit_object.object_index == oBot){
			armour_id = hit_object.ArmourID;
			helmet_id = hit_object.HelmetID;
			shield_id = hit_object.ShieldID;
		}
		
		hit_living_object(
			hit_object,
			max(hitbox.image_index, HITBOX.BodyNoWeapon),
			id,
			armour_id,
			helmet_id,
			shield_id,
			hitbox.x,
			hitbox.y
		);
		
		damage_hits[? hit_key] = age;
	}
	
	ds_list_destroy(hitbox_count);
}

if(age >= life_time + fade_time){
	instance_destroy(id);
}
