event_inherited();
Keys = ds_map_keys_to_array(HitMap);
for (var i = 0; i < array_length_1d(Keys); i++) {
    ds_map_destroy(HitMap[? Keys[i]]);
}
ds_map_destroy(HitMap);