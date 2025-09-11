# PRAGA

PRAGA is a power-efficient and high-throughput system for graph processing.

## Building PRAGA Simulator

PRAGA Simulator is built using cmake tools. To build Simulator and its testcase, run:

> cd acc_sim && mkdir build && cd build && cmake .. && make

## Test

If you want to test PRAGA Simulator, building it at first and then run:

> cd acc_sim/build && make cpsh && sh -xe  run_test.sh


*INFO: Please make sure DEBUG=1 and CONTROL_FLAG=1 in acc_sim/inc/Accelerator.h*

## Running PRAGA on FPGA

The RTL code is located in the `RTL/` directory. Specifically, the `RTL/Bfs/` and `RTL/DeltaPR/` directories contain the BFS accelerator and the PageRank accelerator, respectively.

To run the accelerator, follow these steps using the Xilinx Vitis unified software platform:

1. Create a new project in Vitis
2. Click the "Launch RTL Kernel Wizard" from the "Xilinx"" dropdown menu
3. In the opened Vivado window, configure the CPU-FPGA interface settings and add the relevant RTL code to the project, including files in `axi/`, `inc/`, `ip/`, `top/` and `testbench/`
4. Click the "Generate RTL Kernel" command from the "Vivado Flow Navigator" > "Project Manager menu"
5. After exporting the RTL project, return to Vitis, import the host code from `host/` and configure the dataset in the `host.cpp`
6. Now, you can build and run the entire project to launch the accelerator
