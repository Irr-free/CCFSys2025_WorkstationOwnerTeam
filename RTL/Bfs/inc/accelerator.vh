/*********************************************
* do not change
**********************************************/
`define HBM_AWIDTH      32
`define HBM_DWIDTH      512
`define MAX_VERTEX_NUM 1048576 // 1024*1024  vertex:1024*1024 = 1048576 / 16384  
`define HBM_EDGE_MASK   16
`define CACHELINE_LEN   16
`define CACHELINE_LEN_WIDTH 4
`define BITMAP_COMPRESSED_LENGTH    32
`define BITMAP_COMPRESSED_LENGTH_WIDTH  5


/*********************************************
* change core_num and channel_num and bitmap_compressed_num to do simulation
**********************************************/
`define CORE_NUM        32
`define CORE_NUM_WIDTH  5
`define PSEUDO_CHANNEL_NUM  2
`define BITMAP_COMPRESSED_NUM   ((`MAX_VERTEX_NUM + `CORE_NUM * `BITMAP_COMPRESSED_LENGTH - 1) / (`CORE_NUM * `BITMAP_COMPRESSED_LENGTH))
`define BITMAP_COMPRESSED_NUM_WIDTH 10  //  vertex,num_width = (1048576,9) / (16384,3) 

`define VERTICAL_NUM 2
`define VERTICAL_NUM_WIDTH 1
`define HORIZONTAL_NUM 16
`define HORIZONTAL_NUM_WIDTH 4

/*********************************************
* other paras include time width
*********************************************/
`define TIME_WIDTH 20


/*********************************************
* change vtx_num and edge_num to check different graph
*********************************************/
`define VTX_NUM_WIDTH   20//20   vertex,num_width = (1048576,20) / (16384,14)
`define EDGE_NUM_WIDTH  25//16:20 32:18  64:log2(1024*1024*32/64),图中边数最大大约在3000万点左右  vertex,num_width = (1048576,20) / (16384,20)

/*************************************************
* do not change
*************************************************/
`define V_ID_WIDTH      `VTX_NUM_WIDTH
`define V_OFF_AWIDTH    (`VTX_NUM_WIDTH - `CORE_NUM_WIDTH)
`define V_OFF_DWIDTH    `EDGE_NUM_WIDTH
`define V_VALUE_WIDTH   `V_ID_WIDTH

`define GROUP_CORE_NUM      (`CORE_NUM / `PSEUDO_CHANNEL_NUM)
`define GROUP_CORE_NUM_WIDTH 4
`define HBM_DWIDTH_PER_CORE (`HBM_DWIDTH / `GROUP_CORE_NUM) //32

`define VTX_BRAM_AWIDTH     (`VTX_NUM_WIDTH - `CORE_NUM_WIDTH) // 8
`define VTX_BRAM_DWIDTH     8
`define FIRST_EDGE_BRAM_AWIDTH `VTX_BRAM_AWIDTH
`define FIRST_EDGE_BRAM_DWIDTH `VTX_NUM_WIDTH

`define OMEGA_DEPTH     `CORE_NUM_WIDTH
`define OMEGA_SWITCH_NUM    (`CORE_NUM / 2)

`define ITERATION_DWIDTH  3
`define FIFO_SIZE           16
`define FIFO_SIZE_WIDTH     4
`define OM_FIFO_SIZE        8
`define OM_FIFO_SIZE_WIDTH  3
`define MAX_TASK_NUM 16  //(`FIFO_SIZE * 3 / 2)

`define POWERLAW_VTX_NUM 32
`define INVALID_BFS_VALUE 7
`define INVALID_PULL_VALUE 8

`define MAX_ITERATION_NUM 6


/*********************************************
* for testbench, change to check different graphs
*********************************************/
// `define FILE_LOC "/home/junshuang/project/accelerator/bfs_acc/data/"

// `define LP_MAX_LENGTH0 4154 // WIKI_Vote(data):4154  data_32_LG:8192
// `define LP_MAX_LENGTH1 4144 // WIKI_Vote(data):4144  data_32_LG:8191

// `define root_id 32'h00000003        // data:3  data_32_LG:1
// `define vertex_num 32'd8298         // data:8298  data_32_LG:16383
// `define bitmap_compressed_num 32'd16 // data:9  data_32_LG:16
// `define iteration_num 32'd6         // same as the MAX_ITERATION_NUM

// `define axi00_length 1150630        //16:556410 lg_32:1307439 wk_32(data):1150630, line number of the edge_channel_small_x.txt
// `define axi01_length 1148046        // lg_32:1313387 wk_32:1148046
// `define axi02_length 32768          // lg_32:32769-1 wk_32:32769-1
// `define axi03_length 32768          // lg_32:32769-1 wk_32:32769-1

// `define FILE_LOC "/home/junshuang/project/accelerator/bfs_acc/data_32_LG/"

// `define LP_MAX_LENGTH0 8192 // WIKI_Vote(data):4154  data_32_LG:8192
// `define LP_MAX_LENGTH1 8191 // WIKI_Vote(data):4144  data_32_LG:8191

// `define root_id 32'h00000001        // data:3  data_32_LG:1
// `define vertex_num 32'd16383         // data:8298  data_32_LG:16383
// `define bitmap_compressed_num 32'd16 // data:9  data_32_LG:16
// `define iteration_num 32'd6         // same as the MAX_ITERATION_NUM

// `define axi00_length 1307439        //16:556410 lg_32:1307439 wk_32(data):1150630, line number of the edge_channel_small_x.txt
// `define axi01_length 1313387        // lg_32:1313387 wk_32:1148046
// `define axi02_length 32768          // lg_32:32769-1 wk_32:32769-1
// `define axi03_length 32768          // lg_32:32769-1 wk_32:32769-1

`define FILE_LOC "/home/junshuang/Project/Benchmark/BFS/bfs_acc/data_rmat18/"

`define LP_MAX_LENGTH0 131072 // WIKI_Vote(data):4154  data_32_LG:8192
`define LP_MAX_LENGTH1 131072 // WIKI_Vote(data):4144  data_32_LG:8191

`define root_id 32'd4000        // data:3  data_32_LG:1
`define vertex_num 32'd262144         // data:8298  data_32_LG:16383
`define bitmap_compressed_num 32'd256 // data:9  data_32_LG:16
`define iteration_num 32'd6         // same as the MAX_ITERATION_NUM

`define axi00_length 4950454        //16:556410 lg_32:1307439 wk_32(data):1150630, line number of the edge_channel_small_x.txt
`define axi01_length 4757594        // lg_32:1313387 wk_32:1148046
`define axi02_length 32768          // lg_32:32769-1 wk_32:32769-1
`define axi03_length 1048607          // lg_32:32769-1 wk_32:32769-1