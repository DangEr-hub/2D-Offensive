/// Room start - NetworkManager
if (is_server) {
    create_local_player(my_pid);
}else if(is_connected == true){
	create_local_player(my_pid);
}
