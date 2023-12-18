/// @description  console_add(console,suggestion/help string)
/// @param console
/// @param suggestion/help string
function console_add(argument0, argument1) {
	var c=argument0,str=argument1;

	if !ds_exists(c[? "text"],ds_type_list) {
	    list = ds_list_create();
	} else list = c[? "text"];

	if(ds_list_find_index(list, str) == -1){
	    ds_list_add(list,str);
	}else{
	    ds_list_clear(list);
	    ds_list_add(list, str);
	}
	    c[? "text"] = list;
    
	    if !ds_exists(c[? "suggestions"],ds_type_list) {
	        c[? "suggestions"] = ds_list_create();
	    }else{
	        ds_list_clear(c[? "suggestions"]);
	    }




}
