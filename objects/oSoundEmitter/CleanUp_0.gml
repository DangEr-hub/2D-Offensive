if(audio_emitter_exists(Emitter)){
	if!(emitter_is_playing(Emitter)){
		cleanup_emitter(Emitter);
	}
}