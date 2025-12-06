/* oItems Create event */
PushForce = 0;
scope_attachment = -1;
barrel_attachment = -1;
grip_attachment = -1;
suppressor_attachment = -1;
ClipAmmo = -1;
Ammo = -1;
Durability = -1;
image_speed = 0;
image_angle = random(360);
Amount = 1;
z = 0;
zgravity = 4;
zmaxspeed = 20;
zspeed = zmaxspeed;
LightObject = undefined;
PushTimer = -1;
PushDirection = 0;
alarm[0] = 1;
network_id = -1;
target_x = x;
target_y = y;
last_x = x;
last_y = y;
network_id = compute_item_network_id();
needs_sync = false;

