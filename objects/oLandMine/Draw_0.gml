draw_self();
draw_set_alpha(min_alpha * .5);
draw_set_color(alpha_color[max(ImageIndex / 4, 0)]);
draw_circle(x, y, explosion_distance, false);
draw_set_alpha(1);

