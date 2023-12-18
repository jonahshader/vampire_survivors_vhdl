#!/bin/bash

rm -r ghdl_out
mkdir ghdl_out
rm -r obj_dir
mkdir obj_dir

rm top
rm top.v
rm e~top.o
ghdl clean