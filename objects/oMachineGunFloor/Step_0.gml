// Check if the player and machine gun are correctly referenced
if (instance_exists(stats.Object)) {
    if (global.weapon_id[0] == stats.Id) {
		image_angle = stats.Object.RotationAngle;
    }
}



