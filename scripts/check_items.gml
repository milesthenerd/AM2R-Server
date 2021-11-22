/// check_items
//Samus
var etankCount = 0;
for(var i=0; i<array_length_1d(global.itemSamus); i++){
    if(i == 50 || i == 103 || i == 108 || i == 157 || i == 158 || i == 200 || i == 201 || i == 251 || i == 254 || i == 306){
        if(global.itemSamus[i] == 1){
            etankCount++;
        }
    }
}
if(etankCount != global.etanks){
    global.etanks = etankCount;
}

var stankCount = 0;
for(var i=0; i<array_length_1d(global.itemSamus); i++){
    if(i == 51 || i == 110 || i == 162 || i == 206 || i == 207 || i == 209 || i == 215 || i == 256 || i == 300 || i == 305){
        if(global.itemSamus[i] == 1){
            stankCount++;
        }
    }
}
if(stankCount != global.stanks){
    global.stanks = stankCount;
}

var ptankCount = 0;
for(var i=0; i<array_length_1d(global.itemSamus); i++){
    if(i == 58 || i == 59 || i == 112 || i == 160 || i == 212 || i == 213 || i == 253 || i == 258 || i == 301 || i == 302){
        if(global.itemSamus[i] == 1){
            ptankCount++;
        }
    }
}
if(ptankCount != global.ptanks){
    global.ptanks = ptankCount;
}

var mtankCount = 0;
for(var i=0; i<array_length_1d(global.itemSamus); i++){
    if(i == 52 || i == 53 || i == 54 || i == 55 || i == 56 || i == 57 || i == 60 || i == 100 || i == 101 || i == 102 || i == 104 || i == 105 || i == 106 || i == 107 || i == 109 || i == 111 || i == 150 || i == 151 || i == 152 || i == 153 || i == 154 || i == 155 || i == 156 || i == 159 || i == 161 || i == 163 || i == 202 || i == 203 || i == 204 || i == 205 || i == 208 || i == 210 || i == 211 || i == 214 || i == 250 || i == 252 || i == 255 || i == 257 || i == 259 || i == 303 || i == 304 || i == 307 || i == 308 || i == 309){
        if(global.itemSamus[i] == 1){
            mtankCount++;
        }
    }
}
if(mtankCount != global.mtanks){
    global.mtanks = mtankCount;
}

var itemCount = 0;
for(var h=0; h<array_length_1d(global.itemSamus); h++){
    var val = global.itemSamus[h];
    if(val == 1 && h != 1){
        itemCount++;
    }
}

global.damageMult = (itemCount / 88) * 3;

if(global.experimental) global.damageMult = (itemCount / 88) * 5;

//SAX

var etankCount = 0;
for(var i=0; i<array_length_1d(global.itemSAX); i++){
    if(i == 50 || i == 103 || i == 108 || i == 157 || i == 158 || i == 200 || i == 201 || i == 251 || i == 254 || i == 306){
        if(global.itemSAX[i] == 1){
            etankCount++;
        }
    }
}
if(etankCount != global.etanksSAX){
    global.etanksSAX = etankCount;
}

var stankCount = 0;
for(var i=0; i<array_length_1d(global.itemSAX); i++){
    if(i == 51 || i == 110 || i == 162 || i == 206 || i == 207 || i == 209 || i == 215 || i == 256 || i == 300 || i == 305){
        if(global.itemSAX[i] == 1){
            stankCount++;
        }
    }
}
if(stankCount != global.stanksSAX){
    global.stanksSAX = stankCount;
}

var ptankCount = 0;
for(var i=0; i<array_length_1d(global.itemSAX); i++){
    if(i == 58 || i == 59 || i == 112 || i == 160 || i == 212 || i == 213 || i == 253 || i == 258 || i == 301 || i == 302){
        if(global.itemSAX[i] == 1){
            ptankCount++;
        }
    }
}
if(ptankCount != global.ptanksSAX){
    global.ptanksSAX = ptankCount;
}

var mtankCount = 0;
for(var i=0; i<array_length_1d(global.itemSAX); i++){
    if(i == 52 || i == 53 || i == 54 || i == 55 || i == 56 || i == 57 || i == 60 || i == 100 || i == 101 || i == 102 || i == 104 || i == 105 || i == 106 || i == 107 || i == 109 || i == 111 || i == 150 || i == 151 || i == 152 || i == 153 || i == 154 || i == 155 || i == 156 || i == 159 || i == 161 || i == 163 || i == 202 || i == 203 || i == 204 || i == 205 || i == 208 || i == 210 || i == 211 || i == 214 || i == 250 || i == 252 || i == 255 || i == 257 || i == 259 || i == 303 || i == 304 || i == 307 || i == 308 || i == 309){
        if(global.itemSAX[i] == 1){
            mtankCount++;
        }
    }
}
if(mtankCount != global.mtanksSAX){
    global.mtanksSAX = mtankCount;
}
