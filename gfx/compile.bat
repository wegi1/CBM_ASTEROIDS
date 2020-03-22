
..\TOOLS\CMDCRUNCHER -i "gameover.bmpc64" -DepackAdr $4000  -o "gameover.bin" -binfile
..\TOOLS\CMDCRUNCHER -i "yscore.bmpc64" -DepackAdr $4000  -o "yscore.bin" -binfile
..\TOOLS\CMDCRUNCHER -i "hscore.bmpc64" -DepackAdr $4000  -o "hscore.bin" -binfile -packto $0602
..\TOOLS\CMDCRUNCHER -i "hscore.bmpc64" -DepackAdr $4000  -o "hscoreall.bin" -binfile
..\TOOLS\CMDCRUNCHER -i "1coin.bmpc64" -DepackAdr $4000  -o "1coin.bin" -binfile
..\TOOLS\CMDCRUNCHER -i "picts.bmpc64" -noldad  -DepackAdr $5555 -o "2ndpic.bin" -binfile  -packto $0500
..\TOOLS\CMDCRUNCHER -i "6ast.bmpc64" -noldad -DepackAdr $5555   -o "1stpic.bin" -binfile  -packto $0500