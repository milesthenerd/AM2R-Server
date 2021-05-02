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

