/// reset_globals
i = 100;
repeat (100) {
    i -= 1;
    global.metdead[i] = 0;
}
i = 400;
repeat (400) {
    i -= 1;
    global.event[i] = 0;
}
i = 350;
repeat (350) {
    i -= 1;
    global.itemSamus[i] = 0;
}
global.itemSamus[1] = 1;
i = 350;
repeat (350) {
    i -= 1;
    global.itemSAX[i] = 0;
}
global.itemSAX[1] = 1;
i = 0;
repeat (80) {
    j = 0;
    repeat (80) {
        global.dmapSamus[i, j] = 0;
        j += 1;
    }
    i += 1;
}
i = 0;
repeat (80) {
    j = 0;
    repeat (80) {
        global.dmapSAX[i, j] = 0;
        j += 1;
    }
    i += 1;
}

global.itemSAX = array_clone(global.itemSamus);
global.dmapSAX = array_clone(global.dmapSamus);

global.lavastate = 0;
global.etanks = 0;
global.mtanks = 0;
global.stanks = 0;
global.ptanks = 0;
global.etanksSAX = 0;
global.mtanksSAX = 0;
global.stanksSAX = 0;
global.ptanksSAX = 0;
global.monstersleft = 0;
syncedDifficulty = 1;
syncedELM = 0;
global.seed = 0;
global.rando = 1;



scr_default_global_items();
