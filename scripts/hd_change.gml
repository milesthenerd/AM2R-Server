
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


