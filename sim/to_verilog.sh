#!/bin/bash
# Uses GHDL to convert VHDL 2008 to Verilog using synth --out=verilog
# Converts ../src_hdl/*.vhd to /ghdl_out/*.v
# There's also content in ../src_hdl/imports/*.vhd
# There are files in ../src_hdl/rom/*.rom, which aren't VHDL files, but are used by VHDL files
# Top file is ../src_hdl/vampire_survivors_vhdl_main/vhdl/top_sim.vhd


# ghdl -i --std=08 --workdir=ghdl_out ../src_hdl/*.vhd
# ghdl -i --std=08 --workdir=ghdl_out ../src_hdl/imports/*.vhd
# ghdl -i --std=08 --workdir=ghdl_out ../src_hdl/vampire_survivors_vhdl_main/vhdl/top_sim.vhd
# ghdl -m --std=08 --workdir=ghdl_out top
# ghdl synth --std=08 --workdir=ghdl_out --out=verilog top > ghdl_out/top.v

# uses std_logic_unsigned, so -fsynopsys is needed

ghdl -i --std=08 -fsynopsys --workdir=ghdl_out ../src_hdl/*.vhd
ghdl -i --std=08 -fsynopsys --workdir=ghdl_out ../src_hdl/imports/*.vhd
ghdl -i --std=08 -fsynopsys --workdir=ghdl_out ../src_hdl/vampire_survivors_vhdl_main/vhdl/top_sim.vhd
ghdl -m --std=08 -fsynopsys --workdir=ghdl_out top
ghdl synth --std=08 -fsynopsys --workdir=ghdl_out --out=verilog top > top.v
