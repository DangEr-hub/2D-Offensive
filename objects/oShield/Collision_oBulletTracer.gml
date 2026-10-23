var randomDirection = random(360);

for (var i = 0; i < round(max(other.stats.Damage / 5, 10)); i++) {
    part_type_direction(oParticleSystem.headshot_particle, randomDirection, randomDirection, 0, 0);
    part_type_orientation(oParticleSystem.headshot_particle, randomDirection, randomDirection, 0, 0, false);
    part_particles_create_colour(global.ParticleSystem, x, y, oParticleSystem.headshot_particle, c_gray, 1);
}
