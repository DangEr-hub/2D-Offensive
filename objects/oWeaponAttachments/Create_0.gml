event_inherited();
texture_width = min(384 * global.gui_scale, 512);
texture_height = min(192 * global.gui_scale, 320);
Id = global.Inventory[# global.local_player.WeaponID, Index.slot_id];

draw_set_font(set_font("GUI_small"));
zui_set_size(texture_width, texture_height);

with (zui_create(0, 0, objUIWindowCaption, depth - 1)) {
    caption = global.ItemIndex[# other.Id, ItemStat.Name];
    draggable = 1;
}

var scale = global.gui_scale;
var w_width = 256 * scale;
var w_height = 128 * scale;
var weapon_x = zui_get_width() * 0.5;
var weapon_y = zui_get_height() * 0.59;
var sockets = global.ItemIndex[# Id, ItemStat.attach_sockets];
var slot_keys = ["scope", "barrel", "grip", "suppressor"];
var inv_slots = [Index.slot_scope, Index.slot_barrel, Index.slot_grip, Index.slot_suppressor];

var att = { 
    scope:      { items: [] },
    barrel:     { items: [] },
    grip:       { items: [] },
    suppressor: { items: [] }
};

for(var j = 0; j < INVENTORY_SIZE; j++){
    var item_in_inv = global.Inventory[# j, Index.slot_id];
    if(item_in_inv == Item.None){ continue; }
    
    var item_slot_type = global.ItemIndex[# item_in_inv, ItemStat.slot];
    
    // Projdeme naše 4 sledované typy a porovnáme
    for(var k = 0; k < ATTACHMENTS.slot_suppressor + 1; k++){
        if(item_slot_type == inv_slots[k]){
			array_push(att[$ slot_keys[k]].items, { 
			    item_id: item_in_inv, 
			    inv_pos: j 
			}
			);
			break;
        }
    }
}

var button_offsets = {
    scope: [-9, -20], 
    barrel: [0, -17], 
    grip: [0, 25], 
    suppressor: [0, 20]
};


// Vytvoříme hlavní zbraň
var inst_weapon = zui_create(weapon_x, weapon_y, objUIImage);
with (inst_weapon) {
	zui_set_depth(501);
    zui_set_size(w_width, w_height);
    zui_set_anchor(0.5, 0.5);
    clickable = false;
    sprite = spr_Items;
    sprite_image_index = other.Id;
    sprite_width_size = w_width;
    sprite_height_size = w_height;
}

// Attachmenty a tlačítka
for (var i = 0; i < ATTACHMENTS.slot_suppressor + 1; i++) {
    var att_id = global.Inventory[# global.local_player.WeaponID, inv_slots[i]];
    var socket_name = slot_keys[i];
    var off = sockets[$ socket_name]; // Získáme socket

    if (off != undefined) { 
        var target_x = weapon_x + (off[0] * scale * 2);
        var target_y = weapon_y + (off[1] * scale * 2);
        
        // CASE: Slot na zbrani je PRÁZDNÝ -> Vykreslíme dostupné věci z inventáře
        if (att_id == Item.None) {
            var list = att[$ socket_name].items;
            for (var m = 0; m < min(array_length(list), 4); m++) {
                var item_data = list[m];
                var bh = 16 * scale;
				var sig = socket_name == "barrel" ? -1 : 1;
                with (zui_create(target_x, target_y + (m * bh * 1.05) * sig, objUIButton)) {
                    zui_set_size(32 * scale, bh);
                    spr[1] = item_data.item_id;
                    
                    self.target_slot = inv_slots[i];
                    self.item_id = item_data.item_id;
                    self.inv_pos = item_data.inv_pos;

                    callback = function() {
                        var _row = global.local_player.WeaponID;
                        global.Inventory[# _row, self.target_slot] = self.item_id;
                        ItemAmountSubstract(self.inv_pos, 1);
                        
                        if (instance_exists(oWeaponAttachments)) { with (oWeaponAttachments) { zui_destroy(); } }
                        with (zui_main()) {
                            zui_create(zui_get_width() * 0.5, zui_get_height() * 0.75, oWeaponAttachments);
                        }
                    };
                }
            }
        }

        // CASE: Slot na zbrani je PLNÝ
        if (att_id != Item.None) {
            // Vykreslení ikony attachmentu
            with (zui_create(target_x, target_y, objUIImage)) {
                zui_set_depth(500);
                zui_set_size(w_width * 0.5, w_height * 0.5);
                zui_set_anchor(0.5, 0.5);
                clickable = false;
                sprite = spr_Items;
                sprite_image_index = att_id;
                sprite_width_size = w_width * 0.5;
                sprite_height_size = w_height * 0.5;
            }
        
            var b_off = button_offsets[$ socket_name];
            var b_x = target_x + (b_off[0] * scale);
            var b_y = target_y + (b_off[1] * scale);
        
            with (zui_create(b_x, b_y, objUIButton)) {
                zui_set_size(24 * scale, 12 * scale);
                caption_color = MAIN_COLOR;
                caption = "Drop";
                
                self.target_slot = inv_slots[i];
                self.item_to_drop = att_id;

                callback = function() {
                    var _item = self.item_to_drop;
                    var _slot = self.target_slot;
                    var _player_weapon_row = global.local_player.WeaponID;

                    if (global.Inventory[# _player_weapon_row, _slot] != Item.None) {
                        gain_item(_item, 1, 0, 0, 0, 0, 0, 0, 0, false);
                        global.Inventory[# _player_weapon_row, _slot] = Item.None;    
                        if (instance_exists(oWeaponAttachments)) { with (oWeaponAttachments) { zui_destroy(); } }
                        with (zui_main()) {
                            zui_create(zui_get_width() * 0.5, zui_get_height() * 0.75, oWeaponAttachments);
                        }
                    }
                };
            }    
        }
    }
}