function struct_get_default(_struct, _key, _default)
{
    if(!is_struct(_struct)){ return _default; }
    if(!variable_struct_exists(_struct, _key)){ return _default; }

    return _struct[$ _key];
}


function draw_graph(x_values, y_values, xx, yy, width, height, options)
{
    if(!is_array(x_values)){ return false; }
    if(!is_array(y_values)){ return false; }
    if(!is_struct(options)){ options = {}; }

    var x_count = array_length(x_values);

    if(x_count < 2){ return false; }
    if(x_count != array_length(y_values)){ return false; }
    if(width <= 0 || height <= 0){ return false; }

    var show_background = struct_get_default(options, "show_background", true);
    var show_border = struct_get_default(options, "show_border", true);
    var show_grid = struct_get_default(options, "show_grid", true);
    var show_axes = struct_get_default(options, "show_axes", true);
    var show_points = struct_get_default(options, "show_points", true);
    var show_labels = struct_get_default(options, "show_labels", true);

    var bg_color = struct_get_default(
        options,
        "bg_color",
        make_color_rgb(20, 22, 26)
    );

    var border_color = struct_get_default(
        options,
        "border_color",
        make_color_rgb(120, 125, 135)
    );

    var grid_color = struct_get_default(
        options,
        "grid_color",
        make_color_rgb(55, 58, 65)
    );

    var axis_color = struct_get_default(
        options,
        "axis_color",
        make_color_rgb(180, 185, 195)
    );

    var line_color = struct_get_default(options, "line_color", c_lime);
    var point_color = struct_get_default(options, "point_color", c_white);
    var label_color = struct_get_default(options, "label_color", c_white);

    var background_alpha = clamp(
        struct_get_default(options, "background_alpha", 1),
        0,
        1
    );

    var grid_alpha = clamp(
        struct_get_default(options, "grid_alpha", 1),
        0,
        1
    );

    var grid_x_steps = max(
        1,
        floor(struct_get_default(options, "grid_x_steps", 5))
    );

    var grid_y_steps = max(
        1,
        floor(struct_get_default(options, "grid_y_steps", 5))
    );

    var padding_left = struct_get_default(options, "padding_left", 50);
    var padding_right = struct_get_default(options, "padding_right", 15);
    var padding_top = struct_get_default(options, "padding_top", 15);
    var padding_bottom = struct_get_default(options, "padding_bottom", 35);

    var point_radius = max(
        0,
        struct_get_default(options, "point_radius", 3)
    );

    var line_width = max(
        1,
        struct_get_default(options, "line_width", 2)
    );

    var axis_width = max(
        1,
        struct_get_default(options, "axis_width", 2)
    );

    var label_decimals = max(
        0,
        floor(struct_get_default(options, "label_decimals", 1))
    );

    var y_label_decimals = max(
        0,
        floor(struct_get_default(options, "y_label_decimals", max(label_decimals, 1)))
    );

    var font = struct_get_default(options, "font", -1);

    var minimum_x = x_values[0];
    var maximum_x = x_values[0];
    var minimum_y = y_values[0];
    var maximum_y = y_values[0];

    for(var i = 1; i < x_count; i++)
    {
        minimum_x = min(minimum_x, x_values[i]);
        maximum_x = max(maximum_x, x_values[i]);

        minimum_y = min(minimum_y, y_values[i]);
        maximum_y = max(maximum_y, y_values[i]);
    }

    var custom_minimum_x = struct_get_default(
        options,
        "minimum_x",
        undefined
    );

    var custom_maximum_x = struct_get_default(
        options,
        "maximum_x",
        undefined
    );

    var custom_minimum_y = struct_get_default(
        options,
        "minimum_y",
        undefined
    );

    var custom_maximum_y = struct_get_default(
        options,
        "maximum_y",
        undefined
    );

    if(!is_undefined(custom_minimum_x)){ minimum_x = custom_minimum_x; }
    if(!is_undefined(custom_maximum_x)){ maximum_x = custom_maximum_x; }
    if(!is_undefined(custom_minimum_y)){ minimum_y = custom_minimum_y; }
    if(!is_undefined(custom_maximum_y)){ maximum_y = custom_maximum_y; }

    if(maximum_x < minimum_x)
    {
        var swap_x = minimum_x;
        minimum_x = maximum_x;
        maximum_x = swap_x;
    }

    if(maximum_y < minimum_y)
    {
        var swap_y = minimum_y;
        minimum_y = maximum_y;
        maximum_y = swap_y;
    }

    if(maximum_x == minimum_x){ maximum_x = minimum_x + 1; }
    if(maximum_y == minimum_y){ maximum_y = minimum_y + 1; }

    var plot_x1 = xx + padding_left;
    var plot_y1 = yy + padding_top;
    var plot_x2 = xx + width - padding_right;
    var plot_y2 = yy + height - padding_bottom;

    var plot_width = plot_x2 - plot_x1;
    var plot_height = plot_y2 - plot_y1;

    if(plot_width <= 0 || plot_height <= 0){ return false; }

    var range_x = maximum_x - minimum_x;
    var range_y = maximum_y - minimum_y;

    var graph_x = array_create(x_count);
    var graph_y = array_create(x_count);

    for(var i = 0; i < x_count; i++)
    {
        graph_x[i] =
            plot_x1
            + ((x_values[i] - minimum_x) / range_x)
            * plot_width;

        graph_y[i] =
            plot_y2
            - ((y_values[i] - minimum_y) / range_y)
            * plot_height;
    }

    var old_color = draw_get_color();
    var old_alpha = draw_get_alpha();
    var old_font = draw_get_font();
    var old_halign = draw_get_halign();
    var old_valign = draw_get_valign();

    if(font != -1){ draw_set_font(font); }

    if(show_background)
    {
        draw_set_alpha(background_alpha);
        draw_set_color(bg_color);
        draw_rectangle(xx - 16, yy, xx + width, yy + height, false);
    }

    if(show_grid)
    {
        draw_set_alpha(grid_alpha);
        draw_set_color(grid_color);

        for(var gx = 0; gx <= grid_x_steps; gx++)
        {
            var grid_x =
                plot_x1
                + plot_width
                * (gx / grid_x_steps);

            draw_line(
                grid_x,
                plot_y1,
                grid_x,
                plot_y2
            );
        }

        for(var gy = 0; gy <= grid_y_steps; gy++)
        {
            var grid_y =
                plot_y1
                + plot_height
                * (gy / grid_y_steps);

            draw_line(
                plot_x1,
                grid_y,
                plot_x2,
                grid_y
            );
        }
    }

    draw_set_alpha(1);

    if(show_axes)
    {
        draw_set_color(axis_color);

        if(minimum_x <= 0 && maximum_x >= 0)
        {
            var zero_x =
                plot_x1
                + ((0 - minimum_x) / range_x)
                * plot_width;

            draw_line_width(
                zero_x,
                plot_y1,
                zero_x,
                plot_y2,
                axis_width
            );
        }

        if(minimum_y <= 0 && maximum_y >= 0)
        {
            var zero_y =
                plot_y2
                - ((0 - minimum_y) / range_y)
                * plot_height;

            draw_line_width(
                plot_x1,
                zero_y,
                plot_x2,
                zero_y,
                axis_width
            );
        }
    }

    if(show_labels)
    {
        draw_set_color(label_color);

        draw_set_halign(fa_center);
        draw_set_valign(fa_top);

        for(var lx = 0; lx <= grid_x_steps; lx++)
        {
            var x_ratio = lx / grid_x_steps;
            var x_value = lerp(minimum_x, maximum_x, x_ratio);
            var label_x = plot_x1 + plot_width * x_ratio;

            draw_text(
                label_x,
                plot_y2 + 5,
                string_format(x_value, 0, label_decimals)
            );
        }

        draw_set_halign(fa_right);
        draw_set_valign(fa_middle);

        for(var ly = 0; ly <= grid_y_steps; ly++)
        {
            var y_ratio = ly / grid_y_steps;
            var y_value = lerp(maximum_y, minimum_y, y_ratio);
            var label_y = plot_y1 + plot_height * y_ratio;

            draw_text(
                plot_x1 - 7,
                label_y,
                string_format(y_value, 0, y_label_decimals)
            );
        }
    }

    draw_set_alpha(1);
    draw_set_color(line_color);

    for(var i = 0; i < x_count - 1; i++)
    {
        draw_line_width(
            graph_x[i],
            graph_y[i],
            graph_x[i + 1],
            graph_y[i + 1],
            line_width
        );
    }

    if(show_points && point_radius > 0)
    {
        draw_set_color(point_color);

        for(var i = 0; i < x_count; i++)
        {
            draw_circle(
                graph_x[i],
                graph_y[i],
                point_radius,
                false
            );
        }
    }

    if(show_border)
    {
        draw_set_color(border_color);

        draw_rectangle(
            plot_x1,
            plot_y1,
            plot_x2,
            plot_y2,
            true
        );
    }

    draw_set_color(old_color);
    draw_set_alpha(old_alpha);
    draw_set_font(old_font);
    draw_set_halign(old_halign);
    draw_set_valign(old_valign);

    return true;
}
