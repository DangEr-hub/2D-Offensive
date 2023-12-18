/// @desc Gets the active camera
/// @returns The active camera port [X, Y, Width, Height]
function lighting_get_active_camera() {

	if(global.worldCustomCamera == undefined) {
		// Get active view camera
		var camera = camera_get_active();
		
		/*
		var angle = degtorad(oPlayer.ViewAngle);//degtorad(camera_get_view_angle(view_camera[0]));

		// Vypočtení aktuálního středu kamery (s otočením)
		var centerX = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2;
		var centerY = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2;

		// Výpočet vzdálenosti mezi aktuálním středem a horním levým rohem (s otočením)
		var distX = camera_get_view_x(view_camera[0]) - centerX;
		var distY = camera_get_view_y(view_camera[0]) - centerY;

		// Výpočet původního horního levého rohu (před otočením) pomocí inverzní transformace
		cameraX = centerX + distX * cos(angle) - distY * sin(angle);  // Stejné jako předtím
		cameraY = centerY + distX * sin(angle) + distY * cos(angle);  // Pozor: Y osa je invertována, takže znaménka jsou zde jiná	
		global.CameraX = cameraX;
		global.CameraY = cameraY;
		*/
		
		//cameraX = global.CameraX;
		//cameraY = global.CameraY;
		
		
		var cameraX = camera_get_view_x(camera) - camera_get_view_width(camera)*0.25;
		var cameraY = camera_get_view_y(camera) - camera_get_view_height(camera)*0.25;
		var cameraW = camera_get_view_width(camera) * 1.5;
		var cameraH = camera_get_view_height(camera) * 1.5;

		return [cameraX, cameraY, cameraW, cameraH];
	}

	return global.worldCustomCamera;


}
