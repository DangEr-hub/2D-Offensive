global.ParticleSystem = part_system_create();
part_system_depth(global.ParticleSystem, -10000);
part_system_automatic_update(global.ParticleSystem, false);

leaf_emitter = part_emitter_create(global.ParticleSystem);
part_timer = 0;

//Headshot
headshot_particle = part_type_create();
part_type_sprite(headshot_particle, spr_BulletTracer, 0, 0, 0);
part_type_orientation(headshot_particle, 0, 360, 0, 0, 0);
part_type_color1(headshot_particle, c_white);
part_type_size(headshot_particle, .1, .3,0,.1);
part_type_speed(headshot_particle, 10, 20, 0, 0);
part_type_direction(headshot_particle,0,359,0,0);
part_type_blend(headshot_particle, 1);
part_type_life(headshot_particle, 5, 5);

///Fire
fire_particle = part_type_create();
part_type_sprite(fire_particle,spr_Fire,0,0,1);
part_type_size(fire_particle,.25,.75,-.05,0);
part_type_orientation(fire_particle,0,360,2,0,0);
part_type_colour1(fire_particle,c_orange);
part_type_alpha3(fire_particle,1,1,0);
part_type_blend(fire_particle,1);
part_type_direction(fire_particle,0,360,0,0);
part_type_speed(fire_particle,0.25,1,-.05,0);
part_type_life(fire_particle,30,60);


//Flame
flame_particle = part_type_create();
part_type_shape(flame_particle,pt_shape_line);
part_type_size(flame_particle,.25,1,0,0);
part_type_scale(flame_particle,0.5,1);
part_type_color3(flame_particle,16749459,c_orange,255);
part_type_alpha3(flame_particle,0.04,0.06,0.07);
part_type_speed(flame_particle,0.25,1.5,-0.02,0);
part_type_direction(flame_particle,0,360,0,9);
part_type_blend(flame_particle,1);
part_type_life(flame_particle,10,20);

fog_particle = part_type_create();
part_type_shape(fog_particle, pt_shape_cloud);
part_type_size(fog_particle, .5, 1, 0, .05);
part_type_alpha1(fog_particle, .25);
part_type_speed(fog_particle, 1, 2, 0, .5);
part_type_direction(fog_particle, 0, 360, 0, 0);
part_type_orientation(fog_particle, 0, 360, 0, 0, 0);
part_type_color1(fog_particle, c_white);
part_type_life(fog_particle, camera_get_view_width(CAM), camera_get_view_width(CAM));

//Blood
BloodParticle = part_type_create();
part_type_size(BloodParticle,.25,1.25,0,.05);
part_type_speed(BloodParticle,1,5,0,0);
part_type_direction(BloodParticle,0,359,0,0);
part_type_life(BloodParticle,22,22);
part_type_sprite(BloodParticle, spr_BloodParticle, true, 0, true);

//Spark
Spark = part_type_create();
part_type_shape(Spark, pt_shape_spark);
part_type_size(Spark,.1,.25,0,.1);
part_type_color3(Spark,c_orange, c_yellow, c_orange);
part_type_speed(Spark,5,10,0,0);
part_type_direction(Spark,0,359,0,0);
part_type_blend(Spark, 1);
part_type_life(Spark,5,10);

//Light
LightParticle = part_type_create();
part_type_alpha1(LightParticle,.4);
part_type_color1(LightParticle,c_white);
part_type_shape(LightParticle,pt_shape_spark);
part_type_size(LightParticle,1.5,1.5,0, .05);
part_type_direction(LightParticle, 0, 0, 0, 0);
part_type_orientation(LightParticle, 0, 0, 0, 0, 1);
part_type_blend(LightParticle, 1);
part_type_life(LightParticle, LIGHT_UPDATE + 1, LIGHT_UPDATE + 1);

//Dust
dust_particle = part_type_create();
part_type_speed(dust_particle, 0.1, .5, 0, .05);
part_type_alpha2(dust_particle, .1, .25);
part_type_color1(dust_particle, make_color_rgb(194, 178, 128));
part_type_shape(dust_particle, pt_shape_pixel);
part_type_size(dust_particle,1,3,0, .05);
part_type_life(dust_particle, 1 * game_get_speed(gamespeed_fps), 2 * game_get_speed(gamespeed_fps));
part_type_blend(dust_particle, 1);
part_type_direction(dust_particle, 0, 360, 0, .5);
part_type_orientation(dust_particle, 0, 360, 0, .1, 0);

//Rain

rain_particle = part_type_create();
part_type_alpha2(rain_particle, .4, .5);
part_type_shape(rain_particle, pt_shape_line);
part_type_direction(rain_particle, 0, 360, 0, 1);
part_type_orientation(rain_particle,0,360,0,0,1);
part_type_scale(rain_particle, 0.1, 0.1);
part_type_speed(rain_particle, 3 * (game_get_speed(gamespeed_fps)/60), 4  * (game_get_speed(gamespeed_fps)/60), 0, 1);
part_type_color1(rain_particle, c_aqua);
part_type_life(rain_particle, 5, 7);

//Leaf
leaf_particle = part_type_create();
part_type_sprite(leaf_particle, spr_Leaf, false, false, 1);
part_type_size(leaf_particle, 0.25, 0.75, 0.001, 0);
part_type_direction(leaf_particle, 0, 359, 0, 15);
part_type_speed(leaf_particle, 0.5, 1, 0, .05);
part_type_life(leaf_particle, 2 * game_get_speed(gamespeed_fps), 3 * game_get_speed(gamespeed_fps));
part_type_orientation(leaf_particle, 0, 359, 0.1, 1, 1);
part_type_alpha3(leaf_particle, 0.5, 1, 0.02);

/// Fireflies
firefly_particle = part_type_create();
part_type_shape(firefly_particle, pt_shape_sphere);
part_type_size(firefly_particle, .075, .1, 0, 0);
part_type_color3(firefly_particle, make_color_rgb(80, 255, 80), make_color_rgb(160, 255, 100), make_color_rgb(40, 120, 20));
part_type_alpha3(firefly_particle, 0, 1, 0);
//part_type_blend(firefly_particle, true);
part_type_speed(firefly_particle, 0.1, 0.5, 0, 0);
part_type_direction(firefly_particle, 0, 359, 0, 0);
part_type_orientation(firefly_particle, 0, 359, 0, 0, false);
part_type_life(firefly_particle, 90, 270);

//snow_particle
weather_emitter = part_emitter_create(global.ParticleSystem);
snow_particle = part_type_create();
part_type_sprite(snow_particle, spr_SnowFlake, 0, 0, 0);
part_type_direction(snow_particle, 230, 330, 0, 1);
part_type_orientation(snow_particle,0,359,0,0,1);
part_type_life(snow_particle,180,360);
part_type_speed(snow_particle, 1, 5, 0, 0);
part_type_size(snow_particle, 0.05, 0.1, 0, 0);
part_type_color2(snow_particle, c_white, c_white);

//Level up particle
level_up_speed_min = 15;
level_up_speed_max = 23;
level_up_life_min = 20;
level_up_life_max = 40;
level_up_particle = part_type_create();
part_type_shape(level_up_particle, pt_shape_flare);
part_type_size(level_up_particle, .5, 1, 0, 0);
part_type_color2(level_up_particle, MAIN_COLOR, c_white);
part_type_speed(level_up_particle, level_up_speed_min, level_up_speed_max, 0, 0);
part_type_direction(level_up_particle, 0, 360, 0, 0);
part_type_blend(level_up_particle, 1);
part_type_life(level_up_particle, level_up_life_min, level_up_life_max);
part_type_alpha2(level_up_particle, .5, 1);