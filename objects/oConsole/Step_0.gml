if(console_submit(global.my_console)){
    if(console_cmd(global.my_console,"show message")){
       var  msg = console_value(global.my_console,1);
        show_message(msg);
    }
}

var terminal_mode = ds_map_exists(global.my_console, "terminal_mode") && global.my_console[? "terminal_mode"];
if(keyboard_check_pressed(global.KeyBinds[| KEY.Console]) && !instance_exists(objUILottery) && !terminal_mode){
    console_toggle(global.my_console);
}
