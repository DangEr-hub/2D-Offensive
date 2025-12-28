

draw_self();

var shrink = 0.525;

var cx = (bbox_left + bbox_right) * 0.5;
var cy = (bbox_top + bbox_bottom) * 0.5;

var half_w = (bbox_right - bbox_left) * 0.5 * shrink;
var half_h = (bbox_bottom - bbox_top) * 0.5 * shrink;

var left   = cx - half_w;
var right  = cx + half_w;
var top    = cy - half_h;
var bottom = cy + half_h;

for(var i = ds_list_size(impact_lines) - 1; i >= 0; i--){
    var list = impact_lines[| i];

    var x1 = list[0];
    var y1 = list[1];
    var x2 = list[2];
    var y2 = list[3];
    var life = list[4];
    var col = list[5];
    var width = list[6];
    var offsets = list[7];

    // === PROJEKCE DO TILE ===
    x1 = clamp(x1, left, right);
    y1 = clamp(y1, top, bottom);
    x2 = clamp(x2, left, right);
    y2 = clamp(y2, top, bottom);

    if(point_distance(x1, y1, x2, y2) <= 16){
        list[4]--;
        if(list[4] <= 0){ ds_list_delete(impact_lines, i); }
        continue;
    }

    var alpha = (life / global.clear_particles_timer) * .5;

    draw_set_alpha(alpha);
    draw_set_color(col);

    var dir = point_direction(x1, y1, x2, y2);
    var perp = dir + 90;

    var last_x = x1;
    var last_y = y1;

    var num_s = array_length(offsets) - 1;

    for(var s = 1; s <= num_s; s++){
        var t = s / num_s;

        var base_x = lerp(x1, x2, t);
        var base_y = lerp(y1, y2, t);

        var off = offsets[s];

		var nx = base_x + lengthdir_x(off, perp);
		var ny = base_y + lengthdir_y(off, perp);
		nx = clamp(nx, left, right);
		ny = clamp(ny, top, bottom);

        draw_line_width(last_x, last_y, nx, ny, width);

        last_x = nx;
        last_y = ny;
    }

    draw_set_alpha(1);

    // === LIFE ===
    list[4]--;
    if(list[4] <= 0){
        ds_list_delete(impact_lines, i);
    }
}
