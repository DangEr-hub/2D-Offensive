lottery_active = false;
lottery_last_center_index = -1;
lottery_items = [];
lottery_scroll = 0;
lottery_scroll_start = 0;
lottery_scroll_target = 0;
lottery_timer = 0;
lottery_duration = 300;
lottery_winner_index = -1;
lottery_result = -1;

g_width = 512 * global.gui_scale;
g_height = 128 * global.gui_scale;

alpha_value = 0;
alpha = global.GUIHUDAlpha;

lottery_weapon_pool = [
];

alarm[0] = 5;