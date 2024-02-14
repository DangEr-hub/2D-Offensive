tickCounter++;
if (tickCounter >= global.TimeSpeed) {
    CurrentMinute++;
    tickCounter = 0;
}

if (CurrentMinute >= 60) {
    CurrentHour++;
    CurrentMinute = 0;
}

if(CurrentHour >= 24){
	CurrentHour = 0;	
}

var endIntensity = global.MapProperties[#global.MapID, MapProperty.MapEndIntensity];
var startIntensity = global.MapProperties[#global.MapID, MapProperty.MapStartIntensity];
var peakIntensity = global.MapProperties[#global.MapID, MapProperty.MapPeakIntensity];
var endHours = global.MapProperties[#global.MapID, MapProperty.MapEndHours]/60;
var startHours = global.MapProperties[#global.MapID, MapProperty.MapStartHours]/60;
var currentTime = CurrentHour;
var Value = (CurrentHour - startHours) / (endHours - startHours);
var startColor = [color_get_red(global.MapProperties[#global.MapID, MapProperty.MapStartColor]), color_get_green(global.MapProperties[#global.MapID, MapProperty.MapStartColor]), color_get_blue(global.MapProperties[#global.MapID, MapProperty.MapStartColor])];
var endColor = [color_get_red(global.MapProperties[#global.MapID, MapProperty.MapEndColor]), color_get_green(global.MapProperties[#global.MapID, MapProperty.MapEndColor]), color_get_blue(global.MapProperties[#global.MapID, MapProperty.MapEndColor])];
var startColorTime = startHours;
var endColorTime = endHours - 5 * 60;
var colorInterval = (currentTime - startColorTime) / (endColorTime - startColorTime);
var interpolatedColor = interpolate_color(startColor, endColor, colorInterval);

ambient_color = make_color_rgb(interpolatedColor[0], interpolatedColor[1], interpolatedColor[2]);
intensity = clamp((peakIntensity - startIntensity) * (-4 * power(Value, 2) + 4 * Value) + startIntensity, endIntensity, peakIntensity);



