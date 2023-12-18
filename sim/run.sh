#!/bin/bash
./clean.sh
./to_verilog.sh
./verilate.sh
./obj_dir/sim