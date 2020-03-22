del aster.prg
cd msx
call compile.bat
cd ..
cd logo
call compile.bat
cd ..
cd gfx
call compile.bat
cd ..
call compile.bat
TOOLS\CMDCRUNCHER -i "asteroids.prg"  -o aster.prg -PRGFILE -jmp $080d 
