tickCounter++;
// Check if a game-time minute has passed
if (tickCounter >= global.TimeSpeed) {
    CurrentMinute++;
    tickCounter = 0;  // Reset the tick counter
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
var endHours = global.MapProperties[#global.MapID, MapProperty.MapEndHours];
var startHours = global.MapProperties[#global.MapID, MapProperty.MapStartHours];
var currentTime = CurrentHour * 60 + CurrentMinute;
var fractionOfInterval = (currentTime - startHours) / (endHours - startHours);
var startDirection = 270;
var endDirection = 315;
var Value = (CurrentMinute + CurrentHour*60 - startHours) / (endHours - startHours);
var startColor = hex_to_rgb(global.MapProperties[#global.MapID, MapProperty.MapStartColor]);
var endColor = hex_to_rgb(global.MapProperties[#global.MapID, MapProperty.MapEndColor]);
var startColorTime = startHours;
var endColorTime = endHours - 5 * 60;
var colorInterval = (currentTime - startColorTime) / (endColorTime - startColorTime);
var interpolatedColor = interpolate_color(startColor, endColor, colorInterval);
intensity = clamp((peakIntensity - startIntensity) * (-4 * power(Value, 2) + 4 * Value) + startIntensity, endIntensity, peakIntensity);





light[| eLight.Color] = rgb_to_hex(interpolatedColor[0], interpolatedColor[1], interpolatedColor[2]);
light[| eLight.Direction] = lerp(startDirection, endDirection, fractionOfInterval);
light[| eLight.Intensity] = intensity;




