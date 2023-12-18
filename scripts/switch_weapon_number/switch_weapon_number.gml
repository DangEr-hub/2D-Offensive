// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function switch_weapon_number(){
	if(CanShoot == true){
		switch(WeaponNumber){
			case 0:
				if(WeaponID != 0){
					weapon_shooting_mode = 0;
					ReloadTime = 0;
					ReloadTimer = -1;
					WeaponID = 0;
					Reloading = false;
					if(global.weapon_id[min(WeaponID, 2)] != Item.None){
						EquipmentAlpha = global.GUIHUDAlpha;
					}
					if(kick_back_timer != -1){
						kick_back_timer = KickBackTime;
					}
				}
			break;
			
			case 1:
				if(WeaponID != 1){
					weapon_shooting_mode = 0;
					ReloadTime = 0;
					ReloadTimer = -1;
					WeaponID = 1;
					Reloading = false;
					if(global.weapon_id[min(WeaponID, 2)] != Item.None){
						EquipmentAlpha = global.GUIHUDAlpha;
					}
					if(kick_back_timer != -1){
						kick_back_timer = KickBackTime;
					}
				}
			break;

			case 2:
				if(WeaponID != 2){
					weapon_shooting_mode = 0;
					ReloadTime = 0;
					ReloadTimer = -1;
					WeaponID = 2;
					Reloading = false;
					if(global.weapon_id[min(WeaponID, 2)] != Item.None){
						EquipmentAlpha = global.GUIHUDAlpha;
					}
					if(kick_back_timer != -1){
						kick_back_timer = KickBackTime;
					}
				}
			break;
		}
	}
}