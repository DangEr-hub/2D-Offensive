/// @description Composite haze before regular GUI and HUD drawing
//Draw haze areas
if(instance_exists(oPlayer)
&& instance_exists(global.local_player)
&& global.local_player.ScopeIn
&& global.local_player.player_has_scope == 0){
	exit;
}

var haze_active = coverScreen;

if (!haze_active) {
    for (var i = 0; i < ds_list_size(hazePoints); i++) {
        var point_arr = hazePoints[| i];
        if (point_arr[2] > 1) {
            haze_active = true;
            break;
        }
    }
}

if (!haze_active) {
    for (var i = 0; i < ds_list_size(hazeAreas); i++) {
        var area_arr = hazeAreas[| i];
        if (area_arr[2] > 1 && area_arr[3] > 1) {
            haze_active = true;
            break;
        }
    }
}

if (!haze_active) {
    exit;
}

//Camera vars
var cam_id = view_camera[viewN];

var cam_x = camera_get_view_x(cam_id);
var cam_y = camera_get_view_y(cam_id);
var cam_w = camera_get_view_width(cam_id);
var cam_h = camera_get_view_height(cam_id);

//Vars
var pos = application_get_position();

if (!surface_exists(hazePointSurf)) {
    hazePointSurf = surface_create(surfW, surfH);
}

//Point surf
surface_set_target(hazePointSurf);
//haze_surf_clear(pointSurf);
draw_clear_alpha(0, 0);

draw_clear(c_black);

//cover screen
if (coverScreen){
    draw_set_color(c_white);
    draw_rectangle(0, 0, surfW, surfH, false);
}

//circle
gpu_set_blendmode(bm_add);

for(var i=0; i<ds_list_size(hazePoints); i++){
    //get array
    var Arr = hazePoints[|i];
    
    //translate to surface coords
    var sX, sY, sR = 0;
    sX = Arr[0] - (cam_x*cameraUsed);
    sY = Arr[1] - (cam_y*cameraUsed);
    sR = Arr[2];
    
    //subtract app coord
    //sX -= pos[0]/2;
    //sY -= pos[1]/2;
    
    //scale
    if (cameraUsed){
        sX *= surfW/cam_w;
        sY *= surfH/cam_h;
        sR *= surfW/cam_w;
    }
    else{
        sX *= surfW/room_width;
        sY *= surfH/room_height;
        sR *= surfW/room_width;
    }
    
    //draw
    draw_circle_colour(sX, sY, sR, c_white, c_black, false);
}

//rect
for(var i=0; i<ds_list_size(hazeAreas); i++){
    //get array
    var Arr = hazeAreas[|i];
    
    //translate to surface coords
    var sX, sY, sW, sH = 0;
    sX = Arr[0] - (cam_x*cameraUsed);
    sY = Arr[1] - (cam_y*cameraUsed);
    sW = Arr[2];
    sH = Arr[3];
    
    //scale
    if (cameraUsed){
        sX *= surfW/cam_w;
        sY *= surfH/cam_h;
        sW *= surfW/cam_w;
        sH *= surfH/cam_h;
    }
    else{
        sX *= surfW/room_width;
        sY *= surfH/room_height;
        sW *= surfW/room_width;
        sH *= surfH/room_height;
    }
    
    //draw
    draw_set_color(c_white);
    draw_rectangle(sX, sY, sX+sW, sY+sH, false);
}

gpu_set_blendmode(bm_normal);

surface_reset_target();

//Draw to surface
surface_set_target(hazeSurf);

//haze_surf_clear(hazeSurf);
draw_clear_alpha(0, 0);

//Draw app surf
shader_set(sh_haze);

shader_set_uniform_f(uniTime, current_time);
gpu_set_texrepeat_ext(uniSamp, true);
var NTex = sprite_get_texture(spr_haze_noise, 0);
texture_set_stage(uniSamp, NTex);
shader_set_uniform_f(uniSampSize, texture_get_width(NTex), texture_get_height(NTex));

shader_set_uniform_f(uniSpeed, hazeSpeed/100);
shader_set_uniform_f(uniSize, hazeSize/1000);
shader_set_uniform_f(uniFreq, hazeWaveLength/2.5);

var source_surface = application_surface;
if(instance_exists(oDraw) && surface_exists(oDraw.haze_source_surface)){
    source_surface = oDraw.haze_source_surface;
}

draw_surface_stretched(source_surface, 0, 0, surfW, surfH);

shader_reset();

//Points
shader_set(sh_mask);
gpu_set_blendmode_ext(bm_zero, bm_src_color);
draw_surface(hazePointSurf, 0, 0);
gpu_set_blendmode(bm_normal);
shader_reset();


surface_reset_target();

//Draw haze surface
draw_surface(hazeSurf, 0, 0);

