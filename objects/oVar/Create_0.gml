randomize();
global.bomb_time = 5 * game_get_speed(gamespeed_fps);
global.player_character_seed = irandom(2147483646);
global.my_console = console_create();
global.unlocked_items = ds_list_create();
global.local_player = -1;
global.sudo = false;
global.InventoryEquipLeftTopCorner = [-1, -1];
global.InventoryEquipRightBottomCorner = [-1, -1];
global.InventoryLeftTopCorner = [-1, -1];
global.InventoryRightBottomCorner = [-1, -1];
global.FlashBangMaxDistance = 512;
global.HitBoxAlpha = .1;
global.ConsoleHeight = 256;
global.ConsoleWidth = 512;
global.gui_alpha = .75;
global.FieldOfView = 10;
global.CameraWidth = 1920/2;
global.CameraHeight = 1080/2;
global.ranked_game = false;
global.hard_mode = false;
global.Weather = 0;
global.time_step = 1;
global.bomb_planted = false;
global.bomb_timer = 0;
global.bomb_planter_pid = -1;


global.translates = {
    Main_menu: { cz: "Hlavní nabídka", en: "Main menu" },
    Play_unranked: { cz: "Nehodnocená hra", en: "Play unranked" },
    Play_ranked: { cz: "Hodnocená hra", en: "Play ranked" },
    Statistics: { cz: "Statistiky", en: "Statistics" },
    ERS: { cz: "ERS", en: "ERS" },
    Weapons: { cz: "Zbraně", en: "Weapons" },
    Settings: { cz: "Nastavení", en: "Settings" },
    Keyboard_settings: { cz: "Ovládání", en: "Keyboard settings" },
    Sources: { cz: "Zdroje", en: "Sources" },
    Cases: { cz: "Bedny", en: "Cases" },
    Exit: { cz: "Ukončit", en: "Exit" },
    Host_server: { cz: "Hostovat", en: "Host server" },
    Join_server: { cz: "Připojit se", en: "Join server" },
    Plot: { cz: "Graf", en: "Plot" },
    Buy: { cz: "Koupit", en: "Buy" },
    Open: { cz: "Otevřít", en: "Open" },
    Reset: { cz: "Obnovit", en: "Reset" },
    On: { cz: "Zap.", en: "On" },
    Off: { cz: "Vyp.", en: "Off" },
    Damage_function: { cz: "Graf poškození", en: "Damage function" },
    Inaccuracy_function: { cz: "Graf nepřesnosti", en: "Inaccuracy function" },
    Magazine_capacity: { cz: "Zásobník", en: "Magazine capacity" },
    Reload_speed: { cz: "Přebíjení", en: "Reload speed" },
    Equip_speed: { cz: "Tasení", en: "Equip speed" },
    Movement_speed: { cz: "Pohyb", en: "Movement speed" },
    Armor_penetration: { cz: "Průraznost", en: "Armor penetration" },
    Base_damage: { cz: "Poškození", en: "Base damage" },
    Damage_table: { cz: "Tabulka škod", en: "Damage table" },
    Spectate: { cz: "Sledovat", en: "Spectate" },
    Next_round: { cz: "Další kolo", en: "Next round" },
    Continue: { cz: "Pokračovat", en: "Continue" },
    Close: { cz: "Zavřít", en: "Close" },
    Back: { cz: "Zpět", en: "Back" },
    Unequip: { cz: "Sundat", en: "Unequip" },
    Equip: { cz: "Nasadit", en: "Equip" },
    Use: { cz: "Použít", en: "Use" },
    Drop: { cz: "Pusť", en: "Drop" },
    Respawn_menu: { cz: "Menu respawnu", en: "Respawn menu" },
    Yes: { cz: "Ano", en: "Yes" },
    No: { cz: "Ne", en: "No" },
    OK: { cz: "OK", en: "OK" },
    Play_unranked_game: { cz: "Nehodnocená hra", en: "Play unranked game" },
    Play_ranked_game: { cz: "Hodnocená hra", en: "Play ranked game" },
    Keyboard_configuration: { cz: "Nastavení ovládání", en: "Keyboard configuration" },
    Game_end: { cz: "Konec hry", en: "Game end" },
    Round_end: { cz: "Konec kola", en: "Round end" },
    Weapon_cases: { cz: "Bedny se zbraněmi", en: "Weapon cases" },
    Weapon_database: { cz: "Databáze zbraní", en: "Weapon database" },
    Eggy_Rating_System: { cz: "Eggy Rating System", en: "Eggy Rating System" },
    Pause: { cz: "Pauza", en: "Pause" },
    Mortar: { cz: "Minomet", en: "Mortar" },
    Scoreboard: { cz: "Tabulka hráčů", en: "Scoreboard" },
    Terminal: { cz: "Terminál", en: "Terminal" },
    Leave: { cz: "Odejít", en: "Leave" },
    Buy_time_remaining: { cz: "Zbývající čas nákupu:", en: "Buy time remaining:" },
    Level: { cz: "Úroveň", en: "Level" },
    Experience: { cz: "Zkušenosti", en: "Experience" },
    Health: { cz: "Životy", en: "Health" },
    Stamina: { cz: "Výdrž", en: "Stamina" },
    Kills: { cz: "Zabití", en: "Kills" },
    Assists: { cz: "Asistence", en: "Assists" },
    Deaths: { cz: "Úmrtí", en: "Deaths" },
    Headshots: { cz: "Zásahy do hlavy", en: "Headshots" },
    Headshot_percentage: { cz: "Podíl zásahů do hlavy", en: "Headshot percentage" },
    Accuracy: { cz: "Přesnost", en: "Accuracy" },
    Finished_games: { cz: "Odehrané hry", en: "Finished games" },
    Won_games: { cz: "Vyhrané hry", en: "Won games" },
    Lost_games: { cz: "Prohrané hry", en: "Lost games" },
    Tied_games: { cz: "Remízy", en: "Tied games" },
    Total_kills: { cz: "Celkem zabití", en: "Total kills" },
    Total_headshots: { cz: "Celkem zásahů do hlavy", en: "Total headshots" },
    Time_alive: { cz: "Čas naživu", en: "Time alive" },
    Average_playing_time: { cz: "Průměrná doba hraní", en: "Average playing time" },
    Rank: { cz: "Hodnost", en: "Rank" },
    Player_rating: { cz: "Hodnocení hráče", en: "Player rating" },
    Bot_enemy_rating: { cz: "Hodnocení nepřátel", en: "Bot enemy rating" },
    Ratings: { cz: "Hodnocení", en: "Ratings" },
    RDs: { cz: "Odchylky RD", en: "RDs" },
    Evaluation: { cz: "Odhad", en: "Evaluation" },
    Rating: { cz: "Hodnocení", en: "Rating" },
    Rating_deviation: { cz: "Odchylka", en: "Rating deviation" },
    Volatility: { cz: "Volatilita", en: "Volatility" },
    Predictive_volatility: { cz: "Prediktivní volatilita", en: "Predictive volatility" },
    Game_volatility: { cz: "Herní volatilita", en: "Game volatility" },
    Upcoming_game: { cz: "Nadcházející hra", en: "Upcoming game" },
    Velocity: { cz: "Rychlost", en: "Velocity" },
    Kickback: { cz: "Zpětný ráz", en: "Kickback" },
    Inaccuracy: { cz: "Nepřesnost", en: "Inaccuracy" },
    Units: { cz: "jednotek", en: "units" },
    Units_per_second: { cz: "jednotek·s⁻¹", en: "units·s⁻¹" },
    Units_per_shot: { cz: "jednotek na výstřel", en: "units per shot" },
    Per_shot: { cz: "na výstřel", en: "per shot" },
    Safety: { cz: "Pojistka", en: "Safety" },
    Semi: { cz: "Poloautomatická", en: "Semi" },
    Burst: { cz: "Dávka", en: "Burst" },
    Auto: { cz: "Automatická", en: "Auto" },
    Pistol: { cz: "Pistole", en: "Pistol" },
    Assault_rifle: { cz: "Útočná puška", en: "Assault rifle" },
    Shotgun: { cz: "Brokovnice", en: "Shotgun" },
    Sniper_rifle: { cz: "Odstřelovací puška", en: "Sniper rifle" },
    Machine_gun: { cz: "Kulomet", en: "Machine gun" },
    Submachine_gun: { cz: "Samopal", en: "Submachine gun" },
    Knife: { cz: "Nůž", en: "Knife" },
    Missile: { cz: "Raketomet", en: "Missile" },
    Enemy: { cz: "Nepřítel", en: "Enemy" },
    Particles: { cz: "Částice", en: "Particles" },
    Bloom_shader: { cz: "Bloom shader", en: "Bloom shader" },
    Volume_gain: { cz: "Hlasitost", en: "Volume gain" },
    Saturation_level: { cz: "Sytost barev", en: "Saturation level" },
    Dynamic_crosshair: { cz: "Dynamický zaměřovač", en: "Dynamic crosshair" },
    Toggle_fullscreen: { cz: "Celá obrazovka", en: "Toggle fullscreen" },
    Window_size: { cz: "Velikost okna", en: "Window size" },
    GUI_scale: { cz: "Měřítko GUI", en: "GUI scale" },
    Language: { cz: "Jazyk", en: "Language" },
    IP_address: { cz: "IP adresa", en: "IP address" },
    Hardmode: { cz: "Těžký režim", en: "Hardmode" },
    Assault_rifles: { cz: "Útočné pušky", en: "Assault rifles" },
    Sniper_rifles: { cz: "Odstřelovačky", en: "Sniper rifles" },
    Pistols: { cz: "Pistole", en: "Pistols" },
    Submachine_guns: { cz: "Samopaly", en: "Submachine guns" },
    Heavy_guns: { cz: "Těžké zbraně", en: "Heavy guns" },
    Ammo: { cz: "Munice", en: "Ammo" },
    Price: { cz: "Cena", en: "Price" },
    RPM: { cz: "Kadence", en: "RPM" },
    Body_damage: { cz: "Poškození těla", en: "Body damage" },
    Head_damage: { cz: "Poškození hlavy", en: "Head damage" },
    Arm_damage: { cz: "Poškození rukou", en: "Arm damage" },
    Leg_damage: { cz: "Poškození nohou", en: "Leg damage" },
    Base_Spread: { cz: "Základní rozptyl", en: "Base Spread" },
    Penetration_power: { cz: "Průraznost", en: "Penetration power" },
    Reload_time: { cz: "Doba přebíjení", en: "Reload time" },
    Equip_time: { cz: "Doba tasení", en: "Equip time" },
    Kill_reward: { cz: "Odměna za zabití", en: "Kill reward" },
    Maximal_range: { cz: "Maximální dostřel", en: "Maximal range" },
    Fire_modes: { cz: "Režimy střelby", en: "Fire modes" },
    Class: { cz: "Třída", en: "Class" },
    Type: { cz: "Typ", en: "Type" },
    Moving_spread_increase: { cz: "Rozptyl při pohybu", en: "Moving spread increase" },
    Kickback_spread_increase: { cz: "Rozptyl při zpětném rázu", en: "Kickback spread increase" },
    Complex_recoil: { cz: "Složitý zpětný ráz", en: "Complex recoil" },
    Caliber: { cz: "Ráže", en: "Caliber" },
    Crosshair_vertical_recoil: { cz: "Vertikální zpětný ráz zaměřovače", en: "Crosshair vertical recoil" },
    Crosshair_horizontal_recoil: { cz: "Horizontální zpětný ráz zaměřovače", en: "Crosshair horizontal recoil" },
    Bullet_vertical_offset: { cz: "Vertikální posun střely", en: "Bullet vertical offset" },
    Bullet_horizontal_offset: { cz: "Horizontální posun střely", en: "Bullet horizontal offset" },
    Search_weapon: { cz: "Hledat zbraň", en: "Search weapon" },
    Difficulty: { cz: "Obtížnost", en: "Difficulty" },
    Damage: { cz: "Poškození", en: "Damage" },
    Penetration: { cz: "Průraznost", en: "Penetration" },
    Range: { cz: "Dostřel", en: "Range" },
    Armour: { cz: "Brnění", en: "Armour" },
    Healing_power: { cz: "Léčivá síla", en: "Healing power" },
    Team: { cz: "Tým", en: "Team" },
    Police: { cz: "Policie", en: "Police" },
    Terrorist: { cz: "Terorista", en: "Terrorist" },
    None: { cz: "Žádné", en: "None" },
    Weight: { cz: "Hmotnost", en: "Weight" },
    Height: { cz: "Výška", en: "Height" },
    Age: { cz: "Věk", en: "Age" },
    Helmet: { cz: "Helma", en: "Helmet" },
    Body: { cz: "Tělo", en: "Body" },
    Primary_weapon: { cz: "Hlavní zbraň", en: "Primary weapon" },
    Secondary_weapon: { cz: "Vedlejší zbraň", en: "Secondary weapon" },
    HE_grenades: { cz: "Tříštivé granáty", en: "HE grenades" },
    Flash_grenades: { cz: "Oslepující granáty", en: "Flash grenades" },
    Smoke_grenades: { cz: "Kouřové granáty", en: "Smoke grenades" },
    Molotov_grenades: { cz: "Molotovy", en: "Molotov grenades" },
    Health_packs: { cz: "Lékárničky", en: "Health packs" },
    Complex_coordinates: { cz: "Složité souřadnice", en: "Complex coordinates" },
    Up: { cz: "Nahoru", en: "Up" },
    Left: { cz: "Vlevo", en: "Left" },
    Down: { cz: "Dolů", en: "Down" },
    Right: { cz: "Vpravo", en: "Right" },
    Open_inventory: { cz: "Otevřít inventář", en: "Open inventory" },
    Pick_up: { cz: "Sebrat", en: "Pick up" },
    Cycle_item_left: { cz: "Předchozí předmět", en: "Cycle item left" },
    Cycle_item_right: { cz: "Další předmět", en: "Cycle item right" },
    Shoot: { cz: "Střílet", en: "Shoot" },
    Reload: { cz: "Přebít", en: "Reload" },
    Grenade_throw: { cz: "Hodit granát", en: "Grenade throw" },
    Toggle_night_vision: { cz: "Přepnout noční vidění", en: "Toggle night vision" },
    Change_shooting_mode: { cz: "Změnit režim střelby", en: "Change shooting mode" },
    Prone: { cz: "Lehnout", en: "Prone" },
    Show_attachments: { cz: "Ukázat doplňky", en: "Show attachments" },
    Select_bot: { cz: "Vybrat bota", en: "Select bot" },
    Command_bot: { cz: "Přikázat botovi", en: "Command bot" },
    Open_buy_menu: { cz: "Otevřít nákup", en: "Open buy menu" },
    Drop_weapon: { cz: "Zahodit zbraň", en: "Drop weapon" },
    Open_console: { cz: "Otevřít konzoli", en: "Open console" },
    Knife_light_attack: { cz: "Lehký útok nožem", en: "Knife light attack" },
    Knife_heavy_attack: { cz: "Silný útok nožem", en: "Knife heavy attack" },
    Use_item: { cz: "Použít předmět", en: "Use item" },
    Scope: { cz: "Zamířit", en: "Scope" },
    Show_scoreboard: { cz: "Ukázat tabulku", en: "Show scoreboard" },
    Take_hostage: { cz: "Převzít rukojmí", en: "Take hostage" },
    Defuse_bomb: { cz: "Zneškodnit bombu", en: "Defuse bomb" },
    Open_door: { cz: "Otevřít dveře", en: "Open door" },
    Bot_info: { cz: "Informace o botovi", en: "Bot info" },
    Run: { cz: "Běh", en: "Run" },
    Walk: { cz: "Chůze", en: "Walk" },
    Open_terminal: { cz: "Otevřít terminál", en: "Open terminal" },
    Take_bot: { cz: "Převzít bota", en: "Take bot" },
    Years: { cz: "let", en: "years" },
    Getting_spotted_chance: { cz: "Šance na odhalení", en: "Getting spotted chance" },
    Attack_power: { cz: "Síla útoku", en: "Attack power" },
    Vertical_recoil: { cz: "Vertikální zpětný ráz", en: "Vertical recoil" },
    Horizontal_recoil: { cz: "Horizontální zpětný ráz", en: "Horizontal recoil" },
    Round_won: { cz: "Vyhrané kolo", en: "Round won" },
    Round_lost: { cz: "Prohrané kolo", en: "Round lost" },
    Spectating: { cz: "Sledování", en: "Spectating" },
    Win: { cz: "Výhra", en: "Win" },
	Money: { cz: "Peníze", en: "Money" },
    Loss: { cz: "Prohra", en: "Loss" },
    Draw: { cz: "Remíza", en: "Draw" },
    You_died: { cz: "Zemřel jsi", en: "You died" },
    Primary: { cz: "Primární", en: "Primary" },
    Secondary: { cz: "Sekundární", en: "Secondary" },
    Tertiary: { cz: "Terciální", en: "Tertiary" },
    Low: { cz: "Nízký", en: "Low" },
    Medium: { cz: "Střední", en: "Medium" },
    High: { cz: "Vysoký", en: "High" },
    Gauges: { cz: "Broková ráže", en: "Gauges" },
    Rocket: { cz: "Raketa", en: "Rocket" },
	Bomb_planted: { cz: "Bomba položena", en: "Bomb planted"},
    Sources_description: { cz: "Inspirace: Counter-Strike, CS2D\na Unturned.\nProhlášení o použití AI:\nTento projekt vzniká s pomocí AI,\nkonkrétně agenta ChatGPT Codex.\nJsem hobby programátor v GML\ns vlastním životem a prací. AI mi\npomáhá rychleji realizovat nápady\na přidávat do 2D Offensive věci,\nkteré bych těžko zvládl sám.", en: "Inspired by Counter-Strike, CS2D \nand Unturned.\nDeclaration of AI usage:\nThis project, as many things in 2026, \nis developed with help of an AI, \nconcretely ChatGPT codex agent.\nI am just a hobby GML programmer\nwith his own life and job. AI speeds up\nimplementing ideas or even helps to\nimplement ideas that I have never imagined\nadding in 2D Offensive." },
    Items: array_create(ITEM.Total)
};
global.translates[$ "Play!"] = { cz: "Hrát!", en: "Play!" };
global.translates[$ "Launch!"] = { cz: "Odpálit!", en: "Launch!" };
global.translates[$ "K/D_ratio"] = { cz: "Poměr K/D", en: "K/D ratio" };
global.translates[$ "Crosshair_color_(rgb)"] = { cz: "Barva zaměřovače (RGB)", en: "Crosshair color (rgb)" };
global.translates[$ "Anti-aliasing"] = { cz: "Vyhlazování hran", en: "Anti-aliasing" };
global.translates[$ "Player’s_name"] = { cz: "Jméno hráče", en: "Player’s name" };
global.translates[$ "Damage_drop-off"] = { cz: "Pokles poškození", en: "Damage drop-off" };
global.translates[$ "Damage_progress_(1)"] = { cz: "Průběh poškození (1)", en: "Damage progress (1)" };
global.translates[$ "Damage_progress_(2)"] = { cz: "Průběh poškození (2)", en: "Damage progress (2)" };
global.translates[$ "Leave_to_the_main_menu?"] = { cz: "Odejít do hlavní nabídky?", en: "Leave to the main menu?" };
global.translates[$ "Buy_over"] = { cz: "Čas k nákupu vypršel.", en: "The buy period is over." };


global.cases_cost = {
	AR_cases: 12,
	Pistol_cases: 8,
	Sniper_cases: 14,
	Smg_cases: 10,
	Heavy_cases: 10
};

global.player_stats = {
	Name: "DangEr",
	All_shots: 0,
	Headshots: 0,
	Kills: 0,
	Assists: 0,
	Hit_shots: 0,
	Deaths: 0,
	Diamonds: 1000,
	AR_cases: 100,
	Pistol_cases: 100,
	Sniper_cases: 100,
	Smg_cases: 100,
	Heavy_cases: 100,
	Player_team: choose(TEAM.POLICE, TEAM.TERRORIST),
    Get_KD: function() {
        return (Deaths != 0) ? (Kills / Deaths) : 0;
    },
	Get_headshot_percentage: function() {
		return (Kills != 0) ? (Headshots / Kills) * 100 : 0;
	},
	Get_accuracy: function() {
		return (All_shots > 0) ? clamp(Hit_shots / All_shots * 100, 0, 100) : 0;
	},
	Xp: 0,
	Max_xp: 50,
	Max_health: 100,
	Max_stamina: 100,
	Lvl: 1,
	Skill_points: 0,
	Unskill_points: 0,
	Money: ROUND_STARTING_MONEY,
	Weight: 0,
	Max_weight: 15,
	Armour: 0,
	Gold: false,
	Magenta: false,
	Red: false,
	Aqua: false,
	Green: false,
	Gray: false,
	White: false
	
};
global.game_struct = game_struct_create();

enum ICON{
	none, health, stamina, xp, kills, deaths, armour, kd, headshot_percentage, accuracy, time, game, tracking, won_game, lost_game, tied_game, 
	ammo, assists, total
}

enum TEAM{
	NONE,
	POLICE,
	TERRORIST
}

enum ATTACHMENTS {
	scope, barrel, grip, suppressor, total
};

// 

enum CALIBER{
	GAUGES,
	LOW,
	MEDIUM,
	HIGH,
	ROCKET
}

enum RARITY{
	COMMON, UNCOMMON, RARE, LEGENDARY
}

enum MATERIAL{
	CONCRETE,
	METAL,
	WOOD,
	GLASS
}

enum WEAPON_CLASS {
	PISTOL = 1,
	ASSAULT_RIFLE,
	SHOTGUN,
	SNIPER_RIFLE,
	SUBMACHINE_GUN,
	MISSILE,
	MACHINE_GUN,
	KNIFE,
	SHIELD
}


enum WEAPON_TYPE {
	PRIMARY, SECONDARY, TERTIARY	
};



enum WEATHER{
	SUN,
	RAIN,
	SNOW
}



enum MAP_STAT{
	MapStartColor, MapEndColor, MapStartIntensity, MapEndIntensity, MapPeakIntensity, MapStartHours, MapEndHours, Name, EnemyAreas, MaxEnemies, Tile,
	FriendAreas, MaxFriends, BombAreas, HostageAreas, Total
}

enum MAP{
	Desert, RainForest, City, Nuclear, Total
}

global.map_rounds = [];
for (var i = 0; i < MAP.Total; i++) {
    global.map_rounds[i] = [];
    
    for (var j = 0; j < 3; j++) {
        global.map_rounds[i][j] = -1;
    }
}


global.MapID = MAP.Desert;
global.BotMatchStats = [];
global.MapProperties = ds_grid_create(MAP.Total, MAP_STAT.Total);
global.MapProperties[# MAP.Desert, MAP_STAT.Name] = "Desert";
global.MapProperties[# MAP.Desert, MAP_STAT.MapStartColor] = make_color_rgb(208, 141, 35);
global.MapProperties[# MAP.Desert, MAP_STAT.MapEndColor] = make_color_rgb(249, 151, 25);
global.MapProperties[# MAP.Desert, MAP_STAT.MapStartIntensity] = .25;
global.MapProperties[# MAP.Desert, MAP_STAT.MapEndIntensity] = 0;
global.MapProperties[# MAP.Desert, MAP_STAT.MapPeakIntensity] = .7;
global.MapProperties[# MAP.Desert, MAP_STAT.MapStartHours] = 7 * 60;
global.MapProperties[# MAP.Desert, MAP_STAT.MapEndHours] = 22 * 60;
global.MapProperties[# MAP.Desert, MAP_STAT.MaxEnemies] = 100;
global.MapProperties[# MAP.Desert, MAP_STAT.MaxFriends] = 5;
global.MapProperties[# MAP.Desert, MAP_STAT.Tile] = spr_Desert;

var desert_enemy_areas = ds_map_create();
ds_map_add(desert_enemy_areas, "area1", [100, 750, 450, 1200, 4]); //x1, y1, x2, y2, enemy number
ds_map_add(desert_enemy_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(desert_enemy_areas, "area3", [900, 100, 1900, 500, 5]);
ds_map_add(desert_enemy_areas, "area4", [2300, 400, 3000, 1000, 5]);
ds_map_add(desert_enemy_areas, "area5", [2000, 1000, 2900, 1500, 5]);
var desert_friend_areas = ds_map_create();
ds_map_add(desert_friend_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(desert_friend_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(desert_friend_areas, "area3", [900, 100, 1900, 500, 5]);
global.MapProperties[# MAP.Desert, MAP_STAT.EnemyAreas] = desert_enemy_areas;
global.MapProperties[# MAP.Desert, MAP_STAT.FriendAreas] = desert_friend_areas;

var desert_bomb_areas = ds_map_create();
ds_map_add(desert_bomb_areas, "area1", [3300, 1800, 3800, 2200]); //x1, y1, x2, y2
ds_map_add(desert_bomb_areas, "area2", [2700, 0, 3800, 500]);
global.MapProperties[# MAP.Desert, MAP_STAT.BombAreas] = desert_bomb_areas;

var desert_hostage_areas = ds_map_create();
ds_map_add(desert_hostage_areas, "area1", [200, 1200, 500, 1400]); //x1, y1, x2, y2
ds_map_add(desert_hostage_areas, "area2", [800, 1700, 1000, 2000]);
global.MapProperties[# MAP.Desert, MAP_STAT.HostageAreas] = desert_hostage_areas;


global.MapProperties[# MAP.RainForest, MAP_STAT.Name] = "Rain forest";
global.MapProperties[# MAP.RainForest, MAP_STAT.MapStartColor] = make_color_rgb(180, 142, 35);
global.MapProperties[# MAP.RainForest, MAP_STAT.MapEndColor]   = make_color_rgb(180, 156, 90);
global.MapProperties[# MAP.RainForest, MAP_STAT.MapStartIntensity] = 0.4;
global.MapProperties[# MAP.RainForest, MAP_STAT.MapEndIntensity] = 0;
global.MapProperties[# MAP.RainForest, MAP_STAT.MapPeakIntensity] = 0.7;
global.MapProperties[# MAP.RainForest, MAP_STAT.MapStartHours] = 10 * 60;
global.MapProperties[# MAP.RainForest, MAP_STAT.MapEndHours] = 20 * 60;
global.MapProperties[# MAP.RainForest, MAP_STAT.MaxEnemies] = 100;
global.MapProperties[# MAP.RainForest, MAP_STAT.MaxFriends] = 5;
global.MapProperties[# MAP.RainForest, MAP_STAT.Tile] = spr_RainForest;

var rainforest_enemy_areas = ds_map_create();
ds_map_add(rainforest_enemy_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(rainforest_enemy_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(rainforest_enemy_areas, "area3", [900, 100, 1900, 500, 5]);
ds_map_add(rainforest_enemy_areas, "area4", [2300, 400, 3000, 1000, 5]);
ds_map_add(rainforest_enemy_areas, "area5", [2000, 1000, 2900, 1500, 5]);
var rainforest_friend_areas = ds_map_create();
ds_map_add(rainforest_friend_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(rainforest_friend_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(rainforest_friend_areas, "area3", [900, 100, 1900, 500, 5]);
global.MapProperties[# MAP.RainForest, MAP_STAT.EnemyAreas] = rainforest_enemy_areas;
global.MapProperties[# MAP.RainForest, MAP_STAT.FriendAreas] = rainforest_friend_areas;

var rainforest_bomb_areas = ds_map_create();
ds_map_add(rainforest_bomb_areas, "area1", [3300, 1800, 3800, 2200]); //x1, y1, x2, y2
ds_map_add(rainforest_bomb_areas, "area2", [2700, 0, 3800, 500]);
global.MapProperties[# MAP.RainForest, MAP_STAT.BombAreas] = rainforest_bomb_areas;

var rainforest_hostage_areas = ds_map_create();
ds_map_add(rainforest_hostage_areas, "area1", [200, 1200, 500, 1400]); //x1, y1, x2, y2
ds_map_add(rainforest_hostage_areas, "area2", [800, 1700, 1000, 2000]);
global.MapProperties[# MAP.RainForest, MAP_STAT.HostageAreas] = rainforest_hostage_areas;

global.MapProperties[# MAP.City, MAP_STAT.MapStartColor] = c_white;
global.MapProperties[# MAP.City, MAP_STAT.Name] = "City";
global.MapProperties[# MAP.City, MAP_STAT.MapEndColor] = c_orange;
global.MapProperties[# MAP.City, MAP_STAT.MapStartIntensity] = 0.75;
global.MapProperties[# MAP.City, MAP_STAT.MapEndIntensity] = 0.5;
global.MapProperties[# MAP.City, MAP_STAT.MapPeakIntensity] = 1.5;
global.MapProperties[# MAP.City, MAP_STAT.MapStartHours] = 10 * 60;
global.MapProperties[# MAP.City, MAP_STAT.MapEndHours] = 20 * 60;
global.MapProperties[# MAP.City, MAP_STAT.MaxEnemies] = 100;
global.MapProperties[# MAP.City, MAP_STAT.MaxFriends] = 5;

var city_enemy_areas = ds_map_create();
ds_map_add(city_enemy_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(city_enemy_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(city_enemy_areas, "area3", [900, 100, 1900, 500, 5]);
ds_map_add(city_enemy_areas, "area4", [2300, 400, 3000, 1000, 5]);
ds_map_add(city_enemy_areas, "area5", [2000, 1000, 2900, 1500, 5]);
var city_friend_areas = ds_map_create();
ds_map_add(city_friend_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(city_friend_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(city_friend_areas, "area3", [900, 100, 1900, 500, 5]);
global.MapProperties[# MAP.City, MAP_STAT.EnemyAreas] = city_enemy_areas;
global.MapProperties[# MAP.City, MAP_STAT.FriendAreas] = city_friend_areas;

var city_bomb_areas = ds_map_create();
ds_map_add(city_bomb_areas, "area1", [3300, 1800, 3800, 2200]); //x1, y1, x2, y2
ds_map_add(city_bomb_areas, "area2", [2700, 0, 3800, 500]);
global.MapProperties[# MAP.City, MAP_STAT.BombAreas] = city_bomb_areas;

var city_hostage_areas = ds_map_create();
ds_map_add(city_hostage_areas, "area1", [200, 1200, 500, 1400]); //x1, y1, x2, y2
ds_map_add(city_hostage_areas, "area2", [800, 1700, 1000, 2000]);
global.MapProperties[# MAP.City, MAP_STAT.HostageAreas] = city_hostage_areas;


global.MapProperties[# MAP.Nuclear, MAP_STAT.MapStartColor] = c_white;
global.MapProperties[# MAP.Nuclear, MAP_STAT.Name] = "Nuclear";
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapEndColor] = c_orange;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapStartIntensity] = 0.75;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapEndIntensity] = 0.5;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapPeakIntensity] = 1.5;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapStartHours] = 10 * 60;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MapEndHours] = 20 * 60;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MaxEnemies] = 100;
global.MapProperties[# MAP.Nuclear, MAP_STAT.MaxFriends] = 5;

var nuclear_enemy_areas = ds_map_create();
ds_map_add(nuclear_enemy_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(nuclear_enemy_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(nuclear_enemy_areas, "area3", [900, 100, 1900, 500, 5]);
ds_map_add(nuclear_enemy_areas, "area4", [2300, 400, 3000, 1000, 5]);
ds_map_add(nuclear_enemy_areas, "area5", [2000, 1000, 2900, 1500, 5]);
var nuclear_friend_areas = ds_map_create();
ds_map_add(nuclear_friend_areas, "area1", [800, 800, 1300, 1000, 2]); //x1, y1, x2, y2, enemy number
ds_map_add(nuclear_friend_areas, "area2", [900, 1200, 1500, 1800, 3]);
ds_map_add(nuclear_friend_areas, "area3", [900, 100, 1900, 500, 5]);
global.MapProperties[# MAP.Nuclear, MAP_STAT.EnemyAreas] = nuclear_enemy_areas;
global.MapProperties[# MAP.Nuclear, MAP_STAT.FriendAreas] = nuclear_friend_areas;

var nuclear_bomb_areas = ds_map_create();
ds_map_add(nuclear_bomb_areas, "area1", [3300, 1800, 3800, 2200]); //x1, y1, x2, y2
ds_map_add(nuclear_bomb_areas, "area2", [2700, 0, 3800, 500]);
global.MapProperties[# MAP.Nuclear, MAP_STAT.BombAreas] = nuclear_bomb_areas;

var nuclear_hostage_areas = ds_map_create();
ds_map_add(nuclear_hostage_areas, "area1", [200, 1200, 500, 1400]); //x1, y1, x2, y2
ds_map_add(nuclear_hostage_areas, "area2", [800, 1700, 1000, 2000]);
global.MapProperties[# MAP.Nuclear, MAP_STAT.HostageAreas] = nuclear_hostage_areas;



enum KEY{
	Up, Left, Down, Right,
	Inventory, PickUp, CycleLeft,
	CycleRight, ShootMouse, Reload,
	GrenadeThrowMouse, Pause, ToggleNightVision, ChangeMode,
	Prone, WeaponAttachments, SelectBot, CommandBot, 
	BuyMenu, DropWeapon, Console,
	KnifeLight, KnifeHeavy, UseItem, Scope,
	Scoreboard, HostageTake, Defuse, Door,
	BotInfo, Run, Walk, OpenTerm, TakeBot,
	Total
}

global.KeyBinds = ds_list_create();
ds_list_add(
	global.KeyBinds, 
	ord("W"), ord("A"), ord("S"), ord("D"),
	ord("I"), vk_space, ord("Q"), 
	ord("E"), mb_left, ord("R"),
	mb_left, vk_escape, ord("N"), ord("V"),
	ord("Y"), ord("T"), ord("X"), ord("C"),
	ord("B"), ord("G"), 192,
	mb_left, mb_right, mb_left, mb_right,
	vk_tab, vk_space, vk_space, vk_space,
	vk_shift, vk_lcontrol, vk_shift, vk_space, ord("E")
);

global.DefaultKeyBinds = ds_list_create();
ds_list_copy(global.DefaultKeyBinds, global.KeyBinds);

enum TEXTURES{
	no_weapon, pistol, assault_rifle, death, flashed_weapon, flashed_no_weapon, reload, //0-6
	prone, prone_second, prone_third, flashed_prone, flashed_prone_second, flashed_prone_third, //7-12
	reload_prone, reload_prone_second, reload_prone_third, knife_prone, knife_prone_second, knife_prone_third, //13-18
	grenade_prone, grenade_prone_second, grenade_prone_third, grenade_throw, knife_attack //19-23
}


enum STATES_PLAYER{
	none_state,
	prone_state,
	machine_gun_state,
	mortar_state
}

enum HITBOX{
	Head,
	HeadFlashed,
	HeadProne,
	BodyNoWeapon,
	BodyPistol,
	BodyAR,
	BodyThrowReload,
	BodyFlashedWeapon,
	BodyFlashedNoWeapon,
	BodyProne,
	ArmNoWeapon,
	ArmPistol,
	ArmAR,
	ArmThrowReload,
	ArmFlashedWeapon,
	ArmFlashedNoWeapon,
	ArmProne,
	ArmProneFlashed,
	ArmProneReloading,
	ArmKnife,
	ArmProneKnife,
	ArmProneGrenade,
	LegProne,
	LegProne_second,
	LegProne_third,
}

enum STATES{
	Idle,
	MoveShoot,
	Move,
	Chase,
	Death,
	MoveAway,
	MoveAwayFromGrenade,
	MoveToward,
	ThrowGrenade,
	MoveFlashed,
	MoveInSmoke,
	LayDownLandMine,
	MoveHealing,
	MovePredictive,
	MoveCommand,
	NoMove,
	FleeDanger,
	Prone,
	MACHINE_GUN,
	Walk
}

rank_database();
InventoryInit();
global.translates.Items[ITEM.None] = { Name: { cz: "", en: "" }, Desc: { cz: "", en: "" } };
global.translates.Items[ITEM.AKM] = {
    Name: { cz: "AKM", en: "AKM" },
    Desc: { cz: "AKM je proslulá náročným ovládáním, ale také vysokou smrtonosností. Zvládnutí zpětného rázu vyžaduje cvik, ve zkušených rukou však dokáže nepřátele rychle vyřadit.", en: "Known for its challenging handling yet unmatched lethality on the battlefield. Mastering its recoil demands skill, but once tamed, it becomes a devastating tool capable of swiftly dispatching foes with deadly precision." }
};
global.translates.Items[ITEM.KevlarHelm] = { Name: { cz: "Kevlarová helma", en: "Kevlar helmet" }, Desc: { cz: "Základní helma snižuje poškození hlavy o " + string_format((1 - global.ItemIndex[# ITEM.KevlarHelm, ITEMSTATS.Defense]) * 100, 0, 1) + " %. Chrání před slabšími hrozbami a díky nízké hmotnosti téměř neomezuje pohyb.", en: "This basic helmet provides " + string_format((1 - global.ItemIndex[# ITEM.KevlarHelm, ITEMSTATS.Defense]) * 100, 0, 1) + "% damage reduction, offering essential head protection against low-level threats. Lightweight design ensures mobility is maintained." } };
global.translates.Items[ITEM.DesertEagle] = { Name: { cz: "Desert Eagle", en: "Desert Eagle" }, Desc: { cz: "Vysoké poškození a průraznost překážek vyvažuje silný zpětný ráz a malý zásobník. Zkušený střelec dokáže každou dobře mířenou ranou způsobit vážné škody.", en: "Known for its high damage and armor penetration, presents a formidable challenge to master due to its recoil and limited magazine capacity. Despite these drawbacks, skilled player harness its power to devastating effect, making each well-placed shot count in engagements." } };
global.translates.Items[ITEM.KevlarVest] = { Name: { cz: "Kevlarová vesta", en: "Kevlar vest" }, Desc: { cz: "Lehká vesta snižuje poškození o " + string_format((1 - global.ItemIndex[# ITEM.KevlarVest, ITEMSTATS.Defense]) * 100, 0, 1) + " %. Zvyšuje šanci na přežití, aniž by výrazně omezovala pohyb.", en: "This lightweight vest offers a basic " + string_format((1 - global.ItemIndex[# ITEM.KevlarVest, ITEMSTATS.Defense]) * 100, 0, 1) + "% damage reduction, enhancing survivability against threats. Ideal for added protection without sacrificing mobility." } };
global.translates.Items[ITEM.Spas] = { Name: { cz: "SPAS-12", en: "Spas-12" }, Desc: { cz: "Brokovnice SPAS-12 je smrtící na krátkou vzdálenost, ale na dálku ztrácí účinnost. Nejlépe se hodí do stísněných prostor.", en: "A lethal close-quarters option, the SPAS-12 shotgun delivers swift takedowns up close but falters at longer distances. Ideal for tight encounters where its devastating power reigns supreme." } };
global.translates.Items[ITEM.MilitaryHelm] = { Name: { cz: "Vojenská helma", en: "Military helmet" }, Desc: { cz: "Vojenská helma snižuje poškození hlavy o " + string_format((1 - global.ItemIndex[# ITEM.MilitaryHelm, ITEMSTATS.Defense]) * 100, 0, 1) + " %. Nabízí lepší ochranu proti středně silným hrozbám při zachování dobré pohyblivosti.", en: "With a " + string_format((1 - global.ItemIndex[# ITEM.MilitaryHelm, ITEMSTATS.Defense]) * 100, 0, 1) + "% damage reduction, the Military Helmet offers enhanced head protection against moderate threats. A balanced choice for defense and comfort." } };
global.translates.Items[ITEM.MilitaryVest] = { Name: { cz: "Vojenská vesta", en: "Military vest" }, Desc: { cz: "Vojenská vesta snižuje poškození o " + string_format((1 - global.ItemIndex[# ITEM.MilitaryVest, ITEMSTATS.Defense]) * 100, 0, 1) + " %. Poskytuje solidní ochranu proti středně silným hrozbám a přitom příliš neomezuje pohyb.", en: "Enhanced with " + string_format((1 - global.ItemIndex[# ITEM.MilitaryVest, ITEMSTATS.Defense]) * 100, 0, 1) + "% damage reduction, this robust military vest provides significant protection against moderate threats, balancing defense with agility." } };
global.translates.Items[ITEM.SSG08] = { Name: { cz: "SSG 08", en: "SSG 08" }, Desc: { cz: "Přesná odstřelovací puška. Její nižší poškození vyžaduje pečlivé míření, ale zkušeného střelce odmění spolehlivými zásahy na dlouhou vzdálenost.", en: "SSG08 is a precision sniper rifle known for its deadly accuracy. While it offers unmatched precision, its lower damage requires skilled shooters to make each shot count, making it a challenging yet rewarding choice on the battlefield." } };
global.translates.Items[ITEM.HEGrenade] = { Name: { cz: "Tříštivý granát", en: "HE grenade" }, Desc: { cz: "Výbušný granát působí vysoké poškození v širokém okolí. Hodí se k likvidaci skupin nepřátel i k zajištění důležitých míst. Zacházej s ním opatrně.", en: "Designed for maximum impact, it delivers lethal damage over a broad radius, perfect for neutralizing enemy clusters or securing critical spaces. Handle with care; its potent blast is as swift as it is fierce." } };
global.translates.Items[ITEM.MAC11] = { Name: { cz: "MAC11", en: "MAC11" }, Desc: { cz: "Lehký samopal s vysokou kadencí a výbornou pohyblivostí na krátkou vzdálenost. Nízké poškození a slabší průraznost překážek vyžadují rychlý pohyb.", en: "MAC11 is offering exceptional mobility in close-quarters combat, altough it has limited damage output and armor penetration. Has lightweight design and rapid rate of fire but requires skilled maneuvering to maximize its effectiveness while minimizing its drawbacks." } };
global.translates.Items[ITEM.FlashBangGrenade] = { Name: { cz: "Oslepující granát", en: "Flashbang" }, Desc: { cz: "Neletální granát oslepí a ohluší nepřátele. Naruší jejich orientaci a usnadní překvapivý postup.", en: "Disorient foes with this non-lethal flashbang. Its blinding flash and deafening bang disrupt enemy senses, ideal for stealthy advances." } };
global.translates.Items[ITEM.SG550] = { Name: { cz: "SIG SG550", en: "SIG SG550" }, Desc: { cz: "SIG 550 má předem nasazený zaměřovač a nabízí dobrý dostřel i poškození. Silný zpětný ráz, nižší kadence a hmotnost však vyžadují přesnou střelbu.", en: "The SIG 550 comes equipped with a preattached scope, offering exceptional range and damage. However, its high recoil and slower rate of fire demand precision shooting, while its bulkier build limits movement speed. Ideal for those who excel in calculated, long-range engagements." } };
global.translates.Items[ITEM.SpecOpsHelm] = { Name: { cz: "Helma speciálních jednotek", en: "Spec ops helmet" }, Desc: { cz: "Helma speciálních jednotek snižuje poškození hlavy o " + string_format((1 - global.ItemIndex[# ITEM.SpecOpsHelm, ITEMSTATS.Defense]) * 100, 0, 1) + " %. Poskytuje silnou ochranu, ale její nižší výdrž a vyšší hmotnost vyžadují opatrnost.", en: "The Spec Ops Helmet, featuring a " + string_format((1 - global.ItemIndex[# ITEM.SpecOpsHelm, ITEMSTATS.Defense]) * 100, 0, 1) + "% damage reduction, is designed for intense combat situations but has lower durability. Its heavier construction focuses on maximal protection, demanding strategic use to compensate for its shorter lifespan." } };
global.translates.Items[ITEM.SpecOpsVest] = { Name: { cz: "Vesta speciálních jednotek", en: "Spec ops vest" }, Desc: { cz: "Vesta speciálních jednotek snižuje poškození o " + string_format((1 - global.ItemIndex[# ITEM.SpecOpsVest, ITEMSTATS.Defense]) * 100, 0, 1) + " %. Nabízí vysokou ochranu za cenu vyšší hmotnosti a nižší výdrž.", en: "Equipped with " + string_format((1 - global.ItemIndex[# ITEM.SpecOpsVest, ITEMSTATS.Defense]) * 100, 0, 1) + "% damage reduction, the Spec Ops Vest offers advanced protection but with lower durability. Ideal for high-risk scenarios, its heavier build prioritizes maximum defense, requiring careful management due to its limited lifespan." } };
global.translates.Items[ITEM.NightVision] = { Name: { cz: "Noční vidění", en: "Night vision" }, Desc: { cz: "Brýle pro noční vidění zlepšují viditelnost za špatného osvětlení.", en: "Night Vision Goggles improve visibility in low-light environments." } };
global.translates.Items[ITEM.HealingKit] = { Name: { cz: "Lékárnička", en: "Healing kit" }, Desc: { cz: "Lékárnička obnoví značnou část životů a pomůže přežít náročný střet.", en: "The Healing kit restores a substantial amount of health, providing crucial support during intense combat situations." } };
global.translates.Items[ITEM.InfraredVision] = { Name: { cz: "Infračervené vidění", en: "Infrared vision" }, Desc: { cz: "Infračervené brýle usnadňují odhalování nepřátel ve tmě a poskytují výhodu při nočních akcích.", en: "Gain a tactical advantage in darkness with Infrared Vision Goggles. Spot enemies easily in low-light conditions and stay ahead in nighttime missions." } };
global.translates.Items[ITEM.SmokeGrenade] = { Name: { cz: "Kouřový granát", en: "Smoke grenade" }, Desc: { cz: "Po dopadu vytvoří hustý kouř, který omezuje výhled, usnadňuje krytý postup a mate protivníky.", en: "Upon impact, smoke grenade blankets the surrounding area with dense smoke, perfect for obscuring vision, enabling stealthy movements, or disorienting opponents." } };
global.translates.Items[ITEM.Javelin] = { Name: { cz: "FGM-148", en: "FGM-148" }, Desc: { cz: "Silná zbraň s vysokým poškozením a průrazností překážek. Kvůli nepřesnosti a omezené zásobě munice vyžaduje pečlivé míření.", en: "High-damage, armor-piercing powerhouse. Mastery requires skill due to its inaccuracy and limited magazine but in the hands of a skilled player, each shot spells devastation for your enemies." } };
global.translates.Items[ITEM.HELandMine] = { Name: { cz: "Výbušná mina", en: "HE landmine" }, Desc: { cz: "Silná výbušná mina vhodná k přepadům a uzavření prostoru.", en: "The High-explosive landmine delivers devastating force, ideal for ambush tactics and area denial." } };
global.translates.Items[ITEM.CELandMine] = { Name: { cz: "Tříštivá mina", en: "CE landmine" }, Desc: { cz: "Po výbuchu rozptýlí střepiny do okolí a ohrozí nepřátele v blízkosti.", en: "The Cluster-explosion landmine disperses explosives projectiles upon detonation, creating deadly shrapnel to eliminate nearby threats." } };
global.translates.Items[ITEM.LELandMine] = { Name: { cz: "Průrazná mina", en: "LE landmine" }, Desc: { cz: "Působí menší poškození než výbušná mina, ale její střepiny lépe pronikají překážkami.", en: "The Low-explosive landmine, while inflicting less damage than High-explosive variant, features shrapnels with superior armor penetration." } };
global.translates.Items[ITEM.Glock] = { Name: { cz: "Glock-17", en: "Glock-17" }, Desc: { cz: "Glock-17 nabízí vyvážené poškození a velký zásobník. Slabší průraznost překážek však omezuje jeho účinnost proti obrněným cílům.", en: "The Glock-17 balances moderate damage with a generous magazine capacity, but its limited armor penetration capabilities make it less effective against heavily protected targets." } };
global.translates.Items[ITEM.StickyGrenade] = { Name: { cz: "Lepivý granát", en: "Sticky grenade" }, Desc: { cz: "Při dopadu přilne k cíli. Má střední výbušné poškození, ale dokáže protivníka znehybnit a připravit ho o možnost úniku.", en: "The sticky grenade has moderate damage but a unique ability to adhere to targets upon impact. While its explosive power maybe be less dangerous, its ability to immobilize adversaries offers strategic oppurtunities for skilled players to neutralize threats with precision." } };
global.translates.Items[ITEM.red_dot_scope] = { Name: { cz: "Kolimátor", en: "Red dot sight" }, Desc: { cz: "Kolimátor usnadňuje míření, ale neposkytuje přiblížení.", en: "The red dot sight offers improved aiming, but is lacking magnification." } };
global.translates.Items[ITEM.two_scope] = { Name: { cz: "Odstřelovací zaměřovač", en: "Sniper scope" }, Desc: { cz: "Poskytuje dvojnásobné přiblížení pro střelbu na delší vzdálenost.", en: "This item provides double magnification for a high-range engagements." } };
global.translates.Items[ITEM.adaptive_chambering] = { Name: { cz: "Adaptivní nabíjení", en: "Adaptive chambering" }, Desc: { cz: "Po nasazení zvyšuje kadenci zbraně a tím i její bojovou účinnost.", en: "This item enhances a weapons fire rate when attached, improving its overall combat efficiency." } };
global.translates.Items[ITEM.vertical_grip] = { Name: { cz: "Vertikální rukojeť", en: "Vertical grip" }, Desc: { cz: "Zlepšuje kontrolu vertikálního zpětného rázu.", en: "The vertical grip improves weapon vertical recoil control, ideal for players who prefer spraying over burst fire tactics." } };
global.translates.Items[ITEM.horizontal_grip] = { Name: { cz: "Horizontální rukojeť", en: "Horizontal grip" }, Desc: { cz: "Zlepšuje kontrolu horizontálního zpětného rázu při delších dávkách.", en: "The horizontal grip improves weapon horizontal recoil control, ideal for players who prefer spraying over burst fire tactics." } };
global.translates.Items[ITEM.suppressor] = { Name: { cz: "Vojenský tlumič", en: "Military suppressor" }, Desc: { cz: "Tlumič na ústí hlavně snižuje hluk při výstřelu.", en: "A muzzle device functions to dampen the noise generated upon firing a firearm, thus diminishing the sound level produced by the discharge." } };
global.translates.Items[ITEM.m4a1] = { Name: { cz: "M4A1", en: "M4A1" }, Desc: { cz: "M4A1 má předem nasazený tlumič a snadno zvládnutelný zpětný ráz. Za přesnost a nenápadnost platí nižší průrazností překážek.", en: "The M4A1 rifle is a great choice with a preattached silencer, offering reduced recoil for improved accuracy, altough at the cost of lower armor penetration. While it may struggle against heavily armored opponents, its stealthy profile and manageable recoil make it a favored option for precise engagements." } };
global.translates.Items[ITEM.awm] = { Name: { cz: "AWM", en: "AWM" }, Desc: { cz: "Výkonná odstřelovací puška s vysokým poškozením a malým poklesem účinnosti na dálku. Omezená pohyblivost vyžaduje dobré postavení a přesnou střelbu.", en: "Formidable long-range weapon, boasting unparalleled damage and minimal damage drop over distance, yet hampered by its poor mobility. Skilled marksmen wield it to devastating effect, delivering precise and lethal shots." } };
global.translates.Items[ITEM.usp] = { Name: { cz: "USP", en: "USP" }, Desc: { cz: "Přesná pistole s účinným prvním výstřelem a předem nasazeným tlumičem. Slabší průraznost překážek ji omezuje proti obrněným nepřátelům.", en: "Is a precision weapon, excelling in accuracy with its first shot and boasting considerable damage, yet its lackluster armor penetration. Enhanced with a preattached silencer, offering skilled players a tactical advantage despite its limitations against heavily protected foes." } };
global.translates.Items[ITEM.base_explosion] = { Name: { cz: "Výbuch", en: "Explosion" }, Desc: { cz: "", en: "" } };
global.translates.Items[ITEM.nuclear_explosion] = { Name: { cz: "Jaderný výbuch", en: "Nuclear explosion" }, Desc: { cz: "", en: "" } };
global.translates.Items[ITEM.basic_machine_gun] = { Name: { cz: "Kulomet", en: "Machine gun" }, Desc: { cz: "", en: "" } };
global.translates.Items[ITEM.galil] = { Name: { cz: "Galil", en: "Galil" }, Desc: { cz: "Silná puška s náročným zpětným rázem a omezenou průrazností překážek. Zkušený střelec z ní ale dokáže vytěžit ničivý účinek.", en: "Galil is a fierce contender known for its unruly recoil and limited armor penetration. Despite its challenges, mastering this weapon unlocks a devastating force on the battlefield, swiftly eliminating targets with precision and agility." } };
global.translates.Items[ITEM.p250] = { Name: { cz: "P250", en: "P250" }, Desc: { cz: "P250 nabízí přesný první výstřel za nízkou cenu. Vyžaduje zvládnutí zpětného rázu a má slabší průraznost překážek, ale při rychlém útoku dokáže překvapit.", en: "With sharp first-shot accuracy, the P250 is ideal for quick surprises on a budget. Despite its recoil, skilled hands can make it work. While it lacks armor penetration, its tactical edge remains in sudden encounters." } };
global.translates.Items[ITEM.MK18] = { Name: { cz: "MK18", en: "MK18" }, Desc: { cz: "Puška s vysokou kadencí a dobrou přesností na delší vzdálenost. Silnější zpětný ráz a slabší průraznost překážek vyžadují kontrolované dávky.", en: "MK18 is a potent rifle renowned for its rapid fire rate and exceptional accuracy over longer distances, though with a punchier recoil. While sacrificing some armor penetration, its swift RPM makes it ideal for precise engagements, striking a balance between speed and effectiveness on the battlefield." } };
global.translates.Items[ITEM.famas] = { Name: { cz: "FAMAS", en: "FAMAS" }, Desc: { cz: "Spolehlivá puška s nízkým zpětným rázem a vysokou přesností. Zásobník na 25 nábojů, slabší průraznost překážek a výrazný pokles poškození na dálku ji předurčují pro střety na krátkou až střední vzdálenost.", en: "FAMAS is a reliable weapon with low recoil and high accuracy. Despite its 25-round magazine, poor armor penetration, and high damage drop-off, mastering it unleashes devastating close to mid-range power, swiftly eliminating targets with precision." } };
global.translates.Items[ITEM.steel_knife] = { Name: { cz: "Ocelový nůž", en: "Steel knife" }, Desc: { cz: "Lehký a rychlý bojový nůž pro souboje zblízka. Spolehlivá záloha, když nelze použít střelnou zbraň.", en: "A reliable steel combat knife designed for close-quarters encounters. Lightweight and quick to use, it provides a dependable option when firearms are unavailable." } };
global.translates.Items[ITEM.tec9] = { Name: { cz: "TEC-9", en: "TEC-9" }, Desc: { cz: "Rychlá pistole vhodná pro střelbu za pohybu. Dobrá pohyblivost a nadprůměrná průraznost překážek odměňují agresivní styl hry.", en: "Fast and unforgiving, the TEC-9 thrives in constant motion. Its mobility and accuracy while moving make it a dangerous tool. With higher penetration than most pistols, it rewards bold plays and relentless pressure. The TEC-9 turns reckless rushes into calculated strikes." } };
global.translates.Items[ITEM.low_cal_box] = { Name: { cz: "Krabice munice nízké ráže", en: "Low caliber ammunition box" }, Desc: { cz: "Přidá 100 nábojů do právě držené zbraně, pokud používá odpovídající ráži.", en: "A box of low-caliber ammunition that adds 100 rounds to the currently held weapon, provided it uses a compatible caliber." } };
global.translates.Items[ITEM.med_cal_box] = { Name: { cz: "Krabice munice střední ráže", en: "Medium caliber ammunition box" }, Desc: { cz: "Přidá 75 nábojů do právě držené zbraně, pokud používá odpovídající ráži.", en: "A box of medium-caliber ammunition that adds 75 rounds to the currently held weapon, provided it uses a compatible caliber." } };
global.translates.Items[ITEM.high_cal_box] = { Name: { cz: "Krabice munice vysoké ráže", en: "High caliber ammunition box" }, Desc: { cz: "Přidá 25 nábojů do právě držené zbraně, pokud používá odpovídající ráži.", en: "A box of high-caliber ammunition that adds 25 rounds to the currently held weapon, provided it uses a compatible caliber." } };
global.translates.Items[ITEM.gauge_box] = { Name: { cz: "Krabice brokových nábojů", en: "Gauge ammunition box" }, Desc: { cz: "Přidá 50 nábojů do právě držené brokovnice, pokud používá odpovídající ráži.", en: "A box of shotgun ammunition that adds 50 shells to the currently held weapon, provided it uses a compatible gauge." } };
global.translates.Items[ITEM.range_finder] = { Name: { cz: "Ukazatel dostřelu", en: "Range indicator" }, Desc: { cz: "Nástavec na hlaveň, který podle polohy zaměřovače zobrazuje účinný dostřel zbraně a pomáhá odhadnout vzdálenost cíle.", en: "A barrel attachment designed to display a visual indication of a firearm’s effective range based on crosshair alignment, assisting the user in judging distance and projectile reach during combat." } };
global.translates.Items[ITEM.Dragunov] = { Name: { cz: "Dragunov", en: "Dragunov" }, Desc: { cz: "Poloautomatická odstřelovací puška s vysokým poškozením a dobrou průrazností překážek. Nižší pohyblivost a pokles poškození na dálku vyžadují přesnou, klidnou střelbu.", en: "Semi-automatic long-range rifle with high base damage and strong penetration, offset by limited mobility and noticeable damage drop over distance. Its ability to fire successive shots without breaking aim rewards steady, disciplined marksmanship." } };
global.translates.Items[ITEM.dilatation_pill] = { Name: { cz: "Pilulka zpomalení času", en: "Dilatation pill" }, Desc: { cz: "Speciální pilulka zpomalí čas na " + string(DILATATION_TIME / game_get_speed(gamespeed_fps)) + " sekundy a poskytne výhodu v náročném střetu.", en: "A specialized pill that triggers bullet time for " + string(DILATATION_TIME / game_get_speed(gamespeed_fps)) + " seconds, providing a critical advantage during intense combat situations." } };
global.translates.Items[ITEM.adrenaline] = { Name: { cz: "Adrenalin", en: "Adrenaline" }, Desc: { cz: "Injekční stříkačka s koncentrovaným adrenalinem zrychlí hráče na " + string(ADRENALINE_TIME / game_get_speed(gamespeed_fps)) + " sekundy.", en: "A syringe with concentrated adrenaline speeds up the player for " + string(ADRENALINE_TIME / game_get_speed(gamespeed_fps)) + " seconds." } };
global.translates.Items[ITEM.steroids] = { Name: { cz: "Steroidy", en: "Steroids" }, Desc: { cz: "Injekční stříkačka se steroidy zvýší poškození hráče na " + string(STEROID_TIME / game_get_speed(gamespeed_fps)) + " sekund.", en: "A syringe with steroids boosts player damage for " + string(STEROID_TIME / game_get_speed(gamespeed_fps)) + " seconds." } };
global.translates.Items[ITEM.MP9] = { Name: { cz: "MP9", en: "MP9" }, Desc: { cz: "Samopal s vysokou kadencí a dobrou průrazností překážek, vhodný pro rychlé přepady. Na dálku ztrácí poškození; delší tasení a silný vertikální zpětný ráz vyžadují dobrou kontrolu.", en: "MP9 has a high rate of fire and impressive armor penetration, making it perfect for rapid ambushes. While lethal at close range, it suffers from a lengthy equip time and significant damage drop-off. Its stout vertical recoil demands steady control to balance its high-velocity output against its handling drawbacks." } };
global.translates.Items[ITEM.CZ75] = { Name: { cz: "CZ-75", en: "CZ-75" }, Desc: { cz: "Plně automatická pistole s vysokou palebnou silou na krátkou vzdálenost. Malý zásobník nedává mnoho prostoru pro chyby.", en: "This fully automatic pistol delivers devastating close-range firepower, but its limited magazine capacity leaves little room for mistakes. A high-risk, high-reward choice for aggressive players." } };
global.translates.Items[ITEM.kevlar_shield] = { Name: { cz: "Kevlarový štít", en: "Kevlar shield" }, Desc: { cz: "Kevlarový štít blokuje " + string_format((1 - global.ItemIndex[# ITEM.kevlar_shield, ITEMSTATS.Defense]) * 100, 0, 1) + " % příchozího poškození zepředu. Je těžký, zpomaluje pohyb, brání použití zbraně a při delším nasazení se opotřebovává.", en: "This kevlar shield blocks " + string_format((1 - global.ItemIndex[# ITEM.kevlar_shield, ITEMSTATS.Defense]) * 100, 0, 1) + "% of incoming damage, offering superior frontal protection. Heavy weight reduces movement speed, prevents weapon use, and durability limits sustained defense." } };
global.translates.Items[ITEM.military_shield] = { Name: { cz: "Vojenský štít", en: "Military shield" }, Desc: { cz: "Vojenský štít blokuje " + string_format((1 - global.ItemIndex[# ITEM.military_shield, ITEMSTATS.Defense]) * 100, 0, 1) + " % příchozího poškození zepředu. Vyšší hmotnost omezuje pohyb a nižší výdrž zkracuje dobu, po kterou vydrží palbu.", en: "This military shield blocks " + string_format((1 - global.ItemIndex[# ITEM.military_shield, ITEMSTATS.Defense]) * 100, 0, 1) + "% of incoming damage, providing enhanced frontal protection against sustained fire. Increased weight further reduces mobility, while lower durability limits prolonged engagements." } };
global.translates.Items[ITEM.spec_ops_shield] = { Name: { cz: "Štít speciálních jednotek", en: "Spec ops shield" }, Desc: { cz: "Štít speciálních jednotek blokuje " + string_format((1 - global.ItemIndex[# ITEM.spec_ops_shield, ITEMSTATS.Defense]) * 100, 0, 1) + " % příchozího poškození zepředu. Poskytuje maximální ochranu, ale jeho extrémní hmotnost a nižší výdrž vyžadují opatrné použití.", en: "This Spec Ops shield blocks " + string_format((1 - global.ItemIndex[# ITEM.spec_ops_shield, ITEMSTATS.Defense]) * 100, 0, 1) + "% of incoming damage, delivering maximum frontal protection for high-risk operations. Extreme weight severely limits mobility, and reduced durability demands careful use." } };
global.translates.Items[ITEM.MP7] = { Name: { cz: "MP7", en: "MP7" }, Desc: { cz: "Samopal s vysokým poškozením a výbornou přesností na krátkou vzdálenost. Prudký pokles poškození na dálku vyžaduje agresivní přiblížení k cíli.", en: "MP7 combines high damage with outstanding accuracy, allowing it to dominate close-range firefights. However, its severe damage drop-off quickly reduces effectiveness at longer ranges, demanding aggressive positioning to unleash its full potential." } };
global.translates.Items[ITEM.P90] = { Name: { cz: "P90", en: "P90" }, Desc: { cz: "Samopal s obrovským zásobníkem, nízkým poklesem poškození a dobrou přesností za pohybu. Vyšší cena, nižší pohyblivost a rychlá ztráta přesnosti omezují jeho využití na dálku.", en: "P90 combines a massive magazine with low damage drop-off and reliable accuracy while moving, making it ideal for aggressive engagements. Its high price, reduced mobility, and rapidly declining accuracy limit its effectiveness at longer ranges." } };
global.translates.Items[ITEM.Scar] = { Name: { cz: "SCAR-L", en: "SCAR-L" }, Desc: { cz: "Puška s velkým zásobníkem, výbornou přesností a malým poklesem poškození na dálku. Má však omezenou rezervní munici, slabší průraznost, nižší pohyblivost a vyšší cenu.", en: "Built for fast and precise eliminations, the SCAR-L combines a large magazine with exceptional accuracy and low damage drop-off. Limited reserve ammunition, low penetration, reduced mobility, and a higher price balance its reliable performance." } };
global.translates.Items[ITEM.MolotovGrenade] = { Name: { cz: "Molotovův koktejl", en: "Molotov" }, Desc: { cz: "Zápalná láhev po dopadu praskne a rozšíří oheň po zemi. Hodí se k uzavření cesty, vyhnání nepřátel z krytu nebo potrestání těch, kdo zůstanou v plamenech.", en: "A simple incendiary bottle that bursts on impact and spreads fire across the ground. Useful for blocking paths, forcing enemies out of cover, or punishing anyone who stays inside the flames." } };
global.translates.Items[ITEM.Bomb] = { Name: { cz: "Bomba", en: "Bomb" }, Desc: { cz: "Bomba způsobí obrovské poškození na rozsáhlém území. Teroristé ji musí položit a ubránit, zatímco policisté se ji snaží včas zneškodnit.", en: "Designed for devastating objective attacks, this bomb delivers extreme damage and penetration power across a massive blast radius. Terrorists must plant and defend it, while opposing forces race to defuse it before detonation." } };
global.translates.Items[ITEM.DefuseKit] = { Name: { cz: "Sada na zneškodnění bomby", en: "Defuse kit" }, Desc: { cz: "Nezbytná pomůcka pro zneškodnění bomby. Zkracuje potřebný čas na polovinu.", en: "This item is essential for defusing the bomb. It halves the defusing time." } };
global.translates.Items[ITEM.gold_card] = { Name: { cz: "Zlatá karta", en: "Golden card" }, Desc: { cz: "Otevírá zlaté bezpečnostní dveře a umožňuje vstup do jinak nepřístupných oblastí.", en: "The Golden card grants access to golden security doors, allowing entry into otherwise restricted areas." } };
global.translates.Items[ITEM.magenta_card] = { Name: { cz: "Fialová karta", en: "Magenta card" }, Desc: { cz: "Otevírá fialové bezpečnostní dveře a umožňuje vstup do jinak nepřístupných oblastí.", en: "The Magenta card grants access to magenta security doors, allowing entry into otherwise restricted areas." } };
global.translates.Items[ITEM.red_card] = { Name: { cz: "Červená karta", en: "Red card" }, Desc: { cz: "Otevírá červené bezpečnostní dveře a umožňuje vstup do jinak nepřístupných oblastí.", en: "The Red card grants access to red security doors, allowing entry into otherwise restricted areas." } };
global.translates.Items[ITEM.aqua_card] = { Name: { cz: "Azurová karta", en: "Cyan card" }, Desc: { cz: "Otevírá azurové bezpečnostní dveře a umožňuje vstup do jinak nepřístupných oblastí.", en: "The Cyan card grants access to cyan security doors, allowing entry into otherwise restricted areas." } };
global.translates.Items[ITEM.green_card] = { Name: { cz: "Zelená karta", en: "Green card" }, Desc: { cz: "Otevírá zelené bezpečnostní dveře a umožňuje vstup do jinak nepřístupných oblastí.", en: "The Green card grants access to green security doors, allowing entry into otherwise restricted areas." } };
global.translates.Items[ITEM.black_card] = { Name: { cz: "Černá karta", en: "Black card" }, Desc: { cz: "Otevírá černé bezpečnostní dveře a umožňuje vstup do jinak nepřístupných oblastí.", en: "The Black card grants access to black security doors, allowing entry into otherwise restricted areas." } };
global.translates.Items[ITEM.white_card] = { Name: { cz: "Bílá karta", en: "White card" }, Desc: { cz: "Otevírá bílé bezpečnostní dveře a umožňuje vstup do jinak nepřístupných oblastí.", en: "The White card grants access to white security doors, allowing entry into otherwise restricted areas." } };
global.translates.Items[ITEM.m200] = { Name: { cz: "M200", en: "M200" }, Desc: { cz: "Odstřelovací puška schopná smrtícího zásahu na libovolnou vzdálenost. Extrémní zpětný ráz, špatná pohyblivost, zásobník na tři náboje a omezená zásoba munice nedovolují plýtvat střelami.", en: "An uncompromising long-range weapon capable of delivering a fatal hit at any distance. Extreme recoil and poor mobility demand careful handling, while its three-round magazine and scarce reserve ammunition make every shot count." } };
global.translates.Items[ITEM.bipod] = { Name: { cz: "Dvojnožka", en: "Bipod" }, Desc: { cz: "Výrazně zlepšuje ovládání zbraně při střelbě vleže.", en: "The bipod drastically improves weapon control when proning." } };
global.translates.Items[ITEM.g36c] = { Name: { cz: "G36C", en: "G36C" }, Desc: { cz: "Puška pro přesné zásahy na dlouhou vzdálenost. Vyniká přesností první rány, průrazností a malým poklesem poškození, ale její silný zpětný ráz a nižší pohyblivost vyžadují kontrolovanou střelbu.", en: "Built for precise long-range engagements, the G36C combines exceptional first-shot accuracy, high penetration power, and minimal damage drop-off. Heavy recoil makes sustained fire difficult, while demanding handling and reduced mobility reward controlled, well-placed shots." } };
global.translates.Items[ITEM.laser] = { Name: { cz: "Laser", en: "Laser" }, Desc: { cz: "Nástavec na hlaveň, který zlepšuje přesnost zbraně.", en: "A barrel attachment designed to reduce inaccuracy of a firearm." } };
global.translates.Items[ITEM.AKM].Advantages = { cz: "+Vysoké poškození\n+Dlouhý dostřel\n+Rychlé tasení", en: "+High damage\n+High range\n+Fast equipping" };
global.translates.Items[ITEM.AKM].Disadvantages = { cz: "-Velký rozptyl\n-Silný zpětný ráz", en: "-High bullet spread\n-High recoil" };
global.translates.Items[ITEM.g36c].Advantages = { cz: "+Dlouhý dostřel\n+Vysoká průraznost\n+Nízký pokles poškození", en: "+High range\n+High penetration power\n+Low damage drop-off" };
global.translates.Items[ITEM.g36c].Disadvantages = { cz: "-Velký rozptyl při spojité střelbě\n-Silný zpětný ráz\n-Dlouhé přebíjení", en: "-High kickback spread\n-High recoil\n-Long reloading" };
global.translates.Items[ITEM.Scar].Advantages = { cz: "+Velmi malý pokles přesnosti\n+Velmi malý pokles poškození\n+Velká zásoba munice", en: "+Very low accuracy drop\n+Very low damage drop-off\n+High ammo capacity" };
global.translates.Items[ITEM.Scar].Disadvantages = { cz: "-Nízká pohyblivost\n-Málo nábojů v zásobníku\n-Nízká průraznost", en: "-Bad mobility\n-Low clip ammo\n-Low penetration power" };
global.translates.Items[ITEM.DesertEagle].Advantages = { cz: "+Vysoké poškození\n+Dlouhý dostřel\n+Vysoká průraznost", en: "+High damage\n+High range\n+High penetration power" };
global.translates.Items[ITEM.DesertEagle].Disadvantages = { cz: "-Silný zpětný ráz\n-Malý zásobník", en: "-High recoil\n-Low magazine capacity" };
global.translates.Items[ITEM.Spas].Advantages = { cz: "+Výborná pohyblivost\n+Vysoké poškození", en: "+Great mobility\n+High damage" };
global.translates.Items[ITEM.Spas].Disadvantages = { cz: "-Nízká průraznost\n-Krátký dostřel", en: "-Low penetration power\n-Low range" };
global.translates.Items[ITEM.SSG08].Advantages = { cz: "\n+Vysoké poškození\n+Dlouhý dostřel", en: "\n+High damage\n+High range" };
global.translates.Items[ITEM.SSG08].Disadvantages = { cz: "-Nízká průraznost\n-Omezený výhled", en: "-Low penetration power\n-Limited view" };
global.translates.Items[ITEM.MAC11].Advantages = { cz: "+Výborná pohyblivost\n+Rychlé tasení", en: "+Great mobility\n+Fast equipping" };
global.translates.Items[ITEM.MAC11].Disadvantages = { cz: "-Nízká průraznost\n-Velký rozptyl\n-Krátký dostřel", en: "-Low penetration power\n-High bullet spread\n-Low range" };
global.translates.Items[ITEM.MP9].Advantages = { cz: "+Výborná průraznost\n+Dobrý dostřel na samopal\n+Vysoká kadence", en: "+Great penetration power\n+Great range for SMG\n+Great rate of fire" };
global.translates.Items[ITEM.MP9].Disadvantages = { cz: "-Pomalé tasení\n-Silný zpětný ráz\n-Velký pokles poškození", en: "-Slow equip\n-High recoil\n-High damage drop-off" };
global.translates.Items[ITEM.MP7].Advantages = { cz: "+Vysoké poškození\n+Výborná přesnost", en: "+High damage\n+Great accuracy" };
global.translates.Items[ITEM.MP7].Disadvantages = { cz: "-Nízká průraznost\n-Velká nepřesnost při zpětném rázu\n-Velký pokles poškození na dálku", en: "-Low penetration power\n-High kickback inaccuracy\n-High damage drop-off" };
global.translates.Items[ITEM.P90].Advantages = { cz: "+Velký zásobník\n+Vysoká průraznost", en: "+High ammo capacity\n+High penetration power" };
global.translates.Items[ITEM.P90].Disadvantages = { cz: "-Silný horizontální zpětný ráz\n-Nízká přesnost na dálku\n-Slabší pohyblivost na samopal", en: "-High horizontal recoil\n-High range inaccuracy\n-Bad mobility for SMG" };
global.translates.Items[ITEM.SG550].Advantages = { cz: "+Dlouhý dostřel\n+Vysoké poškození\n+Vysoká průraznost", en: "+High range\n+High damage\n+High penetration power" };
global.translates.Items[ITEM.SG550].Disadvantages = { cz: "-Nižší kadence\n-Silný zpětný ráz\n-Střední pohyblivost\n-Velký rozptyl", en: "-Lower rate of fire\n-High recoil\n-Moderate mobility\n-High bullet spread" };
global.translates.Items[ITEM.Javelin].Advantages = { cz: "+Naváděné střely\n+Vysoké poškození", en: "+Homing projectiles\n+High damage" };
global.translates.Items[ITEM.Javelin].Disadvantages = { cz: "-Velmi nízká pohyblivost\n-Nebezpečný výbuch\n-Jedna raketa na výstřel", en: "-Very bad mobility\n-Dangerous explosion\n-Only one rocket per shot" };
global.translates.Items[ITEM.Glock].Advantages = { cz: "+Výborná pohyblivost\n+Velký zásobník", en: "-Great mobility\n-High magazine capacity" };
global.translates.Items[ITEM.Glock].Disadvantages = { cz: "-Nízké poškození\n-Nízká průraznost", en: "-Low damage\n-Low penetration power" };
global.translates.Items[ITEM.MK18].Advantages = { cz: "+Dobrá pohyblivost\n+Malý rozptyl střel", en: "+Good mobility\n+Low bullet spread" };
global.translates.Items[ITEM.MK18].Disadvantages = { cz: "-Nízká průraznost\n-Silný zpětný ráz", en: "-Low penetration power\n-High recoil" };
global.translates.Items[ITEM.m4a1].Advantages = { cz: "+Dobrá pohyblivost\n+Malý rozptyl střel\n+Slabý zpětný ráz", en: "+Good mobility\n+Low bullet spread\n+Low recoil" };
global.translates.Items[ITEM.m4a1].Disadvantages = { cz: "-Nízká průraznost\n-Dlouhé přebíjení", en: "-Low penetration power\n-Long reloading" };
global.translates.Items[ITEM.m200].Advantages = { cz: "\n+Velmi vysoké poškození\n+Dlouhý dostřel\n+Zanedbatelný pokles poškození\n+Zanedbatelný pokles přesnosti", en: "\n+Very high damage\n+High range\n+Neglidible damage drop-off\n+Neglidible accuracy drop" };
global.translates.Items[ITEM.m200].Disadvantages = { cz: "-Nízká pohyblivost\n-Omezený výhled\n-Malý zásobník", en: "-Ultra bad mobility\n-Limited view\n-Low ammo capacity" };
global.translates.Items[ITEM.awm].Advantages = { cz: "\n+Vysoké poškození\n+Dlouhý dostřel\n+Zanedbatelný pokles poškození", en: "\n+High damage\n+High range\n+Neglidible damage drop" };
global.translates.Items[ITEM.awm].Disadvantages = { cz: "-Nízká pohyblivost\n-Omezený výhled\n-Dlouhé přebíjení\n-Pomalé tasení", en: "-Very bad mobility\n-Limited view\n-Long reloading\n-Slow equip" };
global.translates.Items[ITEM.Dragunov].Advantages = { cz: "\n+Poloautomatická střelba\n+Dlouhý dostřel", en: "\n+Semi-automatic\n+High range" };
global.translates.Items[ITEM.Dragunov].Disadvantages = { cz: "-Velmi nízká pohyblivost\n-Omezený výhled\n-Dlouhé přebíjení\n-Velký pokles poškození", en: "-Very bad mobility\n-Limited view\n-Long reloading\n-High damage drop" };
global.translates.Items[ITEM.usp].Advantages = { cz: "+Výborná pohyblivost\n+Velký zásobník", en: "+Great mobility\n+High magazine capacity" };
global.translates.Items[ITEM.usp].Disadvantages = { cz: "-Nízká průraznost", en: "-Low penetration power" };
global.translates.Items[ITEM.p250].Advantages = { cz: "+Výborná pohyblivost\n+Přesný první výstřel", en: "+Great mobility\n+First shot accuracy" };
global.translates.Items[ITEM.p250].Disadvantages = { cz: "-Nízká průraznost", en: "-Low penetration power" };
global.translates.Items[ITEM.tec9].Advantages = { cz: "+Výborná pohyblivost\n+Skvělá průraznost", en: "+Great mobility\n+Good penetration power" };
global.translates.Items[ITEM.tec9].Disadvantages = { cz: "-Nízké poškození\n-Pomalé tasení", en: "-Low damage\n-Slow equip" };
global.translates.Items[ITEM.CZ75].Advantages = { cz: "+Automatická pistole\n+Nízký zpětný ráz\n+Vysoká odměna za zabití", en: "+Automatic pistol\n+Accurate recoil\n+High kill reward" };
global.translates.Items[ITEM.CZ75].Disadvantages = { cz: "-Nízké poškození\n-Pomalé tasení\n-Horší přesnost na dálku", en: "-Low damage\n-Slow equip\n-Worse range accuracy" };
global.translates.Items[ITEM.famas].Advantages = { cz: "+Malý rozptyl střel\n+Nízký vertikální zpětný ráz", en: "+Low bullet spread\n+Low vertical recoil" };
global.translates.Items[ITEM.famas].Disadvantages = { cz: "-Malý zásobník\n-Nízká průraznost\n-Velký pokles poškození", en: "-Low magazine capacity\n-Low penetration power\n-High damage drop-off" };
global.translates.Items[ITEM.galil].Advantages = { cz: "+Rychlé tasení\n+Rychlé přebíjení\n+Nízká cena", en: "+Fast equipping\n+Fast reloading\n+Low price" };
global.translates.Items[ITEM.galil].Disadvantages = { cz: "-Velký rozptyl\n-Vysoký horizontální zpětný ráz\n-Nízká průraznost", en: "-High bullet spread\n-High horizontal recoil\n-Low penetration power" };
global.translates.Items[ITEM.steel_knife].Advantages = { cz: "", en: "" };
global.translates.Items[ITEM.steel_knife].Disadvantages = { cz: "", en: "" };
load_game();
display_set_gui_size(1920, 1080);
ui_scale_set_window_size(global.window_width, global.window_height);
global.GuiW = display_get_gui_width();
global.GuiH = display_get_gui_height();
console_settings(global.my_console," ",false);
console_preset(global.my_console);
audio_master_gain(global.sound_gain/100);
window_resize();
room_goto_next();
