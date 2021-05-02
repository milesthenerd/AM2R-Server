/// add_randomod_buffer

var size, type, alignment;
size = 1024;
type = buffer_grow;
alignment = 1;
buffer = buffer_create(size, type, alignment);
buffer_seek(buffer, buffer_seek_start, 0);
buffer_write(buffer, buffer_u8, 4);
buffer_write(buffer, buffer_f64, global.seed);
buffer_write(buffer, buffer_u8, tempClientID);

//Power-ups
buffer_write(buffer, buffer_s16, oControl.mod_bombs);
buffer_write(buffer, buffer_s16, oControl.mod_spider);
buffer_write(buffer, buffer_s16, oControl.mod_jumpball);
buffer_write(buffer, buffer_s16, oControl.mod_hijump);
buffer_write(buffer, buffer_s16, oControl.mod_varia);
buffer_write(buffer, buffer_s16, oControl.mod_spacejump);
buffer_write(buffer, buffer_s16, oControl.mod_speedbooster);
buffer_write(buffer, buffer_s16, oControl.mod_screwattack);
buffer_write(buffer, buffer_s16, oControl.mod_gravity);
buffer_write(buffer, buffer_s16, oControl.mod_charge);
buffer_write(buffer, buffer_s16, oControl.mod_ice);
buffer_write(buffer, buffer_s16, oControl.mod_wave);
buffer_write(buffer, buffer_s16, oControl.mod_spazer);
buffer_write(buffer, buffer_s16, oControl.mod_plasma);

//Missiles
buffer_write(buffer, buffer_s16, oControl.mod_52);
buffer_write(buffer, buffer_s16, oControl.mod_53);
buffer_write(buffer, buffer_s16, oControl.mod_54);
buffer_write(buffer, buffer_s16, oControl.mod_55);
buffer_write(buffer, buffer_s16, oControl.mod_56);
buffer_write(buffer, buffer_s16, oControl.mod_57);
buffer_write(buffer, buffer_s16, oControl.mod_60);
buffer_write(buffer, buffer_s16, oControl.mod_100);
buffer_write(buffer, buffer_s16, oControl.mod_101);
buffer_write(buffer, buffer_s16, oControl.mod_102);
buffer_write(buffer, buffer_s16, oControl.mod_104);
buffer_write(buffer, buffer_s16, oControl.mod_105);
buffer_write(buffer, buffer_s16, oControl.mod_106);
buffer_write(buffer, buffer_s16, oControl.mod_107);
buffer_write(buffer, buffer_s16, oControl.mod_109);
buffer_write(buffer, buffer_s16, oControl.mod_111);
buffer_write(buffer, buffer_s16, oControl.mod_150);
buffer_write(buffer, buffer_s16, oControl.mod_151);
buffer_write(buffer, buffer_s16, oControl.mod_152);
buffer_write(buffer, buffer_s16, oControl.mod_153);
buffer_write(buffer, buffer_s16, oControl.mod_154);
buffer_write(buffer, buffer_s16, oControl.mod_155);
buffer_write(buffer, buffer_s16, oControl.mod_156);
buffer_write(buffer, buffer_s16, oControl.mod_159);
buffer_write(buffer, buffer_s16, oControl.mod_161);
buffer_write(buffer, buffer_s16, oControl.mod_163);
buffer_write(buffer, buffer_s16, oControl.mod_202);
buffer_write(buffer, buffer_s16, oControl.mod_203);
buffer_write(buffer, buffer_s16, oControl.mod_204);
buffer_write(buffer, buffer_s16, oControl.mod_205);
buffer_write(buffer, buffer_s16, oControl.mod_208);
buffer_write(buffer, buffer_s16, oControl.mod_210);
buffer_write(buffer, buffer_s16, oControl.mod_211);
buffer_write(buffer, buffer_s16, oControl.mod_214);
buffer_write(buffer, buffer_s16, oControl.mod_250);
buffer_write(buffer, buffer_s16, oControl.mod_252);
buffer_write(buffer, buffer_s16, oControl.mod_255);
buffer_write(buffer, buffer_s16, oControl.mod_257);
buffer_write(buffer, buffer_s16, oControl.mod_259);
buffer_write(buffer, buffer_s16, oControl.mod_303);
buffer_write(buffer, buffer_s16, oControl.mod_304);
buffer_write(buffer, buffer_s16, oControl.mod_307);
buffer_write(buffer, buffer_s16, oControl.mod_308);
buffer_write(buffer, buffer_s16, oControl.mod_309);

//Super Missiles
buffer_write(buffer, buffer_s16, oControl.mod_51);
buffer_write(buffer, buffer_s16, oControl.mod_110);
buffer_write(buffer, buffer_s16, oControl.mod_162);
buffer_write(buffer, buffer_s16, oControl.mod_206);
buffer_write(buffer, buffer_s16, oControl.mod_207);
buffer_write(buffer, buffer_s16, oControl.mod_209);
buffer_write(buffer, buffer_s16, oControl.mod_215);
buffer_write(buffer, buffer_s16, oControl.mod_256);
buffer_write(buffer, buffer_s16, oControl.mod_300);
buffer_write(buffer, buffer_s16, oControl.mod_305);

//Energy Tanks
buffer_write(buffer, buffer_s16, oControl.mod_50);
buffer_write(buffer, buffer_s16, oControl.mod_103);
buffer_write(buffer, buffer_s16, oControl.mod_108);
buffer_write(buffer, buffer_s16, oControl.mod_157);
buffer_write(buffer, buffer_s16, oControl.mod_158);
buffer_write(buffer, buffer_s16, oControl.mod_200);
buffer_write(buffer, buffer_s16, oControl.mod_201);
buffer_write(buffer, buffer_s16, oControl.mod_251);
buffer_write(buffer, buffer_s16, oControl.mod_254);
buffer_write(buffer, buffer_s16, oControl.mod_306);

//Power Bombs
buffer_write(buffer, buffer_s16, oControl.mod_58);
buffer_write(buffer, buffer_s16, oControl.mod_59);
buffer_write(buffer, buffer_s16, oControl.mod_112);
buffer_write(buffer, buffer_s16, oControl.mod_160);
buffer_write(buffer, buffer_s16, oControl.mod_212);
buffer_write(buffer, buffer_s16, oControl.mod_213);
buffer_write(buffer, buffer_s16, oControl.mod_253);
buffer_write(buffer, buffer_s16, oControl.mod_258);
buffer_write(buffer, buffer_s16, oControl.mod_301);
buffer_write(buffer, buffer_s16, oControl.mod_302);

var bufferSize = buffer_tell(buffer);
buffer_seek(buffer, buffer_seek_start, 0);
buffer_write(buffer, buffer_s32, bufferSize);
buffer_write(buffer, buffer_u8, 4);
buffer_write(buffer, buffer_f64, global.seed);
buffer_write(buffer, buffer_u8, tempClientID);

//Power-ups
buffer_write(buffer, buffer_s16, oControl.mod_bombs);
buffer_write(buffer, buffer_s16, oControl.mod_spider);
buffer_write(buffer, buffer_s16, oControl.mod_jumpball);
buffer_write(buffer, buffer_s16, oControl.mod_hijump);
buffer_write(buffer, buffer_s16, oControl.mod_varia);
buffer_write(buffer, buffer_s16, oControl.mod_spacejump);
buffer_write(buffer, buffer_s16, oControl.mod_speedbooster);
buffer_write(buffer, buffer_s16, oControl.mod_screwattack);
buffer_write(buffer, buffer_s16, oControl.mod_gravity);
buffer_write(buffer, buffer_s16, oControl.mod_charge);
buffer_write(buffer, buffer_s16, oControl.mod_ice);
buffer_write(buffer, buffer_s16, oControl.mod_wave);
buffer_write(buffer, buffer_s16, oControl.mod_spazer);
buffer_write(buffer, buffer_s16, oControl.mod_plasma);

//Missiles
buffer_write(buffer, buffer_s16, oControl.mod_52);
buffer_write(buffer, buffer_s16, oControl.mod_53);
buffer_write(buffer, buffer_s16, oControl.mod_54);
buffer_write(buffer, buffer_s16, oControl.mod_55);
buffer_write(buffer, buffer_s16, oControl.mod_56);
buffer_write(buffer, buffer_s16, oControl.mod_57);
buffer_write(buffer, buffer_s16, oControl.mod_60);
buffer_write(buffer, buffer_s16, oControl.mod_100);
buffer_write(buffer, buffer_s16, oControl.mod_101);
buffer_write(buffer, buffer_s16, oControl.mod_102);
buffer_write(buffer, buffer_s16, oControl.mod_104);
buffer_write(buffer, buffer_s16, oControl.mod_105);
buffer_write(buffer, buffer_s16, oControl.mod_106);
buffer_write(buffer, buffer_s16, oControl.mod_107);
buffer_write(buffer, buffer_s16, oControl.mod_109);
buffer_write(buffer, buffer_s16, oControl.mod_111);
buffer_write(buffer, buffer_s16, oControl.mod_150);
buffer_write(buffer, buffer_s16, oControl.mod_151);
buffer_write(buffer, buffer_s16, oControl.mod_152);
buffer_write(buffer, buffer_s16, oControl.mod_153);
buffer_write(buffer, buffer_s16, oControl.mod_154);
buffer_write(buffer, buffer_s16, oControl.mod_155);
buffer_write(buffer, buffer_s16, oControl.mod_156);
buffer_write(buffer, buffer_s16, oControl.mod_159);
buffer_write(buffer, buffer_s16, oControl.mod_161);
buffer_write(buffer, buffer_s16, oControl.mod_163);
buffer_write(buffer, buffer_s16, oControl.mod_202);
buffer_write(buffer, buffer_s16, oControl.mod_203);
buffer_write(buffer, buffer_s16, oControl.mod_204);
buffer_write(buffer, buffer_s16, oControl.mod_205);
buffer_write(buffer, buffer_s16, oControl.mod_208);
buffer_write(buffer, buffer_s16, oControl.mod_210);
buffer_write(buffer, buffer_s16, oControl.mod_211);
buffer_write(buffer, buffer_s16, oControl.mod_214);
buffer_write(buffer, buffer_s16, oControl.mod_250);
buffer_write(buffer, buffer_s16, oControl.mod_252);
buffer_write(buffer, buffer_s16, oControl.mod_255);
buffer_write(buffer, buffer_s16, oControl.mod_257);
buffer_write(buffer, buffer_s16, oControl.mod_259);
buffer_write(buffer, buffer_s16, oControl.mod_303);
buffer_write(buffer, buffer_s16, oControl.mod_304);
buffer_write(buffer, buffer_s16, oControl.mod_307);
buffer_write(buffer, buffer_s16, oControl.mod_308);
buffer_write(buffer, buffer_s16, oControl.mod_309);

//Super Missiles
buffer_write(buffer, buffer_s16, oControl.mod_51);
buffer_write(buffer, buffer_s16, oControl.mod_110);
buffer_write(buffer, buffer_s16, oControl.mod_162);
buffer_write(buffer, buffer_s16, oControl.mod_206);
buffer_write(buffer, buffer_s16, oControl.mod_207);
buffer_write(buffer, buffer_s16, oControl.mod_209);
buffer_write(buffer, buffer_s16, oControl.mod_215);
buffer_write(buffer, buffer_s16, oControl.mod_256);
buffer_write(buffer, buffer_s16, oControl.mod_300);
buffer_write(buffer, buffer_s16, oControl.mod_305);

//Energy Tanks
buffer_write(buffer, buffer_s16, oControl.mod_50);
buffer_write(buffer, buffer_s16, oControl.mod_103);
buffer_write(buffer, buffer_s16, oControl.mod_108);
buffer_write(buffer, buffer_s16, oControl.mod_157);
buffer_write(buffer, buffer_s16, oControl.mod_158);
buffer_write(buffer, buffer_s16, oControl.mod_200);
buffer_write(buffer, buffer_s16, oControl.mod_201);
buffer_write(buffer, buffer_s16, oControl.mod_251);
buffer_write(buffer, buffer_s16, oControl.mod_254);
buffer_write(buffer, buffer_s16, oControl.mod_306);

//Power Bombs
buffer_write(buffer, buffer_s16, oControl.mod_58);
buffer_write(buffer, buffer_s16, oControl.mod_59);
buffer_write(buffer, buffer_s16, oControl.mod_112);
buffer_write(buffer, buffer_s16, oControl.mod_160);
buffer_write(buffer, buffer_s16, oControl.mod_212);
buffer_write(buffer, buffer_s16, oControl.mod_213);
buffer_write(buffer, buffer_s16, oControl.mod_253);
buffer_write(buffer, buffer_s16, oControl.mod_258);
buffer_write(buffer, buffer_s16, oControl.mod_301);
buffer_write(buffer, buffer_s16, oControl.mod_302);

show_debug_message("added");
