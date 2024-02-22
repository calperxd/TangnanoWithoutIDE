#!/bin/bash

# Check if yosys is installed
if ! command -v yosys &> /dev/null; then
    echo "yosys is not installed or not in PATH!"
    exit 1
fi

# Check if nextpnr-gowin is installed
if ! command -v nextpnr-gowin &> /dev/null; then
    echo "nextpnr-gowin is not installed or not in PATH!"
    exit 1
fi

DEVICE="GW1NR-LV9QN88PC6/I5"
FAMILY="GW1N-9C"
INPUT_SYNTH_JSON="synth/synth_input.json"
OUTPUT_SYNTH_JSON="synth/synth_output.json"
RTL_JSON="rtl/netlist.json"
BOARD="board/tangnano9k.cst"
BITSTREAM="out/bitstream.fs"
TOP_ENTITY="top" # Edit this to change the top entity

case "$1" in
    buildenv)
        docker build -t verilog_project:latest -f Docker/Dockerfile .
        docker run -it --privileged -v "$(pwd)":/app -v /dev:/dev verilog_project:latest /bin/bash -c "./setenv.sh; bash"
        exit 0
        ;;
    build)
        mkdir -p out rtl synth
        VERILOG_FILES=$(find src/ -type f -name "*.v" | tr '\n' ' ')
        YOSYS_CMD="yosys -p \"read_verilog $VERILOG_FILES; hierarchy -check; opt; synth_gowin -top $TOP_ENTITY -json $INPUT_SYNTH_JSON; write_json $RTL_JSON;\""
        eval $YOSYS_CMD
        if [ $? -ne 0 ]; then
            echo "yosys command failed!"
            exit 1
        fi
        nextpnr-gowin --quiet --json $INPUT_SYNTH_JSON --write $OUTPUT_SYNTH_JSON --device $DEVICE --family $FAMILY --cst $BOARD
        if [ $? -ne 0 ]; then
            echo "nextpnr-gowin command failed!"
            exit 1
        fi
        gowin_pack -d $FAMILY -o $BITSTREAM $OUTPUT_SYNTH_JSON
        
        echo ""
        echo ""
        echo ""
        echo "Verilog files: $VERILOG_FILES"
        echo "Top entity: $TOP_ENTITY"
        echo "Bitstream generated : $BITSTREAM"
        ;;
    clean)
        echo "Cleaning up..."
        rm -rf rtl/ synth/ out/
        ;;
    flash)
        if [ ! -f out/*.fs ]; then
            echo "Error: No .fs file found in out/ directory!"
            exit 1
        fi
        echo "Flashing..."
        openFPGALoader --list-cables
        openFPGALoader -m -b tangnano9k $BITSTREAM
        echo "Flashed"
        ;;
    *)
        echo "Error: Invalid option. Valid options are buildenv, build, clean, flash."
        exit 1
        ;;
esac
