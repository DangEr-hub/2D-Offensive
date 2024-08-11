function draw_hitbox(ObjectType, hitbox_width, hitbox_height, offset_distance, HitBoxAngle) {
    var xx = ObjectType.x + lengthdir_x(offset_distance, HitBoxAngle);
    var yy = ObjectType.y + lengthdir_y(offset_distance, HitBoxAngle);

    // Calculate the four corners of the hitbox
    var angle = HitBoxAngle;
    var cos_angle = dcos(-angle);
    var sin_angle = dsin(-angle);

    var corner_x1 = xx + cos_angle * (-hitbox_width / 2) - sin_angle * (-hitbox_height / 2);
    var corner_y1 = yy + sin_angle * (-hitbox_width / 2) + cos_angle * (-hitbox_height / 2);

    var corner_x2 = xx + cos_angle * (hitbox_width / 2) - sin_angle * (-hitbox_height / 2);
    var corner_y2 = yy + sin_angle * (hitbox_width / 2) + cos_angle * (-hitbox_height / 2);

    var corner_x3 = xx + cos_angle * (hitbox_width / 2) - sin_angle * (hitbox_height / 2);
    var corner_y3 = yy + sin_angle * (hitbox_width / 2) + cos_angle * (hitbox_height / 2);

    var corner_x4 = xx + cos_angle * (-hitbox_width / 2) - sin_angle * (hitbox_height / 2);
    var corner_y4 = yy + sin_angle * (-hitbox_width / 2) + cos_angle * (hitbox_height / 2);

    // Draw the hitbox
    draw_line(corner_x1, corner_y1, corner_x2, corner_y2);
    draw_line(corner_x2, corner_y2, corner_x3, corner_y3);
    draw_line(corner_x3, corner_y3, corner_x4, corner_y4);
    draw_line(corner_x4, corner_y4, corner_x1, corner_y1);
}

function get_hitbox_corners(ObjectType, hitbox_width, hitbox_height, offset_distance, HitBoxAngle) {
    var xx = ObjectType.x + lengthdir_x(offset_distance, HitBoxAngle);
    var yy = ObjectType.y + lengthdir_y(offset_distance, HitBoxAngle);
    var angle = HitBoxAngle;
    var cos_angle = dcos(-angle);
    var sin_angle = dsin(-angle);

    var corner_x1 = xx + cos_angle * (-hitbox_width / 2) - sin_angle * (-hitbox_height / 2);
    var corner_y1 = yy + sin_angle * (-hitbox_width / 2) + cos_angle * (-hitbox_height / 2);

    var corner_x2 = xx + cos_angle * (hitbox_width / 2) - sin_angle * (-hitbox_height / 2);
    var corner_y2 = yy + sin_angle * (hitbox_width / 2) + cos_angle * (-hitbox_height / 2);

    var corner_x3 = xx + cos_angle * (hitbox_width / 2) - sin_angle * (hitbox_height / 2);
    var corner_y3 = yy + sin_angle * (hitbox_width / 2) + cos_angle * (hitbox_height / 2);

    var corner_x4 = xx + cos_angle * (-hitbox_width / 2) - sin_angle * (hitbox_height / 2);
    var corner_y4 = yy + sin_angle * (-hitbox_width / 2) + cos_angle * (hitbox_height / 2);

    return [
        [corner_x1, corner_y1],
        [corner_x2, corner_y2],
        [corner_x3, corner_y3],
        [corner_x4, corner_y4]
    ];
}
