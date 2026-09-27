/// @description  console_destroy(console)
/// @param console
function console_destroy(argument0) {
	var console = argument0;
	if(ds_exists(console[? "history"], ds_type_list)) ds_list_destroy(console[? "history"]);
	if(ds_exists(console[? "input_history"], ds_type_list)) ds_list_destroy(console[? "input_history"]);
	if(ds_exists(console[? "text"], ds_type_list)) ds_list_destroy(console[? "text"]);
	if(ds_exists(console[? "suggestions"], ds_type_list)) ds_list_destroy(console[? "suggestions"]);

	ds_map_destroy(console);







}
