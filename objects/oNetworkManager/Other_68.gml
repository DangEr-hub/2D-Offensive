/* oNetworkManager - Async Networking Event */
var type = async_load[? "type"];
switch (type) {
		case network_type_data:
		    var sender_ip   = async_load[? "ip"];
		    var sender_port = async_load[? "port"];
		    buffer_seek(receive_buffer, buffer_seek_start, 0);
			
			var inbuf = async_load[? "buffer"];
			var sz    = buffer_get_size(inbuf);
			buffer_seek(receive_buffer, buffer_seek_start, 0);
			buffer_copy(inbuf, 0, sz, receive_buffer, 0);


		    if (is_server)
		        handle_server_receive(sender_ip, sender_port);
		    else
		        handle_client_receive();
		    break;

    case network_type_disconnect:
        if (is_server)
            handle_client_disconnect(async_load[? "socket"]);
        else
            handle_server_disconnect();
        break;
}
