/// @description Insert description here
// You can write your code in this editor
//window_set_cursor(cr_none);
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
RecoilTimer = [-1, -1];
Recoil = [0, 0];
StabilizationSpeed = 15;
axis_multiplier = [0, 0];
#endregion


AlphaMul = 1;