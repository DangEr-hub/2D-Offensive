/* oNetworkManager - Async Networking Event */
var type = async_load[? "type"];
switch (type) {
		case network_type_data:
		    var sender_ip   = async_load[? "ip"];
		    var sender_port = async_load[? "port"];
			var inbuf = async_load[? "buffer"];
			var sz    = async_load[? "size"];
			if (sz < 5) break; // packet type (u8) + sequence (u32)
			buffer_resize(receive_buffer, sz); // Do not leave bytes from the previous packet readable.
			buffer_seek(receive_buffer, buffer_seek_start, 0);
			buffer_copy(inbuf, 0, sz, receive_buffer, 0);


		    if (is_server)
		        handle_server_receive(sender_ip, sender_port);
		    else
		        handle_client_receive(sender_ip, sender_port);
		    break;

    case network_type_disconnect:
        if (is_server)
            handle_client_disconnect(async_load[? "socket"]);
        else
            handle_server_disconnect();
        break;
}
