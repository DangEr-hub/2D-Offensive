part_timer += global.time_step;
if (part_timer >= 1) {
    part_system_update(global.ParticleSystem);
    part_timer -= 1;
}