if(place_meeting(x, y, global.local_player)){
	if(global.local_player.hidden == false){
		global.local_player.hidden = true;	
	}
}else{
	if(global.local_player.hidden == true){
		global.local_player.hidden = false;	
	}
}