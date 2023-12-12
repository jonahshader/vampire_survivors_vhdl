#*****************************************************************************************
# Tcl script for re-creating project 'vampire_survivors_vhdl_main' in Vivado 2023.1
#*****************************************************************************************
# In order to re-create the project, please source this file in the Vivado Tcl Shell.
# From bash: /opt/xilinx/Vivado/2023.1/bin/vivado -mode batch -source vampire_survivors_vhdl_main.tcl
# OR
# source /opt/xilinx/Vivado/2023.1/settings64.sh
# vivado -mode batch -source vampire_survivors_vhdl_main.tcl
# where /opt/xilinx is the Vivado installation path prefix.
#
# To perform an entire build all the way through to generating the .xsa file:
# vivado -mode batch -source vampire_survivors_vhdl_main.tcl -tclargs bit
#
# On Windows open Vivado then select the Tcl Console at the bottom and run:
# source [path_to_repo]/vivado/vampire_survivors_vhdl_main.tcl

set proj_name "vampire_survivors_vhdl_main"

# By default only generate a project, don't synthesize/implement/generate a bitstream.
set gen_bitstream 0
if { $argc > 0 } {
  if { [lindex $argv 0] == "bit" } {
    set gen_bitstream 1
  }
}
puts "gen_bitstream=${gen_bitstream}"

# Get the path to this script [the git repo]/vivado
set base_dir [file dirname [file normalize [info script]]]
set proj_dir ${base_dir}/${proj_name}
set src_dir [file normalize "${base_dir}/../src_hdl/${proj_name}"]
set src_common_dir [file normalize "${base_dir}/../src_hdl"]

create_project ${proj_name} ${proj_dir} -part xc7a100tcsg324-1 -force
set_property target_language    VHDL [current_project]
set_property simulator_language VHDL [current_project]

# List of source files to be added to the project (VHDL and IPs)
set src_files [list \
  [file normalize "${src_common_dir}/multi_vga.vhd"] \
  [file normalize "${src_common_dir}/vga.vhd"] \
  [file normalize "${src_common_dir}/screen.vhd"] \
  [file normalize "${src_common_dir}/gpu.vhd"] \
  [file normalize "${src_common_dir}/gpu_test.vhd"] \
  [file normalize "${src_common_dir}/gpu_codes.vhd"] \
  [file normalize "${src_common_dir}/rect_renderer.vhd"] \
  [file normalize "${src_common_dir}/circle_renderer.vhd"] \
  [file normalize "${src_common_dir}/line_renderer.vhd"] \
  [file normalize "${src_common_dir}/sprite_renderer.vhd"] \
  [file normalize "${src_common_dir}/tile_renderer.vhd"] \
  [file normalize "${src_common_dir}/pixel_translator.vhd"] \
  [file normalize "${src_common_dir}/input_sync.vhd"] \
  [file normalize "${src_common_dir}/level_pkg.vhd"] \
  [file normalize "${src_common_dir}/render_level1.vhd"] \
  [file normalize "${src_common_dir}/render_player.vhd"] \
  [file normalize "${src_common_dir}/custom_types.vhd"] \
  [file normalize "${src_common_dir}/render_game.vhd"] \
  [file normalize "${src_common_dir}/imports/bram_sdp.vhd"] \
  [file normalize "${src_common_dir}/imports/prom.vhd"] \
  [file normalize "${src_common_dir}/imports/clock_mux.vhd"] \
  [file normalize "${src_common_dir}/imports/square_root.vhd"] \
  [file normalize "${src_common_dir}/auto_atk.vhd"] \
  [file normalize "${src_common_dir}/clkdiv.vhd"] \
  [file normalize "${src_common_dir}/keyboard_ctrl.vhd"] \
  [file normalize "${src_common_dir}/keybinds.vhd"] \
  [file normalize "${src_common_dir}/gamestate.vhd"] \
  [file normalize "${src_common_dir}/inv_mng.vhd"] \
  [file normalize "${src_common_dir}/item_gen_rand.vhd"] \
  [file normalize "${src_common_dir}/player_stat.vhd"] \
  [file normalize "${src_common_dir}/player_move.vhd"] \
  [file normalize "${src_common_dir}/Bram_control.vhd"] \
  [file normalize "${src_common_dir}/Enemy_Generator.vhd"] \
  [file normalize "${src_common_dir}/Enemy_update_ctrl.vhd"] \
  [file normalize "${src_common_dir}/Enemy_update_unit.vhd"] \
  [file normalize "${src_common_dir}/RandomNumberGenerator.vhd"] \
  [file normalize "${src_common_dir}/imports/plotline.vhd"] \
  [file normalize "${src_common_dir}/rom/forest_tiles_fixed.rom"] \
  [file normalize "${src_dir}/ip/vga_clocks/vga_clocks.xci"] \
  [file normalize "${src_dir}/vhdl/top.vhd"] \
]

# List of constraints files to be added
set constr_files [list \
  [file normalize "${src_dir}/constr/${proj_name}.xdc"] \
]


# Add the source files to the project and set as VHDL 2008
# TODO: use VHDL 2019?
add_files -fileset sources_1 ${src_files}
set_property file_type {VHDL 2008} [get_files -of_objects [get_filesets sources_1] -filter {is_generated == false} *.vhd]

# Add the constraints files to the project
add_files -fileset constrs_1 ${constr_files}

# Use ExtraTimingOpt implementation strategy for now. TODO: fix 100/200 MHz timing
# set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]
set_property strategy {Vivado Implementation Defaults} [get_runs impl_1]

if { $gen_bitstream } {
  # Mimic GUI behavior of automatically setting top and file compile order
  update_compile_order -fileset sources_1

  # Launch Synthesis
  launch_runs synth_1
  wait_on_run synth_1

  # Launch Implementation
  launch_runs impl_1 -to_step write_bitstream
  wait_on_run impl_1
  
  # TODO: not sure if this writes bitstream
}