// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// Convert a hexadecimal color string to RGB values
function hex_to_rgb(hex) {
    var r = (hex >> 24) & 0xFF;
    var g = (hex >> 16) & 0xFF;
    var b = (hex >> 8) & 0xFF;
    return [r, g, b];
}
function interpolate_color(color1, color2, fraction) {
    return [
        round(lerp(color1[0], color2[0], fraction)),
        round(lerp(color1[1], color2[1], fraction)),
        round(lerp(color1[2], color2[2], fraction))
    ];
}

function rgb_to_hex(r, g, b) {
    return (r << 24) | (g << 16) | (b << 8) | 0xFF;
}