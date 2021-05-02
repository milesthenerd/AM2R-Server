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

#define draw_gui2
/// draw_gui()
/*if (global.classicmode == 0 && global.opshowhud) {
xoff = 33;
if (global.etanks == 0) draw_background(bgGUIHealth, 0, 0);
if (global.etanks == 1 || global.etanks == 2) {
draw_background(bgGUIHealth1, 0, 0);
xoff = 42;
}
if (global.etanks == 3 || global.etanks == 4) {
draw_background(bgGUIHealth2, 0, 0);
xoff = 48;
}
if (global.etanks == 5 || global.etanks == 6) {
draw_background(bgGUIHealth3, 0, 0);
xoff = 54;
}
if (global.etanks == 7 || global.etanks == 8) {
draw_background(bgGUIHealth4, 0, 0);
xoff = 60;
}
if (global.etanks == 9 || global.etanks == 10) {
draw_background(bgGUIHealth5, 0, 0);
xoff = 66;
}
if (global.etanks == 11 || global.etanks == 12) {
draw_background(bgGUIHealth6, 0, 0);
xoff = 75;
}
if (global.etanks == 13 || global.etanks == 14) {
draw_background(bgGUIHealth7, 0, 0);
xoff = 81;
}
if (global.etanks == 15 || global.etanks == 16) {
draw_background(bgGUIHealth8, 0, 0);
xoff = 87;
}
if (global.etanks == 17 || global.etanks == 18) {
draw_background(bgGUIHealth9, 0, 0);
xoff = 93;
}
if (global.etanks == 19 || global.etanks == 20) {
draw_background(bgGUIHealth10, 0, 0);
xoff = 99;
}
if (global.etanks == 21 || global.etanks == 22) {
draw_background(bgGUIHealth11, 0, 0);
xoff = 108;
}
if (global.etanks == 23 || global.etanks == 24) {
draw_background(bgGUIHealth12, 0, 0);
xoff = 114;
}
if (global.etanks == 25 || global.etanks == 26) {
draw_background(bgGUIHealth13, 0, 0);
xoff = 120;
}
if (global.etanks == 27 || global.etanks == 28) {
draw_background(bgGUIHealth14, 0, 0);
xoff = 126;
}
if (global.etanks == 29 || global.etanks >= 30) {
draw_background(bgGUIHealth15, 0, 0);
xoff = 132;
}
draw_set_font(guifont1);
draw_set_alpha(1);
draw_set_color(c_white);
draw_text(4, 4, gui_health());
if (hudflash) {
draw_set_font(guifont1a);
draw_text_color(4, 4, gui_health(), c_white, c_white, c_white, c_white, hudflashfx / 4);
}
etankxoff = 32;
if (global.etanks >= 1) {
if (global.playerhealth > 99) draw_sprite(sGUIETank, 1, 0 + etankxoff, 4);
if (global.playerhealth <= 99) draw_sprite(sGUIETank, 0, 0 + etankxoff, 4);
}
if (global.etanks >= 2) {
if (global.playerhealth > 199) draw_sprite(sGUIETank, 1, 0 + etankxoff, 10);
if (global.playerhealth <= 199) draw_sprite(sGUIETank, 0, 0 + etankxoff, 10);
}
if (global.etanks >= 3) {
if (global.playerhealth > 299) draw_sprite(sGUIETank, 1, 0 + etankxoff + 6, 4);
if (global.playerhealth <= 299) draw_sprite(sGUIETank, 0, 0 + etankxoff + 6, 4);
}
if (global.etanks >= 4) {
if (global.playerhealth > 399) draw_sprite(sGUIETank, 1, 0 + etankxoff + 6, 10);
if (global.playerhealth <= 399) draw_sprite(sGUIETank, 0, 0 + etankxoff + 6, 10);
}
if (global.etanks >= 5) {
if (global.playerhealth > 499) draw_sprite(sGUIETank, 1, 0 + etankxoff + 12, 4);
if (global.playerhealth <= 499) draw_sprite(sGUIETank, 0, 0 + etankxoff + 12, 4);
}
if (global.etanks >= 6) {
if (global.playerhealth > 599) draw_sprite(sGUIETank, 1, 0 + etankxoff + 12, 10);
if (global.playerhealth <= 599) draw_sprite(sGUIETank, 0, 0 + etankxoff + 12, 10);
}
/*
if (global.etanks >= 7) {
if (global.playerhealth > 699) draw_sprite(sGUIETank, 1, 0 + etankxoff + 18, 4);
if (global.playerhealth <= 699) draw_sprite(sGUIETank, 0, 0 + etankxoff + 18, 4);
}
*/

/*if (global.etanks >= 7) {
if (global.playerhealth > 99 + (6 * (100 * oControl.mod_etankhealthmult))) draw_sprite(sGUIETank, 1, 0 + etankxoff + 18, 4);
if (global.playerhealth <= 99 + (6 * (100 * oControl.mod_etankhealthmult))) draw_sprite(sGUIETank, 0, 0 + etankxoff + 18, 4);
}

if (global.etanks >= 8) {
if (global.playerhealth > 799) draw_sprite(sGUIETank, 1, 0 + etankxoff + 18, 10);
if (global.playerhealth <= 799) draw_sprite(sGUIETank, 0, 0 + etankxoff + 18, 10);
}
if (global.etanks >= 9) {
if (global.playerhealth > 899) draw_sprite(sGUIETank, 1, 0 + etankxoff + 24, 4);
if (global.playerhealth <= 899) draw_sprite(sGUIETank, 0, 0 + etankxoff + 24, 4);
}
if (global.etanks >= 10) {
if (global.playerhealth > 999) draw_sprite(sGUIETank, 1, 0 + etankxoff + 24, 10);
if (global.playerhealth <= 999) draw_sprite(sGUIETank, 0, 0 + etankxoff + 24, 10);
}
if (global.etanks >= 11) {
if (global.playerhealth > 1099) draw_sprite(sGUIETank, 1, 0 + etankxoff + 33, 4);
if (global.playerhealth <= 1099) draw_sprite(sGUIETank, 0, 0 + etankxoff + 33, 4);
}
if (global.etanks >= 12) {
if (global.playerhealth > 1199) draw_sprite(sGUIETank, 1, 0 + etankxoff + 33, 10);
if (global.playerhealth <= 1199) draw_sprite(sGUIETank, 0, 0 + etankxoff + 33, 10);
}
if (global.etanks >= 13) {
if (global.playerhealth > 1299) draw_sprite(sGUIETank, 1, 0 + etankxoff + 39, 4);
if (global.playerhealth <= 1299) draw_sprite(sGUIETank, 0, 0 + etankxoff + 39, 4);
}
if (global.etanks >= 14) {
if (global.playerhealth > 1399) draw_sprite(sGUIETank, 1, 0 + etankxoff + 39, 10);
if (global.playerhealth <= 1399) draw_sprite(sGUIETank, 0, 0 + etankxoff + 39, 10);
}
if (global.etanks >= 15) {
if (global.playerhealth > 1499) draw_sprite(sGUIETank, 1, 0 + etankxoff + 45, 4);
if (global.playerhealth <= 1499) draw_sprite(sGUIETank, 0, 0 + etankxoff + 45, 4);
}
if (global.etanks >= 16) {
if (global.playerhealth > 1599) draw_sprite(sGUIETank, 1, 0 + etankxoff + 45, 10);
if (global.playerhealth <= 1599) draw_sprite(sGUIETank, 0, 0 + etankxoff + 45, 10);
}
if (global.etanks >= 17) {
if (global.playerhealth > 1699) draw_sprite(sGUIETank, 1, 0 + etankxoff + 51, 4);
if (global.playerhealth <= 1699) draw_sprite(sGUIETank, 0, 0 + etankxoff + 51, 4);
}
if (global.etanks >= 18) {
if (global.playerhealth > 1799) draw_sprite(sGUIETank, 1, 0 + etankxoff + 51, 10);
if (global.playerhealth <= 1799) draw_sprite(sGUIETank, 0, 0 + etankxoff + 51, 10);
}
if (global.etanks >= 19) {
if (global.playerhealth > 1899) draw_sprite(sGUIETank, 1, 0 + etankxoff + 57, 4);
if (global.playerhealth <= 1899) draw_sprite(sGUIETank, 0, 0 + etankxoff + 57, 4);
}
if (global.etanks >= 20) {
if (global.playerhealth > 1999) draw_sprite(sGUIETank, 1, 0 + etankxoff + 57, 10);
if (global.playerhealth <= 1999) draw_sprite(sGUIETank, 0, 0 + etankxoff + 57, 10);
}
if (global.etanks >= 21) {
if (global.playerhealth > 2099) draw_sprite(sGUIETank, 1, 0 + etankxoff + 66, 4);
if (global.playerhealth <= 2099) draw_sprite(sGUIETank, 0, 0 + etankxoff + 66, 4);
}
if (global.etanks >= 22) {
if (global.playerhealth > 2199) draw_sprite(sGUIETank, 1, 0 + etankxoff + 66, 10);
if (global.playerhealth <= 2199) draw_sprite(sGUIETank, 0, 0 + etankxoff + 66, 10);
}
if (global.etanks >= 23) {
if (global.playerhealth > 2299) draw_sprite(sGUIETank, 1, 0 + etankxoff + 72, 4);
if (global.playerhealth <= 2299) draw_sprite(sGUIETank, 0, 0 + etankxoff + 72, 4);
}
if (global.etanks >= 24) {
if (global.playerhealth > 2399) draw_sprite(sGUIETank, 1, 0 + etankxoff + 72, 10);
if (global.playerhealth <= 2399) draw_sprite(sGUIETank, 0, 0 + etankxoff + 72, 10);
}
if (global.etanks >= 25) {
if (global.playerhealth > 2499) draw_sprite(sGUIETank, 1, 0 + etankxoff + 78, 4);
if (global.playerhealth <= 2499) draw_sprite(sGUIETank, 0, 0 + etankxoff + 78, 4);
}
if (global.etanks >= 26) {
if (global.playerhealth > 2599) draw_sprite(sGUIETank, 1, 0 + etankxoff + 78, 10);
if (global.playerhealth <= 2599) draw_sprite(sGUIETank, 0, 0 + etankxoff + 78, 10);
}
if (global.etanks >= 27) {
if (global.playerhealth > 2699) draw_sprite(sGUIETank, 1, 0 + etankxoff + 84, 4);
if (global.playerhealth <= 2699) draw_sprite(sGUIETank, 0, 0 + etankxoff + 84, 4);
}
if (global.etanks >= 28) {
if (global.playerhealth > 2799) draw_sprite(sGUIETank, 1, 0 + etankxoff + 84, 10);
if (global.playerhealth <= 2799) draw_sprite(sGUIETank, 0, 0 + etankxoff + 84, 10);
}
if (global.etanks >= 29) {
if (global.playerhealth > 2899) draw_sprite(sGUIETank, 1, 0 + etankxoff + 90, 4);
if (global.playerhealth <= 2899) draw_sprite(sGUIETank, 0, 0 + etankxoff + 90, 4);
}
if (global.etanks >= 30) {
if (global.playerhealth > 2999) draw_sprite(sGUIETank, 1, 0 + etankxoff + 90, 10);
if (global.playerhealth <= 2999) draw_sprite(sGUIETank, 0, 0 + etankxoff + 90, 10);
}
draw_set_font(global.guifont2);
if (global.maxmissiles > 0) {
if (global.maxmissiles >= 100) {
draw_background(bgGUIMsl, xoff, 0);
} else draw_background(bgGUISmsl, xoff, 0);
draw_text(0 + xoff + 19, 7, string(global.missiles));
if (global.opmslstyle == 0) {
if (global.currentweapon != 1 || oCharacter.state == 23 || oCharacter.state == 24 || oCharacter.state == 27 || oCharacter.state == 54 || oCharacter.state == 55 || oCharacter.sjball) draw_sprite(sGUIMissile, 0, 0 + xoff + 1, 4);
if (global.currentweapon == 1 && oCharacter.state != 23 && oCharacter.state != 24 && oCharacter.state != 27 && oCharacter.state != 54 && oCharacter.state != 55 && oCharacter.sjball == 0) {
if (oCharacter.armmsl == 0) draw_sprite(sGUIMissile, 1, 0 + xoff + 1, 4);
if (oCharacter.armmsl == 1) draw_sprite(sGUIMissile, 2, 0 + xoff + 1, 4);
}
}
if (global.opmslstyle == 1) {
if (global.currentweapon == 1) {
draw_sprite(sGUIMissile, 1, 0 + xoff + 1, 4);
} else draw_sprite(sGUIMissile, 0, 0 + xoff + 1, 4);
}
if (global.maxmissiles >= 100) {
xoff += 45;
} else xoff += 38;
}
if (global.maxsmissiles > 0) {
draw_background(bgGUISmsl, xoff, 0);
draw_text(xoff + 19, 7, string(global.smissiles));
if (global.opmslstyle == 0) {
if (global.currentweapon != 2 || oCharacter.state == 23 || oCharacter.state == 24 || oCharacter.state == 27 || oCharacter.state == 54 || oCharacter.state == 55 || oCharacter.sjball) draw_sprite(sGUISMissile, 0, xoff + 1, 4);
if (global.currentweapon == 2 && oCharacter.state != 23 && oCharacter.state != 24 && oCharacter.state != 27 && oCharacter.state != 54 && oCharacter.state != 55 && oCharacter.sjball == 0) {
if (oCharacter.armmsl == 0) draw_sprite(sGUISMissile, 1, xoff + 1, 4);
if (oCharacter.armmsl == 1) draw_sprite(sGUISMissile, 2, xoff + 1, 4);
}
}
if (global.opmslstyle == 1) {
if (global.currentweapon == 2) {
draw_sprite(sGUISMissile, 1, xoff + 1, 4);
} else draw_sprite(sGUISMissile, 0, xoff + 1, 4);
}
xoff += 38;
}
if (global.maxpbombs > 0) {
draw_background(bgGUISmsl, xoff, 0);
draw_text(xoff + 19, 7, string(global.pbombs));
if (global.opmslstyle == 0) {
if (oCharacter.state != 23 && oCharacter.state != 24 && oCharacter.state != 27 && oCharacter.state != 54 && oCharacter.state != 55 && oCharacter.sjball == 0) draw_sprite(sGUIPBomb, 0, xoff + 1, 4);
if (oCharacter.state == 23 || oCharacter.state == 24 || oCharacter.state == 27 || oCharacter.state == 54 || oCharacter.state == 55 || oCharacter.sjball) {
if (oCharacter.armmsl == 0) draw_sprite(sGUIPBomb, 1, xoff + 1, 4);
if (oCharacter.armmsl == 1) draw_sprite(sGUIPBomb, 2, xoff + 1, 4);
}
}
if (global.opmslstyle == 1) {
if (global.currentweapon == 3) {
draw_sprite(sGUIPBomb, 1, xoff + 1, 4);
} else draw_sprite(sGUIPBomb, 0, xoff + 1, 4);
}
}
if (global.ophudshowmap && global.ophudshowmetrcount) {
draw_background(bgGUIMap, 250, 0);
xoff = 250;
}
if (global.ophudshowmap && global.ophudshowmetrcount == 0) draw_background(bgGUIMapOnly, 272, 0);
if (global.ophudshowmap == 0 && global.ophudshowmetrcount) {
draw_background(bgGUIMetOnly, 296, 0);
xoff = 296;
}
if (global.ophudshowmetrcount) {
if (global.ophudshowmetrcount == 1) {
draw_background(bgGUIMetCountBG1, xoff + 4, 4);
draw_text(xoff + 6, 21, to_string_lz(global.monstersarea));
}
if (global.ophudshowmetrcount == 2) {
draw_background(bgGUIMetCountBG2, xoff + 4, 4);
draw_text(xoff + 6, 21, to_string_lz(global.monstersleft));
}
}
if (global.ophudshowmap) draw_gui_map(276, 0);
} // if (global.classicmode == 0 && global.opshowhud)


/* ORIGINAL
/// draw_gui()
if (global.classicmode == 0 && global.opshowhud) {
    xoff = 33;
    if (global.etanks == 0) draw_background(bgGUIHealth, 0, 0);
    if (global.etanks == 1 || global.etanks == 2) {
        draw_background(bgGUIHealth1, 0, 0);
        xoff = 42;
    }
    if (global.etanks == 3 || global.etanks == 4) {
        draw_background(bgGUIHealth2, 0, 0);
        xoff = 48;
    }
    if (global.etanks == 5 || global.etanks == 6) {
        draw_background(bgGUIHealth3, 0, 0);
        xoff = 54;
    }
    if (global.etanks == 7 || global.etanks == 8) {
        draw_background(bgGUIHealth4, 0, 0);
        xoff = 60;
    }
    if (global.etanks == 9 || global.etanks == 10) {
        draw_background(bgGUIHealth5, 0, 0);
        xoff = 66;
    }
    draw_set_font(guifont1);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text(4, 4, gui_health());
    if (hudflash) {
        draw_set_font(guifont1a);
        draw_text_color(4, 4, gui_health(), c_white, c_white, c_white, c_white, hudflashfx / 4);
    }
    etankxoff = 32;
    if (global.etanks >= 1) {
        if (global.playerhealth > 99) draw_sprite(sGUIETank, 1, 0 + etankxoff, 4);
        if (global.playerhealth <= 99) draw_sprite(sGUIETank, 0, 0 + etankxoff, 4);
    }
    if (global.etanks >= 2) {
        if (global.playerhealth > 199) draw_sprite(sGUIETank, 1, 0 + etankxoff, 10);
        if (global.playerhealth <= 199) draw_sprite(sGUIETank, 0, 0 + etankxoff, 10);
    }
    if (global.etanks >= 3) {
        if (global.playerhealth > 299) draw_sprite(sGUIETank, 1, 0 + etankxoff + 6, 4);
        if (global.playerhealth <= 299) draw_sprite(sGUIETank, 0, 0 + etankxoff + 6, 4);
    }
    if (global.etanks >= 4) {
        if (global.playerhealth > 399) draw_sprite(sGUIETank, 1, 0 + etankxoff + 6, 10);
        if (global.playerhealth <= 399) draw_sprite(sGUIETank, 0, 0 + etankxoff + 6, 10);
    }
    if (global.etanks >= 5) {
        if (global.playerhealth > 499) draw_sprite(sGUIETank, 1, 0 + etankxoff + 12, 4);
        if (global.playerhealth <= 499) draw_sprite(sGUIETank, 0, 0 + etankxoff + 12, 4);
    }
    if (global.etanks >= 6) {
        if (global.playerhealth > 599) draw_sprite(sGUIETank, 1, 0 + etankxoff + 12, 10);
        if (global.playerhealth <= 599) draw_sprite(sGUIETank, 0, 0 + etankxoff + 12, 10);
    }
    if (global.etanks >= 7) {
        if (global.playerhealth > 699) draw_sprite(sGUIETank, 1, 0 + etankxoff + 18, 4);
        if (global.playerhealth <= 699) draw_sprite(sGUIETank, 0, 0 + etankxoff + 18, 4);
    }
    if (global.etanks >= 8) {
        if (global.playerhealth > 799) draw_sprite(sGUIETank, 1, 0 + etankxoff + 18, 10);
        if (global.playerhealth <= 799) draw_sprite(sGUIETank, 0, 0 + etankxoff + 18, 10);
    }
    if (global.etanks >= 9) {
        if (global.playerhealth > 899) draw_sprite(sGUIETank, 1, 0 + etankxoff + 24, 4);
        if (global.playerhealth <= 899) draw_sprite(sGUIETank, 0, 0 + etankxoff + 24, 4);
    }
    if (global.etanks == 10) {
        if (global.playerhealth > 999) draw_sprite(sGUIETank, 1, 0 + etankxoff + 24, 10);
        if (global.playerhealth <= 999) draw_sprite(sGUIETank, 0, 0 + etankxoff + 24, 10);
    }
    draw_set_font(global.guifont2);
    if (global.maxmissiles > 0) {
        if (global.maxmissiles >= 100) {
            draw_background(bgGUIMsl, xoff, 0);
        } else draw_background(bgGUISmsl, xoff, 0);
        draw_text(0 + xoff + 19, 7, string(global.missiles));
        if (global.opmslstyle == 0) {
            if (global.currentweapon != 1 || oCharacter.state == 23 || oCharacter.state == 24 || oCharacter.state == 27 || oCharacter.state == 54 || oCharacter.state == 55 || oCharacter.sjball) draw_sprite(sGUIMissile, 0, 0 + xoff + 1, 4);
            if (global.currentweapon == 1 && oCharacter.state != 23 && oCharacter.state != 24 && oCharacter.state != 27 && oCharacter.state != 54 && oCharacter.state != 55 && oCharacter.sjball == 0) {
                if (oCharacter.armmsl == 0) draw_sprite(sGUIMissile, 1, 0 + xoff + 1, 4);
                if (oCharacter.armmsl == 1) draw_sprite(sGUIMissile, 2, 0 + xoff + 1, 4);
            }
        }
        if (global.opmslstyle == 1) {
            if (global.currentweapon == 1) {
                draw_sprite(sGUIMissile, 1, 0 + xoff + 1, 4);
            } else draw_sprite(sGUIMissile, 0, 0 + xoff + 1, 4);
        }
        if (global.maxmissiles >= 100) {
            xoff += 45;
        } else xoff += 38;
    }
    if (global.maxsmissiles > 0) {
        draw_background(bgGUISmsl, xoff, 0);
        draw_text(xoff + 19, 7, string(global.smissiles));
        if (global.opmslstyle == 0) {
            if (global.currentweapon != 2 || oCharacter.state == 23 || oCharacter.state == 24 || oCharacter.state == 27 || oCharacter.state == 54 || oCharacter.state == 55 || oCharacter.sjball) draw_sprite(sGUISMissile, 0, xoff + 1, 4);
            if (global.currentweapon == 2 && oCharacter.state != 23 && oCharacter.state != 24 && oCharacter.state != 27 && oCharacter.state != 54 && oCharacter.state != 55 && oCharacter.sjball == 0) {
                if (oCharacter.armmsl == 0) draw_sprite(sGUISMissile, 1, xoff + 1, 4);
                if (oCharacter.armmsl == 1) draw_sprite(sGUISMissile, 2, xoff + 1, 4);
            }
        }
        if (global.opmslstyle == 1) {
            if (global.currentweapon == 2) {
                draw_sprite(sGUISMissile, 1, xoff + 1, 4);
            } else draw_sprite(sGUISMissile, 0, xoff + 1, 4);
        }
        xoff += 38;
    }
    if (global.maxpbombs > 0) {
        draw_background(bgGUISmsl, xoff, 0);
        draw_text(xoff + 19, 7, string(global.pbombs));
        if (global.opmslstyle == 0) {
            if (oCharacter.state != 23 && oCharacter.state != 24 && oCharacter.state != 27 && oCharacter.state != 54 && oCharacter.state != 55 && oCharacter.sjball == 0) draw_sprite(sGUIPBomb, 0, xoff + 1, 4);
            if (oCharacter.state == 23 || oCharacter.state == 24 || oCharacter.state == 27 || oCharacter.state == 54 || oCharacter.state == 55 || oCharacter.sjball) {
                if (oCharacter.armmsl == 0) draw_sprite(sGUIPBomb, 1, xoff + 1, 4);
                if (oCharacter.armmsl == 1) draw_sprite(sGUIPBomb, 2, xoff + 1, 4);
            }
        }
        if (global.opmslstyle == 1) {
            if (global.currentweapon == 3) {
                draw_sprite(sGUIPBomb, 1, xoff + 1, 4);
            } else draw_sprite(sGUIPBomb, 0, xoff + 1, 4);
        }
    }
    if (global.ophudshowmap && global.ophudshowmetrcount) {
        draw_background(bgGUIMap, 250, 0);
        xoff = 250;
    }
    if (global.ophudshowmap && global.ophudshowmetrcount == 0) draw_background(bgGUIMapOnly, 272, 0);
    if (global.ophudshowmap == 0 && global.ophudshowmetrcount) {
        draw_background(bgGUIMetOnly, 296, 0);
        xoff = 296;
    }
    if (global.ophudshowmetrcount) {
        if (global.ophudshowmetrcount == 1) {
            draw_background(bgGUIMetCountBG1, xoff + 4, 4);
            draw_text(xoff + 6, 21, to_string_lz(global.monstersarea));
        }
        if (global.ophudshowmetrcount == 2) {
            draw_background(bgGUIMetCountBG2, xoff + 4, 4);
            draw_text(xoff + 6, 21, to_string_lz(global.monstersleft));
        }
    }
    if (global.ophudshowmap) draw_gui_map(276, 0);
} // if (global.classicmode == 0 && global.opshowhud)
*/


#define gui_health2
/// gui_health()
/*if (global.playerhealth < 0) global.playerhealth = 0;
guih = ceil(global.playerhealth);
if (global.playerhealth >= 100) guih = global.playerhealth - 100;
if (global.playerhealth >= 200) guih = global.playerhealth - 200;
if (global.playerhealth >= 300) guih = global.playerhealth - 300;
if (global.playerhealth >= 400) guih = global.playerhealth - 400;
if (global.playerhealth >= 500) guih = global.playerhealth - 500;
if (global.playerhealth >= 600) guih = global.playerhealth - 600;
if (global.playerhealth >= 700) guih = global.playerhealth - 700;
if (global.playerhealth >= 800) guih = global.playerhealth - 800;
if (global.playerhealth >= 900) guih = global.playerhealth - 900;
if (global.playerhealth >= 1000) guih = global.playerhealth - 1000;
if (global.playerhealth >= 1100) guih = global.playerhealth - 1100;
if (global.playerhealth >= 1200) guih = global.playerhealth - 1200;
if (global.playerhealth >= 1300) guih = global.playerhealth - 1300;
if (global.playerhealth >= 1400) guih = global.playerhealth - 1400;
if (global.playerhealth >= 1500) guih = global.playerhealth - 1500;
if (global.playerhealth >= 1600) guih = global.playerhealth - 1600;
if (global.playerhealth >= 1700) guih = global.playerhealth - 1700;
if (global.playerhealth >= 1800) guih = global.playerhealth - 1800;
if (global.playerhealth >= 1900) guih = global.playerhealth - 1900;
if (global.playerhealth >= 2000) guih = global.playerhealth - 2000;
if (global.playerhealth >= 2100) guih = global.playerhealth - 2100;
if (global.playerhealth >= 2200) guih = global.playerhealth - 2200;
if (global.playerhealth >= 2300) guih = global.playerhealth - 2300;
if (global.playerhealth >= 2400) guih = global.playerhealth - 2400;
if (global.playerhealth >= 2500) guih = global.playerhealth - 2500;
if (global.playerhealth >= 2600) guih = global.playerhealth - 2600;
if (global.playerhealth >= 2700) guih = global.playerhealth - 2700;
if (global.playerhealth >= 2800) guih = global.playerhealth - 2800;
if (global.playerhealth >= 2900) guih = global.playerhealth - 2900;
if (global.playerhealth >= 3000) guih = global.playerhealth - 3000;
if (ceil(guih) == 100) guih = 0;
guih = string(ceil(guih));
if (real(guih) < 10) guih = "0" + guih;
return guih;



/*  ORIGINAL
/// gui_health()
if (global.playerhealth < 0) global.playerhealth = 0;
guih = ceil(global.playerhealth);
if (global.playerhealth >= 100) guih = global.playerhealth - 100;
if (global.playerhealth >= 200) guih = global.playerhealth - 200;
if (global.playerhealth >= 300) guih = global.playerhealth - 300;
if (global.playerhealth >= 400) guih = global.playerhealth - 400;
if (global.playerhealth >= 500) guih = global.playerhealth - 500;
if (global.playerhealth >= 600) guih = global.playerhealth - 600;
if (global.playerhealth >= 700) guih = global.playerhealth - 700;
if (global.playerhealth >= 800) guih = global.playerhealth - 800;
if (global.playerhealth >= 900) guih = global.playerhealth - 900;
if (global.playerhealth >= 1000) guih = global.playerhealth - 1000;
if (ceil(guih) == 100) guih = 0;
guih = string(ceil(guih));
if (real(guih) < 10) guih = "0" + guih;
return guih;
*/

#define hd_change

//Argument0 = Section | Argument1 = Field | Argument2 = Default value
ini_open('modifiers.ini');
hd = abs(ini_read_real(argument0, argument1, argument2)); 

//var temp_cheating = false;
//if (ini_read_real('Header', 'Cheating', 0) == 1)
//{
//    temp_cheating = true;  
//}

ini_close();
//if (global.mod_cheating == 1) { return hd; }
if (hd < argument2) { return argument2; }
return hd;


#define hdM_change

//Argument0 = Section | Argument1 = Field | Argument2 = Default value
ini_open('modifiers.ini');
hd = argument2 * abs(ini_read_real(argument0, argument1, argument2)); 

//if (ini_read_real('Header', 'Cheating', 0) == 1)
//{
//    return hd;   
//}

ini_close();
//if (global.mod_cheating == 1) { return hd; }
if (hd < argument2) { return argument2; }
return hd;


#define scr_randomizer
var temp_seed = random_get_seed();
randomize();
if(instance_exists(oClient)){
    if(!is_undefined(oClient.seed)){
        oControl.seed = oClient.seed;
        random_set_seed(oControl.seed);
    } else {
        //oControl.seed = random_get_seed();
        //random_set_seed(oControl.seed);
        //send_seed();
    }
} else {
    oControl.seed = random_get_seed();
    random_set_seed(oControl.seed);
}

if (oControl.mod_usemanualseed == 1) { 
    random_set_seed(oControl.mod_seed);
    oControl.seed = oControl.mod_seed; 
}

var list_bombscrew = ds_list_create();

if (oControl.mod_bombrun == 1 && oControl.mod_randomitems == 1) { ds_list_add(list_bombscrew, 0); }
if (oControl.mod_screwattackrun == 1 && oControl.mod_randomitems == 1) { ds_list_add(list_bombscrew, 1); }
if (oControl.mod_powerbombrun == 1 && oControl.mod_randomitems == 1) { ds_list_add(list_bombscrew, 2); }

if (oControl.mod_bombrun =! 1 && oControl.mod_screwattackrun =! 1 && oControl.mod_powerbombrun =! 1)
{
ds_list_add(list_bombscrew, 0);
}

ds_list_shuffle(list_bombscrew);

var screwbombs = ds_list_find_value(list_bombscrew, ds_list_size(list_bombscrew) - 1);
if (oControl.mod_randomitems == 0) { screwbombs = 0; }

    
switch (screwbombs)
{
    case 0:
        scr_randomizer_bombs();
        break
    case 1:
        scr_randomizer_screwattack()
        break;
    case 2:
        scr_randomizer_powerbombs();
        break;
    default:
        screwbombs = 0;
        scr_randomizer_bombs();
        break;
}




random_set_seed(temp_seed);

if (oControl.mod_randomitems == 1) { scr_randomizer_items(screwbombs); }



#define mod_changes_2
//Must check for absolute value here first. Could cheat otherwise.
var temp = abs(argument0);
//if (global.mod_cheating == 1) { return temp; }
if (temp > argument1) { return argument1; }
return temp;

#define scr_itemchange

switch (argument0)
{
    case 0:
        return oControl.mod_bombs;
        break;
    case 2:
        return oControl.mod_spider;
        break;
    case 3:
        return oControl.mod_jumpball;
        break;
    case 4:
        return oControl.mod_hijump;
        break;
    case 5:
        return oControl.mod_varia;
        break;
    case 6:
        return oControl.mod_spacejump;
        break;
    case 7:
        return oControl.mod_speedbooster;
        break;
    case 8:
        return oControl.mod_screwattack;
        break;
    case 9:
        return oControl.mod_gravity;
        break;
    case 10:
        return oControl.mod_charge;
        break;
    case 11:
        return oControl.mod_ice;
        break;
    case 12:
        return oControl.mod_wave;
        break;
    case 13:
        return oControl.mod_spazer;
        break;
    case 14:
        return oControl.mod_plasma;
        break;
        //Missiles
    case 52:
        return oControl.mod_52;
        break;
    case 53:
        return oControl.mod_53;
        break;
    case 54:
        return oControl.mod_54;
        break;
    case 55:
        return oControl.mod_55;
        break;
    case 56:
        return oControl.mod_56;
        break;
    case 57:
        return oControl.mod_57;
        break;
    case 60:
        return oControl.mod_60;
        break;
    case 100:
        return oControl.mod_100;
        break;
    case 101:
        return oControl.mod_101;
        break;
    case 102:
        return oControl.mod_102;
        break;
    case 104:
        return oControl.mod_104;
        break;
    case 105:
        return oControl.mod_105;
        break;
    case 106:
        return oControl.mod_106;
        break;
    case 107:
        return oControl.mod_107;
        break;
    case 109:
        return oControl.mod_109;
        break;
    case 111:
        return oControl.mod_111;
        break;
    case 150:
        return oControl.mod_150;
        break;
    case 151:
        return oControl.mod_151;
        break;
    case 152:
        return oControl.mod_152;
        break;
    case 153:
        return oControl.mod_153;
        break;
    case 154:
        return oControl.mod_154;
        break;
    case 155:
        return oControl.mod_155;
        break;
    case 156:
        return oControl.mod_156;
        break;
    case 159:
        return oControl.mod_159;
        break;
    case 161:
        return oControl.mod_161;
        break;
    case 163:
        return oControl.mod_163;
        break;
    case 202:
        return oControl.mod_202;
        break;
    case 203:
        return oControl.mod_203;
        break;
    case 204:
        return oControl.mod_204;
        break;
    case 205:
        return oControl.mod_205;
        break;
    case 208:
        return oControl.mod_208;
        break;
    case 210:
        return oControl.mod_210;
        break;
    case 211:
        return oControl.mod_211;
        break;
    case 214:
        return oControl.mod_214;
        break;
    case 250:
        return oControl.mod_250;
        break;
    case 252:
        return oControl.mod_252;
        break;
    case 255:
        return oControl.mod_255;
        break;
    case 257:
        return oControl.mod_257;
        break;
    case 259:
        return oControl.mod_259;
        break;
    case 303:
        return oControl.mod_303;
        break;
    case 304:
        return oControl.mod_304;
        break;
    case 307:
        return oControl.mod_307;
        break;
    case 308:
        return oControl.mod_308;
        break;
    case 309:
        return oControl.mod_309;
        break;
    //Super Missiles
    case 51:
        return oControl.mod_51;
        break;
    case 110:
        return oControl.mod_110;
        break;
    case 162:
        return oControl.mod_162;
        break;
    case 206:
        return oControl.mod_206;
        break;
    case 207:
        return oControl.mod_207;
        break;
    case 209:
        return oControl.mod_209;
        break;
    case 215:
        return oControl.mod_215;
        break;
    case 256:
        return oControl.mod_256;
        break;
    case 300:
        return oControl.mod_300;
        break;
    case 305:
        return oControl.mod_305;
        break;
    //Energy Tanks
    case 50:
        return oControl.mod_50;
        break;
    case 103:
        return oControl.mod_103;
        break;
    case 108:
        return oControl.mod_108;
        break;
    case 157:
        return oControl.mod_157;
        break;
    case 158:
        return oControl.mod_158;
        break;
    case 200:
        return oControl.mod_200;
        break;
    case 201:
        return oControl.mod_201;
        break;
    case 251:
        return oControl.mod_251;
        break;
    case 254:
        return oControl.mod_254;
        break;
    case 306:
        return oControl.mod_306;
        break;
    //Powerbombs
    case 58:
        return oControl.mod_58;
        break;
    case 59:
        return oControl.mod_59;
        break;
    case 112:
        return oControl.mod_112;
        break;
    case 160:
        return oControl.mod_160;
        break;
    case 212:
        return oControl.mod_212;
        break;
    case 213:
        return oControl.mod_213;
        break;
    case 253:
        return oControl.mod_253;
        break;
    case 258:
        return oControl.mod_258;
        break;
    case 301:
        return oControl.mod_301;
        break;
    case 302:
        return oControl.mod_302;
        break;
}

return argument0;




#define scr_newgame

//NewGame+ Additions
//Thanks Craig!


//oControl.mod_purerandom = 0;
oControl.mod_purerandombool = 0;
oControl.mod_randomgamebool = 0
oControl.mod_splitrandom = 0;



if (global.gamemode == 2 || global.gamemode == 3 || global.gamemode == 4 || global.gamemode == 5) 
{
    global.lavastate = 7;
    global.event[4] = 1;
    global.event[56] = 1;
    global.event[155] = 1;
    global.event[173] = 1;
    global.event[204] = 1;
    global.event[259] = 1;
    global.monstersarea = 38;
    
    if (global.gamemode == 3) { scr_randomizer(); } //Classic Mode
    
    if (global.gamemode == 4) //Pure Random
    {
        oControl.mod_purerandombool = 1;
        scr_randomizer_pure();
    }
        
    if (global.gamemode == 5) //Split Pools
    {
        oControl.mod_splitrandom = 1;
        scr_rand_split_powerups();
        scr_randomizer_split_items();    
    }
    
    if (global.gamemode != 2) { oControl.mod_randomgamebool = 1; }


}
else
{
    global.gamemode = 1;
}


global.monstersleft = 47;

#define scr_itemsopen

switch (argument0)
{
    case 0:
        return oItemBomb;
        break;
    case 2:
        return oItemSpiderBall;
        break;
    case 3:
        return oItemJumpBall;
        break;
    case 4:
        return oItemHijump;
        break;
    case 5:
        return oItemVaria;
        break;
    case 6:
        return oItemSpaceJump;
        break;
    case 7:
        return oItemSpeedBooster;
        break;
    case 8:
        return oItemScrewAttack;
        break;
    case 9:
        return oItemGravity;
        break;
    case 10:
        return oItemCBeam;
        break;
    case 11:
        return oItemIBeam;
        break;
    case 12:
        return oItemWBeam;
        break;
    case 13:
        return oItemSBeam;
        break;
    case 14:
        return oItemPBeam;
        break;
        //Missiles
    case 52:
        return oItemM_52;
        break;
    case 53:
        return oItemM_53;     
        break;
    case 54:
        return oItemM_54;
        break;
    case 55:
        return oItemM_55;    
        break;
    case 56:
        return oItemM_56;     
        break;
    case 57:
        return oItemM_57;    
        break;
    case 60:
        return oItemM_60;    
        break;
    case 100:
        return oItemM_100;     
        break;
    case 101:
        return oItemM_101;     
        break;
    case 102:
        return oItemM_102;     
        break;
    case 104:
        return oItemM_104;    
        break;
    case 105:
        return oItemM_105;     
        break;
    case 106:
        return oItemM_106;     
        break;
    case 107:
        return oItemM_107;     
        break;
    case 109:
        return oItemM_109;     
        break;
    case 111:
        return oItemM_111;     
        break;
    case 150:
        return oItemM_150;     
        break;
    case 151:
        return oItemM_151;     
        break;
    case 152:
        return oItemM_152;     
        break;
    case 153:
        return oItemM_153;    
        break;
    case 154:
        return oItemM_154;     
        break;
    case 155:
        return oItemM_155;     
        break;
    case 156:
        return oItemM_156;    
        break;
    case 159:
        return oItemM_159;    
        break;
    case 161:
        return oItemM_161;    
        break;
    case 163:
        return oItemM_163;     
        break;
    case 202:
        return oItemM_202;   
        break;
    case 203:
        return oItemM_203;   
        break;
    case 204:
        return oItemM_204;     
        break;
    case 205:
        return oItemM_205;     
        break;
    case 208:
        return oItemM_208;     
        break;
    case 210:
        return oItemM_210;     
        break;
    case 211:
        return oItemM_211;     
        break;
    case 214:
        return oItemM_214;     
        break;
    case 250:
        return oItemM_250;    
        break;
    case 252:
        return oItemM_252;     
        break;
    case 255:
        return oItemM_255;     
        break;
    case 257:
        return oItemM_257;     
        break;
    case 259:
        return oItemM_259;    
        break;
    case 303:
        return oItemM_303;    
        break;
    case 304:
        return oItemM_304;    
        break;
    case 307:
        return oItemM_307;    
        break;
    case 308:
        return oItemM_308;    
        break;
    case 309:
        return oItemM_309;    
        break;
    //Super Missiles
    case 51:
        return oItemSM_51;    
        break;
    case 110:
        return oItemSM_110;    
        break;
    case 162:
        return oItemSM_162;    
        break;
    case 206:
        return oItemSM_206;    
        break;
    case 207:
        return oItemSM_207;    
        break;
    case 209:
        return oItemSM_209;    
        break;
    case 215:
        return oItemSM_215;    
        break;
    case 256:
        return oItemSM_256;  
        break;
    case 300:
        return oItemSM_300;    
        break;
    case 305:
        return oItemSM_305;    
        break;
    //Energy Tanks
    case 50:
        return oItemETank_50;    
        break;
    case 103:
        return oItemETank_103;   
        break;
    case 108:
        return oItemETank_108;    
        break;
    case 157:
        return oItemETank_157;    
        break;
    case 158:
        return oItemETank_158;    
        break;
    case 200:
        return oItemETank_200;    
        break;
    case 201:
        return oItemETank_201;    
        break;
    case 251:
        return oItemETank_251;    
        break;
    case 254:
        return oItemETank_254;    
        break;
    case 306:
        return oItemETank_306;    
        break;
    //Powerbombs
    case 58:
        return oItemPB_58    
        break;
    case 59:
        return oItemPB_59;    
        break;
    case 112:
        return oItemPB_112    
        break;
    case 160:
        return oItemPB_160;    
        break;
    case 212:
        return oItemPB_212;   
        break;
    case 213:
        return oItemPB_213;    
        break;
    case 253:
        return oItemPB_253;   
        break;
    case 258:
        return oItemPB_258;    
        break;
    case 301:
        return oItemPB_301;    
        break;
    case 302:
        return oItemPB_302; 
        break;
}

return 1;

#define scr_fixitem
/*
ini_open(working_directory + "random" + string(global.saveslot + 1) + ".ini");
var can_return = false;
if (ini_read_real('Items', string(argument0), argument0) == argument0) { can_return = true; }
if (can_return) { ini_close(); return argument0; }

var current_item = ini_read_real('Items', string(argument0), argument0)
var temp_item = 1;
if (ini_read_real('Items', '0', 0) == argument0) { temp_item = 0; }
if (ini_read_real('Items', '2', 2) == argument0) { temp_item = 2; }
if (ini_read_real('Items', '3', 3) == argument0) { temp_item = 3; }
if (ini_read_real('Items', '4', 4) == argument0) { temp_item = 4; }
if (ini_read_real('Items', '5', 5) == argument0) { temp_item = 5; }
if (ini_read_real('Items', '6', 6) == argument0) { temp_item = 6; }
if (ini_read_real('Items', '7', 7) == argument0) { temp_item = 7; }
if (ini_read_real('Items', '8', 8) == argument0) { temp_item = 8; }
if (ini_read_real('Items', '10', 10) == argument0) { temp_item = 10; }
if (ini_read_real('Items', '11', 11) == argument0) { temp_item = 11; }
if (ini_read_real('Items', '12', 12) == argument0) { temp_item = 12; }
if (ini_read_real('Items', '13', 13) == argument0) { temp_item = 13; }
if (ini_read_real('Items', '14', 14) == argument0) { temp_item = 14; }

ini_close();

if (temp_item == 1) { return argument0; }

ini_open(working_directory + "random" + string(global.saveslot + 1) + ".ini");
ini_write_real('Items', string(argument0), argument0);
ini_write_real('Items', string(temp_item), current_item);
ini_close();

return argument0;
*/

#define scr_load_mods
ini_open('modifiers.ini');

oControl.mod_backgroundframes = 60;
oControl.mod_backgroundspeed = 8;

oControl.mod_xcoordinate = 57;
oControl.mod_ycoordinate = 22;

//Header

//HellRun
//oControl.mod_insanitymode = mod_changes(ini_read_real('InsanityMode', 'InsanityMode', 0), 0);

// HELPER SEPTOGGS USED TO BE HERE

//Filters
oControl.mod_color1value1 = ini_read_real('GBOriginalColorFilter', 'CustomColor1Value1', 87);
oControl.mod_color1value2 = ini_read_real('GBOriginalColorFilter', 'CustomColor1Value2', 111);
oControl.mod_color1value3 = ini_read_real('GBOriginalColorFilter', 'CustomColor1Value3', 93);
oControl.mod_color2value1 = ini_read_real('GBOriginalColorFilter', 'CustomColor2Value1', 229);
oControl.mod_color2value2 = ini_read_real('GBOriginalColorFilter', 'CustomColor2Value2', 115);
oControl.mod_color2value3 = ini_read_real('GBOriginalColorFilter', 'CustomColor2Value3', 158);
oControl.mod_color3value1 = ini_read_real('GBOriginalColorFilter', 'CustomColor3Value1', 253);
oControl.mod_color3value2 = ini_read_real('GBOriginalColorFilter', 'CustomColor3Value2', 159);
oControl.mod_color3value3 = ini_read_real('GBOriginalColorFilter', 'CustomColor3Value3', 167);
oControl.mod_color4value1 = ini_read_real('GBOriginalColorFilter', 'CustomColor4Value1', 252);
oControl.mod_color4value2 = ini_read_real('GBOriginalColorFilter', 'CustomColor4Value2', 252);
oControl.mod_color4value3 = ini_read_real('GBOriginalColorFilter', 'CustomColor4Value3', 252);

//LabMonsterCount
oControl.mod_monstersextremecheck = 0;

//Dealt with in Extras Menu Options
oControl.mod_buttonsconfig = 0;
oControl.mod_percentofitems = 1;
oControl.mod_lowhealthwarning = 1;
oControl.mod_earlybaby = 0;
oControl.mod_fusion = 0;
oControl.mod_diffmult = 1;
oControl.msr_fusionsuit = 1;
oControl.mod_suitchangecheat = 0;
oControl.chozomessage = 0;
global.chozo_message_item_id = -1;


//Collected Items On Map
//oControl.mod_collecteditemsmap = 0;

//E-Tank Health Multiplier
oControl.mod_etankhealthmult = mod_changes_2(ini_read_real('ETankHealth', 'Multiplier', 1), 1);

//MissileStartingCount
oControl.mod_Mstartingcount = mod_changes_2(ini_read_real('MissileStartCount', 'StartingCount', 30), 30);


//RandomizerSettings
oControl.mod_purerandombool = 0;
oControl.mod_randomgamebool = 0;
oControl.mod_splitrandom = 0;
oControl.mod_randomitems = 1;
oControl.mod_screwattackrun = mod_changes_2(ini_read_real('RandomizerSettings', 'ScrewAttackRun', 1), 1);
oControl.mod_bombrun = mod_changes_2(ini_read_real('RandomizerSettings', 'BombRun', 1), 1);
oControl.mod_powerbombrun = mod_changes_2(ini_read_real('RandomizerSettings', 'PowerBombsRun', 1), 1);
oControl.mod_bombblocks = 0;

// RandomizerSeed
oControl.mod_usemanualseed = mod_changes(ini_read_real('RandomizerSeed', 'UseManualSeed', 0), 0);
oControl.mod_seed = ini_read_real('RandomizerSeed', 'Seed', 0);

// AlphaGamma
global.mod_alphagammaH = mod_changes(ini_read_real('AlphaGamma', 'Health', 1), 1);
global.mod_alphagammaD = mod_changes(ini_read_real('AlphaGamma', 'Damage', 1), 1);
// Gamma
global.mod_gammaelectric = mod_changes(ini_read_real('Gamma', 'Electric', 40), 40);
// GrabbedGamma
global.mod_grabbedgammaPS = mod_changes(ini_read_real('GrabbedGamma', 'PowerSuit', 0.08), 0.08);
global.mod_grabbedgammaVS = mod_changes(ini_read_real('GrabbedGamma', 'VariaSuit', 0.05), 0.05);
global.mod_grabbedgammaGS = mod_changes(ini_read_real('GrabbedGamma', 'GravitySuit', 0.03), 0.03);
// Zeta
global.mod_zetahealth = mod_changes(ini_read_real('Zeta', 'Health', 300), 300);
global.mod_zetadamage = mod_changes(ini_read_real('Zeta', 'Damage', 50), 50);
global.mod_zetadamageslash1 = mod_changes(ini_read_real('Zeta', 'DamageSlash1', 80), 80);
global.mod_zetadamageslash2 = mod_changes(ini_read_real('Zeta', 'DamageSlash2', 80), 80);
global.mod_zetadamageacid = mod_changes(ini_read_real('Zeta', 'DamageAcid', 40), 40);
// Omega
global.mod_omegahealth = mod_changes(ini_read_real('Omega', 'Health', 320), 320);
global.mod_omegadamagebackmissile = mod_changes_2(ini_read_real('Omega', 'DamageBackMissile', 30), 30);
global.mod_omegadamagebacksuper = mod_changes_2(ini_read_real('Omega', 'DamageBackSuper', 150), 150);
global.mod_omegadamage = mod_changes(ini_read_real('Omega', 'Damage', 100), 100);
global.mod_omegadamagegroundhit = mod_changes(ini_read_real('Omega', 'DamageGroundHit', 10), 10);
global.mod_omegadamageflame = mod_changes(ini_read_real('Omega', 'DamageFlame', 150), 150);
global.mod_omegadamageprojectile = mod_changes(ini_read_real('Omega', 'DamageProjectile', 250), 250);
// AncientGuardian
global.mod_boss1Health = mod_changes(ini_read_real('AncientGuardian', 'Health', 500), 500);
global.mod_boss1Dhead = mod_changes(ini_read_real('AncientGuardian', 'DamageHead', 8), 8);
global.mod_boss1Dbeam = mod_changes(ini_read_real('AncientGuardian', 'DamageBeam', 15), 15);
global.mod_boss1DfireballO = mod_changes(ini_read_real('AncientGuardian', 'DamageFireballOrange', 20), 20);
global.mod_boss1DfireballExOR = mod_changes(ini_read_real('AncientGuardian', 'DamageFireballOrangeExplosionRight', 14), 14);
global.mod_boss1DfireballExOL = mod_changes(ini_read_real('AncientGuardian', 'DamageFireballOrangeExplosionLeft', 14), 14);
global.mod_boss1DfireballG = mod_changes(ini_read_real('AncientGuardian', 'DamageFireballGreen', 16), 16);
global.mod_boss1DfireballExG = mod_changes(ini_read_real('AncientGuardian', 'DamageFireballGreenExplosion', 5), 5);
global.mod_boss1DfireballR = mod_changes(ini_read_real('AncientGuardian', 'DamageFirebalRed', 15), 15);
// Arachnus
global.mod_arachnusdamage = mod_changes(ini_read_real('Arachnus', 'Damage', 20), 20);
global.mod_arachnusfireballorange = mod_changes(ini_read_real('Arachnus', 'DamageFireballOrange', 15), 15);
global.mod_arachnusfirewallorange = mod_changes(ini_read_real('Arachnus', 'DamageFireWallOrange', 15), 15);
global.mod_arachnusfireballgreen = mod_changes(ini_read_real('Arachnus', 'DamageFireballGreen', 15), 15);
global.mod_arachnusfirewallgreen = mod_changes(ini_read_real('Arachnus', 'DamageFireWallGreen', 15), 15);
global.mod_arachnusfireballred = mod_changes(ini_read_real('Arachnus', 'DamageFireballRed', 8), 8);
global.mod_arachnusdamageclaw = mod_changes(ini_read_real('Arachnus', 'DamageClaw', 22), 22);
global.mod_arachnusdamagespikes = mod_changes(ini_read_real('Arachnus', 'DamageSpikes', 10), 10);
// Torizo
global.mod_torizohealthform1 = mod_changes(ini_read_real('Torizo', 'HealthForm1', 200), 200);
global.mod_torizohealthform2 = mod_changes(ini_read_real('Torizo', 'HealthForm2', 240), 240);
global.mod_torizohealthform1hard = mod_changes(ini_read_real('Torizo', 'HealthForm1Hard', 300), 300);
global.mod_torizohealthform2hard = mod_changes(ini_read_real('Torizo', 'HealthForm2Hard', 350), 350);
global.mod_torizondamageform1 = mod_changes(ini_read_real('Torizo', 'DamageForm1', 30), 30);
global.mod_torizondamageform2 = mod_changes(ini_read_real('Torizo', 'DamageForm2', 30), 30);
global.mod_torizodamagefireball = mod_changes(ini_read_real('Torizo', 'DamageFireball', 18), 18);
global.mod_torizodamageslash = mod_changes(ini_read_real('Torizo', 'DamageSlash', 24), 24);
global.mod_torizodamageghost = mod_changes(ini_read_real('Torizo', 'DamageGhost', 18), 18);
// Tester
global.mod_testerHcannon = mod_changes(ini_read_real('Tester', 'HealthCannon', 15), 15);
global.mod_testerHeye = mod_changes(ini_read_real('Tester', 'HealthEye', 100), 100);
global.mod_testerHglass = mod_changes(ini_read_real('Tester', 'HealthGlass', 30), 30);
global.mod_testerHshield = mod_changes(ini_read_real('Tester', 'HealthShield', 200), 200);
global.mod_testerDicespark = mod_changes(ini_read_real('Tester', 'DamageIceSpark', 25), 25);
global.mod_testerDamage = mod_changes(ini_read_real('Tester', 'Damage', 40), 40);
global.mod_testerDshield = mod_changes(ini_read_real('Tester', 'DamageShield', 40), 40);
global.mod_testerDMissile = mod_changes(ini_read_real('Tester', 'DamageMissile', 40), 40);
global.mod_testerDPlasma = mod_changes(ini_read_real('Tester', 'DamagePlasma', 50), 50);
global.mod_testerDspazer = mod_changes(ini_read_real('Tester', 'DamageSpazer', 25), 25);
global.mod_testerDwave = mod_changes(ini_read_real('Tester', 'DamageWave', 35), 35);
// Tank
global.mod_tankHbottom = mod_changes(ini_read_real('Tank', 'HealthBottom', 100), 100);
global.mod_tankHcannon = mod_changes(ini_read_real('Tank', 'HealthCannon', 150), 150);
global.mod_tankHcore = mod_changes(ini_read_real('Tank', 'HealthCore', 125), 125);
global.mod_tankHhead = mod_changes(ini_read_real('Tank', 'HealthHead', 100), 100);
global.mod_tankHshield = mod_changes(ini_read_real('Tank', 'HealthShield', 100), 100);
global.mod_tankDamage = mod_changes(ini_read_real('Tank', 'Damage', 40), 40);
global.mod_tankDprojectile = mod_changes(ini_read_real('Tank', 'DamageProjectile', 24), 24);
// Serris
global.mod_serrisHealth = mod_changes(ini_read_real('Serris', 'Health', 100), 100);
global.mod_serrisHbody = mod_changes(ini_read_real('Serris', 'HealthBody', 10), 10);
global.mod_serrisDamage = mod_changes(ini_read_real('Serris', 'Damage', 50), 50);
global.mod_serrisDprojectile = mod_changes(ini_read_real('Serris', 'DamageBody', 50), 50);
// Genesis
global.mod_genesisHealth = mod_changes(ini_read_real('Genesis', 'Health', 250), 250);
global.mod_genesisDamage = mod_changes(ini_read_real('Genesis', 'Damage', 80), 80);
global.mod_genesisDacid = mod_changes(ini_read_real('Genesis', 'DamageAcid', 30), 30);
global.mod_genesisDslash = mod_changes(ini_read_real('Genesis', 'DamageSlash', 90), 90);
// Monsters
global.mod_monstersHealth = mod_changes(ini_read_real('Monsters', 'Health', 5), 5);
global.mod_monstersDmissiles = mod_changes(ini_read_real('Monsters', 'DamageMissiles', 1), 1);
global.mod_monstersDsuper = mod_changes(ini_read_real('Monsters', 'DamageSuperMissiles', 5), 5);
global.mod_monstersdrainPS = mod_changes(ini_read_real('Monsters', 'DrainPowerSuit', 2), 2);
global.mod_monstersdrainVS = mod_changes(ini_read_real('Monsters', 'DrainVariaSuit', 1), 1);
global.mod_monstersdrainGS = mod_changes(ini_read_real('Monsters', 'DrainGravitySuit', 0.5), 0.5);
// Queen
global.mod_queenHstart = mod_changes(ini_read_real('Queen', 'HealthStart', 600), 600);
global.mod_queenHcorridors = mod_changes(ini_read_real('Queen', 'HealthCorridors', 200), 200);
global.mod_queenHbigroom = mod_changes(ini_read_real('Queen', 'HealthBigRoom', 400), 400);
global.mod_queenHlast = mod_changes(ini_read_real('Queen', 'HealthLast', 300), 300);
global.mod_queenDbody = mod_changes(ini_read_real('Queen', 'DamageBody', 60), 60);
global.mod_queenDhead = mod_changes(ini_read_real('Queen', 'DamageHead', 90), 90);
global.mod_queenHprojectile = mod_changes(ini_read_real('Queen', 'HealthProjectile', 80), 80);
global.mod_queenDprojectile = mod_changes(ini_read_real('Queen', 'DamageProjectile', 100), 100);
global.mod_queenDfireball = mod_changes(ini_read_real('Queen', 'DamageFireball', 250), 250);
global.mod_queenDacid = mod_changes(ini_read_real('Queen', 'DamageAcid', 80), 80);

// PlantDrain
global.mod_plaintdrainPS = mod_changes(ini_read_real('PlantDrain', 'PowerSuit', 0.1), 0.1);
global.mod_plaintdrainVS = mod_changes(ini_read_real('PlantDrain', 'VariaSuit', 0.05), 0.05);
//LavaBurn
global.mod_lavaburnPS = mod_changes(ini_read_real('LavaBurn', 'PowerSuit', 0.1), 0.1);
global.mod_lavaburnVS = mod_changes(ini_read_real('LavaBurn', 'VariaSuit', 0.05), 0.05);
// Spikes
global.mod_spikes1 = mod_changes(ini_read_real('Spikes', 'Damage1', 3), 3);
global.mod_spikes2 = mod_changes(ini_read_real('Spikes', 'Damage2', 7), 7);
global.mod_spikes3 = mod_changes(ini_read_real('Spikes', 'Damage3', 25), 25);
global.mod_spikes4 = mod_changes(ini_read_real('Spikes', 'Damage4', 40), 40);
global.mod_spikesceiling = mod_changes(ini_read_real('Spikes', 'DamageCeiling', 10), 10);
global.mod_spikeszeta = mod_changes(ini_read_real('Spikes', 'DamageZeta', 25), 25);
// RoboMineProjectile
global.mod_robominedamage = mod_changes(ini_read_real('RoboMineProjectile', 'Damage', 30), 30);
// BladeBot
global.mod_bladebotDamage = mod_changes(ini_read_real('BladeBot', 'Damage', 60), 60);

// Core-X
// Arachnus
global.mod_coreArachnusDamage = ini_read_real("CoreXArachnus", "Damage", 15);
global.mod_coreArachnusHealthBlue = ini_read_real("CoreXArachnus", "HealthBlue", 1);
global.mod_coreArachnusHealthYellow = ini_read_real("CoreXArachnus", "HealthYellow", 2);
global.mod_coreArachnusHealthRed = ini_read_real("CoreXArachnus", "HealthRed", 2);

// Torizo
global.mod_coreTorizoDamage = ini_read_real("CoreXTorizo", "Damage", 25);
global.mod_coreTorizoHealthBlue = ini_read_real("CoreXTorizo", "HealthBlue", 2);
global.mod_coreTorizoHealthYellow = ini_read_real("CoreXTorizo", "HealthYellow", 2);
global.mod_coreTorizoHealthRed = ini_read_real("CoreXTorizo", "HealthRed", 2);

// Genesis
global.mod_coreGenesisDamage = ini_read_real("CoreXGenesis", "Damage", 40);
global.mod_coreGenesisHealthBlue = ini_read_real("CoreXGenesis", "HealthBlue", 2);
global.mod_coreGenesisHealthYellow = ini_read_real("CoreXGenesis", "HealthYellow", 3);
global.mod_coreGenesisHealthRed = ini_read_real("CoreXGenesis", "HealthRed", 3);

// Eris
global.mod_coreErisDamage = ini_read_real("CoreXSerris", "Damage", 65);
global.mod_coreErisHealthBlue = ini_read_real("CoreXSerris", "HealthBlue", 3);
global.mod_coreErisHealthYellow = ini_read_real("CoreXSerris", "HealthYellow", 4);
global.mod_coreErisHealthRed = ini_read_real("CoreXSerris", "HealthRed", 3);

// Translator Debug Room
// oControl.mod_debugRoom = ini_read_real('TranslatorDebug', 'Enable', 0);

// Close ini file
ini_close();

#define mod_changes

//if (global.mod_cheating == 1) { return abs(argument0); }
if (argument0 < argument1) { return argument1; }
return argument0;

#define mod_wat_scr
/*
switch (argument2)
{
    case 'ETanks':
    if (argument0 > 20) { return 20; }
    if (argument0 < 0) { return 0; }
    break;
    case 'Missiles':
    if (argument0 > 149) { return 149; }
    if (argument0 < 0) { return 0; }
    break;
    case 'SuperMissiles':
    case 'PowerBombs':
    if (argument0 > 24) { return 24; }
    if (argument0 < 0) { return 0; }
    break;
}

//global.difficulty

//if (global.mod_cheating == 1) { return abs(argument0); }
return argument0;

#define scr_randomizer_encrypted
/*
global.maprandom = ds_map_create();


ds_map_replace(global.maprandom, oControl.mod_bombs, 0);
ds_map_replace(global.maprandom, 1, 1);
ds_map_replace(global.maprandom, oControl.mod_spider, 2);
ds_map_replace(global.maprandom, oControl.mod_jumpball, 3);
ds_map_replace(global.maprandom, oControl.mod_hijump, 4);
ds_map_replace(global.maprandom, oControl.mod_varia, 5);
ds_map_replace(global.maprandom, oControl.mod_spacejump, 6);
ds_map_replace(global.maprandom, oControl.mod_speedbooster, 7);
ds_map_replace(global.maprandom, oControl.mod_screwattack, 8);
ds_map_replace(global.maprandom, oControl.mod_charge, 10);
ds_map_replace(global.maprandom, oControl.mod_ice, 11);
ds_map_replace(global.maprandom, oControl.mod_wave, 12);
ds_map_replace(global.maprandom, oControl.mod_spazer, 13);
ds_map_replace(global.maprandom, oControl.mod_plasma, 14);



ini_open(working_directory + "random" + string(global.saveslot + 1) + ".ini");
ini_write_string("Items", "Random", ds_map_write(global.maprandom));

ini_close();




#define scr_randomizer_read
//This script should not be used anymore!
/*

//global.maprandom = ds_map_create();

scr_rand_encrypt_read();


ini_open(working_directory + "random" + string(global.saveslot + 1) + ".ini");
/* comment
oControl.mod_bombs = ini_read_real('Items', '0', 0);
oControl.mod_spider = ini_read_real('Items', '2', 2);
oControl.mod_jumpball = ini_read_real('Items', '3', 3);
oControl.mod_hijump = ini_read_real('Items', '4', 4);
oControl.mod_varia = ini_read_real('Items', '5', 5);
oControl.mod_spacejump = ini_read_real('Items', '6', 6);
oControl.mod_speedbooster = ini_read_real('Items', '7', 7);
oControl.mod_screwattack = ini_read_real('Items', '8', 8);
oControl.mod_charge = ini_read_real('Items', '10', 10);
oControl.mod_ice = ini_read_real('Items', '11', 11);
oControl.mod_wave = ini_read_real('Items', '12', 12);
oControl.mod_spazer = ini_read_real('Items', '13', 13);
oControl.mod_plasma = ini_read_real('Items', '14', 14);
// uncomment
//Items
//Missiles
oControl.mod_52 = ini_read_real('Items', '52', 52);
oControl.mod_53 = ini_read_real('Items', '53', 53);
oControl.mod_54 = ini_read_real('Items', '54', 54);
oControl.mod_55 = ini_read_real('Items', '55', 55);
oControl.mod_56 = ini_read_real('Items', '56', 56);
oControl.mod_57 = ini_read_real('Items', '57', 57);
oControl.mod_60 = ini_read_real('Items', '60', 60);
oControl.mod_100 = ini_read_real('Items', '100', 100);
oControl.mod_101 = ini_read_real('Items', '101', 101);
oControl.mod_102 = ini_read_real('Items', '102', 102);
oControl.mod_104 = ini_read_real('Items', '104', 104);
oControl.mod_105 = ini_read_real('Items', '105', 105);
oControl.mod_106 = ini_read_real('Items', '106', 106);
oControl.mod_107 = ini_read_real('Items', '107', 107);
oControl.mod_109 = ini_read_real('Items', '109', 109);
oControl.mod_111 = ini_read_real('Items', '111', 111);
oControl.mod_150 = ini_read_real('Items', '150', 150);
oControl.mod_151 = ini_read_real('Items', '151', 151);
oControl.mod_152 = ini_read_real('Items', '152', 152);
oControl.mod_153 = ini_read_real('Items', '153', 153);
oControl.mod_154 = ini_read_real('Items', '154', 154);
oControl.mod_155 = ini_read_real('Items', '155', 155);
oControl.mod_156 = ini_read_real('Items', '156', 156);
oControl.mod_159 = ini_read_real('Items', '159', 159);
oControl.mod_161 = ini_read_real('Items', '161', 161);
oControl.mod_163 = ini_read_real('Items', '163', 163);
oControl.mod_202 = ini_read_real('Items', '202', 202);
oControl.mod_203 = ini_read_real('Items', '203', 203);
oControl.mod_204 = ini_read_real('Items', '204', 204);
oControl.mod_205 = ini_read_real('Items', '205', 205);
oControl.mod_208 = ini_read_real('Items', '208', 208);
oControl.mod_210 = ini_read_real('Items', '210', 210);
oControl.mod_211 = ini_read_real('Items', '211', 211);
oControl.mod_214 = ini_read_real('Items', '214', 214);
oControl.mod_250 = ini_read_real('Items', '250', 250);
oControl.mod_252 = ini_read_real('Items', '252', 252);
oControl.mod_255 = ini_read_real('Items', '255', 255);
oControl.mod_257 = ini_read_real('Items', '257', 257);
oControl.mod_259 = ini_read_real('Items', '259', 259);
oControl.mod_303 = ini_read_real('Items', '303', 303);
oControl.mod_304 = ini_read_real('Items', '304', 304);
oControl.mod_307 = ini_read_real('Items', '307', 307);
oControl.mod_308 = ini_read_real('Items', '308', 308);
oControl.mod_309 = ini_read_real('Items', '309', 309);
//Super Missiles
oControl.mod_51 = ini_read_real('Items', '51', 51);
oControl.mod_110 = ini_read_real('Items', '110', 110);
oControl.mod_162 = ini_read_real('Items', '162', 162);
oControl.mod_206 = ini_read_real('Items', '206', 206); //SPECIAL
oControl.mod_207 = ini_read_real('Items', '207', 207);
oControl.mod_209 = ini_read_real('Items', '209', 209);
oControl.mod_215 = ini_read_real('Items', '215', 215);
oControl.mod_256 = ini_read_real('Items', '256', 256);
oControl.mod_300 = ini_read_real('Items', '300', 300);
oControl.mod_305 = ini_read_real('Items', '305', 305);
//Energy Tanks
oControl.mod_50 = ini_read_real('Items', '50', 50);
oControl.mod_103 = ini_read_real('Items', '103', 103);
oControl.mod_108 = ini_read_real('Items', '108', 108);
oControl.mod_157 = ini_read_real('Items', '157', 157);
oControl.mod_158 = ini_read_real('Items', '158', 158);
oControl.mod_200 = ini_read_real('Items', '200', 200);
oControl.mod_201 = ini_read_real('Items', '201', 201);
oControl.mod_251 = ini_read_real('Items', '251', 251);
oControl.mod_254 = ini_read_real('Items', '254', 254);
oControl.mod_306 = ini_read_real('Items', '306', 306);
//Power Bombs
oControl.mod_58 = ini_read_real('Items', '58', 58);
oControl.mod_59 = ini_read_real('Items', '59', 59);
oControl.mod_112 = ini_read_real('Items', '112', 112);
oControl.mod_160 = ini_read_real('Items', '160', 160);
oControl.mod_212 = ini_read_real('Items', '212', 212);
oControl.mod_213 = ini_read_real('Items', '213', 213);
oControl.mod_253 = ini_read_real('Items', '253', 253); //SPECIAL
oControl.mod_258 = ini_read_real('Items', '258', 258);
oControl.mod_301 = ini_read_real('Items', '301', 301);
oControl.mod_302 = ini_read_real('Items', '302', 302);


ini_close();
/*

#define scr_variasuitswap
if ((global.item[9] == 1) && (global.currentsuit == 2)) { //syntax fixed for YYC?
    //show_debug_message("TRYING TO SET GRAVITY");
    global.currentsuit = 2;
} else { 
    //show_debug_message("TRYING TO SET VARIA");
    global.currentsuit = 1; 
}

#define spawn_many_powerups_tank
/// spawn_many_powerups(region_x, region_y, region__width, region_height)
repeat (20) instance_create(argument0 + random(argument2), argument1 + random(argument3), oHPickupBig);
if (global.maxmissiles > 0) {
    repeat (20) instance_create(argument0 + random(argument2), argument1 + random(argument3), oMPickup);
}
if (global.maxsmissiles > 0) {
    repeat (5) instance_create(argument0 + random(argument2), argument1 + random(argument3), oSMPickup);
}
if ((global.item[0] == 0 && global.maxpbombs > 0) || oControl.mod_insanitymode == 1) 
{
    repeat (5) instance_create(argument0 + random(argument2), argument1 + random(argument3), oPBPickup);
}

#define scr_disableplayercontrol
global.enablecontrol = 0;
with (oCharacter) {
    kLeft = 0;
    kRight = 0;
    kUp = 0;
    kDown = 0;
    kJump = 0;
    kJumpPressed = 0;
    kRun = 0;
    kAim = 0;
    kFire = 0;
    kMissile = 0;
    if (state == SUPERJUMP) {
        state = JUMPING;
        vjump = 1;
        xVel = 0;
        yVel = 0;
        sfx_stop(sndSJLoop);
    }
    //state = STANDING;
    
}

#define scr_rand_encrypt_read
/*

if (file_exists(working_directory + "save" + string(global.saveslot + 1) + ".dat"))
{   

    global.maprandom = ds_map_secure_load(working_directory + "save" + string(global.saveslot + 1) + ".dat");
    
    var t = (!is_undefined(global.maprandom))
    
    if (!is_undefined(global.maprandom))  oControl.mod_bombs = ds_map_find_value(global.maprandom, "0");
    oControl.mod_spider = ds_map_find_value(global.maprandom, "2");
    oControl.mod_jumpball = ds_map_find_value(global.maprandom, "3");
    oControl.mod_hijump = ds_map_find_value(global.maprandom, "4");
    oControl.mod_varia = ds_map_find_value(global.maprandom, "5");
    oControl.mod_spacejump = ds_map_find_value(global.maprandom, "6");
    oControl.mod_speedbooster = ds_map_find_value(global.maprandom, "7");
    oControl.mod_screwattack = ds_map_find_value(global.maprandom, "8");
    oControl.mod_charge = ds_map_find_value(global.maprandom, "10");
    oControl.mod_ice = ds_map_find_value(global.maprandom, "11");
    oControl.mod_wave = ds_map_find_value(global.maprandom, "12");
    oControl.mod_spazer = ds_map_find_value(global.maprandom, "13");
    oControl.mod_plasma = ds_map_find_value(global.maprandom, "14");    
    
    //Missiles
    oControl.mod_52 = ds_map_find_value(global.maprandom, "52");
    oControl.mod_53 = ds_map_find_value(global.maprandom, "53");
    oControl.mod_54 = ds_map_find_value(global.maprandom, "54");
    oControl.mod_55 = ds_map_find_value(global.maprandom, "55");
    oControl.mod_56 = ds_map_find_value(global.maprandom, "56");
    oControl.mod_57 = ds_map_find_value(global.maprandom, "57");
    oControl.mod_60 = ds_map_find_value(global.maprandom, "60");
    oControl.mod_100 = ds_map_find_value(global.maprandom, "100");
    oControl.mod_101 = ds_map_find_value(global.maprandom, "101");
    oControl.mod_102 = ds_map_find_value(global.maprandom, "102");
    oControl.mod_104 = ds_map_find_value(global.maprandom, "104");
    oControl.mod_105 = ds_map_find_value(global.maprandom, "105");
    oControl.mod_106 = ds_map_find_value(global.maprandom, "106");
    oControl.mod_107 = ds_map_find_value(global.maprandom, "107");
    oControl.mod_109 = ds_map_find_value(global.maprandom, "109");
    oControl.mod_111 = ds_map_find_value(global.maprandom, "111");
    oControl.mod_150 = ds_map_find_value(global.maprandom, "150");
    oControl.mod_151 = ds_map_find_value(global.maprandom, "151");
    oControl.mod_152 = ds_map_find_value(global.maprandom, "152");
    oControl.mod_153 = ds_map_find_value(global.maprandom, "153");
    oControl.mod_154 = ds_map_find_value(global.maprandom, "154");
    oControl.mod_155 = ds_map_find_value(global.maprandom, "155");
    oControl.mod_156 = ds_map_find_value(global.maprandom, "156");
    oControl.mod_159 = ds_map_find_value(global.maprandom, "159");
    oControl.mod_161 = ds_map_find_value(global.maprandom, "161");
    oControl.mod_163 = ds_map_find_value(global.maprandom, "163");
    oControl.mod_202 = ds_map_find_value(global.maprandom, "202");
    oControl.mod_203 = ds_map_find_value(global.maprandom, "203");
    oControl.mod_204 = ds_map_find_value(global.maprandom, "204");
    oControl.mod_205 = ds_map_find_value(global.maprandom, "205");
    oControl.mod_208 = ds_map_find_value(global.maprandom, "208");
    oControl.mod_210 = ds_map_find_value(global.maprandom, "210");
    oControl.mod_211 = ds_map_find_value(global.maprandom, "211");
    oControl.mod_214 = ds_map_find_value(global.maprandom, "214");
    oControl.mod_250 = ds_map_find_value(global.maprandom, "250");
    oControl.mod_252 = ds_map_find_value(global.maprandom, "252");
    oControl.mod_255 = ds_map_find_value(global.maprandom, "255");
    oControl.mod_257 = ds_map_find_value(global.maprandom, "257");
    oControl.mod_259 = ds_map_find_value(global.maprandom, "259");
    oControl.mod_303 = ds_map_find_value(global.maprandom, "303");
    oControl.mod_304 = ds_map_find_value(global.maprandom, "304");
    oControl.mod_307 = ds_map_find_value(global.maprandom, "307");
    oControl.mod_308 = ds_map_find_value(global.maprandom, "308");
    oControl.mod_309 = ds_map_find_value(global.maprandom, "309");
    //Super Missiles
    oControl.mod_51 = ds_map_find_value(global.maprandom, "51");
    oControl.mod_110 = ds_map_find_value(global.maprandom, "110");;
    oControl.mod_162 = ds_map_find_value(global.maprandom, "162");
    oControl.mod_206 = ds_map_find_value(global.maprandom, "206"); //SPECIAL
    oControl.mod_207 = ds_map_find_value(global.maprandom, "207");
    oControl.mod_209 = ds_map_find_value(global.maprandom, "209");
    oControl.mod_215 = ds_map_find_value(global.maprandom, "215");
    oControl.mod_256 = ds_map_find_value(global.maprandom, "256");
    oControl.mod_300 = ds_map_find_value(global.maprandom, "300");
    oControl.mod_305 = ds_map_find_value(global.maprandom, "305");
    //Energy Tanks
    oControl.mod_50 = ds_map_find_value(global.maprandom, "50");
    oControl.mod_103 = ds_map_find_value(global.maprandom, "103");
    oControl.mod_108 = ds_map_find_value(global.maprandom, "108");
    oControl.mod_157 = ds_map_find_value(global.maprandom, "157");
    oControl.mod_158 = ds_map_find_value(global.maprandom, "158");
    oControl.mod_200 = ds_map_find_value(global.maprandom, "200");
    oControl.mod_201 = ds_map_find_value(global.maprandom, "201");
    oControl.mod_251 = ds_map_find_value(global.maprandom, "251");
    oControl.mod_254 = ds_map_find_value(global.maprandom, "254");
    oControl.mod_306 = ds_map_find_value(global.maprandom, "306");
    //Power Bombs
    oControl.mod_58 = ds_map_find_value(global.maprandom, "58");
    oControl.mod_59 = ds_map_find_value(global.maprandom, "59");
    oControl.mod_112 = ds_map_find_value(global.maprandom, "112");
    oControl.mod_160 = ds_map_find_value(global.maprandom, "160");
    oControl.mod_212 = ds_map_find_value(global.maprandom, "212");
    oControl.mod_213 = ds_map_find_value(global.maprandom, "213");
    oControl.mod_253 = ds_map_find_value(global.maprandom, "253"); //SPECIAL
    oControl.mod_258 = ds_map_find_value(global.maprandom, "258");
    oControl.mod_301 = ds_map_find_value(global.maprandom, "301");
    oControl.mod_302 = ds_map_find_value(global.maprandom, "302");
    
    oControl.mod_purerandombool = ds_map_find_value(global.maprandom, "PureRandom");
    oControl.mod_randomgamebool = ds_map_find_value(global.maprandom, "RandomGame");
    

}


#define scr_rand_encrypt_write
/*
scr_default_maprandom();

ds_map_secure_save(global.maprandom, working_directory + "save" + string(global.saveslot + 1) + ".dat");




#define scr_fixitem_encrypted
/// scr_fixitem_encrypted(original_item, item_location)
if (file_exists(working_directory + "\swap.ini")) file_delete(working_directory + "\swap.ini");
ini_open(working_directory + "\swap.ini");

ini_write_real('Items', string(oControl.mod_plasma), 14);
ini_write_real('Items', string(oControl.mod_spazer), 13);
ini_write_real('Items', string(oControl.mod_wave), 12);
ini_write_real('Items', string(oControl.mod_ice), 11);
ini_write_real('Items', string(oControl.mod_charge), 10);
ini_write_real('Items', string(oControl.mod_gravity), 9);
ini_write_real('Items', string(oControl.mod_screwattack), 8);
ini_write_real('Items', string(oControl.mod_speedbooster), 7);
ini_write_real('Items', string(oControl.mod_spacejump), 6);
ini_write_real('Items', string(oControl.mod_varia), 5);
ini_write_real('Items', string(oControl.mod_hijump), 4);
ini_write_real('Items', string(oControl.mod_jumpball), 3);
ini_write_real('Items', string(oControl.mod_spider), 2);
ini_write_real('Items', string(oControl.mod_bombs), 0);
//Missiles
ini_write_real('Items', string(oControl.mod_52), 52);
ini_write_real('Items', string(oControl.mod_53), 53);
ini_write_real('Items', string(oControl.mod_54), 54);
ini_write_real('Items', string(oControl.mod_55), 55);
ini_write_real('Items', string(oControl.mod_56), 56);
ini_write_real('Items', string(oControl.mod_57), 57);
ini_write_real('Items', string(oControl.mod_60), 60);
ini_write_real('Items', string(oControl.mod_100), 100);
ini_write_real('Items', string(oControl.mod_101), 101);
ini_write_real('Items', string(oControl.mod_102), 102);
ini_write_real('Items', string(oControl.mod_104), 104);
ini_write_real('Items', string(oControl.mod_105), 105);
ini_write_real('Items', string(oControl.mod_106), 106);
ini_write_real('Items', string(oControl.mod_107), 107);
ini_write_real('Items', string(oControl.mod_109), 109);
ini_write_real('Items', string(oControl.mod_111), 111);
ini_write_real('Items', string(oControl.mod_150), 150);
ini_write_real('Items', string(oControl.mod_151), 151);
ini_write_real('Items', string(oControl.mod_152), 152);
ini_write_real('Items', string(oControl.mod_153), 153);
ini_write_real('Items', string(oControl.mod_154), 154);
ini_write_real('Items', string(oControl.mod_155), 155);
ini_write_real('Items', string(oControl.mod_156), 156);
ini_write_real('Items', string(oControl.mod_159), 159);
ini_write_real('Items', string(oControl.mod_161), 161);
ini_write_real('Items', string(oControl.mod_163), 163);
ini_write_real('Items', string(oControl.mod_202), 202);
ini_write_real('Items', string(oControl.mod_203), 203);
ini_write_real('Items', string(oControl.mod_204), 204);
ini_write_real('Items', string(oControl.mod_205), 205);
ini_write_real('Items', string(oControl.mod_208), 208);
ini_write_real('Items', string(oControl.mod_210), 210);
ini_write_real('Items', string(oControl.mod_211), 211);
ini_write_real('Items', string(oControl.mod_214), 214);
ini_write_real('Items', string(oControl.mod_250), 250);
ini_write_real('Items', string(oControl.mod_252), 252);
ini_write_real('Items', string(oControl.mod_255), 255);
ini_write_real('Items', string(oControl.mod_257), 257);
ini_write_real('Items', string(oControl.mod_259), 259);
ini_write_real('Items', string(oControl.mod_303), 303);
ini_write_real('Items', string(oControl.mod_304), 304);
ini_write_real('Items', string(oControl.mod_307), 307);
ini_write_real('Items', string(oControl.mod_308), 308);
ini_write_real('Items', string(oControl.mod_309), 309);
//Super Missiles
ini_write_real('Items', string(oControl.mod_51), 51);
ini_write_real('Items', string(oControl.mod_110), 110);
ini_write_real('Items', string(oControl.mod_162), 162);
ini_write_real('Items', string(oControl.mod_206), 206);
ini_write_real('Items', string(oControl.mod_207), 207);
ini_write_real('Items', string(oControl.mod_209), 209);
ini_write_real('Items', string(oControl.mod_215), 215);
ini_write_real('Items', string(oControl.mod_256), 256);
ini_write_real('Items', string(oControl.mod_300), 300);
ini_write_real('Items', string(oControl.mod_305), 305);
//Energy Tanks
ini_write_real('Items', string(oControl.mod_50), 50);
ini_write_real('Items', string(oControl.mod_103), 103);
ini_write_real('Items', string(oControl.mod_108), 108);
ini_write_real('Items', string(oControl.mod_157), 157);
ini_write_real('Items', string(oControl.mod_158), 158);
ini_write_real('Items', string(oControl.mod_200), 200);
ini_write_real('Items', string(oControl.mod_201), 201);
ini_write_real('Items', string(oControl.mod_251), 251);
ini_write_real('Items', string(oControl.mod_254), 254);
ini_write_real('Items', string(oControl.mod_306), 306);
//Power Bombs
ini_write_real('Items', string(oControl.mod_58), 58);
ini_write_real('Items', string(oControl.mod_59), 59);
ini_write_real('Items', string(oControl.mod_112), 112);
ini_write_real('Items', string(oControl.mod_160), 160);
ini_write_real('Items', string(oControl.mod_212), 212);
ini_write_real('Items', string(oControl.mod_213), 213);
ini_write_real('Items', string(oControl.mod_253), 253);
ini_write_real('Items', string(oControl.mod_258), 258);
ini_write_real('Items', string(oControl.mod_301), 301);
ini_write_real('Items', string(oControl.mod_302), 302);

ini_close();
ini_open(working_directory + "\swap.ini");

var can_return = false;
if (ini_read_real('Items', string(argument0), argument0) == argument0) { can_return = true; }
if (can_return) { ini_close(); return argument0; }

var swap_location = ini_read_real('Items', string(argument0), argument0)
var swap_item = 1;
//Powerups
if (ini_read_real('Items', '0', 0) == argument1) { swap_item = 0; }
if (ini_read_real('Items', '2', 2) == argument1) { swap_item = 2; }
if (ini_read_real('Items', '3', 3) == argument1) { swap_item = 3; }
if (ini_read_real('Items', '4', 4) == argument1) { swap_item = 4; }
if (ini_read_real('Items', '5', 5) == argument1) { swap_item = 5; }
if (ini_read_real('Items', '6', 6) == argument1) { swap_item = 6; }
if (ini_read_real('Items', '7', 7) == argument1) { swap_item = 7; }
if (ini_read_real('Items', '8', 8) == argument1) { swap_item = 8; }
if (ini_read_real('Items', '10', 10) == argument1) { swap_item = 10; }
if (ini_read_real('Items', '11', 11) == argument1) { swap_item = 11; }
if (ini_read_real('Items', '12', 12) == argument1) { swap_item = 12; }
if (ini_read_real('Items', '13', 13) == argument1) { swap_item = 13; }
if (ini_read_real('Items', '14', 14) == argument1) { swap_item = 14; }
//Missiles
if (ini_read_real('Items', '52', 52) == argument1) { swap_item = 52; }
if (ini_read_real('Items', '53', 53) == argument1) { swap_item = 53; }
if (ini_read_real('Items', '54', 54) == argument1) { swap_item = 54; }
if (ini_read_real('Items', '55', 55) == argument1) { swap_item = 55; }
if (ini_read_real('Items', '56', 56) == argument1) { swap_item = 56; }
if (ini_read_real('Items', '57', 57) == argument1) { swap_item = 57; }
if (ini_read_real('Items', '60', 60) == argument1) { swap_item = 60; }
if (ini_read_real('Items', '100', 100) == argument1) { swap_item = 100; }
if (ini_read_real('Items', '101', 101) == argument1) { swap_item = 101; }
if (ini_read_real('Items', '102', 102) == argument1) { swap_item = 102; }
if (ini_read_real('Items', '104', 104) == argument1) { swap_item = 104; }
if (ini_read_real('Items', '105', 105) == argument1) { swap_item = 105; }
if (ini_read_real('Items', '106', 106) == argument1) { swap_item = 106; }
if (ini_read_real('Items', '107', 107) == argument1) { swap_item = 107; }
if (ini_read_real('Items', '109', 109) == argument1) { swap_item = 109; }
if (ini_read_real('Items', '111', 111) == argument1) { swap_item = 111; }
if (ini_read_real('Items', '150', 150) == argument1) { swap_item = 150; }
if (ini_read_real('Items', '151', 151) == argument1) { swap_item = 151; }
if (ini_read_real('Items', '152', 152) == argument1) { swap_item = 152; }
if (ini_read_real('Items', '153', 153) == argument1) { swap_item = 153; }
if (ini_read_real('Items', '154', 154) == argument1) { swap_item = 154; }
if (ini_read_real('Items', '155', 155) == argument1) { swap_item = 155; }
if (ini_read_real('Items', '156', 156) == argument1) { swap_item = 156; }
if (ini_read_real('Items', '159', 159) == argument1) { swap_item = 159; }
if (ini_read_real('Items', '161', 161) == argument1) { swap_item = 161; }
if (ini_read_real('Items', '163', 163) == argument1) { swap_item = 163; }
if (ini_read_real('Items', '202', 202) == argument1) { swap_item = 202; }
if (ini_read_real('Items', '203', 203) == argument1) { swap_item = 203; }
if (ini_read_real('Items', '204', 204) == argument1) { swap_item = 204; }
if (ini_read_real('Items', '205', 205) == argument1) { swap_item = 205; }
if (ini_read_real('Items', '208', 208) == argument1) { swap_item = 208; }
if (ini_read_real('Items', '210', 210) == argument1) { swap_item = 210; }
if (ini_read_real('Items', '211', 211) == argument1) { swap_item = 211; }
if (ini_read_real('Items', '214', 214) == argument1) { swap_item = 214; }
if (ini_read_real('Items', '250', 250) == argument1) { swap_item = 250; }
if (ini_read_real('Items', '252', 252) == argument1) { swap_item = 252; }
if (ini_read_real('Items', '255', 255) == argument1) { swap_item = 255; }
if (ini_read_real('Items', '257', 257) == argument1) { swap_item = 257; }
if (ini_read_real('Items', '259', 259) == argument1) { swap_item = 259; }
if (ini_read_real('Items', '303', 303) == argument1) { swap_item = 303; }
if (ini_read_real('Items', '304', 304) == argument1) { swap_item = 304; }
if (ini_read_real('Items', '307', 307) == argument1) { swap_item = 307; }
if (ini_read_real('Items', '308', 308) == argument1) { swap_item = 308; }
if (ini_read_real('Items', '309', 309) == argument1) { swap_item = 309; }
//Super Missiles
if (ini_read_real('Items', '51', 51) == argument1) { swap_item = 51; }
if (ini_read_real('Items', '110', 110) == argument1) { swap_item = 110; }
if (ini_read_real('Items', '162', 162) == argument1) { swap_item = 162; }
if (ini_read_real('Items', '206', 206) == argument1) { swap_item = 206; }
if (ini_read_real('Items', '207', 207) == argument1) { swap_item = 207; }
if (ini_read_real('Items', '209', 209) == argument1) { swap_item = 209; }
if (ini_read_real('Items', '215', 215) == argument1) { swap_item = 215; }
if (ini_read_real('Items', '256', 256) == argument1) { swap_item = 256; }
if (ini_read_real('Items', '300', 300) == argument1) { swap_item = 300; }
if (ini_read_real('Items', '305', 305) == argument1) { swap_item = 305; }
//Energy Tanks
if (ini_read_real('Items', '50', 50) == argument1) { swap_item = 50; }
if (ini_read_real('Items', '103', 103) == argument1) { swap_item = 103; }
if (ini_read_real('Items', '108', 108) == argument1) { swap_item = 108; }
if (ini_read_real('Items', '157', 157) == argument1) { swap_item = 157; }
if (ini_read_real('Items', '158', 158) == argument1) { swap_item = 158; }
if (ini_read_real('Items', '200', 200) == argument1) { swap_item = 200; }
if (ini_read_real('Items', '201', 201) == argument1) { swap_item = 201; }
if (ini_read_real('Items', '251', 251) == argument1) { swap_item = 251; }
if (ini_read_real('Items', '254', 254) == argument1) { swap_item = 254; }
if (ini_read_real('Items', '306', 306) == argument1) { swap_item = 306; }
//Power Bombs
if (ini_read_real('Items', '58', 58) == argument1) { swap_item = 58; }
if (ini_read_real('Items', '59', 59) == argument1) { swap_item = 59; }
if (ini_read_real('Items', '112', 112) == argument1) { swap_item = 112; }
if (ini_read_real('Items', '160', 160) == argument1) { swap_item = 160; }
if (ini_read_real('Items', '212', 212) == argument1) { swap_item = 212; }
if (ini_read_real('Items', '213', 213) == argument1) { swap_item = 213; }
if (ini_read_real('Items', '253', 253) == argument1) { swap_item = 253; }
if (ini_read_real('Items', '258', 258) == argument1) { swap_item = 258; }
if (ini_read_real('Items', '301', 301) == argument1) { swap_item = 301; }
if (ini_read_real('Items', '302', 302) == argument1) { swap_item = 302; }

ini_close();
if (file_exists(working_directory + "\swap.ini")) file_delete(working_directory + "\swap.ini");
if (swap_item == 1) {  return argument0; }

scr_fixitem_switch(argument1, argument0);
scr_fixitem_switch(swap_location, swap_item);

//These settings are saved when saving game.



#define scr_fixitem_switch



//scr_fixitem_switch(temp_item, current_item)

switch (argument0)
{
    case 0:
        oControl.mod_bombs = argument1;
        break;
    case 2:
        oControl.mod_spider = argument1;
        break;
    case 3:
        oControl.mod_jumpball = argument1;
        break;
    case 4:
        oControl.mod_hijump = argument1;
        break;
    case 5:
        oControl.mod_varia = argument1;
        break;
    case 6:
        oControl.mod_spacejump = argument1;
        break;
    case 7:
        oControl.mod_speedbooster = argument1;
        break;
    case 8:
        oControl.mod_screwattack = argument1;
        break;
    case 9:
        oControl.mod_gravity = argument1;
        break;
    case 10:
        oControl.mod_charge = argument1;
        break;
    case 11:
        oControl.mod_ice = argument1;
        break;
    case 12:
        oControl.mod_wave = argument1;
        break;
    case 13:
        oControl.mod_spazer = argument1;
        break;
    case 14:
        oControl.mod_plasma = argument1;
        break;
    //Missiles
    case 52:
        oControl.mod_52 = argument1;
        break;
    case 53:
        oControl.mod_53 = argument1;
        break;
    case 54:
        oControl.mod_54 = argument1;
        break;
    case 55:
        oControl.mod_55 = argument1;
        break;
    case 56:
        oControl.mod_56 = argument1;
        break;
    case 57:
        oControl.mod_57 = argument1;
        break;
    case 60:
        oControl.mod_60 = argument1;
        break;
    case 100:
        oControl.mod_100 = argument1;
        break;
    case 101:
        oControl.mod_101 = argument1;
        break;
    case 102:
        oControl.mod_102 = argument1;
        break;
    case 104:
        oControl.mod_104 = argument1;
        break;
    case 105:
        oControl.mod_105 = argument1;
        break;
    case 106:
        oControl.mod_106 = argument1;
        break;
    case 107:
        oControl.mod_107 = argument1;
        break;
    case 109:
        oControl.mod_109 = argument1;
        break;
    case 111:
        oControl.mod_111 = argument1;
        break;
    case 150:
        oControl.mod_150 = argument1;
        break;
    case 151:
        oControl.mod_151 = argument1;
        break;
    case 152:
        oControl.mod_152 = argument1;
        break;
    case 153:
        oControl.mod_153 = argument1;
        break;
    case 154:
        oControl.mod_154 = argument1;
        break;
    case 155:
        oControl.mod_155 = argument1;
        break;
    case 156:
        oControl.mod_156 = argument1;
        break;
    case 159:
        oControl.mod_159 = argument1;
        break;
    case 161:
        oControl.mod_161 = argument1;
        break;
    case 163:
        oControl.mod_163 = argument1;
        break;
    case 202:
        oControl.mod_202 = argument1;
        break;
    case 203:
        oControl.mod_203 = argument1;
        break;
    case 204:
        oControl.mod_204 = argument1;
        break;
    case 205:
        oControl.mod_205 = argument1;
        break;
    case 208:
        oControl.mod_208 = argument1;
        break;
    case 210:
        oControl.mod_210 = argument1;
        break;
    case 211:
        oControl.mod_211 = argument1;
        break;
    case 214:
        oControl.mod_214 = argument1;
        break;
    case 250:
        oControl.mod_250 = argument1;
        break;
    case 252:
        oControl.mod_252 = argument1;
        break;
    case 255:
        oControl.mod_255 = argument1;
        break;
    case 257:
        oControl.mod_257 = argument1;
        break;
    case 259:
        oControl.mod_259 = argument1;
        break;
    case 303:
        oControl.mod_303 = argument1;
        break;
    case 304:
        oControl.mod_304 = argument1;
        break;
    case 307:
        oControl.mod_307 = argument1;
        break;
    case 308:
        oControl.mod_308 = argument1;
        break;
    case 309:
        oControl.mod_309 = argument1;
        break;
    //Super Missiles
    case 51:
        oControl.mod_51 = argument1;
        break;
    case 110:
        oControl.mod_110 = argument1;
        break;
    case 162:
        oControl.mod_162 = argument1;
        break;
    case 206:
        oControl.mod_206 = argument1;
        break;
    case 207:
        oControl.mod_207 = argument1;
        break;
    case 209:
        oControl.mod_209 = argument1;
        break;
    case 215:
        oControl.mod_215 = argument1;
        break;
    case 256:
        oControl.mod_256 = argument1;
        break;
    case 300:
        oControl.mod_300 = argument1;
        break;
    case 305:
        oControl.mod_305 = argument1;
        break;
    //Energy Tanks
    case 50:
        oControl.mod_50 = argument1;
        break;
    case 103:
        oControl.mod_103 = argument1;
        break;
    case 108:
        oControl.mod_108 = argument1;
        break;
    case 157:
        oControl.mod_157 = argument1;
        break;
    case 158:
        oControl.mod_158 = argument1;
        break;
    case 200:
        oControl.mod_200 = argument1;
        break;
    case 201:
        oControl.mod_201 = argument1;
        break;
    case 251:
        oControl.mod_251 = argument1;
        break;
    case 254:
        oControl.mod_254 = argument1;
        break;
    case 306:
        oControl.mod_306 = argument1;
        break;
    //Powerbombs
    case 58:
        oControl.mod_58 = argument1;
        break;
    case 59:
        oControl.mod_59 = argument1;
        break;
    case 112:
        oControl.mod_112 = argument1;
        break;
    case 160:
        oControl.mod_160 = argument1;
        break;
    case 212:
        oControl.mod_212 = argument1;
        break;
    case 213:
        oControl.mod_213 = argument1;
        break;
    case 253:
        oControl.mod_253 = argument1;
        break;
    case 258:
        oControl.mod_258 = argument1;
        break;
    case 301:
        oControl.mod_301 = argument1;
        break;
    case 302:
        oControl.mod_302 = argument1;
        break;
    
    
}

#define scr_default_global_items
//This script seems to be called excessively on program start.
//Randomizer will take over and act weird otherwise.

oControl.mod_bombs = 0;
oControl.mod_spider = 2;
oControl.mod_jumpball = 3;
oControl.mod_hijump = 4;
oControl.mod_varia = 5;
oControl.mod_spacejump = 6;
oControl.mod_speedbooster = 7;
oControl.mod_screwattack = 8;
oControl.mod_gravity = 9;
oControl.mod_charge = 10;
oControl.mod_ice = 11;
oControl.mod_wave = 12;
oControl.mod_spazer = 13;
oControl.mod_plasma = 14;

//Missiles
oControl.mod_52 = 52;
oControl.mod_53 = 53;
oControl.mod_54 = 54;
oControl.mod_55 = 55;
oControl.mod_56 = 56;
oControl.mod_57 = 57;
oControl.mod_60 = 60;
oControl.mod_100 = 100;
oControl.mod_101 = 101;
oControl.mod_102 = 102;
oControl.mod_104 = 104;
oControl.mod_105 = 105;
oControl.mod_106 = 106;
oControl.mod_107 = 107;
oControl.mod_109 = 109;
oControl.mod_111 = 111;
oControl.mod_150 = 150;
oControl.mod_151 = 151;
oControl.mod_152 = 152;
oControl.mod_153 = 153;
oControl.mod_154 = 154;
oControl.mod_155 = 155;
oControl.mod_156 = 156;
oControl.mod_159 = 159;
oControl.mod_161 = 161;
oControl.mod_163 = 163;
oControl.mod_202 = 202;
oControl.mod_203 = 203;
oControl.mod_204 = 204;
oControl.mod_205 = 205;
oControl.mod_208 = 208;
oControl.mod_210 = 210;
oControl.mod_211 = 211;
oControl.mod_214 = 214;
oControl.mod_250 = 250;
oControl.mod_252 = 252;
oControl.mod_255 = 255;
oControl.mod_257 = 257;
oControl.mod_259 = 259;
oControl.mod_303 = 303;
oControl.mod_304 = 304;
oControl.mod_307 = 307;
oControl.mod_308 = 308;
oControl.mod_309 = 309;

//Super Missiles
oControl.mod_51 = 51;
oControl.mod_110 = 110;;
oControl.mod_162 = 162;
oControl.mod_206 = 206; //SPECIAL
oControl.mod_207 = 207;
oControl.mod_209 = 209;
oControl.mod_215 = 215;
oControl.mod_256 = 256;
oControl.mod_300 = 300;
oControl.mod_305 = 305;

//Energy Tanks
oControl.mod_50 = 50;
oControl.mod_103 = 103;
oControl.mod_108 = 108;
oControl.mod_157 = 157;
oControl.mod_158 = 158;
oControl.mod_200 = 200;
oControl.mod_201 = 201;
oControl.mod_251 = 251;
oControl.mod_254 = 254;
oControl.mod_306 = 306;

//Power Bombs
oControl.mod_58 = 58;
oControl.mod_59 = 59;
oControl.mod_112 = 112;
oControl.mod_160 = 160;
oControl.mod_212 = 212;
oControl.mod_213 = 213;
oControl.mod_253 = 253; //SPECIAL
oControl.mod_258 = 258;
oControl.mod_301 = 301;
oControl.mod_302 = 302;

//Misc
oControl.mod_purerandombool = 0;
oControl.mod_randomgamebool = 0;
oControl.mod_splitrandom = 0;
oControl.mod_fusion = 0;
oControl.mod_suitchangecheat = 0;
oControl.chozomessage = 0;


//None-saved variables
oControl.mod_monstersextreme = 0;






#define scr_ini_write
// Item = Location - This is how qerty.ini lists items.

if (file_exists(working_directory + "\qwerty.ini")) file_delete(working_directory + "\qwerty.ini");
ini_open(working_directory + "\qwerty.ini");

    
ini_write_real('Items', string(oControl.mod_plasma), 14);
ini_write_real('Items', string(oControl.mod_spazer), 13);
ini_write_real('Items', string(oControl.mod_wave), 12);
ini_write_real('Items', string(oControl.mod_ice), 11);
ini_write_real('Items', string(oControl.mod_charge), 10);
ini_write_real('Items', string(oControl.mod_gravity), 9);
ini_write_real('Items', string(oControl.mod_screwattack), 8);
ini_write_real('Items', string(oControl.mod_speedbooster), 7);
ini_write_real('Items', string(oControl.mod_spacejump), 6);
ini_write_real('Items', string(oControl.mod_varia), 5);
ini_write_real('Items', string(oControl.mod_hijump), 4);
ini_write_real('Items', string(oControl.mod_jumpball), 3);
ini_write_real('Items', string(oControl.mod_spider), 2);
ini_write_real('Items', string(oControl.mod_bombs), 0);
//Missiles
ini_write_real('Items', string(oControl.mod_52), 52);
ini_write_real('Items', string(oControl.mod_53), 53);
ini_write_real('Items', string(oControl.mod_54), 54);
ini_write_real('Items', string(oControl.mod_55), 55);
ini_write_real('Items', string(oControl.mod_56), 56);
ini_write_real('Items', string(oControl.mod_57), 57);
ini_write_real('Items', string(oControl.mod_60), 60);
ini_write_real('Items', string(oControl.mod_100), 100);
ini_write_real('Items', string(oControl.mod_101), 101);
ini_write_real('Items', string(oControl.mod_102), 102);
ini_write_real('Items', string(oControl.mod_104), 104);
ini_write_real('Items', string(oControl.mod_105), 105);
ini_write_real('Items', string(oControl.mod_106), 106);
ini_write_real('Items', string(oControl.mod_107), 107);
ini_write_real('Items', string(oControl.mod_109), 109);
ini_write_real('Items', string(oControl.mod_111), 111);
ini_write_real('Items', string(oControl.mod_150), 150);
ini_write_real('Items', string(oControl.mod_151), 151);
ini_write_real('Items', string(oControl.mod_152), 152);
ini_write_real('Items', string(oControl.mod_153), 153);
ini_write_real('Items', string(oControl.mod_154), 154);
ini_write_real('Items', string(oControl.mod_155), 155);
ini_write_real('Items', string(oControl.mod_156), 156);
ini_write_real('Items', string(oControl.mod_159), 159);
ini_write_real('Items', string(oControl.mod_161), 161);
ini_write_real('Items', string(oControl.mod_163), 163);
ini_write_real('Items', string(oControl.mod_202), 202);
ini_write_real('Items', string(oControl.mod_203), 203);
ini_write_real('Items', string(oControl.mod_204), 204);
ini_write_real('Items', string(oControl.mod_205), 205);
ini_write_real('Items', string(oControl.mod_208), 208);
ini_write_real('Items', string(oControl.mod_210), 210);
ini_write_real('Items', string(oControl.mod_211), 211);
ini_write_real('Items', string(oControl.mod_214), 214);
ini_write_real('Items', string(oControl.mod_250), 250);
ini_write_real('Items', string(oControl.mod_252), 252);
ini_write_real('Items', string(oControl.mod_255), 255);
ini_write_real('Items', string(oControl.mod_257), 257);
ini_write_real('Items', string(oControl.mod_259), 259);
ini_write_real('Items', string(oControl.mod_303), 303);
ini_write_real('Items', string(oControl.mod_304), 304);
ini_write_real('Items', string(oControl.mod_307), 307);
ini_write_real('Items', string(oControl.mod_308), 308);
ini_write_real('Items', string(oControl.mod_309), 309);
//Super Missiles
ini_write_real('Items', string(oControl.mod_51), 51);
ini_write_real('Items', string(oControl.mod_110), 110);
ini_write_real('Items', string(oControl.mod_162), 162);
ini_write_real('Items', string(oControl.mod_206), 206);
ini_write_real('Items', string(oControl.mod_207), 207);
ini_write_real('Items', string(oControl.mod_209), 209);
ini_write_real('Items', string(oControl.mod_215), 215);
ini_write_real('Items', string(oControl.mod_256), 256);
ini_write_real('Items', string(oControl.mod_300), 300);
ini_write_real('Items', string(oControl.mod_305), 305);
//Energy Tanks
ini_write_real('Items', string(oControl.mod_50), 50);
ini_write_real('Items', string(oControl.mod_103), 103);
ini_write_real('Items', string(oControl.mod_108), 108);
ini_write_real('Items', string(oControl.mod_157), 157);
ini_write_real('Items', string(oControl.mod_158), 158);
ini_write_real('Items', string(oControl.mod_200), 200);
ini_write_real('Items', string(oControl.mod_201), 201);
ini_write_real('Items', string(oControl.mod_251), 251);
ini_write_real('Items', string(oControl.mod_254), 254);
ini_write_real('Items', string(oControl.mod_306), 306);
//Power Bombs
ini_write_real('Items', string(oControl.mod_58), 58);
ini_write_real('Items', string(oControl.mod_59), 59);
ini_write_real('Items', string(oControl.mod_112), 112);
ini_write_real('Items', string(oControl.mod_160), 160);
ini_write_real('Items', string(oControl.mod_212), 212);
ini_write_real('Items', string(oControl.mod_213), 213);
ini_write_real('Items', string(oControl.mod_253), 253);
ini_write_real('Items', string(oControl.mod_258), 258);
ini_write_real('Items', string(oControl.mod_301), 301);
ini_write_real('Items', string(oControl.mod_302), 302);

ini_close();
    
 

#define scr_skreeks_destroy
if (oControl.mod_randomgamebool == 1 && global.lavastate > 7) { instance_destroy(); }
else if (oControl.mod_randomgamebool == 0 && global.lavastate > 6) instance_destroy();


#define scr_itemsmenu_original
if (global.item[10]) {
    draw_sprite(sSubScrButton, global.cbeam, x - 28, y - 46);
    draw_text(x - 20, y - 47 + oControl.subScrItemOffset, cbeam);
}
if (global.item[11]) {
    draw_sprite(sSubScrButton, global.ibeam, x - 28, y - 37);
    draw_text(x - 20, y - 38 + oControl.subScrItemOffset, ibeam);
}
if (global.item[12]) {
    draw_sprite(sSubScrButton, global.wbeam, x - 28, y - 28);
    draw_text(x - 20, y - 29 + oControl.subScrItemOffset, wbeam);
}
if (global.item[13]) {
    draw_sprite(sSubScrButton, global.sbeam, x - 28, y - 19);
    draw_text(x - 20, y - 20 + oControl.subScrItemOffset, sbeam);
}
if (global.item[14]) {
    draw_sprite(sSubScrButton, global.pbeam, x - 28, y - 10);
    draw_text(x - 20, y - 11 + oControl.subScrItemOffset, pbeam);
}

#define scr_itemsmenu_swap
if (global.item[10]) {
    draw_sprite(sSubScrButton, global.cbeam, x - 28, y - 46);
    draw_text(x - 20, y - 47 + oControl.subScrItemOffset, cbeam);
}
if (global.item[12]) {
    draw_sprite(sSubScrButton, global.wbeam, x - 28, y - 37);
    draw_text(x - 20, y - 38 + oControl.subScrItemOffset, wbeam);
}
if (global.item[13]) {
    draw_sprite(sSubScrButton, global.sbeam, x - 28, y - 28);
    draw_text(x - 20, y - 29 + oControl.subScrItemOffset, sbeam);
}
if (global.item[14]) {
    draw_sprite(sSubScrButton, global.pbeam, x - 28, y - 19);
    draw_text(x - 20, y - 20 + oControl.subScrItemOffset, pbeam);
}
if (global.item[11]) {
    draw_sprite(sSubScrButton, global.ibeam, x - 28, y - 10);
    draw_text(x - 20, y - 11 + oControl.subScrItemOffset, ibeam);
    
    //ibeam
}

#define scr_default_maprandom

//Power ups
ds_map_replace(global.maprandom, "0", oControl.mod_bombs);
ds_map_replace(global.maprandom, "2", oControl.mod_spider);
ds_map_replace(global.maprandom, "3", oControl.mod_jumpball);
ds_map_replace(global.maprandom, "4", oControl.mod_hijump);
ds_map_replace(global.maprandom, "5", oControl.mod_varia);
ds_map_replace(global.maprandom, "6", oControl.mod_spacejump);
ds_map_replace(global.maprandom, "7", oControl.mod_speedbooster);
ds_map_replace(global.maprandom, "8", oControl.mod_screwattack);
ds_map_replace(global.maprandom, "9", oControl.mod_gravity);
ds_map_replace(global.maprandom, "10", oControl.mod_charge);
ds_map_replace(global.maprandom, "11", oControl.mod_ice);
ds_map_replace(global.maprandom, "12", oControl.mod_wave);
ds_map_replace(global.maprandom, "13", oControl.mod_spazer);
ds_map_replace(global.maprandom, "14", oControl.mod_plasma);
//Missiles
ds_map_replace(global.maprandom, "52", oControl.mod_52);
ds_map_replace(global.maprandom, "53", oControl.mod_53);
ds_map_replace(global.maprandom, "54", oControl.mod_54);
ds_map_replace(global.maprandom, "55", oControl.mod_55);
ds_map_replace(global.maprandom, "56", oControl.mod_56);
ds_map_replace(global.maprandom, "57", oControl.mod_57);
ds_map_replace(global.maprandom, "60", oControl.mod_60);
ds_map_replace(global.maprandom, "100", oControl.mod_100);
ds_map_replace(global.maprandom, "101", oControl.mod_101);
ds_map_replace(global.maprandom, "102", oControl.mod_102);
ds_map_replace(global.maprandom, "104", oControl.mod_104);
ds_map_replace(global.maprandom, "105", oControl.mod_105);
ds_map_replace(global.maprandom, "106", oControl.mod_106);
ds_map_replace(global.maprandom, "107", oControl.mod_107);
ds_map_replace(global.maprandom, "109", oControl.mod_109);
ds_map_replace(global.maprandom, "111", oControl.mod_111);
ds_map_replace(global.maprandom, "150", oControl.mod_150);
ds_map_replace(global.maprandom, "151", oControl.mod_151);
ds_map_replace(global.maprandom, "152", oControl.mod_152);
ds_map_replace(global.maprandom, "153", oControl.mod_153);
ds_map_replace(global.maprandom, "154", oControl.mod_154);
ds_map_replace(global.maprandom, "155", oControl.mod_155);
ds_map_replace(global.maprandom, "156", oControl.mod_156);
ds_map_replace(global.maprandom, "159", oControl.mod_159);
ds_map_replace(global.maprandom, "161", oControl.mod_161);
ds_map_replace(global.maprandom, "163", oControl.mod_163);
ds_map_replace(global.maprandom, "202", oControl.mod_202);
ds_map_replace(global.maprandom, "203", oControl.mod_203);
ds_map_replace(global.maprandom, "204", oControl.mod_204);
ds_map_replace(global.maprandom, "205", oControl.mod_205);
ds_map_replace(global.maprandom, "208", oControl.mod_208);
ds_map_replace(global.maprandom, "210", oControl.mod_210);
ds_map_replace(global.maprandom, "211", oControl.mod_211);
ds_map_replace(global.maprandom, "214", oControl.mod_214);
ds_map_replace(global.maprandom, "250", oControl.mod_250);
ds_map_replace(global.maprandom, "252", oControl.mod_252);
ds_map_replace(global.maprandom, "255", oControl.mod_255);
ds_map_replace(global.maprandom, "257", oControl.mod_257);
ds_map_replace(global.maprandom, "259", oControl.mod_259);
ds_map_replace(global.maprandom, "303", oControl.mod_303);
ds_map_replace(global.maprandom, "304", oControl.mod_304);
ds_map_replace(global.maprandom, "307", oControl.mod_307);
ds_map_replace(global.maprandom, "308", oControl.mod_308);
ds_map_replace(global.maprandom, "309", oControl.mod_309);
//Super Missiles
ds_map_replace(global.maprandom, "51", oControl.mod_51);
ds_map_replace(global.maprandom, "110", oControl.mod_110);
ds_map_replace(global.maprandom, "162", oControl.mod_162);
ds_map_replace(global.maprandom, "206", oControl.mod_206);
ds_map_replace(global.maprandom, "207", oControl.mod_207);
ds_map_replace(global.maprandom, "209", oControl.mod_209);
ds_map_replace(global.maprandom, "215", oControl.mod_215);
ds_map_replace(global.maprandom, "256", oControl.mod_256);
ds_map_replace(global.maprandom, "300", oControl.mod_300);
ds_map_replace(global.maprandom, "305", oControl.mod_305);
//Energy Tanks
ds_map_replace(global.maprandom, "50", oControl.mod_50);
ds_map_replace(global.maprandom, "103", oControl.mod_103);
ds_map_replace(global.maprandom, "108", oControl.mod_108);
ds_map_replace(global.maprandom, "157", oControl.mod_157);
ds_map_replace(global.maprandom, "158", oControl.mod_158);
ds_map_replace(global.maprandom, "200", oControl.mod_200);
ds_map_replace(global.maprandom, "201", oControl.mod_201);
ds_map_replace(global.maprandom, "251", oControl.mod_251);
ds_map_replace(global.maprandom, "254", oControl.mod_254);
ds_map_replace(global.maprandom, "306", oControl.mod_306);
//Power Bombs
ds_map_replace(global.maprandom, "58", oControl.mod_58);
ds_map_replace(global.maprandom, "59", oControl.mod_59);
ds_map_replace(global.maprandom, "112", oControl.mod_112);
ds_map_replace(global.maprandom, "160", oControl.mod_160);
ds_map_replace(global.maprandom, "212", oControl.mod_212);
ds_map_replace(global.maprandom, "213", oControl.mod_213);
ds_map_replace(global.maprandom, "253", oControl.mod_253);
ds_map_replace(global.maprandom, "258", oControl.mod_258);
ds_map_replace(global.maprandom, "301", oControl.mod_301);
ds_map_replace(global.maprandom, "302", oControl.mod_302);

ds_map_replace(global.maprandom, "PureRandom", oControl.mod_purerandombool);
ds_map_replace(global.maprandom, "RandomGame", oControl.mod_randomgamebool);

#define sv6_randomizer
/// sv6_add_main()
var list, str_list;
list = ds_list_create();

ds_list_add(list, oControl.mod_bombs);
ds_list_add(list, oControl.mod_spider);
ds_list_add(list, oControl.mod_jumpball);
ds_list_add(list, oControl.mod_hijump);
ds_list_add(list, oControl.mod_varia);
ds_list_add(list, oControl.mod_spacejump);
ds_list_add(list, oControl.mod_speedbooster);
ds_list_add(list, oControl.mod_screwattack);
ds_list_add(list, oControl.mod_charge);
ds_list_add(list, oControl.mod_ice);
ds_list_add(list, oControl.mod_wave);
ds_list_add(list, oControl.mod_spazer);
ds_list_add(list, oControl.mod_plasma); //13 total

//Missiles
ds_list_add(list, oControl.mod_52);
ds_list_add(list, oControl.mod_53);
ds_list_add(list, oControl.mod_54);
ds_list_add(list, oControl.mod_55);
ds_list_add(list, oControl.mod_56);
ds_list_add(list, oControl.mod_57);
ds_list_add(list, oControl.mod_60);
ds_list_add(list, oControl.mod_100);
ds_list_add(list, oControl.mod_101);
ds_list_add(list, oControl.mod_102);
ds_list_add(list, oControl.mod_104);
ds_list_add(list, oControl.mod_105);
ds_list_add(list, oControl.mod_106);
ds_list_add(list, oControl.mod_107);
ds_list_add(list, oControl.mod_109);
ds_list_add(list, oControl.mod_111);
ds_list_add(list, oControl.mod_150);
ds_list_add(list, oControl.mod_151);
ds_list_add(list, oControl.mod_152);
ds_list_add(list, oControl.mod_153);
ds_list_add(list, oControl.mod_154);
ds_list_add(list, oControl.mod_155);
ds_list_add(list, oControl.mod_156);
ds_list_add(list, oControl.mod_159);
ds_list_add(list, oControl.mod_161);
ds_list_add(list, oControl.mod_163);
ds_list_add(list, oControl.mod_202);
ds_list_add(list, oControl.mod_203);
ds_list_add(list, oControl.mod_204);
ds_list_add(list, oControl.mod_205);
ds_list_add(list, oControl.mod_208);
ds_list_add(list, oControl.mod_210);
ds_list_add(list, oControl.mod_211);
ds_list_add(list, oControl.mod_214);
ds_list_add(list, oControl.mod_250);
ds_list_add(list, oControl.mod_252);
ds_list_add(list, oControl.mod_255);
ds_list_add(list, oControl.mod_257);
ds_list_add(list, oControl.mod_259);
ds_list_add(list, oControl.mod_303);
ds_list_add(list, oControl.mod_304);
ds_list_add(list, oControl.mod_307);
ds_list_add(list, oControl.mod_308);
ds_list_add(list, oControl.mod_309); // 44 total
//Super Missiles
ds_list_add(list, oControl.mod_51);
ds_list_add(list, oControl.mod_110);
ds_list_add(list, oControl.mod_162);
ds_list_add(list, oControl.mod_206); //SPECIAL
ds_list_add(list, oControl.mod_207);
ds_list_add(list, oControl.mod_209);
ds_list_add(list, oControl.mod_215);
ds_list_add(list, oControl.mod_256);
ds_list_add(list, oControl.mod_300);
ds_list_add(list, oControl.mod_305); // 10
//Energy Tanks
ds_list_add(list, oControl.mod_50);
ds_list_add(list, oControl.mod_103);
ds_list_add(list, oControl.mod_108);
ds_list_add(list, oControl.mod_157);
ds_list_add(list, oControl.mod_158);
ds_list_add(list, oControl.mod_200);
ds_list_add(list, oControl.mod_201);
ds_list_add(list, oControl.mod_251);
ds_list_add(list, oControl.mod_254);
ds_list_add(list, oControl.mod_306); //10
//Power Bombs
ds_list_add(list, oControl.mod_58);
ds_list_add(list, oControl.mod_59);
ds_list_add(list, oControl.mod_112);
ds_list_add(list, oControl.mod_160);
ds_list_add(list, oControl.mod_212);
ds_list_add(list, oControl.mod_213);
ds_list_add(list, oControl.mod_253); //SPECIAL
ds_list_add(list, oControl.mod_258);
ds_list_add(list, oControl.mod_301);
ds_list_add(list, oControl.mod_302); //10

ds_list_add(list, oControl.mod_purerandombool);
ds_list_add(list, oControl.mod_randomgamebool);
ds_list_add(list, oControl.mod_splitrandom);
ds_list_add(list, oControl.mod_fusion);
ds_list_add(list, oControl.mod_diffmult);
ds_list_add(list, oControl.chozomessage);
ds_list_add(list, oControl.mod_gravity);
ds_list_add(list, global.gamemode); //8 total

i = 0;
repeat (25) { //120 total in list. 95 used up through chozomessage.
    ds_list_add(list, 0);
    i += 1;
}
str_list = ds_list_write(list);
ds_list_clear(list);
return str_list;

#define sv6_get_random
/// sv6_get_random()

list = ds_list_create();

ds_list_read(list, base64_decode(file_text_read_string(argument0)));
i = 0;

oControl.mod_bombs = readline();
oControl.mod_spider = readline();
oControl.mod_jumpball = readline();
oControl.mod_hijump = readline();
oControl.mod_varia = readline();
oControl.mod_spacejump = readline();
oControl.mod_speedbooster = readline();
oControl.mod_screwattack = readline();
oControl.mod_charge = readline();
oControl.mod_ice = readline();
oControl.mod_wave = readline();
oControl.mod_spazer = readline();
oControl.mod_plasma = readline();
//Missiles
oControl.mod_52 = readline();
oControl.mod_53 = readline();
oControl.mod_54 = readline();
oControl.mod_55 = readline();
oControl.mod_56 = readline();
oControl.mod_57 = readline();
oControl.mod_60 = readline();
oControl.mod_100 = readline();
oControl.mod_101 = readline();
oControl.mod_102 = readline();
oControl.mod_104 = readline();
oControl.mod_105 = readline();
oControl.mod_106 = readline();
oControl.mod_107 = readline();
oControl.mod_109 = readline();
oControl.mod_111 = readline();
oControl.mod_150 = readline();
oControl.mod_151 = readline();
oControl.mod_152 = readline();
oControl.mod_153 = readline();
oControl.mod_154 = readline();
oControl.mod_155 = readline();
oControl.mod_156 = readline();
oControl.mod_159 = readline();
oControl.mod_161 = readline();
oControl.mod_163 = readline();
oControl.mod_202 = readline();
oControl.mod_203 = readline();
oControl.mod_204 = readline();
oControl.mod_205 = readline();
oControl.mod_208 = readline();
oControl.mod_210 = readline();
oControl.mod_211 = readline();
oControl.mod_214 = readline();
oControl.mod_250 = readline();
oControl.mod_252 = readline();
oControl.mod_255 = readline();
oControl.mod_257 = readline();
oControl.mod_259 = readline();
oControl.mod_303 = readline();
oControl.mod_304 = readline();
oControl.mod_307 = readline();
oControl.mod_308 = readline();
oControl.mod_309 = readline();
//Super Missiles
oControl.mod_51 = readline();
oControl.mod_110 = readline();;
oControl.mod_162 = readline();
oControl.mod_206 = readline(); //SPECIAL
oControl.mod_207 = readline();
oControl.mod_209 = readline();
oControl.mod_215 = readline();
oControl.mod_256 = readline();
oControl.mod_300 = readline();
oControl.mod_305 = readline();
//Energy Tanks
oControl.mod_50 = readline();
oControl.mod_103 = readline();
oControl.mod_108 = readline();
oControl.mod_157 = readline();
oControl.mod_158 = readline();
oControl.mod_200 = readline();
oControl.mod_201 = readline();
oControl.mod_251 = readline();
oControl.mod_254 = readline();
oControl.mod_306 = readline();
//Power Bombs
oControl.mod_58 = readline();
oControl.mod_59 = readline();
oControl.mod_112 = readline();
oControl.mod_160 = readline();
oControl.mod_212 = readline();
oControl.mod_213 = readline();
oControl.mod_253 = readline(); //SPECIAL
oControl.mod_258 = readline();
oControl.mod_301 = readline();
oControl.mod_302 = readline();
//Random
oControl.mod_purerandombool = readline();
oControl.mod_randomgamebool = readline();
oControl.mod_splitrandom = readline();
oControl.mod_fusion = readline();
oControl.mod_diffmult = readline();
oControl.chozomessage = readline();
oControl.mod_gravity = readline();
global.gamemode = readline();

ds_list_clear(list);

scr_load_undefined(); //Just in case. Needed if used old save editor or coming from old version of AM2R.

var t = 0;


#define scr_swappables
//Not used. Probably wrong v1.4

switch (argument0)
{
    case 4:
    case 8:
    case 11:
    case 250:
    case 252:
        return false;
        break;
    default:
        return true;
        break;
    
}

#define scr_speedbooster_wall

switch (argument0)
{
    case 54:
    case 55:
    case 110:
    case 161:
    case 162:
    case 201:
    case 204:
    case 205:
    case 207:
    case 208:
    case 209:
    case 212:
    case 301:
    case 305:
    case 306:
    case 307:
    case 309:
        return false;
        break;
    default:
        return true;
        break;
    
}

#define scr_randomizer_junk
//Powerups
oControl.mod_spider = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_jumpball = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_hijump = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_varia = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

//SPACE JUMP
while (true)
{
    checkcount = 0;
    oControl.mod_spacejump = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
    if (oControl.mod_spacejump != 4 && oControl.mod_spacejump != 8 && oControl.mod_spacejump != 11 && oControl.mod_spacejump != 250 && oControl.mod_spacejump != 252) { checkcount++; }
    if (oControl.mod_spacejump != 306 && oControl.mod_spacejump != 212) { checkcount++; }
    if (oControl.mod_spacejump == 158 || oControl.mod_spacejump == 160 || oControl.mod_spacejump == 161)
    {
        var cc2 = 0;
        if (oControl.mod_hijump == 158 || oControl.mod_hijump == 160 || oControl.mod_hijump == 161) { cc2++; }
        if (cc2 == 0) { checkcount++; }
    }
    else { checkcount++; }
    if (checkcount == 3) { break; }
    ds_list_shuffle(list_locations);
}
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_charge = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_ice = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_wave = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_spazer = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_plasma = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

//SPEED BOOSTER
while (true)
{  
    checkcount = 0;
    oControl.mod_speedbooster = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
    if (oControl.mod_speedbooster != 4 && oControl.mod_speedbooster != 8 && oControl.mod_speedbooster != 11 && oControl.mod_speedbooster != 250 && oControl.mod_speedbooster != 252) { checkcount++; }
    if (scr_speedbooster_wall(oControl.mod_speedbooster)) { checkcount++; }
    if (oControl.mod_speedbooster == 57)
    {
           var cc2 = 0;
           if (scr_speedbooster_wall(oControl.mod_spacejump))  { cc2++; }
           if (scr_speedbooster_wall(oControl.mod_hijump))  { cc2++; }
           if (cc2 != 2) { checkcount++; }
    }
    else { checkcount ++; }
    if (oControl.mod_speedbooster == 158)
    {
           var cc2 = 0;
           if (scr_speedbooster_wall(oControl.mod_spacejump))  { cc2++; }
           if (scr_speedbooster_wall(oControl.mod_hijump))  { cc2++; }
           if (scr_speedbooster_wall(oControl.mod_bombs))  { cc2++; }
           if (cc2 != 3) { checkcount++; }
    }
    else { checkcount ++; }
    
    if (checkcount == 4) { break; } 
    ds_list_shuffle(list_locations);
}
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

//SCREW ATTACK
while (true)
{
    checkcount = 0;
    oControl.mod_screwattack = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
    if (oControl.mod_screwattack != 4 && oControl.mod_screwattack != 11 && oControl.mod_screwattack != 250 && oControl.mod_screwattack != 252) checkcount++;
    if (oControl.mod_speedbooster == 160 || oControl.mod_speedbooster == 259 || oControl.mod_speedbooster == 300)
    {
        if (scr_speedbooster_wall(oControl.mod_screwattack))  { checkcount++; }
    }
    else { checkcount++; }
        
    if (checkcount == 2) { break; } 
    ds_list_shuffle(list_locations);
}
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

//BOMBS
while (true)
{
    checkcount = 0;
    oControl.mod_bombs = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
    if (oControl.mod_speedbooster == 53)
    {
        if (scr_speedbooster_wall(oControl.mod_bombs))  { checkcount++; }
    }
    else { checkcount++; }
    if (oControl.mod_bombs == 158 || oControl.mod_bombs == 160 || oControl.mod_bombs == 161)
    {
        var cc2 = 0;
        if (oControl.mod_hijump == 158 || oControl.mod_hijump == 160 || oControl.mod_hijump == 161) { cc2++; }
        if (oControl.mod_spacejump == 158 || oControl.mod_spacejump == 160 || oControl.mod_spacejump == 161) { cc2++; }
        if (cc2 == 0) { checkcount++; } //Could technically let one of these items in these locations. Don't want to risk getting stuck though.
    }
    else { checkcount++; }
    if (checkcount = 2) { break; }
    ds_list_shuffle(list_locations);
}
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

#define scr_randomizer_bombs

var list = ds_list_create();
ds_list_add(list,2,3,4,5,6,7,8,9,10,11,12,13,14);
ds_list_shuffle(list);

var list_random = ds_list_create();
ds_list_add(list_random,0,1,2);
ds_list_shuffle(list_random);

var list_random_value = ds_list_find_value(list_random, ds_list_size(list_random) - 1);

//Bombs
if (list_random_value == 0) { oControl.mod_bombs = 0; }
else
{
    if (oControl.mod_randomitems == 1)
    {
        while (true)
            {   
                oControl.mod_bombs = ds_list_find_value(list, ds_list_size(list) - 1);
                if (oControl.mod_bombs != 8) { break; }
                ds_list_shuffle(list);
            }
            ds_list_delete(list, ds_list_size(list) - 1);
    }
    else
    {
        oControl.mod_bombs = ds_list_find_value(list, ds_list_size(list) - 1);
        ds_list_delete(list, ds_list_size(list) - 1);
    }
}

//Spider Ball
if (list_random_value == 1) { oControl.mod_spider = 0; }
else
{
    if (oControl.mod_randomitems == 1)
    {
        while (true)
            {   
                oControl.mod_spider = ds_list_find_value(list, ds_list_size(list) - 1);
                if (oControl.mod_spider != 8) { break; }
                ds_list_shuffle(list);
            }
            ds_list_delete(list, ds_list_size(list) - 1);
    }
    else
    {
        oControl.mod_spider = ds_list_find_value(list, ds_list_size(list) - 1);
        ds_list_delete(list, ds_list_size(list) - 1);
    }
}

//Charge Beam
if (list_random_value == 2) { oControl.mod_charge = 0; }
else
{
    if (oControl.mod_randomitems == 1)
    {
        while (true)
            {   
                oControl.mod_charge = ds_list_find_value(list, ds_list_size(list) - 1);
                if (oControl.mod_charge != 8) { break; }
                ds_list_shuffle(list);
            }
            ds_list_delete(list, ds_list_size(list) - 1);
    }
    else
    {
        oControl.mod_charge = ds_list_find_value(list, ds_list_size(list) - 1);
        ds_list_delete(list, ds_list_size(list) - 1);
    }
}

oControl.mod_jumpball = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_hijump = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_varia = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_spacejump = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_speedbooster = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_screwattack = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_ice = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_wave = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_spazer = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_plasma = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_gravity = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

ds_list_empty(list);

#define scr_randomizer_powerbombs

var list = ds_list_create();

ds_list_add(list,2,3,4,5,6,7,9,10,11,12,13,14);
ds_list_shuffle(list);

//No Bombs or Screw Attack
oControl.mod_bombs = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_spider = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);
  
oControl.mod_charge = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);  

ds_list_add(list,0,8);
ds_list_shuffle(list);

oControl.mod_jumpball = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_hijump = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_varia = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_spacejump = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_speedbooster = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_screwattack = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_ice = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_wave = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_spazer = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_plasma = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_gravity = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);


ds_list_empty(list);

#define scr_randomizer_screwattack

var list = ds_list_create();
ds_list_add(list,0,2,3,4,5,6,7,9,10,11,12,13,14);
ds_list_shuffle(list);

var list_random = ds_list_create();
ds_list_add(list_random,0,1,2);
ds_list_shuffle(list_random);

var list_random_value = ds_list_find_value(list_random, ds_list_size(list_random) - 1);

//Bombs
if (list_random_value == 0) { oControl.mod_bombs = 8; }
else
{
    if (oControl.mod_randomitems == 1)
    {
        while (true)
            {   
                oControl.mod_bombs = ds_list_find_value(list, ds_list_size(list) - 1);
                if (oControl.mod_bombs != 0) { break; }
                ds_list_shuffle(list);
            }
            ds_list_delete(list, ds_list_size(list) - 1);
    }
    else
    {
        oControl.mod_bombs = ds_list_find_value(list, ds_list_size(list) - 1);
        ds_list_delete(list, ds_list_size(list) - 1);
    }
}

//Spider Ball
if (list_random_value == 1) { oControl.mod_spider = 8; }
else
{
    if (oControl.mod_randomitems == 1)
    {
        while (true)
            {   
                oControl.mod_spider = ds_list_find_value(list, ds_list_size(list) - 1);
                if (oControl.mod_spider != 0) { break; }
                ds_list_shuffle(list);
            }
            ds_list_delete(list, ds_list_size(list) - 1);
    }
    else
    {
        oControl.mod_spider = ds_list_find_value(list, ds_list_size(list) - 1);
        ds_list_delete(list, ds_list_size(list) - 1);
    }
}

//Charge Beam
if (list_random_value == 2) { oControl.mod_charge = 8; }
else
{
    if (oControl.mod_randomitems == 1)
    {
        while (true)
            {   
                oControl.mod_charge = ds_list_find_value(list, ds_list_size(list) - 1);
                if (oControl.mod_charge != 0) { break; }
                ds_list_shuffle(list);
            }
            ds_list_delete(list, ds_list_size(list) - 1);
    }
    else
    {
        oControl.mod_charge = ds_list_find_value(list, ds_list_size(list) - 1);
        ds_list_delete(list, ds_list_size(list) - 1);
    }
}
   
oControl.mod_jumpball = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_hijump = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_varia = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_spacejump = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_speedbooster = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_screwattack = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_ice = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_wave = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_spazer = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_plasma = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_gravity = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

ds_list_empty(list);

#define scr_randomizer_items
var temp_seed = random_get_seed();
randomize();
if(instance_exists(oClient)){
    if(!is_undefined(oClient.seed)){
        oControl.seed = oClient.seed;
        random_set_seed(oControl.seed);
    } else {
        //oControl.seed = random_get_seed();
        //random_set_seed(oControl.seed);
        //send_seed();
    }
} else {
    oControl.seed = random_get_seed();
    random_set_seed(oControl.seed);
}

var randpb = argument0;
// randpb = 0 = Bombs || Classic Mode+
// randpb = 1 = Screw Attack
// randpb = 2 = Power Bombs

var list_locations = ds_list_create();


//Technically the list holds the items. The oControl.mod variables are the locations!
ds_list_add(list_locations, 52,53,54,55,56,57,60,100,101,102,104,105,106,107,109,111,150,151,152,153,154,155,156,159,161,163); //Missiles
ds_list_add(list_locations, 202,203,204,205,208,210,211,214,250,252,255,257,259,303,304,307,308,309); //Missiles
ds_list_add(list_locations, 51,110,162,207,209,215,256,300,305); //Super Missiles
ds_list_add(list_locations, 50,103,108,157,158,200,201,251,306); //Energy Tanks
if (oControl.mod_insanitymode == 0) { ds_list_add(list_locations, 254); }
if (randpb == 0) ds_list_add(list_locations,58,59,112,160,212,213,258,301,302);
ds_list_shuffle(list_locations);

//ds_list_add(list_locations,58,59,112,160,212,213,258,301,302); //SA
//ds_list_add(list_locations,59,112,160,212,213,258,301,302); //PB

oControl.mod_101 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_102 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_104 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_105 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_106 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

if (randpb == 2)
{
    oControl.mod_108 = 58;
}
else
{
    oControl.mod_108 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
    ds_list_delete(list_locations, ds_list_size(list_locations) - 1);
}

oControl.mod_109 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);


if (randpb == 1)
{
    ds_list_add(list_locations,58,59,112,160,212,213,258,301,302); //SA
    ds_list_shuffle(list_locations);
}


oControl.mod_100 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_103 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_107 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_111 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_112 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

if (randpb == 2)
{
    ds_list_add(list_locations,59,112,160,212,213,258,301,302); //PB
    ds_list_shuffle(list_locations);
}


//Power Bombs

oControl.mod_58 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);
    
oControl.mod_59 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_160 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_212 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_213 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_258 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_301 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_302 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);


//Missiles
oControl.mod_52 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_53 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_54 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_55 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_56 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_57 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_60 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);


oControl.mod_150 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_151 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_152 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_153 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_154 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_155 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_156 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_159 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_161 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_163 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_202 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_203 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_204 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_205 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_208 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_210 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_211 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_214 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_250 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_252 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_255 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_257 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_259 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_303 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_304 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_307 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_308 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_309 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);


//Super Missiles
oControl.mod_51 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_110 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_162 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_207 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_209 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_215 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_256 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_300 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_305 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);


//Energy Tanks
oControl.mod_50 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);


oControl.mod_157 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_158 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_200 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_201 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

oControl.mod_251 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);

if (oControl.mod_insanitymode == 0)
{
    oControl.mod_254 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
    ds_list_delete(list_locations, ds_list_size(list_locations) - 1);
}
else { oControl.mod_254 = 254; }

oControl.mod_306 = ds_list_find_value(list_locations, ds_list_size(list_locations) - 1);
ds_list_delete(list_locations, ds_list_size(list_locations) - 1);


oControl.mod_206 = 206; //SM
oControl.mod_253 = 253; // PB


ds_list_empty(list_locations);


random_set_seed(temp_seed);



#define scr_randomizer_pure
var temp_seed = random_get_seed();
randomize();
if(instance_exists(oClient)){
    if(!is_undefined(oClient.seed)){
        oControl.seed = oClient.seed;
        random_set_seed(oControl.seed);
    } else {
        //oControl.seed = random_get_seed();
        //random_set_seed(oControl.seed);
        //send_seed();
    }
} else {
    oControl.seed = random_get_seed();
    random_set_seed(oControl.seed);
}

if (oControl.mod_usemanualseed == 1) { 
    random_set_seed(oControl.mod_seed);
    oControl.seed = oControl.mod_seed; 
}



// These lists no longer used after 1.3.3
oControl.list_bombs = ds_list_create();
ds_list_add(oControl.list_bombs,true,false);

oControl.list_powerbombs = ds_list_create();
if (oControl.mod_fusion == 1) { ds_list_add(oControl.list_powerbombs, true);}
else { ds_list_add(oControl.list_powerbombs,true); }
//ds_list_add(oControl.list_powerbombs,true);

oControl.list_speedbooster = ds_list_create();
ds_list_add(oControl.list_speedbooster,true,false); //1.3.3 - true,false,false
ds_list_shuffle(oControl.list_speedbooster);

oControl.list_spacejump = ds_list_create();
ds_list_add(oControl.list_spacejump,false);
ds_list_shuffle(oControl.list_spacejump);

//These lists still in use
oControl.list_torizo = ds_list_create();
ds_list_add(oControl.list_torizo,false);
ds_list_shuffle(oControl.list_torizo);

oControl.list_genesis = ds_list_create();
ds_list_add(oControl.list_genesis,true,false,false,false,false);
ds_list_shuffle(oControl.list_genesis);

oControl.list_ibeam = ds_list_create();
ds_list_add(oControl.list_ibeam,true,false,false,false,false);
ds_list_shuffle(oControl.list_ibeam);

oControl.list_jumpball = ds_list_create();
ds_list_add(oControl.list_jumpball,true,true,false,false);
ds_list_shuffle(oControl.list_jumpball);

//Not being used
oControl.list_33percent = ds_list_create();
ds_list_add(oControl.list_33percent, true,false,false);
ds_list_shuffle(oControl.list_33percent);
var percent33 = ds_list_find_value(oControl.list_33percent, ds_list_size(oControl.list_33percent) - 1);


//Technically the list holds the items. The oControl.mod variables are the locations!
oControl.list_locations = ds_list_create();
ds_list_add(oControl.list_locations, 52,53,54,55,56,57,60,100,101,102,104,105,106,107,109,111,150,151,152,153,154,155,156,159,161,163); //Missiles
ds_list_add(oControl.list_locations, 202,203,204,205,208,210,211,214,250,252,255,257,259,303,304,307,308,309); //Missiles
ds_list_add(oControl.list_locations, 51,110,162,207,209,215,256,300,305); //Super Missiles
ds_list_add(oControl.list_locations, 50,103,108,157,158,200,201,251,306); //Energy Tanks
if (oControl.mod_insanitymode == 0) { ds_list_add(oControl.list_locations, 254); }
ds_list_add(oControl.list_locations, 58,59,112,160,212,213,258,301,302); //Power Bombs
ds_list_shuffle(oControl.list_locations);


//Beginning of randomizer logic

//Area 6 Locations - no power ups
oControl.mod_51 = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);

oControl.mod_56 = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);

oControl.mod_60 = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);

//Adding powerups to list after area 6 assignments
ds_list_add(oControl.list_locations, 0,2,3,4,5,6,7,8,9,10,11,12,13,14);
ds_list_shuffle(oControl.list_locations);

//these variables are being set. howerver some are not being used.
oControl.twocount_B_SJ = 0; // Bombs and Space Jump - Location: 53
oControl.twocount_HJ_SJ = 0; // Hi-Jump and Space Jump - Location: 57
oControl.threecount = 0; // Bombs, Hi-jump, and Space Jump - Locations: 158,160,161
oControl.bombs_placed = false;
oControl.hijump_placed = false;
oControl.spacejump_placed = false;
oControl.speed_placed = false;
oControl.screw_placed = false;

oControl.bombs_wall = false;
oControl.spider_wall = false;
oControl.spring_wall = false;
oControl.hijump_wall = false;
oControl.spacejump_wall = false;
oControl.screw_wall = false;
oControl.gravity_wall = false;
oControl.varia_wall = false;


var checkcounter = 0;





//Speed Booster Walled Items
oControl.mod_54 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_55 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_110 = scr_logic_SB_wall(true, true, false, true, false); //no screw attack, no springball(as of 1.4.3)
oControl.mod_161 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_162 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_201 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_204 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_205 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_207 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_208 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_209 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_212 = scr_logic_SB_wall(false, true, true, true, true); //no space jump
oControl.mod_301 = scr_logic_SB_wall(true, true, true, true, true);
oControl.mod_305 = scr_logic_SB_wall(true, false, true, true, true); // no gravity
oControl.mod_306 = scr_logic_SB_wall(false, false, true, true, true); //no space jump, no gravity
oControl.mod_307 = scr_logic_SB_wall(true, false, true, true, true); // no gravity
oControl.mod_309 = scr_logic_SB_wall(true, false, true, true, true); // no gravity
oControl.mod_255 = scr_logic_SB_wall(true, true, true, true, true); // added 1.4.4



//Plasma Beam Location - forced power up or energy tank
//var shuff = ds_list_find_value(oControl.mod_plasma, ds_list_size(oControl.list_torizo) - 1);
while (true)
{
    oControl.mod_plasma = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    //if (shuff == true) { break; }
    if (scr_PUorET(oControl.mod_plasma) == true) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);

//Space Jump - forced power up or energy tank
//var shuff = ds_list_find_value(oControl.list_torizo, ds_list_size(oControl.list_torizo) - 1);
while (true)
{
    oControl.mod_spacejump = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    //if (shuff == true) { break; }
    if (scr_PUorET(oControl.mod_spacejump) == true) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);


//Ice Beam - more likely to get Power-up or Energy Tank
var shuff = ds_list_find_value(oControl.list_ibeam, ds_list_size(oControl.list_ibeam) - 1);
while (true)
{
    oControl.mod_ice = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    if (shuff == true) { break; }
    if (scr_PUorET(oControl.mod_ice) == true) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);


//Genesis - more likely to get Power-up or Energy Tank
var shuff = ds_list_find_value(oControl.list_genesis, ds_list_size(oControl.list_genesis) - 1);
while (true)
{
    oControl.mod_50 = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    if (shuff == true) { break; }
    if (scr_PUorET(oControl.mod_50) == true) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);

//Jump ball - 50% chance to be PU or ET
var shuff = ds_list_find_value(oControl.list_jumpball, ds_list_size(oControl.list_jumpball) - 1);
while (true)
{
    oControl.mod_jumpball = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    if (shuff == true) { break; }
    if (scr_PUorET(oControl.mod_jumpball) == true) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);




//Area 0 need bombs or space jump to get item

while (true)
{
    oControl.mod_53 = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    if (oControl.mod_53 != 0)
    {    
        if (oControl.mod_53 != 7) { break; }
        else { if (oControl.bombs_wall == false && oControl.spacejump_wall == false) { break; } }
    }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);


//Area 0 need space jump or high jump to get this item
while (true)
{
    oControl.mod_57 = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    if (oControl.mod_57 != 4 && oControl.mod_57 != 6)
    {  
        if (oControl.mod_57 != 7) { break; }
        else { if (oControl.spacejump_wall == false && oControl.hijump_wall == false) { break; } }
    }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);


//No Screw Attack & If Speed Booster here than no Screw Attack behind wall
while (true)
{
    checkcounter = 0;
    oControl.mod_259 = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    if (oControl.mod_259 != 8) { checkcounter++; }
    if (oControl.mod_259 == 7 && oControl.screw_wall == true) { } else { checkcounter++; }
    if (checkcounter == 2) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);


//Cannot be Screw Attack && If Speed Booster here than no Screw Attack behind wall
while (true)
{
    checkcounter = 0;
    oControl.mod_300 = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    if (oControl.mod_300 != 8) { checkcounter++; }
    if (oControl.mod_300 == 7 && oControl.screw_wall) { } else { checkcounter++; }
    if (checkcounter == 2) { break; }   
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);


//If Speed Booster here than no Screw Attack behind wall & Only one of three items: Bombs, Hi-Jump, Space Jump
while (true)
{
    checkcounter = 0;
    oControl.mod_160 = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);    
    if (oControl.mod_160 == 7 && oControl.screw_wall) { } else { checkcounter++; }
    if (oControl.threecount > 1 && (oControl.mod_160 == 0 || oControl.mod_160 == 4 || oControl.mod_160 == 6)) { } else { checkcounter++; }
    if (checkcounter == 2) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);


//Only one of three items: Bombs, Hi-Jump, Space Jump
while (true)
{
    checkcounter = 0;
    oControl.mod_158 = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);    
    if (oControl.threecount > 1 && (oControl.mod_158 == 0 || oControl.mod_158 == 4 || oControl.mod_158 == 6)) { } else { checkcounter++; }
    if (checkcounter == 1) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);





//Powerups
oControl.mod_gravity = scr_random_draw_pool();
oControl.mod_screwattack = scr_random_draw_pool();
oControl.mod_hijump = scr_random_draw_pool();
oControl.mod_speedbooster = scr_random_draw_pool();
oControl.mod_wave = scr_random_draw_pool();
oControl.mod_spazer = scr_random_draw_pool();
oControl.mod_bombs = scr_random_draw_pool();
oControl.mod_spider = scr_random_draw_pool();
oControl.mod_varia = scr_random_draw_pool();
oControl.mod_charge = scr_random_draw_pool();


//Area 1
oControl.mod_100 = scr_random_draw_pool();
oControl.mod_101 = scr_random_draw_pool();
oControl.mod_102 = scr_random_draw_pool();
oControl.mod_103 = scr_random_draw_pool();
oControl.mod_104 = scr_random_draw_pool();
oControl.mod_105 = scr_random_draw_pool();
oControl.mod_106 = scr_random_draw_pool();
oControl.mod_107 = scr_random_draw_pool();
oControl.mod_108 = scr_random_draw_pool();
oControl.mod_109 = scr_random_draw_pool();
oControl.mod_52 = scr_random_draw_pool();
oControl.mod_152 = scr_random_draw_pool();
oControl.mod_163 = scr_random_draw_pool();

//Missiles
oControl.mod_111 = scr_random_draw_111(); // changed 1.4.4
oControl.mod_150 = scr_random_draw_pool();
oControl.mod_151 = scr_random_draw_pool();
oControl.mod_153 = scr_random_draw_pool();
oControl.mod_154 = scr_random_draw_pool();
oControl.mod_155 = scr_random_draw_pool();
oControl.mod_156 = scr_random_draw_pool();
oControl.mod_159 = scr_random_draw_pool();
oControl.mod_202 = scr_random_draw_pool();
oControl.mod_203 = scr_random_draw_pool();
oControl.mod_210 = scr_random_draw_pool();
oControl.mod_211 = scr_random_draw_pool();
oControl.mod_214 = scr_random_draw_pool();
oControl.mod_250 = scr_random_draw_pool();
oControl.mod_252 = scr_random_draw_pool();
//oControl.mod_255 = scr_random_draw_pool(); removed 1.4.4
oControl.mod_257 = scr_random_draw_spider();
oControl.mod_303 = scr_random_draw_gravity_spider(); //cannot be gravity, no spider
oControl.mod_304 = scr_random_draw_pool();
oControl.mod_308 = scr_random_draw_pool();

//Super Missiles

oControl.mod_215 = scr_random_draw_pool();
oControl.mod_256 = scr_random_draw_pool();
oControl.mod_206 = 206; //SM - first occurance


//Energy Tanks

//oControl.mod_50 //Genesis - above
oControl.mod_157 = scr_random_draw_pool();
oControl.mod_200 = scr_random_draw_pool();
oControl.mod_251 = scr_random_draw_pool();

if (oControl.mod_insanitymode == 0)
{
    oControl.mod_254 = scr_random_draw_pool();
}
else { oControl.mod_254 = 254; }


//Power Bombs
oControl.mod_302 = scr_random_draw_gravity(); //cannot be gravity
oControl.mod_58 = scr_random_draw_pool();
oControl.mod_59 = scr_random_draw_pool();
oControl.mod_112 = scr_random_draw_112(); // changed 1.4.4
oControl.mod_213 = scr_random_draw_pool();
oControl.mod_258 = scr_random_draw_pool();
//Last item variable CANNOT pull item from ANY SCRIPT EXCEPT for scr_random_draw_pool(). It could create endless loop!!!

oControl.mod_253 = 253; // PB - first occurance








//Destroy all lists to help with memory
ds_list_destroy(oControl.list_bombs);
ds_list_destroy(oControl.list_powerbombs);
ds_list_destroy(oControl.list_speedbooster);
ds_list_destroy(oControl.list_genesis);
ds_list_destroy(oControl.list_jumpball);
ds_list_destroy(oControl.list_33percent);
//ds_list_empty(oControl.list_locations);
ds_list_destroy(oControl.list_locations);

random_set_seed(temp_seed);









// below is old code for space jump. Probably don't need but it's here.
/*
    if (scr_PUorET(oControl.mod_spacejump) == true)
    {        
        if (percent33 == true && oControl.mod_spacejump < 20 && oControl.mod_spacejump != 7)
        {
            break;   
        }
        else if (percent33 == false && oControl.mod_spacejump > 20) { break; }
        //if (oControl.mod_spacejump != 7) { break; }
    }
*/



#define scr_logic_SB_wall
///scr_logic_SB_wall(true_SpaceJump, true_gravity, true_screw_attack, true_spider, true_springball)

while (true)
{   
    checkcounter = 0;
    var temp_mod = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
   
    if (oControl.threecount <= 2 && (temp_mod == 0 || temp_mod == 4 || temp_mod == 6)) { } else { checkcounter++; }

    if (argument0 == true) { checkcounter++; } else { if (temp_mod != 6) { checkcounter++; } }
    if (argument1 == true) { checkcounter++; } else { if (temp_mod != 9) { checkcounter++; } }
    if (argument2 == true) { checkcounter++; } else { if (temp_mod != 8) { checkcounter++; } }
    if (argument3 == true) { checkcounter++; } else { if (temp_mod != 2) { checkcounter++; } }
    if (argument4 == true) { checkcounter++; } else { if (temp_mod != 3) { checkcounter++; } }
    if (temp_mod != 7) { checkcounter++; }
    if (checkcounter == 7) { break; }
    ds_list_shuffle(oControl.list_locations);
}
scr_randomizer_pure_wall(temp_mod);
scr_randomizer_pure_vars(temp_mod);
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return temp_mod;

#define scr_randomizer_pure_wall
switch (argument0)
{
    case 0:
        oControl.bombs_wall = true;
        break;
    case 2:
        oControl.spider_wall = true;
        break;
    case 3:
        oControl.spring_wall = true;
        break; //changed 1.4.4
    case 4:
        oControl.hijump_wall = true;
        break;
    case 5:
        oControl.varia_wall = true;
        break;
    case 6:
        oControl.spacejump_wall = true;
        break;
    case 8:
        oControl.screw_wall = true;
        break;
    case 9:
        oControl.gravity_wall = true;
        break;
}

#define scr_randomizer_pure_vars
//not all these variables used.
switch (argument0)
{
    case 0:
        oControl.bombs_placed = true;
        oControl.twocount_B_SJ++;
        oControl.threecount++;
        break;
    case 4:
        oControl.hijump_placed = true;
        oControl.twocount_HJ_SJ++;
        oControl.threecount++;
        break;
    case 6:
        oControl.spacejump_placed = true;
        oControl.twocount_B_SJ++;
        oControl.twocount_HJ_SJ++;
        oControl.threecount++;
        break;
    case 7:
        oControl.speed_placed = true;
        break;
    case 8:
        oControl.screw_placed = true;
        break;
}

#define scr_randomizer_pure_area2


#define scr_rand_split_powerups
var temp_seed = random_get_seed();
randomize();
if(instance_exists(oClient)){
    if(!is_undefined(oClient.seed)){
        oControl.seed = oClient.seed;
        random_set_seed(oControl.seed);
    } else {
        //oControl.seed = random_get_seed();
        //random_set_seed(oControl.seed);
        //send_seed();
    }
} else {
    oControl.seed = random_get_seed();
    random_set_seed(oControl.seed);
}

if (oControl.mod_usemanualseed == 1) { 
    random_set_seed(oControl.mod_seed);
    oControl.seed = oControl.mod_seed; 
}

var list = ds_list_create();

ds_list_add(list,0,2,3,4,5,6,7,8,9,10,11,12,13,14);
ds_list_shuffle(list);

//No Bombs or Screw Attack
oControl.mod_bombs = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_spider = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);
  
oControl.mod_charge = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);  

oControl.mod_jumpball = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_hijump = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_varia = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_spacejump = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_speedbooster = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_screwattack = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_ice = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_wave = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_spazer = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_plasma = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);

oControl.mod_gravity = ds_list_find_value(list, ds_list_size(list) - 1);
ds_list_delete(list, ds_list_size(list) - 1);


ds_list_empty(list);


random_set_seed(temp_seed);



#define scr_randomizer_split_items

var temp_seed = random_get_seed();
randomize();

if(instance_exists(oClient)){
    if(!is_undefined(oClient.seed)){
        oControl.seed = oClient.seed;
        random_set_seed(oControl.seed);
    } else {
        //oControl.seed = random_get_seed();
        //random_set_seed(oControl.seed);
        //send_seed();
    }
} else {
    oControl.seed = random_get_seed();
    random_set_seed(oControl.seed);
}

if (oControl.mod_usemanualseed == 1) { random_set_seed(oControl.mod_seed); }

oControl.list_powerbombs = ds_list_create();
ds_list_add(oControl.list_powerbombs,true,false,false,false);






//Technically the list holds the items. The oControl.mod variables are the locations!
oControl.list_locations = ds_list_create();
ds_list_add(oControl.list_locations, 52,53,54,55,56,57,60,100,101,102,104,105,106,107,109,111,150,151,152,153,154,155,156,159,161,163); //Missiles
ds_list_add(oControl.list_locations, 202,203,204,205,208,210,211,214,250,252,255,257,259,303,304,307,308,309); //Missiles
ds_list_add(oControl.list_locations, 51,110,162,207,209,215,256,300,305); //Super Missiles
ds_list_add(oControl.list_locations, 50,103,108,157,158,200,201,251,306); //Energy Tanks
if (oControl.mod_insanitymode == 0) { ds_list_add(oControl.list_locations, 254); }
ds_list_add(oControl.list_locations,58,59,112,160,212,213,258,301,302);
ds_list_shuffle(oControl.list_locations);

/*
//Area 1 - Anti-Power Bomb Influence - Only affects split pool logic
oControl.mod_100 = scr_logic_misc(false,false,true,scr_logic_PB_shuffle(),false,false,false,false);
oControl.mod_101 = scr_logic_misc(false,false,true,scr_logic_PB_shuffle(),false,false,false,false);
oControl.mod_102 = scr_logic_misc(false,false,true,scr_logic_PB_shuffle(),false,false,false,false);
oControl.mod_103 = scr_logic_misc(false,false,true,scr_logic_PB_shuffle(),false,false,false,false);
oControl.mod_104 = scr_logic_misc(false,false,true,scr_logic_PB_shuffle(),false,false,false,false);
oControl.mod_105 = scr_logic_misc(false,false,true,scr_logic_PB_shuffle(),false,false,false,false);
oControl.mod_106 = scr_logic_misc(false,false,true,scr_logic_PB_shuffle(),false,false,false,false);
oControl.mod_107 = scr_logic_misc(false,false,true,scr_logic_PB_shuffle(),false,false,false,false);
oControl.mod_108 = scr_logic_misc(false,false,true,scr_logic_PB_shuffle(),false,false,false,false);
oControl.mod_109 = scr_logic_misc(false,false,true,scr_logic_PB_shuffle(),false,false,false,false);
*/

//Area 1
oControl.mod_100 = scr_random_draw_pool();
oControl.mod_101 = scr_random_draw_pool();
oControl.mod_102 = scr_random_draw_pool();
oControl.mod_103 = scr_random_draw_pool();
oControl.mod_104 = scr_random_draw_pool();
oControl.mod_105 = scr_random_draw_pool();
oControl.mod_106 = scr_random_draw_pool();
oControl.mod_107 = scr_random_draw_pool();
oControl.mod_108 = scr_random_draw_pool();
oControl.mod_109 = scr_random_draw_pool();


//Power Bombs
oControl.mod_58 = scr_random_draw_pool();
oControl.mod_59 = scr_random_draw_pool();
oControl.mod_112 = scr_random_draw_pool();
oControl.mod_160 = scr_random_draw_pool();
oControl.mod_212 = scr_random_draw_pool();
oControl.mod_213 = scr_random_draw_pool();
oControl.mod_258 = scr_random_draw_pool();
oControl.mod_301 = scr_random_draw_pool();
oControl.mod_302 = scr_random_draw_pool();

//Missiles
oControl.mod_52 = scr_random_draw_pool();
oControl.mod_53 = scr_random_draw_pool();
oControl.mod_54 = scr_random_draw_pool();
oControl.mod_55 = scr_random_draw_pool();
oControl.mod_56 = scr_random_draw_pool();
oControl.mod_57 = scr_random_draw_pool();
oControl.mod_60 = scr_random_draw_pool();
oControl.mod_111 = scr_random_draw_pool();
oControl.mod_150 = scr_random_draw_pool();
oControl.mod_151 = scr_random_draw_pool();
oControl.mod_152 = scr_random_draw_pool();
oControl.mod_153 = scr_random_draw_pool();
oControl.mod_154 = scr_random_draw_pool();
oControl.mod_155 = scr_random_draw_pool();
oControl.mod_156 = scr_random_draw_pool();
oControl.mod_159 = scr_random_draw_pool();
oControl.mod_161 = scr_random_draw_pool();
oControl.mod_163 = scr_random_draw_pool();
oControl.mod_202 = scr_random_draw_pool();
oControl.mod_203 = scr_random_draw_pool();
oControl.mod_204 = scr_random_draw_pool();
oControl.mod_205 = scr_random_draw_pool();
oControl.mod_208 = scr_random_draw_pool();
oControl.mod_210 = scr_random_draw_pool();
oControl.mod_211 = scr_random_draw_pool();
oControl.mod_214 = scr_random_draw_pool();
oControl.mod_250 = scr_random_draw_pool();
oControl.mod_252 = scr_random_draw_pool();
oControl.mod_255 = scr_random_draw_pool();
oControl.mod_257 = scr_random_draw_pool();
oControl.mod_259 = scr_random_draw_pool();
oControl.mod_303 = scr_random_draw_pool();
oControl.mod_304 = scr_random_draw_pool();
oControl.mod_307 = scr_random_draw_pool();
oControl.mod_308 = scr_random_draw_pool();
oControl.mod_309 = scr_random_draw_pool();


//Super Missiles
oControl.mod_51 = scr_random_draw_pool();
oControl.mod_110 = scr_random_draw_pool();
oControl.mod_162 = scr_random_draw_pool();
oControl.mod_207 = scr_random_draw_pool();
oControl.mod_209 = scr_random_draw_pool();
oControl.mod_215 = scr_random_draw_pool();
oControl.mod_256 = scr_random_draw_pool();
oControl.mod_300 = scr_random_draw_pool();
oControl.mod_305 = scr_random_draw_pool();

//Energy Tanks
oControl.mod_50 = scr_random_draw_pool();
oControl.mod_157 = scr_random_draw_pool();
oControl.mod_158 = scr_random_draw_pool();
oControl.mod_200 = scr_random_draw_pool();
oControl.mod_201 = scr_random_draw_pool();
oControl.mod_251 = scr_random_draw_pool();

if (oControl.mod_insanitymode == 0)
{
    oControl.mod_254 = scr_random_draw_pool();    
}
else { oControl.mod_254 = 254; }

oControl.mod_306 = scr_random_draw_pool();

oControl.mod_206 = 206; //SM
oControl.mod_253 = 253; // PB


ds_list_empty(oControl.list_locations);


random_set_seed(temp_seed);



#define scr_logic_misc
///scr_logic_misc(check_bombs,bombs_var,check_PB,PB_var,check_SB,SB_var,check_SJ,SJ_var)
//check_bombs = 0
//bombs_var = 1
//check_PB = 2
//PB_var = 3
//check_SB = 4
//SB_var = 5
//check_SJ = 6
//SJ_var = 7

while (true)
{
    checkcounter = 0;
    temp_mod = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    
    //check_bombs
    if (argument0 == true) 
    {
        if (argument1 == true) { checkcounter++; }
        else 
        { 
            if (temp_mod != 0) { checkcounter++; } 
        }
    }
    else { checkcounter++; }

    //check_pb
    if (argument2 == true)
    {
        if (argument3 == true) { checkcounter++; }
        else 
        { 
            if (temp_mod != 58 && temp_mod != 59 && temp_mod != 112 && temp_mod != 160 && temp_mod != 212 && temp_mod != 213 && temp_mod != 258 && temp_mod != 301 && temp_mod != 302) { checkcounter++; } 
        }
    }
    else { checkcounter++; }   
    
    //check_SB
    if (argument4 == true) 
    {
        if (argument5 == true) { checkcounter++; }
        else { if (temp_mod != 7) { checkcounter++; } }
    }
    else { checkcounter++; }   
    
    //check_SJ
    if (argument6 == true) 
    {
        if (argument7 == true) { checkcounter++; }
        else { if (temp_mod != 6) { checkcounter++; } }
    }
    else { checkcounter++; }   

    if (checkcounter == 4) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return temp_mod;


#define scr_logic_bomb_shuffle
ds_list_shuffle(oControl.list_bombs);
return ds_list_find_value(oControl.list_bombs, ds_list_size(oControl.list_bombs) - 1);

#define scr_logic_PB_shuffle
ds_list_shuffle(oControl.list_powerbombs);
var t = ds_list_find_value(oControl.list_powerbombs, ds_list_size(oControl.list_powerbombs) - 1);
return t;

#define scr_logic_SB_shuffle
ds_list_shuffle(oControl.list_speedbooster);
return ds_list_find_value(oControl.list_speedbooster, ds_list_size(oControl.list_speedbooster) - 1);

#define scr_logic_SJ_shuffle
ds_list_shuffle(oControl.list_speedbooster);
return ds_list_find_value(oControl.list_speedbooster, ds_list_size(oControl.list_speedbooster) - 1);

#define scr_PUorET
switch (argument0)
{ 
    //Power-ups
    case 0:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
    case 11:
    case 12:
    case 13:
    case 14:
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
        return true;
        break;
    default:
        return false;
        break;
}


#define scr_PU
switch (argument0)
{ 
    //Power-ups
    case 0:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
    case 11:
    case 12:
    case 13:
    case 14:    
        return true;
        break;
    default:
        return false;
        break;
}


#define scr_random_draw_pool
var temp_item_number = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return temp_item_number;

#define scr_random_draw_gravity

while (true)
{
    checkcounter = 0;
    var shuff = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    if (shuff == 7 && oControl.gravity_wall == true) { } else { checkcounter++; }
    if (shuff != 9) { checkcounter++; }
    if (checkcounter == 2) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return shuff;

#define scr_random_draw_screw

while (true)
{
    checkcounter = 0;
    var shuff = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    if (shuff == 8) { } else { checkcounter++; }
    if (checkcounter == 1) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return shuff;

#define scr_random_draw_gravity_spider

while (true)
{
    checkcounter = 0;
    var shuff = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);    
    if (shuff == 7 && (oControl.gravity_wall == true || oControl.spider_wall == true)) { } else { checkcounter++; }
    if (shuff != 9) { checkcounter++; }
    if (shuff != 2) { checkcounter++; }
    if (checkcounter == 3) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return shuff;

#define scr_random_draw_spider_spring_space_112


while (true)
{
    checkcounter = 0;
    var shuff = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    
    var tc = 0;
    if (oControl.bombs_wall == true) tc++;
    if (oControl.spider_wall == true && oControl.spring_wall == true) tc++;
    if (oControl.spacejump_wall == true) tc++;
    
    if (shuff == 7 && tc > 1) { } else { checkcounter++; }
    //next line seems out of place. I'm trying to resolve issues without restricting speed booster from being here.
    if (shuff == 7 && oControl.screw_wall == true) { } else { checkcounter++; } 
    //Next line seems a little extreme but it's here so hard locks don't happen.
    if ((shuff == 0 || shuff == 2 || shuff == 3 || shuff == 6 || shuff == 7) && (oControl.mod_111 == 0 || oControl.mod_111 == 2 || oControl.mod_111 == 3 || oControl.mod_111 == 6 || oControl.mod_111 == 7)) { } else { checkcounter++; }
    if (checkcounter == 3) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return shuff;


/*

while (true)
{
    checkcounter = 0;
    var shuff = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    
    var tc = 0;
    if (oControl.bombs_wall == true) tc++;
    if (oControl.spider_wall == true && oControl.spring_wall == true) tc++;
    if (oControl.spacejump_wall == true) tc++;
        
    if (shuff == 7 && tc > 1) { } else { break; }
    //if ((shuff == 2 || shuff == 3 || shuff == 6 || shuff == 7) && (oControl.mod_111 == 2 || oControl.mod_111 == 3 || oControl.mod_111 == 6 || oControl.mod_111 == 7)) { } else { checkcounter++; }
    //if (checkcounter == 2) { break; }
    ds_list_shuffle(oControl.list_locations);
    

}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return shuff;

#define scr_random_draw_spider_spring_space_111


while (true)
{
    checkcounter = 0;
    var shuff = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    
    var tc = 0;
    if (oControl.bombs_wall == true) tc++;
    if (oControl.spider_wall == true && oControl.spring_wall == true) tc++;
    if (oControl.spacejump_wall == true) tc++;    
    if (shuff == 7 && tc > 1) { } else { checkcounter++; }
    //next line seems out of place. I'm trying to resolve issues without restricting speed booster from being here.
    if (shuff == 7 && oControl.screw_wall == true) { } else { checkcounter++; } 
    if (checkcounter == 2) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return shuff;

#define scr_random_draw_spider



while (true)
{
    var shuff = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);       
    if (shuff != 2 && shuff != 6 && shuff != 7) { break; }
    if (shuff != 2 && oControl.spider_wall == false && oControl.spacejump_wall == false) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return shuff;

#define scr_random_draw_111

//changed 1.4.4

while (true)
{
    checkcounter = 0;
    var shuff = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    
    var tc = 0;
    if (oControl.bombs_wall == true || oControl.spring_wall == true) tc++;
    if (oControl.spider_wall == true) tc++;
    if (oControl.spacejump_wall == true) tc++;
    if (oControl.hijump_wall == true) tc++;
    
    if (shuff == 7 && tc > 1) { } else { checkcounter++; }
    //next line seems out of place. I'm trying to resolve issues without restricting speed booster from being here.
    if (shuff == 7 && oControl.screw_wall == true) { } else { checkcounter++; } 
    //Next line seems a little extreme but it's here so hard locks don't happen.
    if ((shuff == 0 || shuff == 2 || shuff == 3 || shuff == 4|| shuff == 6 || shuff == 7) && (oControl.mod_112 == 0 || oControl.mod_112 == 2 || oControl.mod_112 == 3|| oControl.mod_112 == 4 || oControl.mod_112 == 6 || oControl.mod_112 == 7)) { } else { checkcounter++; }
    if (checkcounter == 3) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return shuff;



#define scr_random_draw_112
//changed 1.4.4

while (true)
{
    checkcounter = 0;
    var shuff = ds_list_find_value(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
    
    var tc = 0;
    if (oControl.bombs_wall == true || oControl.spring_wall == true) tc++;
    if (oControl.spider_wall == true) tc++;
    if (oControl.spacejump_wall == true) tc++;
    if (oControl.hijump_wall == true) tc++;
    
    if (shuff == 7 && tc > 1) { } else { checkcounter++; }
    //next line seems out of place. I'm trying to resolve issues without restricting speed booster from being here.
    if (shuff == 7 && oControl.screw_wall == true) { } else { checkcounter++; } 
    //Next line seems a little extreme but it's here so hard locks don't happen.
    if ((shuff == 0 || shuff == 2 || shuff == 3 || shuff == 4|| shuff == 6 || shuff == 7) && (oControl.mod_111 == 0 || oControl.mod_111 == 2 || oControl.mod_111 == 3|| oControl.mod_111 == 4 || oControl.mod_111 == 6 || oControl.mod_111 == 7)) { } else { checkcounter++; }
    if (checkcounter == 3) { break; }
    ds_list_shuffle(oControl.list_locations);
}
ds_list_delete(oControl.list_locations, ds_list_size(oControl.list_locations) - 1);
return shuff;



#define scr_load_items
ini_open('modifiers.ini');
//Header
//global.mod_cheating = ini_read_real('Header', 'Cheating', 0);




ini_close();

#define scr_load_undefined
if (is_undefined(oControl.mod_bombs)) oControl.mod_bombs = 0;
if (is_undefined(oControl.mod_spider)) oControl.mod_spider = 2;
if (is_undefined(oControl.mod_jumpball)) oControl.mod_jumpball = 3;
if (is_undefined(oControl.mod_hijump)) oControl.mod_hijump = 4;
if (is_undefined(oControl.mod_varia)) oControl.mod_varia = 5;
if (is_undefined(oControl.mod_spacejump)) oControl.mod_spacejump = 6;
if (is_undefined(oControl.mod_speedbooster)) oControl.mod_speedbooster = 7;
if (is_undefined(oControl.mod_screwattack)) oControl.mod_screwattack = 8;
if (is_undefined(oControl.mod_gravity)) oControl.mod_gravity = 9;
if (is_undefined(oControl.mod_charge)) oControl.mod_charge = 10;
if (is_undefined(oControl.mod_ice)) oControl.mod_ice = 11;
if (is_undefined(oControl.mod_wave)) oControl.mod_wave = 12;
if (is_undefined(oControl.mod_spazer)) oControl.mod_spazer = 13;
if (is_undefined(oControl.mod_plasma)) oControl.mod_plasma = 14;

//Missiles
if (is_undefined(oControl.mod_52)) oControl.mod_52 = 52;
if (is_undefined(oControl.mod_53)) oControl.mod_53 = 53;
if (is_undefined(oControl.mod_54)) oControl.mod_54 = 54;
if (is_undefined(oControl.mod_55)) oControl.mod_55 = 55;
if (is_undefined(oControl.mod_56)) oControl.mod_56 = 56;
if (is_undefined(oControl.mod_57)) oControl.mod_57 = 57;
if (is_undefined(oControl.mod_60)) oControl.mod_60 = 60;
if (is_undefined(oControl.mod_100)) oControl.mod_100 = 100;
if (is_undefined(oControl.mod_101)) oControl.mod_101 = 101;
if (is_undefined(oControl.mod_102)) oControl.mod_102 = 102;
if (is_undefined(oControl.mod_104)) oControl.mod_104 = 104;
if (is_undefined(oControl.mod_105)) oControl.mod_105 = 105;
if (is_undefined(oControl.mod_106)) oControl.mod_106 = 106;
if (is_undefined(oControl.mod_107)) oControl.mod_107 = 107;
if (is_undefined(oControl.mod_109)) oControl.mod_109 = 109;
if (is_undefined(oControl.mod_111)) oControl.mod_111 = 111;
if (is_undefined(oControl.mod_150)) oControl.mod_150 = 150;
if (is_undefined(oControl.mod_151)) oControl.mod_151 = 151;
if (is_undefined(oControl.mod_152)) oControl.mod_152 = 152;
if (is_undefined(oControl.mod_153)) oControl.mod_153 = 153;
if (is_undefined(oControl.mod_154)) oControl.mod_154 = 154;
if (is_undefined(oControl.mod_155)) oControl.mod_155 = 155;
if (is_undefined(oControl.mod_156)) oControl.mod_156 = 156;
if (is_undefined(oControl.mod_159)) oControl.mod_159 = 159;
if (is_undefined(oControl.mod_161)) oControl.mod_161 = 161;
if (is_undefined(oControl.mod_163)) oControl.mod_163 = 163;
if (is_undefined(oControl.mod_202)) oControl.mod_202 = 202;
if (is_undefined(oControl.mod_203)) oControl.mod_203 = 203;
if (is_undefined(oControl.mod_204)) oControl.mod_204 = 204;
if (is_undefined(oControl.mod_205)) oControl.mod_205 = 205;
if (is_undefined(oControl.mod_208)) oControl.mod_208 = 208;
if (is_undefined(oControl.mod_210)) oControl.mod_210 = 210;
if (is_undefined(oControl.mod_211)) oControl.mod_211 = 211;
if (is_undefined(oControl.mod_214)) oControl.mod_214 = 214;
if (is_undefined(oControl.mod_250)) oControl.mod_250 = 250;
if (is_undefined(oControl.mod_252)) oControl.mod_252 = 252;
if (is_undefined(oControl.mod_255)) oControl.mod_255 = 255;
if (is_undefined(oControl.mod_257)) oControl.mod_257 = 257;
if (is_undefined(oControl.mod_259)) oControl.mod_259 = 259;
if (is_undefined(oControl.mod_303)) oControl.mod_303 = 303;
if (is_undefined(oControl.mod_304)) oControl.mod_304 = 304;
if (is_undefined(oControl.mod_307)) oControl.mod_307 = 307;
if (is_undefined(oControl.mod_308)) oControl.mod_308 = 308;
if (is_undefined(oControl.mod_309)) oControl.mod_309 = 309;

//Super Missiles
if (is_undefined(oControl.mod_51)) oControl.mod_51 = 51;
if (is_undefined(oControl.mod_110)) oControl.mod_110 = 110;;
if (is_undefined(oControl.mod_162)) oControl.mod_162 = 162;
if (is_undefined(oControl.mod_206)) oControl.mod_206 = 206; //SPECIAL
if (is_undefined(oControl.mod_207)) oControl.mod_207 = 207;
if (is_undefined(oControl.mod_209)) oControl.mod_209 = 209;
if (is_undefined(oControl.mod_215)) oControl.mod_215 = 215;
if (is_undefined(oControl.mod_256)) oControl.mod_256 = 256;
if (is_undefined(oControl.mod_300)) oControl.mod_300 = 300;
if (is_undefined(oControl.mod_305)) oControl.mod_305 = 305;

//Energy Tanks
if (is_undefined(oControl.mod_50)) oControl.mod_50 = 50;
if (is_undefined(oControl.mod_103)) oControl.mod_103 = 103;
if (is_undefined(oControl.mod_108)) oControl.mod_108 = 108;
if (is_undefined(oControl.mod_157)) oControl.mod_157 = 157;
if (is_undefined(oControl.mod_158)) oControl.mod_158 = 158;
if (is_undefined(oControl.mod_200)) oControl.mod_200 = 200;
if (is_undefined(oControl.mod_201)) oControl.mod_201 = 201;
if (is_undefined(oControl.mod_251)) oControl.mod_251 = 251;
if (is_undefined(oControl.mod_254)) oControl.mod_254 = 254;
if (is_undefined(oControl.mod_306)) oControl.mod_306 = 306;

//Power Bombs
if (is_undefined(oControl.mod_58)) oControl.mod_58 = 58;
if (is_undefined(oControl.mod_59)) oControl.mod_59 = 59;
if (is_undefined(oControl.mod_112)) oControl.mod_112 = 112;
if (is_undefined(oControl.mod_160)) oControl.mod_160 = 160;
if (is_undefined(oControl.mod_212)) oControl.mod_212 = 212;
if (is_undefined(oControl.mod_213)) oControl.mod_213 = 213;
if (is_undefined(oControl.mod_253)) oControl.mod_253 = 253; //SPECIAL
if (is_undefined(oControl.mod_258)) oControl.mod_258 = 258;
if (is_undefined(oControl.mod_301)) oControl.mod_301 = 301;
if (is_undefined(oControl.mod_302)) oControl.mod_302 = 302;

//Misc
if (is_undefined(oControl.mod_purerandombool)) oControl.mod_purerandombool = 0;
if (is_undefined(oControl.mod_randomgamebool)) oControl.mod_randomgamebool = 0;
if (is_undefined(oControl.mod_splitrandom)) oControl.mod_splitrandom = 0;
if (is_undefined(oControl.mod_fusion)) oControl.mod_fusion = 0;

if (is_undefined(oControl.mod_diffmult) || oControl.mod_diffmult == 0) 
{
    oControl.mod_diffmult = 1;
    if (global.difficulty == 2) oControl.mod_diffmult = 2;
    if (oControl.mod_fusion == 1) oControl.mod_diffmult = 4;
}

if (is_undefined(oControl.chozomessage)) oControl.chozomessage = 0;
if (is_undefined(global.gamemode)) global.gamemode = 0;




#define scr_controller_xbox
/// get_xjoybtnname(gamepad_button)
if (argument0 == gp_face1) return "A";
if (argument0 == gp_face2) return "B";
if (argument0 == gp_face3) return "X";
if (argument0 == gp_face4) return "Y";
if (argument0 == gp_shoulderl) return get_text("Buttons", "LB"); //"LB";
if (argument0 == gp_shoulderr) return get_text("Buttons", "RB"); //"RB";
if (argument0 == gp_shoulderlb) return get_text("Buttons", "LT"); //"LT";
if (argument0 == gp_shoulderrb) return get_text("Buttons", "RT"); //"RT";
if (argument0 == gp_stickl) return get_text("Buttons", "LStick"); //"LStick";
if (argument0 == gp_stickr) return get_text("Buttons", "RStick"); //"RStick";
if (argument0 == gp_start) return get_text("Buttons", "Start"); //"Start";
if (argument0 == gp_select) return get_text("Buttons", "Back"); //"Back";
return "";

#define scr_controller_ps
/// get_xjoybtnname(gamepad_button)
if (argument0 == gp_face1) return get_text("Buttons", "Cross");
if (argument0 == gp_face2) return get_text("Buttons", "Circle");
if (argument0 == gp_face3) return get_text("Buttons", "Square");
if (argument0 == gp_face4) return get_text("Buttons", "Triangle");
if (argument0 == gp_shoulderl) return get_text("Buttons", "L1"); //"LB";
if (argument0 == gp_shoulderr) return get_text("Buttons", "R1"); //"RB";
if (argument0 == gp_shoulderlb) return get_text("Buttons", "L2"); //"LT";
if (argument0 == gp_shoulderrb) return get_text("Buttons", "R2"); //"RT";
if (argument0 == gp_stickl) return get_text("Buttons", "LStick"); //"LStick";
if (argument0 == gp_stickr) return get_text("Buttons", "RStick"); //"RStick";
if (argument0 == gp_start) return get_text("Buttons", "Start"); //"Start";
if (argument0 == gp_select) return get_text("Buttons", "Select"); //"Back";
return "";

#define scr_controller_N
/// get_xjoybtnname(gamepad_button)
if (argument0 == gp_face1) return "B";
if (argument0 == gp_face2) return "A";
if (argument0 == gp_face3) return "Y";
if (argument0 == gp_face4) return "X";
if (argument0 == gp_shoulderl) return get_text("Buttons", "LeftShoulder"); //"LB";
if (argument0 == gp_shoulderr) return get_text("Buttons", "RightShoulder"); //"RB";
if (argument0 == gp_shoulderlb) return get_text("Buttons", "ZL"); //"LT";
if (argument0 == gp_shoulderrb) return get_text("Buttons", "ZR"); //"RT";
if (argument0 == gp_stickl) return get_text("Buttons", "LStick"); //"LStick";
if (argument0 == gp_stickr) return get_text("Buttons", "RStick"); //"RStick";
if (argument0 == gp_start) return get_text("Buttons", "Start"); //"Start";
if (argument0 == gp_select) return get_text("Buttons", "Select"); //"Back";
return "";

#define scr_suit_sprites
///scr_suit_sprites(orginal_suit,fusion_suit)

if (oControl.mod_fusion == 1 || oControl.mod_suitchangecheat == 1) { 
    if(global.currentsuit == 0) {
        return argument1;
    }
    else if(global.currentsuit == 1) {
        return asset_get_index(sprite_get_name(argument1) + "_varia");
    }
    else if (global.currentsuit == 2) {
        return asset_get_index(sprite_get_name(argument1) + "_gravity");
    }
}
else { return argument0; }


#define scr_SubScrTop_swap

if (global.stanks > 0 && global.ptanks > 0) return bg_SubScrTop;
else if (global.stanks > 0) return bg_SubScrTop_SM;
else if (global.ptanks > 0) return bg_SubScrTop_PB;
else return bg_SubScrTop_M;


#define scr_SubScrTop_swap2

if (global.stanks > 0 && global.ptanks > 0) return bg_SubScrTop2;
else if (global.stanks > 0) return bg_SubScrTop2_SM;
else if (global.ptanks > 0) return bg_SubScrTop2_PB;
else return bg_SubScrTop2_M;    


#define scr_septoggs_02467
///Relocate Septoggs?
//Septoggs cannot be destroyed. GM will throw an error

if (global.item[0] = 1 || global.item[2] == 1 || global.item[4] == 1 || global.item[6] == 1 || global.item[7] == 1) return true;
else return false;

#define scr_septoggs_2467
///Relocate Septoggs?
//Septoggs cannot be destroyed. GM will throw an error

if (global.item[2] == 1 || global.item[4] == 1 || global.item[6] == 1 || global.item[7] == 1) return true;
else return false;

#define scr_septoggs_246
///Relocate Septoggs?
//Septoggs cannot be destroyed. GM will throw an error

if (global.item[2] == 1 || global.item[4] == 1 || global.item[6] == 1) {
    return true;
} else {
    return false;
}

#define scr_septoggs_2468
///Relocate Septoggs?
//Septoggs cannot be destroyed. GM will throw an error

if (global.item[2] == 1 || global.item[4] == 1 || global.item[6] == 1 || global.item[8] == 1) return true;
else return false;

#define scr_septoggs_48
///Relocate Septoggs?
//Septoggs cannot be destroyed. GM will throw an error

if (global.item[4] == 1 || global.item[8] == 1) return true;
else return false;

#define scr_septoggs_67
///Relocate Septoggs?
//Septoggs cannot be destroyed. GM will throw an error

if (global.item[6] == 1 || global.item[7] == 1) return true;
else return false;

#define scr_septoggs_46
///Relocate Septoggs?
//Septoggs cannot be destroyed. GM will throw an error

if (global.item[4] == 1 || global.item[6] == 1) return true;
else return false;

#define scr_septoggs_26
///Relocate Septoggs?
//Septoggs cannot be destroyed. GM will throw an error

if (global.item[2] == 1 || global.item[6] == 1) return true;
else return false;

#define scr_septoggs_267
///Relocate Septoggs?
//Septoggs cannot be destroyed. GM will throw an error

if (global.item[2] == 1 || global.item[6] == 1|| global.item[7] == 1) return true;
else return false;

#define data_sav_extras
/// data_sav_extras()
var list, str_list;
list = ds_list_create();
i = 0;

ds_list_add(list, global.mod_fusion_unlocked); // 1 used

repeat (19) { // 20 total
    ds_list_add(list, 0);
    i += 1;
}


str_list = ds_list_write(list);
ds_list_clear(list);
return str_list;

#define data_load_extras
///data_load_extras()

list = ds_list_create();
ds_list_read(list, base64_decode(file_text_read_string(argument0)));
i = 0;

global.mod_fusion_unlocked = readline();
global.mod_gamebeaten = 1;

//if (is_undefined(global.mod_gamebeaten)) oControl.mod_gamebeaten = 0;
if (is_undefined(global.mod_fusion_unlocked)) global.mod_fusion_unlocked = 0;

ds_list_clear(list);

#define mus_change_itemroom
if (file_exists("musItemAmb2.ogg")) {
    audio_sound_gain(oMusicV2.currentbgm, 0, 250);
    oMusicV2.alarm[8] = 15;
    oMusicV2.previousbgm = oMusicV2.currentbgm;
    oMusicV2.currentbgm = musItemAmb2;
    if (!audio_is_playing(oMusicV2.currentbgm)) audio_play_sound(oMusicV2.currentbgm, 1, true);
    audio_sound_gain(oMusicV2.currentbgm, 0, 0);
    audio_sound_gain(oMusicV2.currentbgm, global.opmusicvolume / 100, 250);
}

#define save_stats2
/// save_stats()
var filename, fid;
save_str[0] = data_sav_extras();
filename = "extras.sav";
fid = file_text_open_write(filename);
file_text_write_string(fid, rc4("[AM2R UnlockData V7.0]", "HEADER_KEY"));
file_text_writeln(fid);
i = 0;
repeat (1) {
    file_text_write_string(fid, base64_encode(save_str[i]));
    file_text_writeln(fid);
    i += 1;
}
file_text_close(fid);
if (os_is_native) crypt(filename, "XOR_DFJykQ8xX3PuNnkLt6QviqALOLF8cxIDx1D63DAdph4KGQ4rOJ7", 2);

#define load_stats2
/// load_stats()
var header;
filename = "extras.sav";
if (os_is_native) {
    file_copy(filename, filename + "d");
    crypt(filename + "d", "XOR_DFJykQ8xX3PuNnkLt6QviqALOLF8cxIDx1D63DAdph4KGQ4rOJ7", 2);
    fid = file_text_open_read(filename + "d");
} else fid = file_text_open_read(filename);
header = rc4(file_text_read_string(fid), "HEADER_KEY");
file_text_readln(fid);
if (header != "[AM2R UnlockData V7.0]") {
    file_text_close(fid);
    show_message_async("Save Data Corrupted");
    file_delete(filename + "d");
    file_delete(filename);
    room_goto(titleroom);
} else {
    data_load_extras(fid);
    file_text_readln(fid);
    file_text_close(fid);
    file_delete(filename + "d");
}

#define scr_shader_control
if (oControl.palette_number > 6) oControl.palette_number = 0;
if (oControl.palette_number < 0) oControl.palette_number = 6;

if (oControl.palette_number == 0) {
    oControl.shader_on = false;
}
else {
    if (oControl.shader_on == false) {
        oControl.shader_on = true; 
    }           
}

