part_particles_create(global.ParticleSystem, x, y, oParticleSystem.flame_particle, 5);


part_type_life(oParticleSystem.fog_particle, 10, 50);
part_type_direction(oParticleSystem.fog_particle, 30, 150, 0, 5);
part_type_alpha1(oParticleSystem.fog_particle, 1);

part_particles_create(global.ParticleSystem, x, y, oParticleSystem.fog_particle, 1);

part_type_direction(oParticleSystem.fog_particle, 0, 0, 0, 0);
part_type_life(oParticleSystem.fog_particle, camera_get_view_width(CAM), camera_get_view_width(CAM));
part_type_alpha1(oParticleSystem.fog_particle, .25);