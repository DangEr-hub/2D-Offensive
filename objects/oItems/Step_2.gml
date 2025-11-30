/* oItems end step event */
if (IS_NET && oNetworkManager.is_server) {
    if (x != last_x || y != last_y) {
        needs_sync = true;
    }
    last_x = x;
    last_y = y;
}
