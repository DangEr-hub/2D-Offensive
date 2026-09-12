if(place_meeting(x, y, global.local_player) && image_xscale > 0.5 && image_yscale > 0.5){
	if(global.local_player.hidden == false){
		global.local_player.hidden = true;	
	}
}else{
	if(global.local_player.hidden == true){
		global.local_player.hidden = false;	
	}
}