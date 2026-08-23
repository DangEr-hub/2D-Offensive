event_inherited();
tab_width = max(768 * global.GUIMultiplier, 896);
tab_height = max(512 * global.GUIMultiplier, 768);

draw_set_font(set_font("GUI_small"));
zui_set_size(tab_width, tab_height);

column_width = zui_get_width() / 3;
column_padding = max(24 * global.GUIMultiplier, 32);
rating_row_gap = max(24 * global.GUIMultiplier, 28);
plot_button_width = max(56 * global.GUIMultiplier, 64);
plot_button_height = max(20 * global.GUIMultiplier, 24);
plot_button_y_offset = -(plot_button_height - font_get_size(draw_get_font())) * .25;
plot_control_gap = max(24 * global.GUIMultiplier, 32);
rank_plot_gap = max(8 * global.GUIMultiplier, 12);
ratings_label_width = string_width("Ratings: ");

rank_position = 0;
if(global.game_struct.Played_games >= TRACKING_PERIOD / 2){
	rank_position = get_rank(global.game_struct.Player_ep);
}

rank_image_position_y = max(96, 64 * global.GUIMultiplier);
rank_image_size_width = max(sprite_get_width(spr_ranks) / 2 * global.GUIMultiplier, sprite_get_width(spr_ranks) / 2 * 1.5);
rank_image_size_height = max(sprite_get_height(spr_ranks) / 2 * global.GUIMultiplier, sprite_get_height(spr_ranks) / 2 * 1.5);
rank_image_position_x = round(column_width * .5 - rank_image_size_width * .5);
rank_image_gap = rank_image_size_height * 1.1;
rank_title_y = rank_image_position_y - rank_image_gap;
rank_title_string = "Rank: " + string(global.RankIndex[#rank_position, RankStat.Name]);
rank_title_width = string_width(rank_title_string);
rank_title_x = round(column_width * .5 - rank_title_width * .5);
rank_plot_x = rank_title_x + rank_title_width + rank_plot_gap;

rank_rating_graph = noone;
rank_rating_graph_callback = function(){
	if(instance_exists(oERSTab.enemy_rating_graph)){
		with(oERSTab.enemy_rating_graph){
			zui_destroy();
		}
	}

	if(instance_exists(oERSTab.enemy_rd_graph)){
		with(oERSTab.enemy_rd_graph){
			zui_destroy();
		}
	}

	if(!instance_exists(oERSTab.rank_rating_graph)){
		oERSTab.rank_rating_graph = zui_create(zui_get_width() * .5, zui_get_height() * .5, objUIGraph);

		with(oERSTab.rank_rating_graph){
			zui_set_depth(-1000);
			values_x = [];
			values_y = [];
			line_color = c_lime;
			point_color = c_green;
			x_label_decimals = 0;
			y_label_decimals = 0;
			x_axis_name = "Rank";
			y_axis_name = "Rating";
			grid_x_steps = min(5, RankType.Total - 2);

			for(var rank_id = 1; rank_id < RankType.Total; rank_id++){
				array_push(values_x, rank_id);
				array_push(values_y, global.RankIndex[#rank_id, RankStat.Ep]);
			}
		}
	}else{
		with(oERSTab.rank_rating_graph){
			zui_destroy();
		}
	}
};

for(var i = 0; i < RankType.Total; i++){
	var rank_image = zui_create(rank_image_position_x, rank_image_position_y + i * rank_image_gap, objUIImage);
	rank_image.rank_id = i;

	with(rank_image){
		zui_set_anchor(0, 0);
		zui_set_size(other.rank_image_size_width, other.rank_image_size_height);
		sprite = spr_ranks;
		sprite_image_index = rank_id;
		sprite_width_size = other.rank_image_size_width;
		sprite_height_size = other.rank_image_size_height;
		callback = function(_image){
			ui_show_popup(
				global.RankIndex[#_image.rank_id, RankStat.Name],
				"Min R: " + string(global.RankIndex[#_image.rank_id, RankStat.Ep]),
				"OK",
				-1,
				288 * global.GUIMultiplier,
				64 * global.GUIMultiplier,
				-1,
				-1
			);
		};
	}
}

with(zui_create(rank_image_position_x, rank_image_position_y + rank_position * rank_image_gap, objUIImage)){
	zui_set_anchor(0, 0);
	zui_set_size(other.rank_image_size_width, other.rank_image_size_height);
	sprite = spr_current_rank;
	sprite_image_index = 0;
	sprite_width_size = other.rank_image_size_width;
	sprite_height_size = other.rank_image_size_height;
	rank_id = other.rank_position;
	callback = function(_image){
		ui_show_popup(
			global.RankIndex[#_image.rank_id, RankStat.Name],
			"Min R: " + string(global.RankIndex[#_image.rank_id, RankStat.Ep]),
			"OK",
			-1,
			288 * global.GUIMultiplier,
			64 * global.GUIMultiplier,
			-1,
			-1
		);
	};
}

with(zui_create(rank_title_x, rank_title_y, objUILabel)){
	color = MAIN_COLOR;
	caption = other.rank_title_string;
}

with(zui_create(rank_plot_x * 1.15, rank_title_y + plot_button_y_offset, objUIButton)){
	zui_set_size(other.plot_button_width, other.plot_button_height);
	caption = "Plot";
	callback = oERSTab.rank_rating_graph_callback;
}
enemy_rating_graph = noone;
enemy_rating_graph_callback = function(){
	if(instance_exists(oERSTab.rank_rating_graph)){
		with(oERSTab.rank_rating_graph){
			zui_destroy();
		}
	}

	if(instance_exists(oERSTab.enemy_rd_graph)){
		with(oERSTab.enemy_rd_graph){
			zui_destroy();
		}
	}

	if(!instance_exists(oERSTab.enemy_rating_graph)){
		oERSTab.enemy_rating_graph = zui_create(zui_get_width() * .5, zui_get_height() * .5, objUIGraph);

		with(oERSTab.enemy_rating_graph){
			zui_set_depth(-1000);
			values_x = [];
			values_y = [];
			line_color = c_yellow;
			point_color = c_orange;
			x_axis_name = "Upcoming game";
			y_axis_name = "Rating";

			var first_enemy = global.game_struct.Current_game;
			var remaining_games = TRACKING_PERIOD - first_enemy;
			grid_x_steps = max(1, remaining_games - 1);

			for(var game_offset = 0; game_offset < remaining_games; game_offset++){
				var enemy_index = first_enemy + game_offset;
				var enemy_ep = global.game_struct.Enemy_ep[enemy_index];

				if(enemy_ep >= 0){
					array_push(values_x, game_offset + 1);
					array_push(values_y, convert_back(enemy_ep));
				}
			}
		}
	}else{
		with(oERSTab.enemy_rating_graph){
			zui_destroy();
		}
	}
};

enemy_rd_graph = noone;
enemy_rd_graph_callback = function(){
	if(instance_exists(oERSTab.rank_rating_graph)){
		with(oERSTab.rank_rating_graph){
			zui_destroy();
		}
	}

	if(instance_exists(oERSTab.enemy_rating_graph)){
		with(oERSTab.enemy_rating_graph){
			zui_destroy();
		}
	}

	if(!instance_exists(oERSTab.enemy_rd_graph)){
		oERSTab.enemy_rd_graph = zui_create(zui_get_width() * .5, zui_get_height() * .5, objUIGraph);

		with(oERSTab.enemy_rd_graph){
			zui_set_depth(-1000);
			values_x = [];
			values_y = [];
			line_color = c_aqua;
			point_color = c_blue;
			x_axis_name = "Upcoming game";
			y_axis_name = "RD";

			var first_enemy = global.game_struct.Current_game;
			var remaining_games = TRACKING_PERIOD - first_enemy;
			grid_x_steps = max(1, remaining_games - 1);

			for(var game_offset = 0; game_offset < remaining_games; game_offset++){
				var enemy_index = first_enemy + game_offset;
				var enemy_rd = global.game_struct.Enemy_rd[enemy_index];

				if(enemy_rd >= 0){
					array_push(values_x, game_offset + 1);
					array_push(values_y, convert_back(enemy_rd, true));
				}
			}
		}
	}else{
		with(oERSTab.enemy_rd_graph){
			zui_destroy();
		}
	}
};

var rating_es = global.game_struct.Player_ep;
var rd_es = global.game_struct.Player_rd;
var rating = convert_back(rating_es);
var rd = convert_back(rd_es, true);

var played_rounds = array_create(TRACKING_PERIOD, 0);
for(var i = 0; i < TRACKING_PERIOD; i++){
	played_rounds[i] = global.game_struct.Winned_rounds[i] + global.game_struct.Lost_rounds[i];
}

var predictive_volatility = global.game_struct.Predictive_volatility;
var game_volatility = average(global.game_struct.Game_volatility, true, true, played_rounds);
var volatility = calculate_volatility(global.game_struct.Game_volatility, predictive_volatility, played_rounds);

e_string = "Evaluation: " + string_format(rating, 0, 2) + " EP (" + string_format(rd * 2, 0, 2) + " RD) - "
	+ string_format(rating_es, 0, 2) + " (" + string_format(rd_es * 2, 0, 2) + " RD) ES";
r_string = "Rating: " + string_format(rating, 0, 2) + " EP - " + string_format(rating_es, 0, 2) + " ES";
rd_string = "Rating deviation: " + string_format(rd, 0, 2) + " EP - " + string_format(rd_es, 0, 2) + " ES";
v_string = "Volatility: " + string_format(volatility, 0, 2);
vp_string = "Predictive volatility: " + string_format(predictive_volatility, 0, 2);
vg_string = "Game volatility: " + string_format(game_volatility, 0, 2);

var player_x = column_width + column_padding;
with(zui_create(player_x, rank_title_y, objUILabel)){
	color = MAIN_COLOR;
	caption = "Player rating";
}

with(zui_create(player_x * .75, rank_title_y + rating_row_gap, objUILabel)){
	color = c_white;
	caption = other.e_string;
}

with(zui_create(player_x * .85, rank_title_y + rating_row_gap * 2, objUILabel)){
	color = c_white;
	caption = other.r_string;
}

with(zui_create(player_x * .85, rank_title_y + rating_row_gap * 3, objUILabel)){
	color = c_white;
	caption = other.rd_string;
}

with(zui_create(player_x * .85, rank_title_y + rating_row_gap * 4, objUILabel)){
	color = c_white;
	caption = other.v_string;
}

with(zui_create(player_x * .85, rank_title_y + rating_row_gap * 5, objUILabel)){
	color = c_white;
	caption = other.vp_string;
}

with(zui_create(player_x * .85, rank_title_y + rating_row_gap * 6, objUILabel)){
	color = c_white;
	caption = other.vg_string;
}

var enemy_rating_x = column_width * 2 + column_padding;
with(zui_create(enemy_rating_x, rank_title_y, objUILabel)){
	color = MAIN_COLOR;
	caption = "Bot enemy rating";
}

with(zui_create(enemy_rating_x, rank_title_y + rating_row_gap, objUILabel)){
	color = c_white;
	caption = "Ratings: ";
}

with(zui_create(enemy_rating_x + ratings_label_width + plot_control_gap, rank_title_y + rating_row_gap + plot_button_y_offset, objUIButton)){
	zui_set_size(other.plot_button_width, other.plot_button_height);
	caption = "Plot";
	callback = oERSTab.enemy_rating_graph_callback;
}

with(zui_create(enemy_rating_x, rank_title_y + rating_row_gap * 2, objUILabel)){
	color = c_white;
	caption = "RDs: ";
}

with(zui_create(enemy_rating_x + ratings_label_width + plot_control_gap, rank_title_y + rating_row_gap * 2 + plot_button_y_offset, objUIButton)){
	zui_set_size(other.plot_button_width, other.plot_button_height);
	caption = "Plot";
	callback = oERSTab.enemy_rd_graph_callback;
}

with(zui_create(0, 0, objUIWindowCaption)){
	caption = "Eggy Rating System";
	draggable = 1;
}
