// Check if the player and machine gun are correctly referenced
if (instance_exists(stats.Object)) {
    if (global.Inventory[# OtherSlot.Primary, Index.slot_id] == stats.Id) {
		image_angle = stats.Object.RotationAngle;
    }
}



