/// @description Insert description here
// You can write your code in this editor
crosshair_x = x;
crosshair_y = y;
DeltaX = 0; DeltaY = 0;
recoil_speed = .1;
x = mouse_x;
y = mouse_y;

#region Crosshair shake vars
HitMarker = -1;
WobbleResetSpeed = .25;
WobbleAimPunchMultiplier = 0;
WobbleCrosshairMultiplier = 0;
WobbleScopeInMultiplier = 0;
WobbleX = 0;
WobbleY = 0;
x_offset = 0;
y_offset = 0;
scope_sway_x = 0;
scope_sway_y = 0;
scope_sway_strength = 0;
scope_sway_phase_x = random(360);
scope_sway_phase_y = random(360);
aim_x = x;
aim_y = y;
visual_x = x;
visual_y = y;
RecoilTimer = [-1, -1];
Recoil = [0, 0];
StabilizationSpeed = 15;
axis_multiplier = [0, 0];
#endregion


AlphaMul = 1;
