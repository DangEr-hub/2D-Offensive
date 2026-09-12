alpha_value = 0;
alpha = global.GUIHUDAlpha;

values_x = [];
values_y = [];

g_width = 256 * global.gui_scale;
g_height = 128 * global.gui_scale;

zui_set_size(g_width, g_height);

show_background = true;
show_border = true;
show_grid = true;
show_axes = true;
show_points = true;
show_labels = true;

grid_x_steps = 5;
grid_y_steps = 5;

bg_color = make_color_rgb(18, 20, 24);
border_color = make_color_rgb(110, 115, 125);
grid_color = make_color_rgb(45, 48, 55);
axis_color = make_color_rgb(180, 185, 195);

line_color = c_lime;
point_color = c_green;
label_color = c_white;

line_width = 2;
point_radius = 3;
label_decimals = 1;
x_label_decimals = 1;
y_label_decimals = 1;
x_axis_name = "";
y_axis_name = "";
background_margin = 0.1;

font = set_font("GUI_small");




