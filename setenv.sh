#!/bin/bash


git clone https://github.com/YosysHQ/yosys.git
git clone https://github.com/YosysHQ/nextpnr.git
git clone https://github.com/trabucayre/openFPGALoader.git

cd yosys
make config-gcc 
make -j$(nproc) 
make install
cd .. 
cd nextpnr 
cmake . -DARCH=gowin -DGOWIN_BBA_EXECUTABLE=$(which gowin_bba) 
make -j$(nproc) 
make install 
cd ..
cd openFPGALoader
mkdir build && cd build
cmake ..
make -j$(nproc)
make install
cd ..
cd ..
rm -rf yosys
rm -rf nextpnr
rm -rf openFPGALoader
