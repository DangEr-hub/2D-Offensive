//lighting.Update(0, 0, room_width, room_height);
//lighting.Draw(0, 0);
//Update the lighting
lighting.UpdateFromCamera(view_camera[0]);

//Draw onto the application surface via the camera
lighting.DrawOnCamera(view_camera[0], 1 - intensity);

