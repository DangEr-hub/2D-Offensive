event_inherited();
if(percent_chance(1)){
    part_emitter_region(global.ParticleSystem, oParticleSystem.leaf_emitter, x - sprite_width*image_xscale/4, x + sprite_width*image_xscale/4, y - sprite_height*image_yscale/4, y + sprite_height*image_yscale/4, ps_shape_rectangle, ps_distr_linear);
    part_emitter_burst(global.ParticleSystem, oParticleSystem.leaf_emitter, oParticleSystem.leaf_particle, 1);
}
