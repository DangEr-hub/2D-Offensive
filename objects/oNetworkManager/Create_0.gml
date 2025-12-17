/* NetworkManager - Create Event */
enum PLAYER_FLAGS {
    GODMODE = 1,  // 0b00000001 1 << 0
    MOVING = 2, // 0b00000010 1 << 1
    RELOADING = 4,   // 0b00000100 1 << 2
	FLASHED = 8
}

network_set_config(network_config_use_non_blocking_socket, true);
persistent = true;
network_type = network_socket_udp;
server_port = 50000;
server_ip = "127.0.0.1"; // zatím localhost
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

// tracking
player_states = ds_map_create();
projectiles_seen = ds_map_create(); // key = proj_id, val = true
player_stats = ds_map_create();
item_registry = ds_map_create();
item_pos_buffer = ds_list_create();
free_item_ids = -1;


// Packet types
enum PACKET {
    CONNECT_REQUEST,
    CONNECT_ACCEPT,
    DISCONNECT,
    PROJECTILE_SPAWN,
    OBJECT_SYNC,
    HEARTBEAT,
    TICK_UPDATE,
	EQUIP_SYNC,
	HIT,
	WEAPON_SYNC,
	INIT,
	REQUEST_INIT,
	WEATHER_SYNC,
	OBJECT_POS_SYNC,
	PLAYER_DEATH,
	PLAYER_RESPAWN,
	PING,
	BIRD_SPAWN
}

equipment_sync = false;
weapon_sync = false;
send_rate = 1/30; // Send updates 30 times per second
send_timer = 0;
accum_server = 0;   // časování TICK_UPDATE na serveru
hb_client    = 0;   // heartbeat na klientovi

/// ping
ping_interval = 1;  // how often to measure latency
ping_timer = 0;
ping_ms = 0;
ping_send_time = 0;

// Sequence numbers for packet ordering
send_sequence = 0;
receive_sequences = ds_map_create();

// Prediction and reconciliation
//client_input_buffer = ds_list_create();
//last_processed_input = 0;