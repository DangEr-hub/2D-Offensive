depth = -999;
intensity = 0;
CurrentMinute = 0;
CurrentHour = global.MapProperties[#global.MapID, MapProperty.MapStartHours] / 60;
tickCounter = 0;
intensity = 0;
ambient_color = global.MapProperties[#global.MapID, MapProperty.MapStartColor];
lighting = new BulbRenderer(ambient_color, BULB_MODE.HARD_BM_ADD_SELFLIGHTING, true);
lighting.SetSurfaceDimensionsFromCamera(CAMERA);
//network_tick = 0;
//network_hour = 0;
//network_min = 0;





