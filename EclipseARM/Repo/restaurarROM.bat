@echo off
..\openocd-0.7.0\bin\openocd-0.7.0 -f "..\openocd-0.7.0\scripts\test\arm-fdi-ucm.cfg" -c "program ROM_original.bin 0x0"
pause
