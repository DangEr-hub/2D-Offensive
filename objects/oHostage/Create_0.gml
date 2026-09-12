Legs = instance_create_depth(x,y,depth + 2,oObjectLegs);
Legs.Object = id;
Legs.Visible = false;
Legs.image_speed = 0;
Legs.image_index = Legs.first_frame;
FootStepTimer = 5;
FootSteps = 0;
image_angle = random(359);
RotationAngle = image_angle;
Visible = false;
VisibilityTime = 10 * game_get_speed(gamespeed_fps);
VisibilityTimer = 0;
check_vis_time = 10;
check_vis_timer = irandom_range(1, check_vis_time);

stats = {
	Name: "Hostage",
	Health_points: 100,
	Damage_health_points: 100,
	Max_health_points: 100,
	Team: TEAM.POLICE
};

HPTimer = -1;
hit_timer = -1;
attack_damage = 0;
aimpunch_speed_multiplier = 1;
AimPunchTimer = -1;
AimPunchTime = .35 * game_get_speed(gamespeed_fps);
AimPunchMultiplier = 1;
shield_equip = false;
ArmourID = Item.None;
HelmetID = Item.None;
ShieldID = Item.None;
ArmourDurability = [0, 0, 0];
enemy_aimpunch_direction = 0;
ChasingObject = noone;
ChasingObjectSpotted = false;
KilledByName = "No one";
KilledByWeapon = "Nothing";

rescuing = false;
rescuing_player = noone;
rescue_completed = false;
follow_distance = 128;
follow_speed = 2;
image_speed = 0;

#region Hitbox
HeadHB = instance_create_depth(x, y, depth - 1, oHitBox);
HeadHB.image_index = HITBOX.Head;
HeadHB.MainObject = id;
HeadHB.Visible = false;
BodyHB = instance_create_depth(x, y, depth - 1, oHitBox);
BodyHB.image_index = HITBOX.BodyNoWeapon;
BodyHB.MainObject = id;
BodyHB.Visible = false;
ArmHB = instance_create_depth(x, y, depth - 1, oHitBox);
ArmHB.image_index = HITBOX.ArmNoWeapon;
ArmHB.MainObject = id;
ArmHB.Visible = false;
#endregion





