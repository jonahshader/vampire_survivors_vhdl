#!/bin/bash
verilator -I. -cc top.v --exe main_sim.cpp -o sim \
-CFLAGS "$(sdl2-config --cflags)" -LDFLAGS "$(sdl2-config --libs)"

make -C ./obj_dir -f Vtop.mk