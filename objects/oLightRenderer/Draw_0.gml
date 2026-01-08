//lighting.Update(0, 0, room_width, room_height);
//lighting.Draw(0, 0);
//Update the lighting
lighting.SetAmbientColor(ambient_color);
lighting.UpdateFromCamera(CAM);

//Draw onto the application surface via the camera
lighting.DrawOnCamera(CAM, 1 - intensity);

