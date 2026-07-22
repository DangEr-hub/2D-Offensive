if!(global.my_console[? "active"]){
	if(global.time_step == 1){
	global.time_step = .25;
	}else{ global.time_step = 1;}
}