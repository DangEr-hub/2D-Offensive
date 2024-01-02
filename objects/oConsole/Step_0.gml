if(console_submit(global.my_console)){
    if(console_cmd(global.my_console,"show_message")){
       var  msg = console_value(global.my_console,1);
        show_message(msg);
    }
}

if(keyboard_check_pressed(192)){
    console_toggle(global.my_console);
}
