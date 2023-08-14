# Tangnano9k Without IDE

This repository contains a simple Verilog project that provides an example setup for development on the Tang Nano 9K board. The structure of the repository is organized for clarity and easy setup with Docker and shell scripts.

# Repository Structure

.
├── board         # Board-specific files
│   └── tangnano9k.cst  # Constraints file for Tang Nano 9K
├── build.sh      # Build script for compiling the Verilog sources
├── Docker        # Docker-related files for containerized environment
│   └── Dockerfile    # Dockerfile to set up the development environment
├── setenv.sh     # Environment setup script
└── src           # Source directory containing Verilog files
    └── add.v     # Sample Verilog source file
