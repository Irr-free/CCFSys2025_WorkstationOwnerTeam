`define HBM_DWIDTH_PER_CHANNEL 256
`define HBM_AWIDTH_PER_CHANNEL 32
`define HBM_CHANNEL_NUM 32

/************************************/
/* change with edge pipeline num
/************************************/
`define VERTEX_PIPELINE_NUM 32
`define EDGE_PIPELINE_NUM       512
`define OMEGA_ARRAY_X           (`EDGE_PIPELINE_NUM / 2)
`define OMEGA_ARRAY_Y           9 // log2(EDGE_PIPELINE_NUM)

`define VERTEX_DWIDTH 32
`define VERTEX_AWIDTH (`HBM_AWIDTH_PER_CHANNEL * `HBM_CHANNEL_NUM / `EDGE_PIPELINE_NUM)
`define VERTEX_ID_WIDTH 32