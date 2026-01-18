function enemy_initialized(hitObj, enemy_key, enemy_name) {
    var enemyStatsMap;
	
	/* 
	Každý hráč či nepřítel má svou ds_mapu HitMap a v ní vnořenou ds_mapu
	Takže MĚ dál hráč s key = 12 a jménem DangEr 4 hity.... a bot s key = 45 mi dal 1 hit...
	Formát ds_mapy HitMap:
		HitMap = {
		  12 (key) -> {
		        "Name"           : "DangEr",
		        "HitsReceived"   : 4,
		        "DamageReceived" : 87,
		        "HitsGiven"      : 2,
		        "DamageGiven"    : 41
		       },

		  45 (key) -> {
		        "Name"           : "Elvis",
		        "HitsReceived"   : 1,
		        "DamageReceived" : 12,
		        "HitsGiven"      : 5,
		        "DamageGiven"    : 95
		       }
		}
	
	*/
	
	if(!instance_exists(hitObj)){ return; }

    if (!ds_map_exists(hitObj.HitMap, enemy_key)) {
        enemyStatsMap = ds_map_create();
        ds_map_add(enemyStatsMap, "Name", enemy_name);
        ds_map_add(enemyStatsMap, "HitsReceived", 0);
        ds_map_add(enemyStatsMap, "DamageReceived", 0);
        ds_map_add(enemyStatsMap, "HitsGiven", 0);
        ds_map_add(enemyStatsMap, "DamageGiven", 0);
        hitObj.HitMap[? enemy_key] = enemyStatsMap;
    } else {
        enemyStatsMap = hitObj.HitMap[? enemy_key];
    }

    return enemyStatsMap;
}

function create_blood(splash_number, xx, yy, color, part_number){
	repeat(splash_number){
		BloodSplash = instance_create_layer(xx, yy, "ItemsO", oBloodSplash);
		BloodSplash.image_blend = color;
	}
	if(instance_exists(oParticleSystem)){
		part_type_color1(oParticleSystem.BloodParticle, color);
		part_particles_create(global.ParticleSystem, xx, yy, oParticleSystem.BloodParticle, part_number);
	}	
}

function create_blood_gui(world_x, world_y, splash_number, color = c_red){
	
	// --- kamera (world) ---
	var cam_x1 = oDraw.ViewX;
	var cam_y1 = oDraw.ViewY;
	var cam_x2 = cam_x1 + oDraw.ViewW;
	var cam_y2 = cam_y1 + oDraw.ViewH;

	var cam_cx = cam_x1 + oDraw.ViewW * 0.5;
	var cam_cy = cam_y1 + oDraw.ViewH * 0.5;

	// --- směr od kamery k objektu ---
	var dir = point_direction(global.local_player.x, global.local_player.y, world_x, world_y);
	
	// Určení jednotkového vektoru směru u dsin je mínus, protože GM má invertnuté osy, mínus je nahoru
	var dx = dcos(dir);
	var dy = -dsin(dir);

	// --- hledání průsečíku s hranou kamery ---
	var t_min = 10000;
	var ix = cam_cx;
	var iy = cam_cy;

	if(dx != 0){
		var t = (cam_x1 - cam_cx) / dx;
		var yy = cam_cy + dy * t;
		if(t > 0 && yy >= cam_y1 && yy <= cam_y2 && t < t_min){ t_min = t; ix = cam_x1; iy = yy; }
		
		t = (cam_x2 - cam_cx) / dx;
		yy = cam_cy + dy * t;
		if(t > 0 && yy >= cam_y1 && yy <= cam_y2 && t < t_min){ t_min = t; ix = cam_x2; iy = yy; }
	}

	if(dy != 0){
		var t = (cam_y1 - cam_cy) / dy;
		var xx = cam_cx + dx * t;
		if(t > 0 && xx >= cam_x1 && xx <= cam_x2 && t < t_min){ t_min = t; ix = xx; iy = cam_y1; }
		
		t = (cam_y2 - cam_cy) / dy;
		xx = cam_cx + dx * t;
		if(t > 0 && xx >= cam_x1 && xx <= cam_x2 && t < t_min){ t_min = t; ix = xx; iy = cam_y2; }
	}

	// --- world → GUI ---
	var eps = 1;
	var on_left   = abs(ix - cam_x1) < eps;
	var on_right  = abs(ix - cam_x2) < eps;
	var on_top    = abs(iy - cam_y1) < eps;
	var on_bottom = abs(iy - cam_y2) < eps;
	var margin = 32;
	ix += dx * margin;
	iy += dy * margin;
	var gui_x = (ix - oDraw.ViewX) * (global.GuiW / oDraw.ViewW);
	var gui_y = (iy - oDraw.ViewY) * (global.GuiH / oDraw.ViewH);

	// --- směr rozprsku (od hrany do středu kamery) ---
	var splash_dir = point_direction(ix, iy, cam_cx, cam_cy);

	// --- spawn GUI blood ---
	for(var i = 0; i < splash_number; i ++){
		var range = 128;

		var s_x = gui_x;
		var s_y = gui_y;

		if(on_left || on_right){
			s_y += random_range(-range, range);
		}

		if(on_top || on_bottom){
			s_x += random_range(-range, range);
		}

		var blood = instance_create_layer(s_x, s_y, "ItemsO", oBloodSplash);
		var dir_step = 2.5;
		blood.is_gui = true;
		blood.gui_x = s_x;
		blood.gui_y = s_y;

		blood.movDir = splash_dir - dir_step*splash_number/2 + i*dir_step;
		blood.fric = min(random_range(splash_number/9.75, splash_number/10), .8);
		blood.image_alpha = random_range(.925, .927);
		blood.image_xscale = min(random_range(splash_number/4, splash_number/3.75), 2.5);
		blood.image_yscale = blood.image_xscale;
		blood.visible = false;
		blood.sizeChange = 0;
		blood.alphaChange = random_range(0.05, 0.0525);
		blood.image_blend = color;
		
	}

}


function send_hit(attacking_item, hit_object, BodyPart, impact_pos, equip_dur) {
    if (!IS_NET) { return;}
    if (hit_object.object_index != oPlayer) {return;} ///zatím jen hráče

    var attacker_pid = attacking_item.stats.Owner_id;
    var victim_pid = hit_object.network_id;
    if (attacker_pid < 0 || victim_pid < 0) {return;}

    var damage = hit_object.attack_damage;

    with (oNetworkManager) {
        if (is_server) {
                server_process_hit(attacker_pid, victim_pid, damage, BodyPart, [impact_pos[0], impact_pos[1]], hit_object.aimpunch_speed_multiplier, hit_object.AimPunchMultiplier, [equip_dur[0], equip_dur[1]]);
        } else if (is_connected) {
                buffer_seek(send_buffer, buffer_seek_start, 0);
                buffer_write(send_buffer, buffer_u8, PACKET.HIT);
                buffer_write(send_buffer, buffer_u32, send_sequence++);
                buffer_write(send_buffer, buffer_u8, attacker_pid);
                buffer_write(send_buffer, buffer_u8, victim_pid);
                buffer_write(send_buffer, buffer_f16, damage);
                buffer_write(send_buffer, buffer_u8, BodyPart);
                buffer_write(send_buffer, buffer_f16, impact_pos[0]);
                buffer_write(send_buffer, buffer_f16, impact_pos[1]);
				buffer_write(send_buffer, buffer_f16, hit_object.aimpunch_speed_multiplier);
				buffer_write(send_buffer, buffer_f16, hit_object.AimPunchMultiplier);
				buffer_write(send_buffer, buffer_f16, equip_dur[0]); ///Armour dur
				buffer_write(send_buffer, buffer_f16, equip_dur[1]); ///Helmet dur

                network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
        }
    }
}

function hit_living_object(hit_object, BodyPart, attacking_item, ArmourID, HelmetID, impact_x, impact_y){
	if!(instance_exists(hit_object)){
		return;
	}
	
	var is_player = (hit_object.object_index == oPlayer);
	var is_bot = (hit_object.object_index == oBot);
	var has_godmode = false;
	var armour_id = Item.None;
	var helmet_id = Item.None;
	var helmet_durability = 0;
	var armour_durability = 0;
	var blood_color = c_red;
	var data = -1;
	var hp = hit_object.stats.Health_points;
	var attacker = attacking_item.stats.Object;
	
	/* Networking */
	if(is_player){
		has_godmode = bit_state_has(hit_object.network_bit_state, PLAYER_FLAGS.GODMODE);
		armour_id = hit_object.network_armour_id;
		helmet_id = hit_object.network_helmet_id;
		
		if(IS_NET){
			armour_durability = hit_object.network_armour_dur;
			helmet_durability = hit_object.network_helmet_dur;
		}else{
			helmet_durability = global.Inventory[# OtherSlot.Helmet, Index.slot_durability];
			armour_durability = global.Inventory[# OtherSlot.Armour, Index.slot_durability];
		}
	}
	/*************/
	
	if(is_bot){
		armour_durability = hit_object.ArmourDurability[0];
		helmet_durability = hit_object.ArmourDurability[1];
	}
	
	
	/* Offline gameplay  */
	if!(IS_NET){
		has_godmode = global.GodMode;	
		armour_id = ArmourID;
		helmet_id = HelmetID;
	}
	/********************/
	
	if(is_bot){
		has_godmode = false;
	}
	
	/* Hit marker */
	if(instance_exists(attacker) && attacker.object_index == oPlayer && attacker.is_local == true){
		oCrosshair.HitMarker = 0;
		if(BodyPart <= HITBOX.HeadProne){
			oCrosshair.HitMarker = 4;
		}
	}
	/**************/

	if(hp > 0 && has_godmode == false){
		var Damage = attacking_item.stats.Damage;
		hit_object.aimpunch_speed_multiplier = min(1, (1 - (global.ItemIndex[#attacking_item.stats.Item_id, ItemStat.PenetrationPower] / (attacking_item.stats.Penetration_damage + 1))) / global.ItemIndex[#armour_id, ItemStat.Defense]);
		hit_object.attack_damage = Damage;
		hit_object.AimPunchTimer = hit_object.AimPunchTime;
		hit_object.AimPunchMultiplier = global.ItemIndex[#attacking_item.stats.Item_id, ItemStat.PenetrationPower] / (attacking_item.stats.Penetration_damage + 1);
		
		/* Stealth damage with knife */
		if(global.ItemIndex[# attacking_item.stats.Item_id, ItemStat.WeaponTypeClass] == WEAPON_CLASS.KNIFE){
			if(apply_stealth_damage(hit_object)){
				Damage *= STEALTH_DMG_MOD;
			}
		}
		/*****************************/
		
		if(hit_object.object_index == oBot){
			with(hit_object){
				if(ChasingObjectSpotted == false){
					ChasingObjectSpot(chasing_timer);
				}
			}
		}
		
		if(BodyPart >= HITBOX.LegProne){
			DamageMultiplier = LEG_MULTIPLIER;
		}else if(BodyPart >= HITBOX.ArmNoWeapon){
			DamageMultiplier = ARM_MULTIPLIER;
		}else if(BodyPart >= HITBOX.BodyNoWeapon){
			DamageMultiplier = BODY_MULTIPLIER;
			if(armour_durability > 0){
				if(global.ItemIndex[#armour_id, ItemStat.Defense] <= .95){
					hit_object.attack_damage = Damage * global.ItemIndex[# armour_id, ItemStat.Defense] * global.ItemIndex[#attacking_item.stats.Item_id, ItemStat.PenetrationPower];
				}
			}
		}else if(BodyPart >= HITBOX.Head){
			DamageMultiplier = HEADSHOT_MULTIPLIER;
			blood_color = c_maroon;
			if(helmet_durability > 0){
				if(global.ItemIndex[# helmet_id, ItemStat.Defense] <= .95){
					hit_object.attack_damage = Damage * global.ItemIndex[# helmet_id, ItemStat.Defense] * global.ItemIndex[#attacking_item.stats.Item_id, ItemStat.PenetrationPower];
				}
			}
		}
		
		hit_object.attack_damage = ceil(hit_object.attack_damage * DamageMultiplier);
		
		if(hit_object.object_index == oBot){
			hit_object.enemy_aimpunch = hit_object.attack_damage;
		}
		create_blood(ceil(hit_object.attack_damage / 5), impact_x, impact_y, blood_color, ceil(hit_object.attack_damage / 2));	
		
		if(!is_player || (is_player && hit_object.is_local == false)){
			if(point_distance(hit_object.x, hit_object.y, global.local_player.x, global.local_player.y) <= 192){						
				create_blood_gui(hit_object.x, hit_object.y, ceil(hit_object.attack_damage/2), BodyPart <= HITBOX.HeadProne ? c_maroon : c_red);
			}
		}
		
		if(is_player && hit_object.is_local == true){
			create_blood_gui(attacking_item.stats.Starting_x, attacking_item.stats.Starting_y, ceil(hit_object.attack_damage/2), BodyPart <= HITBOX.HeadProne ? c_maroon : c_red);	
		}

		var attacker_key = -1;
		var attacker_name = "";
		var victim_key = -1;
		var victim_name = "";

		#region Hitmap
		if (instance_exists(attacker)) {
		    if (attacker.object_index == oPlayer) {
		        attacker_key  = attacker.network_id;  // PID hráče
		        attacker_name = attacker.Name;
		    } else {
				///Bot
		        attacker_key  = attacker.id;
		        attacker_name = attacker.stats.Name;
		    }
		} else {
		    // Attacker neexistuje, respektive je přes siť
		    attacker_key  = attacking_item.stats.Owner_id;
		    attacker_name = attacking_item.stats.Owner_name;
		}

		if (is_player) {
		    victim_key  = hit_object.network_id;
		    victim_name = hit_object.Name;
		} else {
			// Pro bota
		    victim_key  = hit_object.id;
		    victim_name = hit_object.stats.Name;
		}
		
		// When an enemy hits the hit_object
		var enemyStatsMap = enemy_initialized(hit_object, attacker_key, attacker_name);
		if!(is_undefined(enemyStatsMap)){
			ds_map_replace(enemyStatsMap, "HitsReceived", ds_map_find_value(enemyStatsMap, "HitsReceived") + 1);
			ds_map_replace(enemyStatsMap, "DamageReceived", ds_map_find_value(enemyStatsMap, "DamageReceived") + hit_object.attack_damage);
		}

		// When the hit_object hits back the attacking_item.stats.Object
	    var hitObjectStatsMap = enemy_initialized(attacker, victim_key, victim_name);
		
		if!(is_undefined(hitObjectStatsMap)){
		    ds_map_replace(hitObjectStatsMap, "HitsGiven", ds_map_find_value(hitObjectStatsMap, "HitsGiven") + 1);
		    ds_map_replace(hitObjectStatsMap, "DamageGiven", ds_map_find_value(hitObjectStatsMap, "DamageGiven") + hit_object.attack_damage);
		}
		
		#endregion
		
		// PID attackera (jen pro hráče)
		var attacker_pid = -1;
		if (instance_exists(attacker)) {
		    if (attacker.object_index == oPlayer) {
		        attacker_pid = attacker.network_id;
		    }
		} else {
		    // síťová střela – Owner_id je PID hráče
		    attacker_pid = attacking_item.stats.Owner_id;
		}
		
		var reward = global.ItemIndex[# attacking_item.stats.Item_id, ItemStat.reward];

		if (hp <= hit_object.attack_damage) {
		    if (!IS_NET) {
		        // SINGLEPLAYER REWARD
		        global.player_stats_struct.Money += reward;
		        if (global.ranked_game) {
		            global.player_stats_struct.Kills++;
		            oRatingController.kills++;
		        }
		    } else if (oNetworkManager.is_server) {
		        // MULTIPLAYER REWARD – jen host zapisuje statistiky (anti-cheat)
		        if (attacker_pid >= 0) {
		            with (oNetworkManager) {
		                var attacker_stats = ds_map_find_value(player_stats, attacker_pid);
		                if (is_undefined(attacker_stats)) {
		                    attacker_stats = ds_map_create();
		                    ds_map_set(attacker_stats, "Kills", 0);
		                    ds_map_set(attacker_stats, "Deaths", 0);
		                    ds_map_set(attacker_stats, "Money", 0);
		                    ds_map_add(player_stats, attacker_pid, attacker_stats);
		                }

		                ds_map_set(attacker_stats, "Kills", ds_map_find_value(attacker_stats, "Kills") + 1);
		                ds_map_set(attacker_stats, "Money", ds_map_find_value(attacker_stats, "Money") + reward);
		            }
		        }

		        if (is_player) {
		            var victim_pid = hit_object.network_id;
		            with (oNetworkManager) {
		                var victim_stats = ds_map_find_value(player_stats, victim_pid);
		                if (is_undefined(victim_stats)) {
		                    victim_stats = ds_map_create();
		                    ds_map_set(victim_stats, "Kills", 0);
		                    ds_map_set(victim_stats, "Deaths", 0);
		                    ds_map_set(victim_stats, "Money", 0);
		                    ds_map_add(player_stats, victim_pid, victim_stats);
		                }
		                ds_map_set(victim_stats, "Deaths", ds_map_find_value(victim_stats, "Deaths") + 1);
		            }
		        }
		    }

		    hit_object.KilledByName = attacking_item.stats.Owner_name;
		    hit_object.KilledByWeapon = global.ItemIndex[# attacking_item.stats.Item_id, ItemStat.Name];
			hit_object.stats.Health_points = -1;
		} else {
			statistics_hit("Health", hit_object.attack_damage, hit_object);
		}
		

	
		if (is_player) {
		    hit_object.AimPunchDir = irandom(sprite_get_number(spr_AimPunch) - 1);
		} else {
		    if (global.ranked_game) {
		        if (!IS_NET) {
		            // SINGLEPLAYER
		            global.player_stats_struct.Hit_shots++;
		            oRatingController.hit_shots++;
		            if (BodyPart <= HITBOX.HeadProne) {
		                global.player_stats_struct.Headshots++;
		                oRatingController.headshots++;
		            }
		        } else if (oNetworkManager.is_server && attacker_pid >= 0) {
		            // MULTIPLAYER HOST
		            with (oNetworkManager) {
		                var stats = ds_map_find_value(player_stats, attacker_pid);
		                if (is_undefined(stats)) {
		                    stats = ds_map_create();
		                    ds_map_set(stats, "Kills", 0);
		                    ds_map_set(stats, "Deaths", 0);
		                    ds_map_set(stats, "Money", 0);
		                    ds_map_set(stats, "Hit_shots", 0);
		                    ds_map_set(stats, "Headshots", 0);
		                    ds_map_add(player_stats, attacker_pid, stats);
		                }

		                ds_map_set(stats, "Hit_shots", ds_map_find_value(stats, "Hit_shots") + 1);
		                if (BodyPart <= HITBOX.HeadProne) {
		                    ds_map_set(stats, "Headshots", ds_map_find_value(stats, "Headshots") + 1);
		                }
		            }
		        }
		    }
		}

		
		
		hit_effects(BodyPart, armour_id, helmet_id, armour_durability, helmet_durability, impact_x, impact_y, attacking_item.stats.Object, hit_object, is_player);
		
        if (IS_NET) {
            send_hit(attacking_item, hit_object, BodyPart, [impact_x, impact_y], [hit_object.network_armour_dur, hit_object.network_helmet_dur]);
        }
		
		damage_indicator("-" + string(ceil(hit_object.attack_damage)), impact_x, impact_y, c_white, spr_Icons, ICON.health);
		hit_object.attack_damage = 0; ///Nezapomenout vynulovat!!!!!
	}
}

function apply_stealth_damage(hit_object){
	if(hit_object.object_index != oPlayer){
		return hit_object.ChasingObjectSpotted == false;
	}else{
		return false;	
	}
}

function hit_effects(BodyPart, armour_id, helmet_id, armour_durability, helmet_durability, impact_x, impact_y, attacking_object, hit_object, is_player) { 
	
	var randomDirection = random(360);
	
	if(instance_exists(attacking_object)){
		randomDirection = random_range(attacking_object.RotationAngle - 180 - 90, attacking_object.RotationAngle - 180 + 90);
	}

    // DAMAGE TO BODY
    if (BodyPart > HITBOX.HeadProne) {

        if (global.ItemIndex[# armour_id, ItemStat.Defense] > .95 || armour_durability <= 0 
        || BodyPart >= HITBOX.ArmNoWeapon) {

            if !audio_is_playing(snd_BulletHit) {
                play_sound(impact_x, impact_y, snd_BulletHit, attacking_object);
            }

        } else {

            var dmg_loss = hit_object.attack_damage / 50 / global.ItemIndex[# armour_id, ItemStat.Defense];
            if (is_player) {
                if (hit_object.is_local) {
                    global.Inventory[# OtherSlot.Armour, Index.slot_durability] = max(global.Inventory[# OtherSlot.Armour, Index.slot_durability] - dmg_loss, 0);
                } else {
                    hit_object.network_armour_dur = max(hit_object.network_armour_dur - dmg_loss, 0);
                }
            } else {
                hit_object.ArmourDurability[0] = max(hit_object.ArmourDurability[0] - dmg_loss, 0);
            }

            for (var i = 0; i < ceil(max(hit_object.attack_damage / 5, 10)); i++) {
                part_type_color1(oParticleSystem.headshot_particle, c_gray);
                part_type_direction(oParticleSystem.headshot_particle, randomDirection, randomDirection, 0, 0);
                part_type_orientation(oParticleSystem.headshot_particle, randomDirection, randomDirection, 0, 0, false);
                part_particles_create(global.ParticleSystem, impact_x, impact_y, oParticleSystem.headshot_particle, 1);
                part_type_color1(oParticleSystem.headshot_particle, c_white);
            }

            var sound_effect = snd_BulletHitArmour1;

            if !audio_is_playing(sound_effect) {
                play_sound(impact_x, impact_y, sound_effect, attacking_object);
            }
        }

    } else {

        if (global.ItemIndex[# helmet_id, ItemStat.Defense] > .95 || helmet_durability <= 0) {

            var sound_effect2 = choose(snd_HeadShot1, snd_HeadShot2);
            if !audio_is_playing(sound_effect2) {
                play_sound(impact_x, impact_y, sound_effect2, attacking_object);
            }

        } else {

            var dmg_loss2 = hit_object.attack_damage / 50 / global.ItemIndex[# helmet_id, ItemStat.Defense];

            if (is_player) {
                if (hit_object.is_local) {
                    global.Inventory[# OtherSlot.Helmet, Index.slot_durability] = max(global.Inventory[# OtherSlot.Helmet, Index.slot_durability] - dmg_loss2, 0);
                } else {
                    hit_object.network_helmet_dur = max(hit_object.network_helmet_dur - dmg_loss2, 0);
                }
            } else {
                hit_object.ArmourDurability[1] = max(hit_object.ArmourDurability[1] - dmg_loss2, 0);
            }

            for (var j = 0; j < ceil(max(hit_object.attack_damage / 5, 10)); j++) {
                part_type_direction(oParticleSystem.headshot_particle, randomDirection, randomDirection, 0, 0);
                part_type_orientation(oParticleSystem.headshot_particle, randomDirection, randomDirection, 0, 0, false);
                part_particles_create(global.ParticleSystem, impact_x, impact_y, oParticleSystem.headshot_particle, 1);
            }

            if !audio_is_playing(snd_HeadShotHelmet) {
                play_sound(impact_x, impact_y, snd_HeadShotHelmet, attacking_object);
            }
        }
    }
}
