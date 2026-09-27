function tr(key){
	if(!variable_struct_exists(global.translates, key)) return "";
	var txt = global.translates[$ key];
	
	if (!is_struct(txt)) return "";
	
	if(variable_struct_exists(txt, global.language))
		return txt[$ global.language];
	
	return txt.en;
}

function tr_name(item_id) {
    var item_text = global.translates.Items[item_id];
    if (!is_struct(item_text)) return "";

    var names = item_text.Name;
    if (variable_struct_exists(names, global.language))
        return names[$ global.language];

    return names.en;
}

function tr_desc(item_id) {
    var item_text = global.translates.Items[item_id];
    if (!is_struct(item_text)) return "";

    var descriptions = item_text.Desc;
    if (variable_struct_exists(descriptions, global.language))
        return descriptions[$ global.language];

    return descriptions.en;
}

function tr_adv(item_id, is_advantage) {
    var item_text = global.translates.Items[item_id];
    if (!is_struct(item_text)) return "";

    var field = is_advantage ? "Advantages" : "Disadvantages";
    if (!variable_struct_exists(item_text, field)) return "";

    var text = item_text[$ field];
    if (variable_struct_exists(text, global.language))
        return text[$ global.language];

    return text.en;
}
