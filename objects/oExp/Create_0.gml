randomize();
value = 0;
PushForce = 0;
LightObject = new BulbLight(oLightRenderer.lighting, sLight128, 0, x, y);
LightObject.castShadows = false;
LightObject.blend = c_green;
LightObject.xscale = .5;
LightObject.yscale = .5;
PushTimer = -1;
PushDirection = 0;
image_index = 0;
image_speed = 0;
image_angle = random(360);
z = 0;
zgravity = 4;
zmaxspeed = 20;
zspeed = zmaxspeed;


