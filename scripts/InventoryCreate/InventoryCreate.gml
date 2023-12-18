function InventoryCreate() {
	var SlotRowSize = 7;
	var SlotColumnSize = 3;
	
	for(i=0;i<SlotRowSize;i++){
		Instance = instance_create_layer(
		    camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0])/2 - (SlotRowSize/2*sprite_get_width(spr_Slot)/2*global.GUIMultiplier)+i*sprite_get_width(spr_Slot)/2*global.GUIMultiplier, 
		    camera_get_view_y(view_camera[0]) + 16 + camera_get_view_height(view_camera[0])/2 - SlotColumnSize/2*sprite_get_height(spr_Slot)/2*global.GUIMultiplier,
		    "OtherO", oSlot
		);
		Instance.VarSlot = i;
		if(i == 0){
			global.InventoryLeftTopCorner = [Instance.x, Instance.y];
		}
	}
	
	for(i=0;i<SlotRowSize;i++){
		Instance = instance_create_layer(
		    camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0])/2 - (SlotRowSize/2*sprite_get_width(spr_Slot)/2*global.GUIMultiplier)+i*sprite_get_width(spr_Slot)/2*global.GUIMultiplier, 
		    camera_get_view_y(view_camera[0]) + 16 + camera_get_view_height(view_camera[0])/2 - SlotColumnSize/2*sprite_get_height(spr_Slot)/2*global.GUIMultiplier + sprite_get_height(spr_Slot)/2*global.GUIMultiplier,
		    "OtherO", oSlot
		);
		Instance.VarSlot = i + SlotRowSize;
	}
	
	for(i=0;i<SlotRowSize;i++){
		Instance = instance_create_layer(
		    camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0])/2 - (SlotRowSize/2*sprite_get_width(spr_Slot)/2*global.GUIMultiplier)+i*sprite_get_width(spr_Slot)/2*global.GUIMultiplier, 
		    camera_get_view_y(view_camera[0]) + 16 + camera_get_view_height(view_camera[0])/2 - SlotColumnSize/2*sprite_get_height(spr_Slot)/2*global.GUIMultiplier + sprite_get_height(spr_Slot)*2/2*global.GUIMultiplier,
		    "OtherO", oSlot
		);
		Instance.VarSlot = i + SlotRowSize*2;
		if(i == SlotRowSize - 1){
			global.InventoryRightBottomCorner = [Instance.x + sprite_get_width(spr_Slot)/2*global.GUIMultiplier, Instance.y + sprite_get_height(spr_Slot)/2*global.GUIMultiplier];
		}
	}
}
