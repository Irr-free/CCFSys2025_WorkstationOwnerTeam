/*********************************************
* do not change
**********************************************/
`define HBM_AWIDTH      32
`define HBM_DWIDTH      512
`define HBM_EDGE_MASK   16
`define CACHELINE_LEN   16
`define CACHELINE_LEN_WIDTH 4
`define BITMAP_COMPRESSED_LENGTH    32
`define BITMAP_COMPRESSED_LENGTH_WIDTH  5


/*********************************************
* change core_num and channel_num and bitmap_compressed_num to do simulation
**********************************************/
`define CORE_NUM        64
`define CORE_NUM_WIDTH  6
`define PSEUDO_CHANNEL_NUM  4
`define BITMAP_COMPRESSED_NUM       8
`define BITMAP_COMPRESSED_NUM_WIDTH 3

/*********************************************
* change vtx_num and edge_num to check different graph
*********************************************/
`define VTX_NUM_WIDTH   14
`define EDGE_NUM_WIDTH  18

/*************************************************
* do not change
*************************************************/
`define V_ID_WIDTH      `VTX_NUM_WIDTH
`define V_OFF_AWIDTH    (`VTX_NUM_WIDTH - `CORE_NUM_WIDTH)
`define V_OFF_DWIDTH    `EDGE_NUM_WIDTH
`define V_VALUE_WIDTH   `EDGE_NUM_WIDTH

`define GROUP_CORE_NUM      (`CORE_NUM / `PSEUDO_CHANNEL_NUM)
`define GROUP_CORE_NUM_WIDTH 4
`define HBM_DWIDTH_PER_CORE (`HBM_DWIDTH / `GROUP_CORE_NUM)

`define VTX_BRAM_AWIDTH     (`VTX_NUM_WIDTH - `CORE_NUM_WIDTH)
`define VTX_BRAM_DWIDTH     8
`define FIRST_EDGE_BRAM_AWIDTH `VTX_BRAM_AWIDTH
`define FIRST_EDGE_BRAM_DWIDTH `EDGE_NUM_WIDTH

`define OMEGA_DEPTH     `CORE_NUM_WIDTH
`define OMEGA_SWITCH_NUM    (`CORE_NUM / 2)

`define ITERATION_DWIDTH  3
`define FIFO_SIZE           16
`define FIFO_SIZE_WIDTH     4
`define OM_FIFO_SIZE        4
`define OM_FIFO_SIZE_WIDTH  2
`define MAX_TASK_NUM 16//(`FIFO_SIZE * 3 / 2)

`define POWERLAW_VTX_NUM 32
`define INVALID_BFS_VALUE 7
`define INVALID_PULL_VALUE 8

`define MAX_ITERATION_NUM 6