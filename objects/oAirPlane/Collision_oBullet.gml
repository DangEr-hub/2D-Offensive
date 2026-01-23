var dmg = round(other.stats.Damage * global.ItemIndex[# other.stats.Item_id, ItemStat.PenetrationPower]);
var p_number = round(dmg/10);


play_sound(other.x, other.y, snd_BulletMetal);

part_particles_create(global.ParticleSystem, other.x, other.y, oParticleSystem.Spark, p_number);
part_particles_create(global.ParticleSystem, other.y, other.x, oParticleSystem.headshot_particle, p_number);

damage_indicator("-" + string(dmg), other.x, other.y, c_white, spr_Icons, ICON.health);

stats.Health_points = max(stats.Health_points - dmg, 0);












