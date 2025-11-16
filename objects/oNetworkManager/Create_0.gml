/* NetworkManager - Create Event */
enum PLAYER_FLAGS {
    GODMODE = 1  // 0b00000001 1 << 0
   //VISIBLE = 2,  // 0b00000010 1 << 1
   // CROUCH  = 4   // 0b00000100 1 << 2
}


network_set_config(network_config_use_non_blocking_socket, true);
persistent = true;
global.debug_text = "kokot";
network_type = network_socket_udp; // UDP for real-time gameplay
server_port = 50000;
server_ip = "127.0.0.1"; // Default to localhost
max_clients = 4;

// Network state
is_server = false;
is_connected = false;
server_socket = -1;
client_socket = -1;
my_player_id = -1;

// Client tracking (server only)
clients = ds_map_create();
client_timeout = ds_map_create();
timeout_threshold = 5000; // 5 seconds without heartbeat = disconnect

// Network buffers
send_buffer = buffer_create(1024, buffer_grow, 1);
receive_buffer = buffer_create(1024, buffer_grow, 1);

// Player data tracking
player_states = ds_map_create();
projectiles_seen = ds_map_create(); // key = proj_id, val = true
player_stats = ds_map_create();

// Packet types
enum PACKET {
    CONNECT_REQUEST,
    CONNECT_ACCEPT,
    DISCONNECT,
    PLAYER_UPDATE,
    PROJECTILE_SPAWN,
    OBJECT_SYNC,
    HEARTBEAT,
    PLAYER_STATE,
	EQUIP_SYNC,
	HIT
	
}

equipment_changed = false;
send_rate = 1/30; // Send updates 30 times per second
send_timer = 0;
accum_server = 0;   // časování PLAYER_STATE na serveru
hb_client    = 0;   // heartbeat na klientovi

// Sequence numbers for packet ordering
send_sequence = 0;
receive_sequences = ds_map_create();

// Prediction and reconciliation
client_input_buffer = ds_list_create();
last_processed_input = 0;