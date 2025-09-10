# PRAGA

PRAGA is a power-efficient and high-throughput system for graph processing.

## Building PRAGA Simulator

PRAGA Simulator is built using cmake tools. To build Simulator and its testcase, run:

> cd acc_sim && mkdir build && cd build && cmake .. && make

## Test

If you want to test PRAGA Simulator, building it at first and then run:

> cd acc_sim/build && make cpsh && sh -xe  run_test.sh


*INFO: Please make sure DEBUG=1 and CONTROL_FLAG=1 in acc_sim/inc/Accelerator.h*
