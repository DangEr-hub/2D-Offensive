// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function string_wrap(str, width){
	if(string_length(str) > 0 && str != 0){
	    var result = "";
	    var line = "";
	    var words = ds_list_create();
    
	    // Split the string into words
	    var temp_str = str;
	    while (string_pos(" ", temp_str) > 0) {
	        var pos = string_pos(" ", temp_str);
	        var word = string_copy(temp_str, 1, pos - 1);
	        ds_list_add(words, word);
	        temp_str = string_delete(temp_str, 1, pos);
	    }
	    ds_list_add(words, temp_str);  // Add the last word

	    // Construct the wrapped text
	    var word_count = ds_list_size(words);
	    for (var i = 0; i < word_count; i++) {
	        var word = words[| i];
	        if (string_width(line + word) <= width) {
	            line += word + " ";
	        } else {
	            result += line + "\n";
	            line = word + " ";
	        }
	    }
	    result += line;  // Add the last line.

	    ds_list_destroy(words);  // Clean up the list
	    return result;	
	}else{
		return "";
	}
}