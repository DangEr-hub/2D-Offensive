function tilemap_get_pixel(tilemap_id, tileset_sprite, tile_w, tile_h, xx, yy){
    var tile = tilemap_get_at_pixel(tilemap_id, xx, yy);
    if(tile == -1) return undefined;

    var local_x = xx mod tile_w;
    var local_y = yy mod tile_h;

    var tiles_per_row = sprite_get_width(tileset_sprite) div tile_w;

    var px = (tile mod tiles_per_row) * tile_w + local_x;
    var py = (tile div tiles_per_row) * tile_h + local_y;

    return sprite_getpixel(tileset_sprite, 0, px, py);
}
