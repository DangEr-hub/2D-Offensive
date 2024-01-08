event_inherited();
Keys = ds_map_keys_to_array(HitMap);
for (var i = 0; i < array_length(Keys); i++) {
    ds_map_destroy(HitMap[? Keys[i]]);
}
ds_map_destroy(HitMap);