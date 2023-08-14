# Verilog Project for Tang Nano 9K Board

The repository contains a Verilog project specially designed for the Tang Nano 9K FPGA board. Its main objective is to provide automation for synthesizing, placing, and routing Verilog designs. This is achieved using a series of scripts that also facilitate the setup of the development environment and facilitate the FPGA programming process. The two primary scripts are build.sh, which oversees the entire synthesis to bitstream generation, and setenv.sh which handles the FPGA toolchain environment setup. An additional feature is the Docker integration, allowing the encapsulation of the development environment for easy replication and distribution.

## Repository Structure

```
.
├── board
│   └── tangnano9k.cst  # Constraints file for Tang Nano 9K
├── build.sh            # Script for synthesis, placement, routing, and more
├── Docker
│   └── Dockerfile      # Dockerfile to set up the development environment
├── setenv.sh           # Script to set up the FPGA toolchain environment
└── src                 # Source folder the script looks for verilog files here 
│   └── add.v           # Sample Verilog source file
```


## Scripts Explained

### build.sh

The `build.sh` script automates the following tasks:

1. Checks if `yosys` and `nextpnr-gowin` are available in PATH.
2. Defines constants used for synthesis and routing.
3. Contains an option to build and run a Docker environment (`buildenv` argument).
4. Houses logic to create necessary directories and clean them if needed (`clean` argument).
5. Includes logic to flash the bitstream to the FPGA board (`flash` argument).
6. Finds and synthesizes all Verilog files in the `src/` directory using `yosys`.
7. Executes placement and routing using `nextpnr-gowin`.
8. Packs the result into a bitstream suitable for the target FPGA.

### setenv.sh

The `setenv.sh` script sets up the FPGA toolchain environment:

1. Clones repositories for `yosys`, `nextpnr`, and `openFPGALoader`.
2. Compiles and installs each tool.
3. Cleans up by removing the cloned repositories.

## Usage

### Environment Setup

Run the `build.sh` script to set up the docker development environment.

```bash
./build.sh buildenv
```

Once you have built the docker env now you can set up the necessary tools to synthesis the FPGA Tangnano9k running the `setenv.sh`.

```bash
./setenv.sh
```
This script will install the `yosys`, `nextpnr-gowin` and `openFPGAloader` inside the docker.

### Synthesizing, Placing, Routing and Flashing

Run the build.sh script without any arguments to trigger the entire flow from synthesis to bitstream generation:

```bash
./build.sh
```

To remove all generated files and directories, use:

```bash
./build.sh clean
```

After generating the bitstream, flash it to the FPGA board with:

```bash
./build.sh flash
```