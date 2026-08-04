event_inherited();
ar_count_str = "Assault rifles - " + string(global.player_stats_struct.AR_cases) + "x";
with(ar_count){caption = oCasesTab.ar_count_str; }

sniper_count_str = "Sniper rifles - " + string(global.player_stats_struct.Sniper_cases) + "x";
with(sniper_count){caption = oCasesTab.sniper_count_str; }


pistol_count_str = "Pistols - " + string(global.player_stats_struct.Pistol_cases) + "x";
with(pistol_count){caption = oCasesTab.pistol_count_str; }


smg_count_str = "Submachine guns - " + string(global.player_stats_struct.Smg_cases) + "x";
with(smg_count){caption = oCasesTab.smg_count_str; }


heavy_count_str = "Heavy guns - " + string(global.player_stats_struct.Heavy_cases) + "x";
with(heavy_count){caption = oCasesTab.heavy_count_str; }