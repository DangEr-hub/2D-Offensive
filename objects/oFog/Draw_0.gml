d3d_transform_set_rotation_z(move_dir);
d3d_transform_add_translation(x,y,0);
for (var i = 0; i < num_cloud_particles; i++){
	gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
    draw_set_color(c_white);
    draw_sprite_ext(spr_Fog,cloud_particles[i,8],cloud_particles[i,0],cloud_particles[i,1],cloud_particles[i,6],cloud_particles[i,6],cloud_particles[i,4],c_white,cloud_particles[i,3]);
	gpu_set_blendmode(bm_normal);
}
d3d_transform_set_identity();

