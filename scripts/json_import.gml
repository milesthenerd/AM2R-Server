/// json_import(file)
var json_data = "";

var f = file_text_open_read(argument0);
while (!file_text_eof(f)) {
    json_data += file_text_read_string(f);
    file_text_readln(f);
}
file_text_close(f);

return(json_data);