event_inherited();

terminal_padding = 32 * global.gui_scale;
terminal_width = min(global.GuiW - terminal_padding * 2, global.ConsoleWidth * global.gui_scale + terminal_padding * 2);
terminal_height = min(global.GuiH - terminal_padding * 2, global.ConsoleHeight * global.gui_scale + 128);
zui_set_size(terminal_width, terminal_height);

with(zui_create(0, 0, objUIWindowCaption, depth - 1)){
	caption = "Terminal";
	draggable = 1;
}

terminal_sudo = false;
sudo_login_stage = 0;
sudo_login_username = "";
sudo_pending_command = "";
sudo_login_grants_session = false;
nmap_installed = false;
rssi_tools_installed = false;
authcrack_installed = false;
camctl_installed = false;
doorctl_installed = false;
laserctl_installed = false;
wordlist_downloaded = false;
camera_login_ips = [];
door_login_ips = [];
laser_login_ips = [];
terminal_device_types = [oCam, oDoor, oLaserEmitter, oTerminal];

network_ip = "";
network_name = "";
network_online = true;
network_world_x = instance_exists(global.local_player) ? global.local_player.x : 0;
network_world_y = instance_exists(global.local_player) ? global.local_player.y : 0;

oDraw.register_network_device(id, "t");
network_world_x = instance_exists(global.local_player) ? global.local_player.x : network_world_x;
network_world_y = instance_exists(global.local_player) ? global.local_player.y : network_world_y;

var terminal_console = global.my_console;
terminal_console[? "terminal_mode"] = true;
terminal_console[? "string"] = "";
terminal_console[? "string_pos"] = 1;
console_selection_clear(terminal_console);
terminal_console[? "select"] = 0;
terminal_console[? "dir"] = -1;
terminal_console[? "backspace_hold"] = 0;
terminal_console[? "left_hold"] = 0;
terminal_console[? "right_hold"] = 0;
keyboard_string = "";

if(instance_exists(global.local_player)){
	global.local_player.player_can_shoot = false;
}
if(!terminal_console[? "active"]){
	console_toggle(terminal_console);
}

if(ds_exists(terminal_console[? "history"], ds_type_list)){
	ds_list_clear(terminal_console[? "history"]);
}
if(ds_exists(terminal_console[? "input_history"], ds_type_list)){
	ds_list_clear(terminal_console[? "input_history"]);
}
terminal_console[? "input_select"] = 0;
if(ds_exists(terminal_console[? "text"], ds_type_list)){
	ds_list_clear(terminal_console[? "text"]);
}
if(ds_exists(terminal_console[? "suggestions"], ds_type_list)){
	ds_list_clear(terminal_console[? "suggestions"]);
}

terminal_write = function(lines){
	for(var line_index = 0; line_index < array_length(lines); line_index++){
		console_write_debug(lines[line_index]);
	}
};

terminal_find_device_by_ip = function(target_ip){
	for(var type_index = 0; type_index < array_length(terminal_device_types); type_index++){
		var device_type = terminal_device_types[type_index];
		for(var device_index = 0; device_index < instance_number(device_type); device_index++){
			var device = instance_find(device_type, device_index);
			if(instance_exists(device)
			&& variable_instance_exists(device, "network_ip")
			&& device.network_ip == target_ip){
				return device;
			}
		}
	}
	return noone;
};

terminal_ip_is_logged_in = function(login_ips, target_ip){
	for(var login_index = 0; login_index < array_length(login_ips); login_index++){
		if(login_ips[login_index] == target_ip) return true;
	}
	return false;
};

terminal_add_suggestions = function(console){
	console_add(console, "sudo su");
	console_add(console, "sudo apt install nmap");
	console_add(console, "sudo apt install rssi-tools");
	console_add(console, "sudo apt install camctl");
	console_add(console, "sudo apt install doorctl");
	console_add(console, "sudo apt install laserctl");
	if(terminal_sudo){
		console_add(console, "apt install nmap");
		console_add(console, "apt install rssi-tools");
		console_add(console, "apt install camctl");
		console_add(console, "apt install doorctl");
		console_add(console, "apt install laserctl");
	}
	console_add(console, "wget authcrack.exe");
	console_add(console, "ip addr");
	console_add(console, "ip route");
	console_add(console, "wget pass.txt");
	console_add(console, "nmap <network/CIDR>");
	console_add(console, "nmap <ip address>");
	console_add(console, "ping <ip address>");
	console_add(console, "rssi-scan <ip address>");
	console_add(console, "rssi-scan --distance <ip address>");
	console_add(console, "netflood <ip address>");
	console_add(console, "authcrack --target <ip address> --wordlist pass.txt");
	console_add(console, "camctl --host <ip address> status");
	console_add(console, "camctl --host <ip address> login <username> <password>");
	console_add(console, "doorctl --host <ip address> status");
	console_add(console, "doorctl --host <ip address> login <username> <password>");
	console_add(console, "laserctl --host <ip address> status");
	console_add(console, "laserctl --host <ip address> login <username> <password>");
	console_add(console, "sudo systemctl stop camera@<ip address>");
	console_add(console, "sudo systemctl start camera@<ip address>");
	console_add(console, "sudo systemctl restart camera@<ip address>");
	console_add(console, "sudo systemctl stop door@<ip address>");
	console_add(console, "sudo systemctl start door@<ip address>");
	console_add(console, "sudo systemctl stop laser@<ip address>");
	console_add(console, "sudo systemctl start laser@<ip address>");
	console_add(console, "sudo systemctl restart laser@<ip address>");
	if(terminal_sudo){
		console_add(console, "systemctl stop camera@<ip address>");
		console_add(console, "systemctl start camera@<ip address>");
		console_add(console, "systemctl restart camera@<ip address>");
		console_add(console, "systemctl stop door@<ip address>");
		console_add(console, "systemctl start door@<ip address>");
		console_add(console, "systemctl stop laser@<ip address>");
		console_add(console, "systemctl start laser@<ip address>");
		console_add(console, "systemctl restart laser@<ip address>");
	}
};

terminal_add_suggestions(terminal_console);
terminal_console[? "preset"] = true;

terminal_command_submit = function(input){
	var command = input;

	if(sudo_login_stage == 1){
		sudo_login_username = command;
		sudo_login_stage = 2;
		terminal_write(["Password:"]);
		return;
	}

	if(sudo_login_stage == 2){
		var sudo_valid_login =
			sudo_login_username == oDraw.network_username
			&& command == oDraw.network_password;
		var pending_command = sudo_pending_command;
		var grant_session = sudo_login_grants_session;
		sudo_login_stage = 0;
		sudo_login_username = "";
		sudo_pending_command = "";
		sudo_login_grants_session = false;

		if(sudo_valid_login){
			terminal_write(["Authentication successful."]);
			if(grant_session){
				terminal_sudo = true;
				terminal_write(["root access granted for this terminal session"]);
			}else if(pending_command != ""){
				terminal_sudo = true;
				terminal_command_submit(pending_command);
				terminal_sudo = false;
			}
		}else{
			terminal_write(["Authentication failed."]);
		}
		return;
	}

	if(command == "sudo su"){
		if(terminal_sudo){
			terminal_write(["This terminal session already has root access."]);
			return;
		}
		sudo_pending_command = "";
		sudo_login_grants_session = true;
		sudo_login_stage = 1;
		terminal_write(["Username:"]);
		return;
	}

	var used_sudo = false;
	if(string_copy(command, 1, 5) == "sudo "){
		used_sudo = true;
		command = string_delete(command, 1, 5);
		if(!terminal_sudo){
			sudo_pending_command = command;
			sudo_login_grants_session = false;
			sudo_login_stage = 1;
			terminal_write(["Username:"]);
			return;
		}
	}

	var words = string_split(command, " ");
	var word_count = array_length(words);
	var requires_sudo = false;

	if(word_count >= 3 && words[0] == "apt" && words[1] == "install"){
		requires_sudo = true;
	}
	if(word_count >= 2 && words[0] == "systemctl" && words[1] != "status"){
		requires_sudo = true;
	}

	if(requires_sudo && !used_sudo && !terminal_sudo){
		terminal_write(["Permission denied. Run the command with sudo."]);
		return;
	}

	if(word_count == 3 && words[0] == "apt" && words[1] == "install"){
		switch(words[2]){
			case "nmap":
				nmap_installed = true;
				terminal_write([
					"Reading package lists... Done",
					"Building dependency tree... Done",
					"The following NEW packages will be installed:",
					"  nmap",
					"Setting up nmap...",
					"Done."
				]);
			return;

			case "rssi-tools":
				rssi_tools_installed = true;
				terminal_write([
					"Reading package lists... Done",
					"The following NEW packages will be installed:",
					"  rssi-tools",
					"Setting up rssi-tools...",
					"Done."
				]);
			return;

			case "camctl":
				camctl_installed = true;
				terminal_write(["Reading package lists... Done", "Setting up camctl...", "Done."]);
			return;

			case "doorctl":
				doorctl_installed = true;
				terminal_write(["Reading package lists... Done", "Setting up doorctl...", "Done."]);
			return;

			case "laserctl":
				laserctl_installed = true;
				terminal_write(["Reading package lists... Done", "Setting up laserctl...", "Done."]);
			return;
		}
	}

	if(command == "ip addr"){
		terminal_write(["eth0:", "    inet " + network_ip + "/24", "    state UP"]);
		return;
	}

	if(command == "ip route"){
		terminal_write([
			"default via " + oDraw.network_gateway + " dev eth0",
			oDraw.network_prefix + ".0/24 dev eth0"
		]);
		return;
	}


	if(word_count == 2 && words[0] == "nmap"){
		if(!nmap_installed){
			terminal_write(["bash: nmap: command not found"]);
			return;
		}

		if(words[1] == oDraw.network_prefix + ".0/24"){
			terminal_write(["Nmap scan report for " + oDraw.network_gateway, "Host is up."]);
			for(var type_index = 0; type_index < array_length(terminal_device_types); type_index++){
				var device_type = terminal_device_types[type_index];
				for(var device_index = 0; device_index < instance_number(device_type); device_index++){
					var device = instance_find(device_type, device_index);
					if(instance_exists(device) && variable_instance_exists(device, "network_ip") && device.network_ip != ""){
						terminal_write(["Nmap scan report for " + device.network_ip, device.network_online ? "Host is up." : "Host seems down."]);
					}
				}
			}
			return;
		}

		var device = terminal_find_device_by_ip(words[1]);
		if(!instance_exists(device) || !device.network_online){
			terminal_write(["Host seems down."]);
			return;
		}

		terminal_write(["Nmap scan report for " + device.network_ip, "PORT     STATE   SERVICE", "22/tcp   open    ssh", "443/tcp  open    https"]);
		if(device.object_index == oCam){
			terminal_write(["8554/tcp open    camera-control"]);
		}else if(device.object_index == oDoor){
			terminal_write(["9443/tcp open    door-control"]);
		}else if(device.object_index == oLaserEmitter){
			terminal_write(["9553/tcp open    laser-control"]);
		}else{
			terminal_write(["8080/tcp open    terminal-control"]);
		}
		return;
	}

	if(word_count == 2 && words[0] == "ping"){
		var device = terminal_find_device_by_ip(words[1]);
		if(!instance_exists(device) || !device.network_online){
			terminal_write(["Request timeout", "Request timeout"]);
		}else{
			var r_time = random_range(5, 100);
			terminal_write([
				"64 bytes from " + words[1] + ": icmp_seq=1 ttl=64 time=" + string(r_time) + " ms",
				"64 bytes from " + words[1] + ": icmp_seq=2 ttl=64 time=" + string(r_time) + " ms",
			]);
		}
		return;
	}

	if(words[0] == "rssi-scan"){
		if(!rssi_tools_installed){
			terminal_write(["bash: rssi-scan: command not found"]);
			return;
		}

		var show_distance = false;
		var target_ip = "";
		if(word_count == 2){
			target_ip = words[1];
		}else if(word_count == 3 && words[1] == "--distance"){
			show_distance = true;
			target_ip = words[2];
		}
		var device = terminal_find_device_by_ip(target_ip);
		if(!instance_exists(device)){
			terminal_write(["rssi-scan: device not found"]);
			return;
		}

		var device_distance = round(point_distance(network_world_x, network_world_y, device.network_world_x, device.network_world_y));
		if(show_distance){
			terminal_write(["Target: " + device.network_name + " (" + target_ip + ")", "Distance: " + string(device_distance) + " px"]);
		}else{
			var signal_level = clamp(round(10 - device_distance / 10), -100, -10);
			terminal_write(["Target: " + device.network_name + " (" + target_ip + ")", "Signal: " + string(signal_level) + " dB"]);
		}
		return;
	}

		if(command == "wget pass.txt"){
			terminal_write(["Saving to: 'pass.txt'", "pass.txt saved"]);
			wordlist_downloaded = true;
			return;
		}

		if(command == "wget authcrack.exe"){
			authcrack_installed = true;
			terminal_write(["Saving to: 'authcrack.exe'", "authcrack.exe saved"]);
			return;
		}



	if(word_count == 5 && words[0] == "authcrack" && words[1] == "--target" && words[3] == "--wordlist"){
		if(!authcrack_installed){
			terminal_write(["bash: authcrack: command not found"]);
			return;
		}
		if(!wordlist_downloaded || words[4] != "pass.txt"){
			terminal_write(["authcrack: pass.txt: file not found"]);
			return;
		}

		var device = terminal_find_device_by_ip(words[2]);
		if(!instance_exists(device)){
			terminal_write(["authcrack: target not supported"]);
			return;
		}
		var cracked_username = oDraw.network_username;
		var cracked_password = oDraw.network_password;
		if(device.object_index == oCam || device.object_index == oDoor || device.object_index == oLaserEmitter){
			cracked_username = device.usrname;
			cracked_password = device.passwd;
		}

		terminal_write([
			"Target: " + device.network_ip,
			"Wordlist: pass.txt",
			"Testing credentials...",
			"PASSWORD FOUND",
			"username: " + cracked_username,
			"password: " + cracked_password
		]);
		return;
	}

	if(word_count >= 4 && (words[0] == "camctl" || words[0] == "doorctl" || words[0] == "laserctl") && words[1] == "--host"){
		var tool_is_camera = words[0] == "camctl";
		var tool_is_door = words[0] == "doorctl";
		if((tool_is_camera && !camctl_installed) || (tool_is_door && !doorctl_installed)
		|| (words[0] == "laserctl" && !laserctl_installed)){
			terminal_write(["bash: " + words[0] + ": command not found"]);
			return;
		}

		var device = terminal_find_device_by_ip(words[2]);
		var expected_object = tool_is_camera ? oCam : (tool_is_door ? oDoor : oLaserEmitter);
		if(!instance_exists(device) || device.object_index != expected_object){
			terminal_write([words[0] + ": controller not found"]);
			return;
		}
		if(!device.network_online){
			terminal_write([words[0] + ": host is not responding"]);
			return;
		}

		var login_ips = tool_is_camera ? camera_login_ips : (tool_is_door ? door_login_ips : laser_login_ips);
		var logged_in = terminal_ip_is_logged_in(login_ips, device.network_ip);

		switch(words[3]){
			case "status":
				terminal_write([
					"Controller: " + device.network_ip,
					"Device: " + device.network_name,
					"Status: ONLINE",
					logged_in ? "Authentication: OK" : "Authentication: REQUIRED"
				]);
			return;

			case "login":
				if(word_count < 6){
					terminal_write(["Authentication failed."]);
					return;
				}
				var device_valid_login =
					words[4] == device.usrname
					&& words[5] == device.passwd;
				if(!device_valid_login){
					terminal_write(["Authentication failed."]);
					return;
				}
				if(!logged_in){
					if(tool_is_camera){
						array_push(camera_login_ips, device.network_ip);
					}else if(tool_is_door){
						array_push(door_login_ips, device.network_ip);
					}else{
						array_push(laser_login_ips, device.network_ip);
					}
				}
				terminal_write(["Authentication successful.", "Session established."]);
			return;
		}
	}

	if(word_count == 3 && words[0] == "systemctl"){
		var action = words[1];
		var service_name = words[2];

		var at_position = string_pos("@", service_name);
		if(at_position > 0){
			var service_type = string_copy(service_name, 1, at_position - 1);
			var target_ip = string_delete(service_name, 1, at_position);
			var device = terminal_find_device_by_ip(target_ip);

			if((service_type != "camera" && service_type != "door" && service_type != "laser")
			|| !instance_exists(device)
			|| (service_type == "camera" && device.object_index != oCam)
			|| (service_type == "door" && device.object_index != oDoor)
			|| (service_type == "laser" && device.object_index != oLaserEmitter)){
				terminal_write(["Unit " + service_name + " could not be found."]);
				return;
			}

			var logged_in = service_type == "camera"
				? terminal_ip_is_logged_in(camera_login_ips, target_ip)
				: (service_type == "door"
					? terminal_ip_is_logged_in(door_login_ips, target_ip)
					: terminal_ip_is_logged_in(laser_login_ips, target_ip));
			if(!logged_in){
				terminal_write(["Authentication required."]);
				return;
			}

			if(action == "status"){
				var service_status;
				if(service_type == "camera" || service_type == "laser"){
					service_status = device.active ? "   Active: active (running)" : "   Active: inactive (stopped)";
				}else{
					service_status = device.opened ? "   Active: inactive (unlocked)" : "   Active: active (locked)";
				}
				terminal_write([
					"* " + service_type + "@" + target_ip + ".service",
					service_status
				]);
				return;
			}

			if(action == "stop" || action == "start" || action == "restart"){
				if(service_type == "camera" || service_type == "laser"){
					if(service_type == "laser" && IS_NET && !oNetworkManager.is_server){
						send_laser_active_request(device, action != "stop");
					}else{
						device.active = action != "stop";
					}
				}else{
					device.open_door(noone, true, action == "stop");
				}
				terminal_write([service_type + "@" + target_ip + ".service " + action + (action == "stop" ? "ped." : "ed.")]);
				if(service_type == "door"){
					terminal_write([device.opened ? "Lock disengaged." : "Lock engaged."]);
				}
				return;
			}
		}
	}

	if(word_count == 2 && words[0] == "netflood"){
		var device = terminal_find_device_by_ip(words[1]);
		if(!instance_exists(device)){
			terminal_write(["netflood: target not found"]);
			return;
		}
		device.network_online = false;
		terminal_write(["Target: " + device.network_ip, "Sending traffic...", "Target overloaded.", "Service unavailable."]);
		return;
	}


	if(used_sudo){
		terminal_write(["sudo: " + command + ": command not found"]);
	}else{
		terminal_write(["bash: " + command + ": command not found"]);
	}
};
