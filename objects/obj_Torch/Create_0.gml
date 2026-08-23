image_speed = .3;

LightObject = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
LightObject.blend = c_orange;

create_haze_effect(
    x,
    y,
    10 * game_get_speed(gamespeed_fps),
    id,
    "Circle",
    true,
    128,
    128
);