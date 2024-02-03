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
intensity = clamp((peakIntensity - startIntensity) * (-4 * power(Value, 2) + 4 * Value) + startIntensity, endIntensity, peakIntensity);



