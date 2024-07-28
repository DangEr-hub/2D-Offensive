if(place_meeting(x, y, oPlayer)){
	if(oPlayer.hidden == false){
		oPlayer.hidden = true;	
	}
}else{
	if(oPlayer.hidden == true){
		oPlayer.hidden = false;	
	}
}