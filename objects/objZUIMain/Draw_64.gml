matrix_stack_push();
matrix_set(matrix_world, matrix_build_identity());

zui_draw(0, 0, 1, 1);

matrix_stack_pop();
matrix_set(matrix_world, matrix_stack_top());

if (room == rm_main_menu) {
    console_draw(global.my_console,
        global.ConsoleHeight * global.GUIMultiplier,
        c_gray, c_silver, c_white, c_white,
        global.GUIHUDAlpha * 2,
        global.ConsoleWidth * global.GUIMultiplier
    );
}