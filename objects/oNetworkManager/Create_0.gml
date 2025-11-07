/// NetworkManager - Create Event

// Network configuration
network_set_config(network_config_use_non_blocking_socket, true);
persistent = true;
global.debug_network = true;
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
player_positions = ds_map_create();
states_player = ds_map_create();
projectiles = ds_list_create();

// Packet types
enum PACKET {
    CONNECT_REQUEST,
    CONNECT_ACCEPT,
    DISCONNECT,
    PLAYER_UPDATE,
    PROJECTILE_SPAWN,
    PROJECTILE_UPDATE,
    OBJECT_SYNC,
    HEARTBEAT,
    GAME_STATE
}

// Interpolation settings
interpolation_enabled = true;
send_rate = 1/30; // Send updates 30 times per second
send_timer = 0;

// Sequence numbers for packet ordering
send_sequence = 0;
receive_sequences = ds_map_create();

// Prediction and reconciliation
client_input_buffer = ds_list_create();
last_processed_input = 0;

show_debug_message("NetworkManager initialized");