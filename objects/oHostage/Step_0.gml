var moved = false;
var movement_speed = 0;

if (FootStepTimer > 0) {
	FootStepTimer -= global.time_step;
}

if (VisibilityTimer > 0) {
	VisibilityTimer--;
} else {
	Visible = false;
}

if (check_vis_timer > 0) {
	check_vis_timer--;
} else if (instance_exists(global.local_player)) {
	check_vis_timer = check_vis_time;
	var observer = global.local_player;
	var in_fov = point_in_triangle(bbox_left, bbox_top, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy)
		|| point_in_triangle(bbox_right, bbox_top, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy)
		|| point_in_triangle(bbox_left, bbox_bottom, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy)
		|| point_in_triangle(bbox_right, bbox_bottom, observer.ax, observer.ay, observer.bx, observer.by, observer.cx, observer.cy);

	if (in_fov
	&& collision_line(x, y, observer.x, observer.y, oParentTile, true, false) == noone
	&& collision_line(x, y, observer.x, observer.y, oSmokeTile, true, false) == noone) {
		Visible = true;
		VisibilityTimer = VisibilityTime;
	}
}

if (instance_exists(Legs)) Legs.Visible = Visible;
if (instance_exists(HeadHB)) HeadHB.Visible = Visible;
if (instance_exists(BodyHB)) BodyHB.Visible = Visible;
if (instance_exists(ArmHB)) ArmHB.Visible = Visible;

if (hit_timer > -1) {
	hit_timer--;
}

stats.Health_points = clamp(stats.Health_points, 0, stats.Max_health_points);
stats.Damage_health_points = clamp(stats.Damage_health_points, 0, stats.Max_health_points);

if (HPTimer > 0) {
	HPTimer = max(0, HPTimer - global.time_step);
} else if (HPTimer == 0) {
	stats.Damage_health_points = max(
		stats.Health_points,
		stats.Damage_health_points - stats.Max_health_points / 100
	);

	if (stats.Damage_health_points <= stats.Health_points) {
		HPTimer = -1;
	}
}

if (stats.Health_points <= 0) {
	if (instance_exists(oGameController)) {
		with (oGameController) {
			hostage_rescued = false;
		}
	}

	if (instance_exists(Legs)) instance_destroy(Legs);
	if (instance_exists(HeadHB)) instance_destroy(HeadHB);
	if (instance_exists(BodyHB)) instance_destroy(BodyHB);
	if (instance_exists(ArmHB)) instance_destroy(ArmHB);

	var EnemyDead = instance_create_depth(x, y, depth, oEnemyDead);
	EnemyDead.mask_index = spr_BotDead;
	EnemyDead.sprite_index = sprite_index;
	EnemyDead.image_index = 1;
	EnemyDead.image_angle = image_angle;

	instance_destroy();
	exit;
}

if (rescuing) {
	if (!instance_exists(rescuing_player)) {
		rescuing_player = instance_nearest(x, y, oPlayer);
	}

	if (instance_exists(rescuing_player)) {
		var distance_to_player = point_distance(x, y, rescuing_player.x, rescuing_player.y);
		if (distance_to_player > follow_distance + 0.5) {
			var old_x = x;
			var old_y = y;

			mp_potential_step_object(
				rescuing_player.x,
				rescuing_player.y,
				follow_speed * global.time_step,
				oParentTile
			);

			moved = abs(x - old_x) > 0.001 || abs(y - old_y) > 0.001;
			if (moved) {
				movement_speed = point_distance(old_x, old_y, x, y);
				RotationAngle = point_direction(old_x, old_y, x, y);
				image_angle = RotationAngle;
			}
		}
	}
}

var has_rescue_authority = !IS_NET
	|| (instance_exists(oNetworkManager) && oNetworkManager.is_server);

if (rescuing && !rescue_completed && has_rescue_authority) {
	var hostage_areas = global.MapProperties[# global.MapID, MAP_STAT.HostageAreas];
	var area_keys = ds_map_keys_to_array(hostage_areas);
	var bbox_inset_x = (bbox_right - bbox_left) * .25;
	var bbox_inset_y = (bbox_bottom - bbox_top) * .25;
	var rescue_left = bbox_left + bbox_inset_x;
	var rescue_right = bbox_right - bbox_inset_x;
	var rescue_top = bbox_top + bbox_inset_y;
	var rescue_bottom = bbox_bottom - bbox_inset_y;

	for (var area_index = 0; area_index < array_length(area_keys); area_index++) {
		var area = hostage_areas[? area_keys[area_index]];
		var touches_area = rescue_right >= area[0]
			&& rescue_left <= area[2]
			&& rescue_bottom >= area[1]
			&& rescue_top <= area[3];

		if (touches_area) {
			rescue_completed = true;

			if (instance_exists(oGameController)) {
				oGameController.hostage_rescued = true;
			}

			global.bomb_planted = false;
			global.bomb_timer = 0;
			global.bomb_planter_pid = -1;
			with (oBomb) instance_destroy();

			if (instance_exists(oDraw)) {
				oDraw.bomb_detonation_pending = false;
				oDraw.round_end_timer = -1;
			}

			var round_result = instance_exists(global.local_player)
				&& global.local_player.stats.Team == TEAM.POLICE
				? "Win"
				: "Loss";
			round_end(round_result, TEAM.POLICE);
			break;
		}
	}
}

if (instance_exists(Legs)) {
	Legs.image_speed = moved ? global.time_step : 0;
}

if (moved) {
	if (Visible) {
		particle_create(round(movement_speed * random(2)), .8, random(360), spr_MovementParticle, random_range(-movement_speed, movement_speed), random_range(-90, 90), random(360), 1, choose(true, false), false, 0, x, y);
	}

	if (FootStepTimer <= 0) {
		FootStepTimer = 5;
		FootSteps++;
		if (Visible) {
			particle_create(1, 0, RotationAngle, spr_FootSteps, 0, 0, RotationAngle, 0, false, false, FootSteps mod 2, x, y, .5, 1.5 * game_get_speed(gamespeed_fps));
		}
	}
} else {
	FootStepTimer = 5;
	FootSteps = 0;
}
