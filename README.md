# Graph500-ACC

Graph500-ACC is a power-efficient system for graph processing.

## Online Document 

none
## Building Graph500-ACC Simulator

Graph500-ACC Simulator is built using cmake tools. To build Simulator and its testcase, run:

> cd acc_sim && mkdir build && cd build && cmake .. && make

## Test

if you want to test Graph500-ACC Simulator, building it at first and then run:

> cd acc_sim/build && make cpsh && sh -xe  run_test.sh

*INFO: Please make sure DEBUG=1 and CONTROL_FLAG=1 in acc_sim/inc/Accelerator.h*