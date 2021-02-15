/// reset_globals
global.data = ds_list_create();
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
    global.item[i] = 0;
}
global.item[1] = 1;
i = 0;
repeat (80) {
    j = 0;
    repeat (80) {
        global.dmap[i, j] = 0;
        j += 1;
    }
    i += 1;
}




