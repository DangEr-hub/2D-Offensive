if (!IS_NET || oNetworkManager.is_server) {
    tickCounter++;

    if (tickCounter >= global.TimeSpeed) { tickCounter = 0; CurrentMinute++; }

    if (CurrentMinute >= 60) { CurrentMinute = 0;CurrentHour++; }

    if (CurrentHour >= 24) { CurrentHour = 0; }

}


var endIntensity = global.MapProperties[#global.MapID, MAP_STAT.MapEndIntensity];
var startIntensity = global.MapProperties[#global.MapID, MAP_STAT.MapStartIntensity];
var peakIntensity = global.MapProperties[#global.MapID, MAP_STAT.MapPeakIntensity];
var endHours = global.MapProperties[#global.MapID, MAP_STAT.MapEndHours]/60;
var startHours = global.MapProperties[#global.MapID, MAP_STAT.MapStartHours]/60;
var currentTime = CurrentHour;
var Value = (CurrentHour - startHours) / (endHours - startHours);
var startColor = [color_get_red(global.MapProperties[#global.MapID, MAP_STAT.MapStartColor]), color_get_green(global.MapProperties[#global.MapID, MAP_STAT.MapStartColor]), color_get_blue(global.MapProperties[#global.MapID, MAP_STAT.MapStartColor])];
var endColor = [color_get_red(global.MapProperties[#global.MapID, MAP_STAT.MapEndColor]), color_get_green(global.MapProperties[#global.MapID, MAP_STAT.MapEndColor]), color_get_blue(global.MapProperties[#global.MapID, MAP_STAT.MapEndColor])];
var startColorTime = startHours;
var endColorTime = endHours - 5 * 60;
var colorInterval = (currentTime - startColorTime) / (endColorTime - startColorTime);
var interpolatedColor = interpolate_color(startColor, endColor, colorInterval);

ambient_color = make_color_rgb(interpolatedColor[0], interpolatedColor[1], interpolatedColor[2]);
intensity = clamp((peakIntensity - startIntensity) * (-4 * power(Value, 2) + 4 * Value) + startIntensity, endIntensity, peakIntensity);



