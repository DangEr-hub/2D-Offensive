// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlaySound(PositionX, PositionY, Sound, falloff_ref_dist = 100, fallof_max_dist = 2500, falloff_factor = 1.5, ObjectType = self, Priority = 0){
    ObjectType.Emitter = audio_emitter_create();
    audio_emitter_position(ObjectType.Emitter, oPlayer.x - (PositionX - oPlayer.x), PositionY, 0);
    audio_emitter_falloff(ObjectType.Emitter, falloff_ref_dist, fallof_max_dist, falloff_factor);
    audio_play_sound_on(ObjectType.Emitter, Sound, false, Priority);
    ObjectType.alarm[5] = audio_sound_length(Sound)*game_get_speed(gamespeed_fps)/1000;
}