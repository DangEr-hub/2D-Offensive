if(percent_chance(1)){
    part_emitter_region(global.ParticleSystem, oParticleSystem.leaf_emitter, x - sprite_width*image_xscale/2, x + sprite_width*image_xscale/2, y, y - sprite_height*image_yscale/2, ps_shape_rectangle, ps_distr_linear);
    part_emitter_burst(global.ParticleSystem, oParticleSystem.leaf_emitter, oParticleSystem.leaf_particle, 1);
}
