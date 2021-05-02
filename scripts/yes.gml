#define scr_missile_create
text1 = get_text("Items", "MissileTank");
text2 = get_text("Items", "MissileTank_Text");
if (global.difficulty == 2) text2 = get_text("Items", "MissileTank_TextHard");


#define scr_supermissile_create
text1 = get_text("Items", "SuperMissileTank");
text2 = get_text("Items", "SuperMissileTank_Text");
if (global.opmslstyle == 1) { btn1_name = "Missile"; }
if (global.opmslstyle == 0) { btn1_name = "Select"; }

#define scr_energytank_create
text1 = get_text("Items", "EnergyTank");
text2 = get_text("Items", "EnergyTank_Text");
btn1_name = "";

if (string_count("|", text2) > 0) {
    p_text1 = string_split(text2, 0, "|");
    p_text2 = string_split(text2, 1, "|");
    
    text2 = p_text1 + string(100*oControl.mod_etankhealthmult) + p_text2;
}

#define scr_powerbomb_create
text1 = get_text("Items", "PowerBombTank");
text2 = get_text("Items", "PowerBombTank_Text");
if (global.opmslstyle == 1) { btn1_name = "Missile"; }
if (global.opmslstyle == 0) { btn1_name = "Select"; }

#define scr_item_create_text
switch (sprite_index)
{
    case sItemMissile:
        scr_missile_create();
        break;
    case sItemSuperMissile:
        scr_supermissile_create();
        break;
    case sItemEnergyTank:
        scr_energytank_create();
        break;
    case sItemPowerBomb:
        scr_powerbomb_create();
        break;    
}

#define scr_item_character_event
switch (sprite_index)
{
    case sItemMissile:
    scr_missile_character_event();
    break;
    case sItemSuperMissile:
    scr_supermissile_character_event();
    break;
    case sItemEnergyTank:
    scr_energytank_character_event();
    break;
    case sItemPowerBomb:
    scr_powerbomb_character_event();
    break;    
}

#define scr_missile_character_event
if (active) {
    if (global.maxmissiles == oControl.mod_Mstartingcount) {
        event_inherited();
    } else {
        itemtype = 1;
        popup_text(get_text("Notifications", "MissileTank"));
        event_inherited();
    }
    if (global.difficulty < 2) global.maxmissiles += 5;
    if (global.difficulty == 2) global.maxmissiles += 2;
    global.missiles = global.maxmissiles;
    global.mtanks += 1;
}

#define scr_supermissile_character_event
if (active) {
    if (global.maxsmissiles == 0) {
        event_inherited();
    } else {
        itemtype = 1;
        popup_text(get_text("Notifications", "SuperMissileTank"));
        event_inherited();
    }
    if (global.difficulty < 2) global.maxsmissiles += 2;
    if (global.difficulty == 2) global.maxsmissiles += 1;
    global.smissiles = global.maxsmissiles;
    global.stanks += 1;
}

#define scr_energytank_character_event
if (active) {
    if (global.maxhealth < 100) {
        event_inherited();
    } else {
        itemtype = 1;
        popup_text(get_text("Notifications", "EnergyTank"));
        event_inherited();
    }
    global.maxhealth += (100 * oControl.mod_etankhealthmult);
    global.playerhealth = global.maxhealth;
    global.etanks += 1;
}

#define scr_powerbomb_character_event
if (active) {
    if (global.maxpbombs == 0) {
        event_inherited();
    } else {
        itemtype = 1;
        popup_text(get_text("Notifications", "PowerBombTank"));
        event_inherited();
    }
    if (global.difficulty < 2) global.maxpbombs += 2;
    if (global.difficulty == 2) global.maxpbombs += 1;
    global.pbombs = global.maxpbombs;
    global.ptanks += 1;
}

#define src_items_rando
switch (argument0) //needs changed to valid variable
{
    //Missiles
    case 52:
    case 53:
    case 54:
    case 55:
    case 56:
    case 57:
    case 60:
    case 100:
    case 101:
    case 102:
    case 104:
    case 105:
    case 106:
    case 107:
    case 109:
    case 111:
    case 150:
    case 151:
    case 152:
    case 153:
    case 154:
    case 155:
    case 156:
    case 159:
    case 161:
    case 163:
    case 202:
    case 203:
    case 204:
    case 205:
    case 208:
    case 210:
    case 211:
    case 214:
    case 250:
    case 252:
    case 255:
    case 257:
    case 259:
    case 303:
    case 304:
    case 307:
    case 308:
    case 309:
    sprite_index = sItemMissile;
    break;
    //Super Missiles
    case 51:
    case 110:
    case 162:
    case 206:
    case 207:
    case 209:
    case 215:
    case 256:
    case 300:
    case 305:
    sprite_index = sItemSuperMissile;
    break;
    //Energy Tanks
    case 50:
    case 103:
    case 108:
    case 157:
    case 158:
    case 200:
    case 201:
    case 251:
    case 254:
    case 306:
    sprite_index = sItemEnergyTank;
    break;
    //Powerbombs
    case 58:
    case 59:
    case 112:
    case 160:
    case 212:
    case 213:
    case 253:
    case 258:
    case 301:
    case 302:
    sprite_index = sItemPowerBomb;
    break;
}

