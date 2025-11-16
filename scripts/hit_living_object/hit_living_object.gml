function enemy_initialized(hitObj, enemy_key, enemy_name) {
    var enemyStatsMap;

    if (!ds_map_exists(hitObj.HitMap, enemy_key)) {
        enemyStatsMap = ds_map_create();
        ds_map_add(enemyStatsMap, "Name", enemy_name);
        ds_map_add(enemyStatsMap, "HitsReceived", 0);
        ds_map_add(enemyStatsMap, "DamageReceived", 0);
        ds_map_add(enemyStatsMap, "HitsGiven", 0);
        ds_map_add(enemyStatsMap, "DamageGiven", 0);
        hitObj.HitMap[$ enemy_key] = enemyStatsMap;
    } else {
        enemyStatsMap = hitObj.HitMap[$ enemy_key];
    }

    return enemyStatsMap;
}

function send_hit(attacking_item, hit_object, BodyPart, BloodSplashX, BloodSplashY, hit_spd_mod) {
    if (!instance_exists(oNetworkManager)) { return;}
    if (hit_object.object_index != oPlayer) {return;} ///zatím jen hráče

    var attacker_pid = attacking_item.stats.Owner_id;
    var victim_pid = hit_object.network_id;
    if (attacker_pid < 0 || victim_pid < 0) {return;}

    var damage = hit_object.attack_damage;

    with (oNetworkManager) {
        if (is_server) {
                server_process_hit(attacker_pid, victim_pid, damage, BodyPart, BloodSplashX, BloodSplashY, true, hit_spd_mod);
        } else if (is_connected) {
                buffer_seek(send_buffer, buffer_seek_start, 0);
                buffer_write(send_buffer, buffer_u8, PACKET.HIT);
                buffer_write(send_buffer, buffer_u32, send_sequence++);
                buffer_write(send_buffer, buffer_u16, attacker_pid);
                buffer_write(send_buffer, buffer_u16, victim_pid);
                buffer_write(send_buffer, buffer_f16, damage);
                buffer_write(send_buffer, buffer_u8, BodyPart);
                buffer_write(send_buffer, buffer_f32, BloodSplashX);
                buffer_write(send_buffer, buffer_f32, BloodSplashY);
				buffer_write(send_buffer, buffer_f16, hit_spd_mod);

                network_send_udp(client_socket, server_ip, server_port, send_buffer, buffer_tell(send_buffer));
        }
    }
}

function hit_living_object(hit_object, BodyPart, attacking_item, ArmourID, HelmetID, BloodSplashX = other.x, BloodSplashY = other.y){
	if!(instance_exists(hit_object)){
		return;
	}
	
	var is_player = (hit_object.object_index == oPlayer);
	var is_bot = (hit_object.object_index == oEnemy);
	var has_godmode = false;
	var armour_id = Item.None;
	var helmet_id = Item.None;
	var helmet_durability = 0;
	var armour_durability = 0;
	var blood_color = c_red;
	var is_net  = instance_exists(oNetworkManager);
	var data = -1;
	var hp = hit_object.stats.Health_points;
	
	/* Networking */
	if(is_player){
		has_godmode = bit_state_has(hit_object.network_bit_state, PLAYER_FLAGS.GODMODE);
		armour_id = hit_object.network_armour_id;
		helmet_id = hit_object.network_helmet_id;
		armour_durability = hit_object.network_armour_dur;
		helmet_durability = hit_object.network_helmet_dur;
	}
	/*************/
	
	if(is_bot){
		armour_durability = hit_object.ArmourDurability[0];
		helmet_durability = hit_object.ArmourDurability[1];
	}
	
	
	/* Offline gameplay  */
	if!(is_net){
		has_godmode = global.GodMode;	
		armour_id = ArmourID;
		helmet_id = HelmetID;
		helmet_durability = global.Inventory[# OtherSlot.Helmet, Index.slot_durability];
		armour_durability = global.Inventory[# OtherSlot.Armour, Index.slot_durability];
	}
	/********************/
	
	/* Hit marker */
	oCrosshair.HitMarker = 0;
	if(BodyPart <= HitBox.HeadProne){
		oCrosshair.HitMarker = 4;
	}
	/**************/

	if(hp > 0 && has_godmode == false){
		var Damage = attacking_item.stats.Damage * power(1 - global.ItemIndex[#attacking_item.stats.Item_id, ItemStat.DamageDrop], point_distance(x, y, attacking_item.stats.Starting_x, attacking_item.stats.Starting_y));
		hit_object.aimpunch_speed_multiplier = min(1, (1 - (global.ItemIndex[#attacking_item.stats.Item_id, ItemStat.PenetrationPower] / (attacking_item.stats.Penetration_damage + 1))) / global.ItemIndex[#armour_id, ItemStat.Defense]);
		hit_object.attack_damage = Damage;
		hit_object.AimPunchTimer = hit_object.AimPunchTime;
		hit_object.AimPunchMultiplier = global.ItemIndex[#attacking_item.stats.Item_id, ItemStat.PenetrationPower] / (attacking_item.stats.Penetration_damage + 1);
		
		/* Stealth damage with knife */
		if(global.ItemIndex[# attacking_item.stats.Item_id, ItemStat.WeaponTypeClass] == "Knife"){
			if(apply_stealth_damage(hit_object)){
				Damage *= STEALTH_DMG_MOD;
			}
		}
		/*****************************/
		
		if(hit_object.object_index == oEnemy){
			with(hit_object){
				if(ChasingObjectSpotted == false){
					ChasingObjectSpot(ceil(5 * game_get_speed(gamespeed_fps) * get_rank_boost(global.rating_struct.Enemy_ep[global.rating_struct.Current_game])));
				}
			}
		}
		
		if(BodyPart >= HitBox.LegProne){
			DamageMultiplier = LEG_MULTIPLIER;
		}else if(BodyPart >= HitBox.ArmWithoutWeapon){
			DamageMultiplier = ARM_MULTIPLIER;
			if(armour_durability > 0){
				if(global.ItemIndex[# armour_id, ItemStat.Defense] <= .95){
					hit_object.attack_damage = Damage * global.ItemIndex[# armour_id, ItemStat.Defense] * global.ItemIndex[# attacking_item.stats.Item_id, ItemStat.PenetrationPower];
				}
			}
		}else if(BodyPart >= HitBox.BodyWithoutWeapon){
			DamageMultiplier = BODY_MULTIPLIER;
			if(armour_durability > 0){
				if(global.ItemIndex[#armour_id, ItemStat.Defense] <= .95){
					hit_object.attack_damage = Damage * global.ItemIndex[# armour_id, ItemStat.Defense] * global.ItemIndex[#attacking_item.stats.Item_id, ItemStat.PenetrationPower];
				}
			}
		}else if(BodyPart >= HitBox.Head){
			DamageMultiplier = HEADSHOT_MULTIPLIER;
			blood_color = c_maroon;
			if(helmet_durability > 0){
				if(global.ItemIndex[# helmet_id, ItemStat.Defense] <= .95){
					hit_object.attack_damage = Damage * global.ItemIndex[# helmet_id, ItemStat.Defense] * global.ItemIndex[#attacking_item.stats.Item_id, ItemStat.PenetrationPower];
				}
			}
		}
		
		hit_object.attack_damage *= DamageMultiplier / (attacking_item.stats.Penetration_damage + 1);
		hit_object.attack_damage = ceil(hit_object.attack_damage);
		
		if(hit_object.object_index == oEnemy){
			hit_object.enemy_aimpunch = hit_object.attack_damage;
		}

		var BloodSplashNumber = ceil(hit_object.attack_damage / 5);
		var BloodParticleNumber = ceil(hit_object.attack_damage / 2);
		var attacker_key = -1;
		var attacker_name = "";
		var victim_key = -1;
		var victim_name = "";
		var attacker = attacking_item.stats.Object;

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
		ds_map_replace(enemyStatsMap, "HitsReceived", ds_map_find_value(enemyStatsMap, "HitsReceived") + 1);
		ds_map_replace(enemyStatsMap, "DamageReceived", ds_map_find_value(enemyStatsMap, "DamageReceived") + hit_object.attack_damage);

		// When the hit_object hits back the attacking_item.stats.Object
	    var hitObjectStatsMap = enemy_initialized(attacker, victim_key, victim_name);
	    ds_map_replace(hitObjectStatsMap, "HitsGiven", ds_map_find_value(hitObjectStatsMap, "HitsGiven") + 1);
	    ds_map_replace(hitObjectStatsMap, "DamageGiven", ds_map_find_value(hitObjectStatsMap, "DamageGiven") + hit_object.attack_damage);
		
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
		var is_host = is_net && oNetworkManager.is_server;

		if (hp <= hit_object.attack_damage) {
		    if (!is_net) {
		        // SINGLEPLAYER REWARD
		        global.player_stats_struct.Money += reward;
		        if (global.ranked_game) {
		            global.player_stats_struct.Kills++;
		            oRatingController.kills++;
		        }
		    } else if (is_host) {
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

		    var death_sound_effect = choose(snd_Death1, snd_Death2);
		    if !audio_is_playing(death_sound_effect) {
		        play_sound(BloodSplashX, BloodSplashY, death_sound_effect, attacking_item.stats.Object);
		    }
		    hit_object.KilledByName = attacking_item.stats.Owner_name;
		    hit_object.KilledByWeapon = global.ItemIndex[# attacking_item.stats.Item_id, ItemStat.Name];
		} else {
			statistics_hit("Health", hit_object.attack_damage, hit_object);
		}
		

	
		if (is_player) {
		    hit_object.AimPunchDir = irandom(sprite_get_number(spr_AimPunch) - 1);
		} else {
		    if (global.ranked_game) {
		        if (!is_net) {
		            // SINGLEPLAYER
		            global.player_stats_struct.Hit_shots++;
		            oRatingController.hit_shots++;
		            if (BodyPart <= HitBox.HeadProne) {
		                global.player_stats_struct.Headshots++;
		                oRatingController.headshots++;
		            }
		        } else if (is_host && attacker_pid >= 0) {
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
		                if (BodyPart <= HitBox.HeadProne) {
		                    ds_map_set(stats, "Headshots", ds_map_find_value(stats, "Headshots") + 1);
		                }
		            }
		        }
		    }
		}

		repeat(BloodSplashNumber){
			BloodSplash = instance_create_layer(BloodSplashX, BloodSplashY, "ItemsO", oBloodSplash);
			BloodSplash.image_blend = blood_color;
		}
		if(instance_exists(oParticleSystem)){
			part_type_color1(oParticleSystem.BloodParticle, blood_color);
			part_particles_create(global.ParticleSystem, BloodSplashX, BloodSplashY, oParticleSystem.BloodParticle, BloodParticleNumber);
		}
		
		/*if(BodyPart != HitBox.Head){
			if(global.ItemIndex[# ArmourID, ItemStat.Defense] > .95 || armour_durability <= 0 || BodyPart == HitBox.ArmWithAssaultRifle || BodyPart == HitBox.ArmWithoutWeapon || BodyPart == HitBox.ArmWithPistol || BodyPart == HitBox.LegProne){
				var sound_effect = snd_BulletHit;
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, attacking_item.stats.Object);
				}
			}else{
				if(is_player){
					global.Inventory[# OtherSlot.Armour, Index.slot_durability] -= hit_object.attack_damage/50/global.ItemIndex[#ArmourID, ItemStat.Defense];	
					global.Inventory[# OtherSlot.Armour, Index.slot_durability] = max(global.Inventory[# OtherSlot.Armour, Index.slot_durability], 0);
				}else{
					hit_object.ArmourDurability[0] -= hit_object.attack_damage/50/global.ItemIndex[#ArmourID, ItemStat.Defense];
					hit_object.ArmourDurability[0] = max(hit_object.ArmourDurability[0], 0);
				}
				if(instance_exists(oParticleSystem) && instance_exists(attacking_item.stats.Object)){
					var posX = BloodSplashX;
					var posY = BloodSplashY;
					var partSystem = global.ParticleSystem;
					var partType = oParticleSystem.headshot_particle;
					var numParticles = ceil(max(hit_object.attack_damage / 5, 10));

					for (var i = 0; i < numParticles; i++) {
					    var randomDirection = random_range(attacking_item.stats.Object.RotationAngle - 180 - 90, attacking_item.stats.Object.RotationAngle - 180 + 90);
						part_type_color1(partType, c_gray);
					    part_type_direction(partType, randomDirection, randomDirection, 0, 0);
					    part_type_orientation(partType, randomDirection, randomDirection, 0, 0, false);
					    part_particles_create(partSystem, posX, posY, partType, 1);
						part_type_color1(partType, c_white);
					}
				}
				var sound_effect = choose(snd_BulletHitArmour1, snd_BulletHitArmour2);
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, attacking_item.stats.Object);
				}
			}
		}else{
			if(instance_exists(oParticleSystem) && instance_exists(attacking_item.stats.Object)){
				var posX = BloodSplashX;
				var posY = BloodSplashY;
				var partSystem = global.ParticleSystem;
				var partType = oParticleSystem.headshot_particle;
				var numParticles = ceil(max(hit_object.attack_damage / 5, 10));

				for (var i = 0; i < numParticles; i++) {
				    var randomDirection = random_range(attacking_item.stats.Object.RotationAngle - 180 - 90, attacking_item.stats.Object.RotationAngle - 180 + 90);
				    part_type_direction(partType, randomDirection, randomDirection, 0, 0);
				    part_type_orientation(partType, randomDirection, randomDirection, 0, 0, false);
				    part_particles_create(partSystem, posX, posY, partType, 1);
				}
			}
			if(global.ItemIndex[#HelmetID, ItemStat.Defense] > .95 || helmet_durability <= 0){
				var sound_effect = choose(snd_HeadShot1, snd_HeadShot2);
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, attacking_item.stats.Object);
				}
			}else{
				if(hit_object.object_index == global.local_player){
					global.Inventory[# OtherSlot.Helmet, Index.slot_durability] -= hit_object.attack_damage/50/global.ItemIndex[#HelmetID, ItemStat.Defense];	
					global.Inventory[# OtherSlot.Helmet, Index.slot_durability] = max(global.Inventory[# OtherSlot.Helmet, Index.slot_durability], 0);
				}else{
					hit_object.ArmourDurability[1] -= hit_object.attack_damage/50/global.ItemIndex[#HelmetID, ItemStat.Defense];
					hit_object.ArmourDurability[1] = max(hit_object.ArmourDurability[1], 0);
				}
				var sound_effect = snd_HeadShotHelmet;
				if!(audio_is_playing(sound_effect)){
					play_sound(BloodSplashX, BloodSplashY, sound_effect, attacking_item.stats.Object);
				}
			}
		}*/
		
        if (is_net) {
            send_hit(attacking_item, hit_object, BodyPart, BloodSplashX, BloodSplashY, hit_object.aimpunch_speed_multiplier);
        }
		
		damage_indicator("-" + string(ceil(hit_object.attack_damage)), BloodSplashX, BloodSplashY, c_white, spr_Icons, icons.health);
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