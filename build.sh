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

# If the first argument is "buildenv", clone the yosys repository and build the Docker image
if [ "$1" == "buildenv" ]; then
    docker build -t verilog_project:latest -f Docker/Dockerfile .
    docker run -it --privileged -v $(pwd):/app -v /dev:/dev verilog_project:latest
    exit 0
fi

# Create necessary directories
mkdir -p out
mkdir -p rtl
mkdir -p synth

# If the first argument is "clean", clean up the directories
if [ "$1" == "clean" ]; then
    echo "Cleaning up..."
    rm -rf rtl/
    rm -rf synth/
    rm -rf out/
    exit 0  # Exit after cleaning
fi

# If the first argument is "flash", flash the bitstream to the FPGA
if [ "$1" == "flash" ]; then
    # Check for .fs file in out/ directory
    if [ ! -f out/*.fs ]; then
        echo "Error: No .fs file found in out/ directory!"
        exit 1
    fi
    
    echo "Flashing..."
    openFPGALoader -f -b tangnano9k $BITSTREAM
    echo "Flashed"
    exit 0  # Exit after cleaning
fi


# Function to find all Verilog files
find_verilog_files() {
    find src/ -type f -name "*.v" | tr '\n' ' '
}

# Construct the yosys command
VERILOG_FILES=$(find_verilog_files)
YOSYS_CMD="yosys -p \"read_verilog $VERILOG_FILES; hierarchy -check; opt; synth_gowin -top $TOP_ENTITY -json $INPUT_SYNTH_JSON; write_json $RTL_JSON;\""

# Run yosys
eval $YOSYS_CMD
if [ $? -ne 0 ]; then
    echo "yosys command failed!"
    exit 1
fi

# Execute place and route with nextpnr-gowin
nextpnr-gowin   --quiet \
                --json $INPUT_SYNTH_JSON \
                --write $OUTPUT_SYNTH_JSON \
                --device $DEVICE \
                --family $FAMILY \
                --cst $BOARD
if [ $? -ne 0 ]; then
    echo "nextpnr-gowin command failed!"
    exit 1
fi

gowin_pack -d $FAMILY -o $BITSTREAM $OUTPUT_SYNTH_JSON

# Display the used Verilog files and top entity
echo "Verilog files: $VERILOG_FILES"
echo "Top entity: $TOP_ENTITY"
echo "Bitstream generated : $BITSTREAM"
