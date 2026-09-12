if(buy_menu == true){
	if (zui_get_hover()) {
		if(!instance_exists(oBuyMenuDescription)){
			with(zui_main()){
				if(global.gui_scale > 1){
					other.buy_menu_description = zui_create(zui_get_width() * .825, zui_get_height() * .82, oBuyMenuDescription);
				}else{
					other.buy_menu_description = zui_create(zui_get_width() * .775, zui_get_height() * .75, oBuyMenuDescription);
				}
			}
			buy_menu_description.item_variable = item_variable;
		}
	} else {
		if(instance_exists(buy_menu_description)){
			with(buy_menu_description){
				zui_destroy();
			}
		}
	}
}



