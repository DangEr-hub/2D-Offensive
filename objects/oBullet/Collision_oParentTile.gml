var wall_sound = snd_BulletMetal;

if(other.Type == "Concrete"){
	wall_sound = snd_BulletConcrete;	
}

if!(audio_is_playing(wall_sound)){
	play_sound(x, y, wall_sound, stats.Object);
}




