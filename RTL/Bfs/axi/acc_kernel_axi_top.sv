// This is a generated file. Use and modify at your own risk.
//////////////////////////////////////////////////////////////////////////////// 
// default_nettype of none prevents implicit wire declaration.
`include "accelerator.vh"
`default_nettype none
module acc_kernel_axi_top #(
  parameter integer C_M00_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M00_AXI_DATA_WIDTH = 512,
  parameter integer C_M01_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M01_AXI_DATA_WIDTH = 512,
  parameter integer C_M02_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M02_AXI_DATA_WIDTH = 512,
  parameter integer C_M03_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M03_AXI_DATA_WIDTH = 512,
  // acc parameter
  parameter integer V_ID_WIDTH = `V_ID_WIDTH,
  parameter integer V_OFF_AWIDTH = `V_OFF_AWIDTH,
  parameter integer V_OFF_DWIDTH = `V_OFF_DWIDTH,
  parameter integer V_VALUE_WIDTH = `V_VALUE_WIDTH,
  parameter integer CORE_NUM = `CORE_NUM,
  parameter integer CORE_NUM_WIDTH = `CORE_NUM_WIDTH,
  parameter integer ITERATION_DWIDTH = `ITERATION_DWIDTH,
  parameter integer HBM_AWIDTH = `HBM_AWIDTH,
  parameter integer HBM_DWIDTH = `HBM_DWIDTH,
  parameter integer HBM_DWIDTH_PER_CORE = `HBM_DWIDTH_PER_CORE,
  parameter integer HBM_EDGE_MASK = `HBM_EDGE_MASK,
  parameter integer FIRST_EDGE_BRAM_AWIDTH = `FIRST_EDGE_BRAM_AWIDTH,
  parameter integer PSEUDO_CHANNEL_NUM = `PSEUDO_CHANNEL_NUM,
  parameter integer GROUP_CORE_NUM = `GROUP_CORE_NUM,
  parameter integer POWERLAW_VTX_NUM = `POWERLAW_VTX_NUM,
  parameter integer VTX_BRAM_AWIDTH = `VTX_BRAM_AWIDTH,
  parameter integer VTX_BRAM_DWIDTH = `VTX_BRAM_DWIDTH,
  parameter integer VTX_NUM_WIDTH = `VTX_NUM_WIDTH,
  parameter integer BITMAP_COMPRESSED_LENGTH = `BITMAP_COMPRESSED_LENGTH,
  parameter integer BITMAP_COMPRESSED_LENGTH_WIDTH = `BITMAP_COMPRESSED_LENGTH_WIDTH
)
(
  // System Signals
  input  wire                              ap_clk         ,
  input  wire                              ap_rst_n       ,
  // AXI4 master interface m00_axi
  output wire                              m00_axi_awvalid,
  input  wire                              m00_axi_awready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_awaddr ,
  output wire [8-1:0]                      m00_axi_awlen  ,
  output wire                              m00_axi_wvalid ,
  input  wire                              m00_axi_wready ,
  output wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_wdata  ,
  output wire [C_M00_AXI_DATA_WIDTH/8-1:0] m00_axi_wstrb  ,
  output wire                              m00_axi_wlast  ,
  input  wire                              m00_axi_bvalid ,
  output wire                              m00_axi_bready ,
  output wire                              m00_axi_arvalid,
  input  wire                              m00_axi_arready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_araddr ,
  output wire [8-1:0]                      m00_axi_arlen  ,
  input  wire                              m00_axi_rvalid ,
  output wire                              m00_axi_rready ,
  input  wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_rdata  ,
  input  wire                              m00_axi_rlast  ,
  // AXI4 master interface m01_axi
  output wire                              m01_axi_awvalid,
  input  wire                              m01_axi_awready,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]   m01_axi_awaddr ,
  output wire [8-1:0]                      m01_axi_awlen  ,
  output wire                              m01_axi_wvalid ,
  input  wire                              m01_axi_wready ,
  output wire [C_M01_AXI_DATA_WIDTH-1:0]   m01_axi_wdata  ,
  output wire [C_M01_AXI_DATA_WIDTH/8-1:0] m01_axi_wstrb  ,
  output wire                              m01_axi_wlast  ,
  input  wire                              m01_axi_bvalid ,
  output wire                              m01_axi_bready ,
  output wire                              m01_axi_arvalid,
  input  wire                              m01_axi_arready,
  output wire [C_M01_AXI_ADDR_WIDTH-1:0]   m01_axi_araddr ,
  output wire [8-1:0]                      m01_axi_arlen  ,
  input  wire                              m01_axi_rvalid ,
  output wire                              m01_axi_rready ,
  input  wire [C_M01_AXI_DATA_WIDTH-1:0]   m01_axi_rdata  ,
  input  wire                              m01_axi_rlast  ,
  // AXI4 master interface m02_axi
  output wire                              m02_axi_awvalid,
  input  wire                              m02_axi_awready,
  output wire [C_M02_AXI_ADDR_WIDTH-1:0]   m02_axi_awaddr ,
  output wire [8-1:0]                      m02_axi_awlen  ,
  output wire                              m02_axi_wvalid ,
  input  wire                              m02_axi_wready ,
  output wire [C_M02_AXI_DATA_WIDTH-1:0]   m02_axi_wdata  ,
  output wire [C_M02_AXI_DATA_WIDTH/8-1:0] m02_axi_wstrb  ,
  output wire                              m02_axi_wlast  ,
  input  wire                              m02_axi_bvalid ,
  output wire                              m02_axi_bready ,
  output wire                              m02_axi_arvalid,
  input  wire                              m02_axi_arready,
  output wire [C_M02_AXI_ADDR_WIDTH-1:0]   m02_axi_araddr ,
  output wire [8-1:0]                      m02_axi_arlen  ,
  input  wire                              m02_axi_rvalid ,
  output wire                              m02_axi_rready ,
  input  wire [C_M02_AXI_DATA_WIDTH-1:0]   m02_axi_rdata  ,
  input  wire                              m02_axi_rlast  ,
  // AXI4 master interface m03_axi
  output wire                              m03_axi_awvalid,
  input  wire                              m03_axi_awready,
  output wire [C_M03_AXI_ADDR_WIDTH-1:0]   m03_axi_awaddr ,
  output wire [8-1:0]                      m03_axi_awlen  ,
  output wire                              m03_axi_wvalid ,
  input  wire                              m03_axi_wready ,
  output wire [C_M03_AXI_DATA_WIDTH-1:0]   m03_axi_wdata  ,
  output wire [C_M03_AXI_DATA_WIDTH/8-1:0] m03_axi_wstrb  ,
  output wire                              m03_axi_wlast  ,
  input  wire                              m03_axi_bvalid ,
  output wire                              m03_axi_bready ,
  output wire                              m03_axi_arvalid,
  input  wire                              m03_axi_arready,
  output wire [C_M03_AXI_ADDR_WIDTH-1:0]   m03_axi_araddr ,
  output wire [8-1:0]                      m03_axi_arlen  ,
  input  wire                              m03_axi_rvalid ,
  output wire                              m03_axi_rready ,
  input  wire [C_M03_AXI_DATA_WIDTH-1:0]   m03_axi_rdata  ,
  input  wire                              m03_axi_rlast  ,
  // Control Signals
  input  wire                              ap_start       ,
  output wire                              ap_idle        ,
  output wire                              ap_done        ,
  output wire                              ap_ready       ,
  input  wire [32-1:0]                     root_id        ,
  input  wire [32-1:0]                     vertex_num     ,
  input  wire [32-1:0]               bitmap_compressed_num,
  input  wire [32-1:0]                     iteration_num  ,
  input  wire [31:0]                 powerlaw_vertex_id_00,
  input  wire [31:0]                 powerlaw_vertex_id_01,
  input  wire [31:0]                 powerlaw_vertex_id_02,
  input  wire [31:0]                 powerlaw_vertex_id_03,
  input  wire [31:0]                 powerlaw_vertex_id_04,
  input  wire [31:0]                 powerlaw_vertex_id_05,
  input  wire [31:0]                 powerlaw_vertex_id_06,
  input  wire [31:0]                 powerlaw_vertex_id_07,
  input  wire [31:0]                 powerlaw_vertex_id_08,
  input  wire [31:0]                 powerlaw_vertex_id_09,
  input  wire [31:0]                 powerlaw_vertex_id_10,
  input  wire [31:0]                 powerlaw_vertex_id_11,
  input  wire [31:0]                 powerlaw_vertex_id_12,
  input  wire [31:0]                 powerlaw_vertex_id_13,
  input  wire [31:0]                 powerlaw_vertex_id_14,
  input  wire [31:0]                 powerlaw_vertex_id_15,
  input  wire [31:0]                 powerlaw_vertex_id_16,
  input  wire [31:0]                 powerlaw_vertex_id_17,
  input  wire [31:0]                 powerlaw_vertex_id_18,
  input  wire [31:0]                 powerlaw_vertex_id_19,
  input  wire [31:0]                 powerlaw_vertex_id_20,
  input  wire [31:0]                 powerlaw_vertex_id_21,
  input  wire [31:0]                 powerlaw_vertex_id_22,
  input  wire [31:0]                 powerlaw_vertex_id_23,
  input  wire [31:0]                 powerlaw_vertex_id_24,
  input  wire [31:0]                 powerlaw_vertex_id_25,
  input  wire [31:0]                 powerlaw_vertex_id_26,
  input  wire [31:0]                 powerlaw_vertex_id_27,
  input  wire [31:0]                 powerlaw_vertex_id_28,
  input  wire [31:0]                 powerlaw_vertex_id_29,
  input  wire [31:0]                 powerlaw_vertex_id_30,
  input  wire [31:0]                 powerlaw_vertex_id_31,
  input  wire [64-1:0]                     axi00_ptr0     ,
  input  wire [64-1:0]                     axi01_ptr0     ,
  input  wire [64-1:0]                     axi02_ptr0     ,
  input  wire [64-1:0]                     axi03_ptr0     
);


timeunit 1ps;
timeprecision 1ps;

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
// Large enough for interesting traffic.
localparam integer  LP_DEFAULT_LENGTH_IN_BYTES = 16384;
localparam integer  LP_NUM_EXAMPLES    = 2; //(32 kernel:32 channel)

localparam integer  BITMAP_DISPATCHER_WIDTH = CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH - 9;

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////
(* KEEP = "yes" *)
logic                                areset                         = 1'b0;
logic                                ap_start_r                     = 1'b0;
logic                                ap_idle_r                      = 1'b1;
logic                                ap_start_pulse                ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_i                     ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_r                      = {LP_NUM_EXAMPLES{1'b0}};
logic [32-1:0]                       ctrl_constant                  = 32'd1;
// kernel
wire [POWERLAW_VTX_NUM * 32 - 1 : 0]    init_vertex_not_read;
wire [HBM_DWIDTH - 1 : 0]               bitmap;
wire [BITMAP_DISPATCHER_WIDTH - 1 : 0]  bitmap_loader_counter;
wire                                    bitmap_valid;

wire [HBM_DWIDTH * (PSEUDO_CHANNEL_NUM / 2) - 1 : 0]  first_edge;
wire [PSEUDO_CHANNEL_NUM / 2 - 1 : 0]   first_edge_loader_counter;
wire [PSEUDO_CHANNEL_NUM / 2 - 1 : 0]   first_edge_valid;

wire [CORE_NUM - 1 : 0]                 P1_transfer_complete;
wire [CORE_NUM - 1 : 0]                 P1_iteration_done;
wire [CORE_NUM - 1 : 0]                 P1_next_rst;
wire [CORE_NUM - 1 : 0]                 P1_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]    P1_active_v_id;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] P1_active_v_value;
wire [CORE_NUM - 1 : 0]                 P1_active_v_pull_first_flag;
wire [CORE_NUM - 1 : 0]                 P1_active_v_valid;
wire [CORE_NUM - 1 : 0]                 P1_iteration_end;
wire [CORE_NUM - 1 : 0]                 P1_iteration_end_valid;
wire [CORE_NUM * ITERATION_DWIDTH - 1 : 0]  P1_global_iteration_id;
wire [POWERLAW_VTX_NUM * 32 - 1 : 0]    P1_vertex_not_read;
wire [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0]  P1_global_powerlaw_v_visit;
wire [V_ID_WIDTH - 1 : 0]               P1_global_root_id;

wire [CORE_NUM - 1 : 0]                 P2_next_rst;
wire [CORE_NUM - 1 : 0]                 P2_stage_full;
wire [CORE_NUM - 1 : 0]                 P2_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]    P2_active_v_id;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] P2_active_v_value;
wire [CORE_NUM * V_OFF_AWIDTH - 1 : 0]  P2_rd_active_v_offset_addr;
wire [CORE_NUM - 1 : 0]                 P2_active_v_pull_first_flag;
wire [CORE_NUM - 1 : 0]                 P2_active_v_valid;
wire [CORE_NUM - 1 : 0]                 P2_iteration_end;
wire [CORE_NUM - 1 : 0]                 P2_iteration_end_valid;
wire [CORE_NUM * ITERATION_DWIDTH - 1 : 0]  P2_global_iteration_id;
wire [POWERLAW_VTX_NUM * 32 - 1 : 0]    P2_vertex_not_read;
wire [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0]  P2_global_powerlaw_v_visit;
wire [V_ID_WIDTH - 1 : 0]               P2_global_root_id;

wire [CORE_NUM - 1 : 0]                 P3_transfer_complete;
//wire [PSEUDO_CHANNEL_NUM * HBM_AWIDTH - 1 : 0]  P3_hbm_controller_addr;
//wire [PSEUDO_CHANNEL_NUM - 1 : 0]  P3_hbm_addr_valid;
wire [LP_NUM_EXAMPLES * HBM_AWIDTH - 1 : 0]  P3_hbm_controller_addr;
wire [LP_NUM_EXAMPLES - 1 : 0]  P3_hbm_addr_valid;
wire [CORE_NUM - 1 : 0]                 P3_next_rst;
wire [CORE_NUM * V_OFF_DWIDTH - 1 : 0]  P3_active_v_loffset;
wire [CORE_NUM * V_OFF_DWIDTH - 1 : 0]  P3_active_v_roffset;
wire [CORE_NUM - 1 : 0]                 P3_active_v_valid;

wire [CORE_NUM - 1 : 0]                 P4_next_rst;
wire [CORE_NUM - 1 : 0]                 P4_stage_full;
wire [CORE_NUM * HBM_AWIDTH - 1 : 0]    P4_rd_hbm_edge_addr;
wire [CORE_NUM * HBM_EDGE_MASK - 1 : 0] P4_rd_hbm_edge_mask;
wire [CORE_NUM - 1 : 0]                 P4_hbm_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]    P4_hbm_active_v_id;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] P4_hbm_active_v_value;
wire [CORE_NUM - 1 : 0]                 P4_rd_hbm_edge_valid;
wire [CORE_NUM * FIRST_EDGE_BRAM_AWIDTH - 1 : 0]  P4_rd_bram_edge_addr;
wire [CORE_NUM - 1 : 0]                 P4_bram_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]    P4_bram_active_v_id;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] P4_bram_active_v_value;
wire [CORE_NUM - 1 : 0]                 P4_rd_bram_edge_valid;
wire [CORE_NUM - 1 : 0]                 P4_iteration_end;
wire [CORE_NUM - 1 : 0]                 P4_iteration_end_valid;
wire [CORE_NUM * ITERATION_DWIDTH - 1 : 0]  P4_global_iteration_id;
wire [POWERLAW_VTX_NUM * 32 - 1 : 0]    P4_vertex_not_read;
wire [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0]  P4_global_powerlaw_v_visit;
wire [V_ID_WIDTH - 1 : 0]               P4_global_root_id;

wire [CORE_NUM - 1 : 0]                 P5_next_rst;
wire [CORE_NUM - 1 : 0]                 P5_stage_full;
wire [PSEUDO_CHANNEL_NUM * HBM_AWIDTH - 1 : 0]    P5_rd_hbm_edge_addr;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]                 P5_rd_hbm_edge_valid;
wire [CORE_NUM - 1 : 0]                 P5_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]    P5_active_v_id;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] P5_active_v_value;
wire [CORE_NUM - 1 : 0]                 P5_active_v_valid;
wire [CORE_NUM - 1 : 0]                 P5_iteration_end;
wire [CORE_NUM - 1 : 0]                 P5_iteration_end_valid;
wire [CORE_NUM * ITERATION_DWIDTH - 1 : 0]  P5_global_iteration_id;
wire [POWERLAW_VTX_NUM * 32 - 1 : 0]    P5_vertex_not_read;
wire [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0]  P5_global_powerlaw_v_visit;
wire [V_ID_WIDTH - 1 : 0]               P5_global_root_id;

wire [PSEUDO_CHANNEL_NUM / 2 - 1 : 0]   P5_2_transfer_complete;
wire [CORE_NUM - 1 : 0]                 P5_2_stage_full;
wire [CORE_NUM - 1 : 0]                 P5_2_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]    P5_2_active_v_id;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] P5_2_active_v_value;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]    P5_2_active_v_edge;
wire [CORE_NUM - 1 : 0]                 P5_2_active_v_valid;
wire [CORE_NUM - 1 : 0]                 P5_2_iteration_end;
wire [CORE_NUM - 1 : 0]                 P5_2_iteration_end_valid;

/*
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_interface_full;
wire [PSEUDO_CHANNEL_NUM * HBM_AWIDTH - 1 : 0]  HBM_interface_rd_hbm_edge_addr;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_interface_rd_hbm_edge_valid;
*/
wire [LP_NUM_EXAMPLES - 1 : 0]               HBM_interface_full;
wire [LP_NUM_EXAMPLES * HBM_AWIDTH - 1 : 0]  HBM_interface_rd_hbm_edge_addr;
wire [LP_NUM_EXAMPLES - 1 : 0]               HBM_interface_rd_hbm_edge_valid;
wire [CORE_NUM * HBM_AWIDTH - 1 : 0]            HBM_interface_active_v_edge;
wire [CORE_NUM - 1 : 0]                         HBM_interface_active_v_edge_valid;

/*
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_controller_read_full;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_controller_write_full;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_controller_write_empty;
wire [PSEUDO_CHANNEL_NUM * HBM_DWIDTH - 1 : 0]  HBM_controller_edge;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_controller_valid;
wire [PSEUDO_CHANNEL_NUM * HBM_AWIDTH - 1 : 0]  HBM_controller_recv_addr;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_controller_addr_valid;
*/
wire [LP_NUM_EXAMPLES - 1 : 0]               HBM_controller_read_full;
wire [LP_NUM_EXAMPLES - 1 : 0]               HBM_controller_write_full;
wire [LP_NUM_EXAMPLES - 1 : 0]               HBM_controller_write_empty;
wire [LP_NUM_EXAMPLES * HBM_DWIDTH - 1 : 0]  HBM_controller_edge;
wire [LP_NUM_EXAMPLES - 1 : 0]               HBM_controller_valid;
wire [LP_NUM_EXAMPLES * HBM_AWIDTH - 1 : 0]  HBM_controller_recv_addr;
wire [LP_NUM_EXAMPLES - 1 : 0]               HBM_controller_addr_valid;

// signals of bitmap channel
wire                                          HBM_bitmap_read_full;
wire [HBM_AWIDTH - 1 : 0]                     HBM_bitmap_read_addr;
wire                                          HBM_bitmap_read_valid;
wire [HBM_DWIDTH - 1 : 0]                     HBM_bitmap_data;
wire                                          HBM_bitmap_valid;

// signals of first_edge channel
wire [PSEUDO_CHANNEL_NUM / 2 - 1 : 0]                 HBM_first_edge_read_full;
wire [HBM_AWIDTH * (PSEUDO_CHANNEL_NUM / 2) - 1 : 0]  HBM_first_edge_read_addr;
wire [PSEUDO_CHANNEL_NUM / 2 - 1 : 0]                 HBM_first_edge_read_valid;
wire [HBM_DWIDTH * (PSEUDO_CHANNEL_NUM / 2) - 1 : 0]  HBM_first_edge_data;
wire [PSEUDO_CHANNEL_NUM / 2 - 1 : 0]                 HBM_first_edge_valid;

wire [CORE_NUM - 1 : 0]                 P6_next_rst;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]       P6_stage_full1;
wire [CORE_NUM - 1 : 0]                 P6_stage_full2;
wire [CORE_NUM - 1 : 0]                 P6_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]    P6_update_v_id;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] P6_update_v_value;
wire [CORE_NUM - 1 : 0]                 P6_pull_first_flag;
wire [CORE_NUM - 1 : 0]                 P6_update_v_valid;
wire [CORE_NUM - 1 : 0]                 P6_iteration_end;
wire [CORE_NUM - 1 : 0]                 P6_iteration_end_valid;
wire [CORE_NUM * ITERATION_DWIDTH - 1 : 0]  P6_global_iteration_id;
wire [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0]  P6_global_powerlaw_v_visit;
wire [V_ID_WIDTH - 1 : 0]               P6_global_root_id;

wire [CORE_NUM - 1 : 0]                 OM1_next_rst;
wire [CORE_NUM - 1 : 0]                 OM2_next_rst;
wire [CORE_NUM - 1 : 0]                 OM1_stage_full, OM2_stage_full;
wire [CORE_NUM - 1 : 0]                 OM1_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]    OM1_update_v_id;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] OM1_update_v_value;
wire [CORE_NUM - 1 : 0]                 OM1_pull_first_flag;
wire [CORE_NUM - 1 : 0]                 OM1_update_v_valid;
wire [CORE_NUM - 1 : 0]                 OM1_iteration_end;
wire [CORE_NUM - 1 : 0]                 OM1_iteration_end_valid;
wire [CORE_NUM - 1 : 0]                 OM2_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]    OM2_update_v_id;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] OM2_update_v_value;
wire [CORE_NUM - 1 : 0]                 OM2_pull_first_flag;
wire [CORE_NUM - 1 : 0]                 OM2_update_v_valid;
wire [CORE_NUM - 1 : 0]                 OM2_iteration_end;
wire [CORE_NUM - 1 : 0]                 OM2_iteration_end_valid;
wire [CORE_NUM * ITERATION_DWIDTH - 1 : 0]  OM_global_iteration_id;
wire [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0]  OM_global_powerlaw_v_visit;
wire [V_ID_WIDTH - 1 : 0]               OM_global_root_id;

wire [CORE_NUM - 1 : 0]                   P7_next_rst1;
wire [CORE_NUM - 1 : 0]                   P7_next_rst2;
wire [CORE_NUM - 1 : 0]                   P7_source_core_full;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]      P7_rd_vertex_bram_addr;
wire [CORE_NUM - 1 : 0]                   P7_rd_vertex_bram_valid;
wire [CORE_NUM - 1 : 0]                   P7_wr_vertex_bram_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]      P7_wr_vertex_bram_addr;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   P7_wr_vertex_bram_data;
wire [CORE_NUM - 1 : 0]                   P7_wr_vertex_bram_pull_first_flag;
wire [CORE_NUM - 1 : 0]                   P7_wr_vertex_bram_valid;
wire [CORE_NUM - 1 : 0]                   P7_wr_vertex_bram_iteration_end;
wire [CORE_NUM - 1 : 0]                   P7_wr_vertex_bram_iteration_end_valid;
wire [CORE_NUM - 1 : 0]                   P7_om2_send_push_flag;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]      P7_om2_send_update_v_id;
wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   P7_om2_send_update_v_value;
wire [CORE_NUM - 1 : 0]                   P7_om2_send_update_v_pull_first_flag;
wire [CORE_NUM - 1 : 0]                   P7_om2_send_update_v_valid;
wire [CORE_NUM - 1 : 0]                   P7_om2_send_iteration_end;
wire [CORE_NUM - 1 : 0]                   P7_om2_send_iteration_end_valid;
wire [CORE_NUM * ITERATION_DWIDTH - 1 : 0]  P7_global_iteration_id;
wire [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0]  P7_global_powerlaw_v_visit;
wire [V_ID_WIDTH - 1 : 0]               P7_global_root_id;

wire [CORE_NUM - 1 : 0]                   VTX_BRAM_next_rst;
wire [CORE_NUM * VTX_BRAM_DWIDTH - 1 : 0] VTX_BRAM_src_recv_update_v_value;
wire [CORE_NUM - 1 : 0]                   VTX_BRAM_src_recv_update_v_valid;
wire [CORE_NUM * V_ID_WIDTH - 1 : 0]      VTX_BRAM_backend_active_v_id;
wire [CORE_NUM - 1 : 0]                   VTX_BRAM_backend_active_v_updated;
wire [CORE_NUM - 1 : 0]                   VTX_BRAM_backend_active_v_pull_first_flag;
wire [CORE_NUM - 1 : 0]                   VTX_BRAM_backend_active_v_id_valid;
wire [CORE_NUM - 1 : 0]                   VTX_BRAM_iteration_end;
wire [CORE_NUM - 1 : 0]                   VTX_BRAM_iteration_end_valid;
wire [CORE_NUM * ITERATION_DWIDTH - 1 : 0]  VTX_BRAM_global_iteration_id;
wire [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0]  VTX_BRAM_global_powerlaw_v_visit;
wire [V_ID_WIDTH - 1 : 0]               VTX_BRAM_global_root_id;
wire                                      VTX_BRAM_transfer_done;
wire [CORE_NUM * HBM_DWIDTH_PER_CORE - 1 : 0] VTX_BRAM_wb_bfs_data;
wire [PSEUDO_CHANNEL_NUM - 1 : 0] VTX_BRAM_wb_bfs_valid;

wire [CORE_NUM * V_ID_WIDTH - 1 : 0]      P8_active_v_id;
wire [CORE_NUM - 1 : 0]                   P8_active_v_updated;
wire [CORE_NUM - 1 : 0]                   P8_active_v_pull_first_flag;
wire [CORE_NUM - 1 : 0]                   P8_active_v_valid;
wire [CORE_NUM - 1 : 0]                   P8_iteration_end;
wire [CORE_NUM - 1 : 0]                   P8_iteration_end_valid;
wire [CORE_NUM * ITERATION_DWIDTH - 1 : 0]  P8_global_iteration_id;
wire [CORE_NUM * POWERLAW_VTX_NUM - 1 : 0]  P8_global_powerlaw_v_visit;
wire [V_ID_WIDTH - 1 : 0]               P8_global_root_id;

// 16 vertex per channel, 32bit per vertex : 8 for value, 24 for id
wire [(8 + 24) * 16 - 1 : 0] WR_BACK_bfs_res [0 : LP_NUM_EXAMPLES - 1];
wire WR_BACK_bfs_valid [0 : LP_NUM_EXAMPLES - 1];

(* keep = "TRUE" *)   wire          clk = ap_clk;
reg rst, uram_rst, cycle_valid;
reg [31 : 0] acc_cycle;
reg [2 : 0] acc_state; // 00: initial state; 01: transfer uram data; 10: running; 11: done
wire transfer_uram;
wire transfer_bram;
assign transfer_uram = (acc_state == 2'b01);
assign transfer_bram = (acc_state == 2'b11); // transfer bram data after acc done

always @ (posedge clk) begin
  if (areset) begin
    acc_state <= 2'b00;
    rst <= 1'b1;
    uram_rst <= 1'b1;
  end else begin
    case (acc_state)
      2'b00: if (ap_start_pulse) begin
        acc_state <= 2'b01;
        rst <= 1'b1;
        uram_rst <= 1'b0;
      end
      2'b01: if ((&P1_transfer_complete) && (&P3_transfer_complete) && (&P5_2_transfer_complete)) begin
        acc_state <= 2'b10;
        rst <= 1'b0;
        uram_rst <= 1'b0;
      end
      2'b10: if (P1_iteration_done == {CORE_NUM{1'b1}}) begin
        acc_state <= 2'b11;
        rst <= 1'b1;
        uram_rst <= 1'b0;
      end
      2'b11: begin
        // keep done signal
      end
    endcase
  end
end

// BUFG u_AXI_CLK_IN_0  ( .I (ap_clk), .O (clk) );

///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

//cycle inc
always @(posedge ap_clk) begin
  if(acc_state < 2) begin
    acc_cycle <= 0;
  end else if (acc_state == 2) begin
    acc_cycle <= acc_cycle + 1;
  end
  if(acc_state < 3 && P1_iteration_done != {CORE_NUM{1'b1}}) begin
    cycle_valid <=0;
  end else if(acc_state == 2 && P1_iteration_done == {CORE_NUM{1'b1}}) begin
    cycle_valid <=1;
  end else if (acc_state == 3) begin
    cycle_valid <=0;
  end
end

// Register and invert reset signal.
always @(posedge ap_clk) begin
  areset <= ~ap_rst_n;
end

// create pulse when ap_start transitions to 1
always @(posedge ap_clk) begin
  begin
    ap_start_r <= ap_start;
  end
end

assign ap_start_pulse = ap_start & ~ap_start_r;

// ap_idle is asserted when done is asserted, it is de-asserted when ap_start_pulse
// is asserted
always @(posedge ap_clk) begin
  if (areset) begin
    ap_idle_r <= 1'b1;
  end
  else begin
    ap_idle_r <= ap_done ? 1'b1 :
      ap_start_pulse ? 1'b0 : ap_idle;
  end
end

assign ap_idle = ap_idle_r;

// Done logic
always @(posedge ap_clk) begin
  if (areset) begin
    ap_done_r <= '0;
  end
  else begin
    ap_done_r <= (ap_done) ? '0 : ap_done_r | ap_done_i;
  end
end

assign ap_done = &ap_done_r && (acc_state == 2'b11) && VTX_BRAM_transfer_done;

// Ready Logic (non-pipelined case)
assign ap_ready = ap_done;

// combine result
generate
  genvar i;
  for (i = 0; i < PSEUDO_CHANNEL_NUM; i = i + 1) begin
    assign WR_BACK_bfs_res[i] = VTX_BRAM_wb_bfs_data[(i + 1) * HBM_DWIDTH - 1 : i * HBM_DWIDTH];
    assign WR_BACK_bfs_valid[i] = VTX_BRAM_wb_bfs_valid[i];
  end
endgenerate

assign HBM_controller_recv_addr = transfer_uram ? P3_hbm_controller_addr : HBM_interface_rd_hbm_edge_addr;
assign HBM_controller_addr_valid = transfer_uram ? P3_hbm_addr_valid : HBM_interface_rd_hbm_edge_valid;


// HBM controller
hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M00_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M00_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m00_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi00_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m00_axi_awvalid         ),
  .m_axi_awready           ( m00_axi_awready         ),
  .m_axi_awaddr            ( m00_axi_awaddr          ),
  .m_axi_awlen             ( m00_axi_awlen           ),
  .m_axi_wvalid            ( m00_axi_wvalid          ),
  .m_axi_wready            ( m00_axi_wready          ),
  .m_axi_wdata             ( m00_axi_wdata           ),
  .m_axi_wstrb             ( m00_axi_wstrb           ),
  .m_axi_wlast             ( m00_axi_wlast           ),
  .m_axi_bvalid            ( m00_axi_bvalid          ),
  .m_axi_bready            ( m00_axi_bready          ),
  .m_axi_arvalid           ( m00_axi_arvalid         ),
  .m_axi_arready           ( m00_axi_arready         ),
  .m_axi_araddr            ( m00_axi_araddr          ),
  .m_axi_arlen             ( m00_axi_arlen           ),
  .m_axi_rvalid            ( m00_axi_rvalid          ),
  .m_axi_rready            ( m00_axi_rready          ),
  .m_axi_rdata             ( m00_axi_rdata           ),
  .m_axi_rlast             ( m00_axi_rlast           ),
  // acc
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(0 + 1) * HBM_AWIDTH - 1 : 0 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[0]),
  .read_stage_full                  (HBM_controller_read_full[0]),
  .controller_send_edge             (HBM_controller_edge[(0 + 1) * HBM_DWIDTH - 1 : 0 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[0]),
  .controller_recv_update_data      (cycle_valid ? {{480{1'b0}},acc_cycle} : WR_BACK_bfs_res[0]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (cycle_valid ? 1 : |WR_BACK_bfs_valid[0]),
  .write_stage_full                 (HBM_controller_write_full[0]),
  .write_stage_empty                (ap_done_i[0])
);

// HBM controller
hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M01_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M01_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m01_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi01_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m01_axi_awvalid         ),
  .m_axi_awready           ( m01_axi_awready         ),
  .m_axi_awaddr            ( m01_axi_awaddr          ),
  .m_axi_awlen             ( m01_axi_awlen           ),
  .m_axi_wvalid            ( m01_axi_wvalid          ),
  .m_axi_wready            ( m01_axi_wready          ),
  .m_axi_wdata             ( m01_axi_wdata           ),
  .m_axi_wstrb             ( m01_axi_wstrb           ),
  .m_axi_wlast             ( m01_axi_wlast           ),
  .m_axi_bvalid            ( m01_axi_bvalid          ),
  .m_axi_bready            ( m01_axi_bready          ),
  .m_axi_arvalid           ( m01_axi_arvalid         ),
  .m_axi_arready           ( m01_axi_arready         ),
  .m_axi_araddr            ( m01_axi_araddr          ),
  .m_axi_arlen             ( m01_axi_arlen           ),
  .m_axi_rvalid            ( m01_axi_rvalid          ),
  .m_axi_rready            ( m01_axi_rready          ),
  .m_axi_rdata             ( m01_axi_rdata           ),
  .m_axi_rlast             ( m01_axi_rlast           ),
  // acc
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(1 + 1) * HBM_AWIDTH - 1 : 1 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[1]),
  .read_stage_full                  (HBM_controller_read_full[1]),
  .controller_send_edge             (HBM_controller_edge[(1 + 1) * HBM_DWIDTH - 1 : 1 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[1]),
  .controller_recv_update_data      (cycle_valid ? {{480{1'b0}},acc_cycle} : WR_BACK_bfs_res[1]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (cycle_valid ? 1 : |WR_BACK_bfs_valid[1]),
  .write_stage_full                 (HBM_controller_write_full[1]),
  .write_stage_empty                (ap_done_i[1])
);

// HBM read controller
hbm_channel_controller_read #(
  .C_M_AXI_ADDR_WIDTH (C_M02_AXI_ADDR_WIDTH),
  .C_M_AXI_DATA_WIDTH (C_M02_AXI_DATA_WIDTH),
  .C_INCLUDE_DATA_FIFO(1)
)
hbm_channel_controller_read_inst_m02_axi (
  .aclk             (ap_clk),
  .areset           (areset),
  .ctrl_start       (ap_start),
  .ctrl_addr_offset (axi02_ptr0),
  .m_axi_arvalid    (m02_axi_arvalid),
  .m_axi_arready    (m02_axi_arready),
  .m_axi_araddr     (m02_axi_araddr),
  .m_axi_arlen      (m02_axi_arlen),
  .m_axi_rvalid     (m02_axi_rvalid),
  .m_axi_rready     (m02_axi_rready),
  .m_axi_rdata      (m02_axi_rdata),
  .m_axi_rlast      (m02_axi_rlast),

  // ACC
  .acc_clk                          (ap_clk),
  .acc_rst                          (areset),
  .controller_recv_edge_addr        ({{32{1'b0}}, HBM_bitmap_read_addr} << 6),
  .controller_recv_edge_addr_valid  (HBM_bitmap_read_valid),
  .stage_full                       (HBM_bitmap_read_full),
  .controller_send_edge             (HBM_bitmap_data),
  .controller_send_edge_valid       (HBM_bitmap_valid)
);
// pull useless signal to ground
assign m02_axi_awvalid  = 1'b0  ;
assign m02_axi_awaddr   =  'h0  ;
assign m02_axi_awlen    =  'h0  ;
assign m02_axi_wvalid   = 1'b0  ;
assign m02_axi_wdata    =  'h0  ;
assign m02_axi_wstrb    =  'h0  ;
assign m02_axi_wlast    =  'h0  ;
assign m02_axi_bready   = 1'b0  ;

// HBM read controller
hbm_channel_controller_read #(
  .C_M_AXI_ADDR_WIDTH (C_M03_AXI_ADDR_WIDTH),
  .C_M_AXI_DATA_WIDTH (C_M03_AXI_DATA_WIDTH),
  .C_INCLUDE_DATA_FIFO(1)
)
hbm_channel_controller_read_inst_m03_axi (
  .aclk             (ap_clk),
  .areset           (areset),
  .ctrl_start       (ap_start),
  .ctrl_addr_offset (axi03_ptr0),
  .m_axi_arvalid    (m03_axi_arvalid),
  .m_axi_arready    (m03_axi_arready),
  .m_axi_araddr     (m03_axi_araddr),
  .m_axi_arlen      (m03_axi_arlen),
  .m_axi_rvalid     (m03_axi_rvalid),
  .m_axi_rready     (m03_axi_rready),
  .m_axi_rdata      (m03_axi_rdata),
  .m_axi_rlast      (m03_axi_rlast),

  // ACC
  .acc_clk                          (ap_clk),
  .acc_rst                          (areset),
  .controller_recv_edge_addr        ({{32{1'b0}}, HBM_first_edge_read_addr[HBM_AWIDTH * 0 +: HBM_AWIDTH]} << 6),
  .controller_recv_edge_addr_valid  (HBM_first_edge_read_valid[0]),
  .stage_full                       (HBM_first_edge_read_full[0]),
  .controller_send_edge             (HBM_first_edge_data[HBM_DWIDTH * 0 +: HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_first_edge_valid[0])
);
// pull useless signal to ground
assign m03_axi_awvalid  = 1'b0  ;
assign m03_axi_awaddr   =  'h0  ;
assign m03_axi_awlen    =  'h0  ;
assign m03_axi_wvalid   = 1'b0  ;
assign m03_axi_wdata    =  'h0  ;
assign m03_axi_wstrb    =  'h0  ;
assign m03_axi_wlast    =  'h0  ;
assign m03_axi_bready   = 1'b0  ;


loader #(
  .LOADER_PSEUDO_CHANNEL_NUM  (1),
  .LOADER_ADDR_WIDTH          (VTX_NUM_WIDTH - 9),  // 9 = $clog(HBM_DWIDTH)
  .LOADER_CORE_NUM            (HBM_DWIDTH / BITMAP_COMPRESSED_LENGTH),
  .DISPATCHER_WIDTH           (BITMAP_DISPATCHER_WIDTH)
) inst_bitmap_loader (
  .clk                  (clk),
  .bram_rst             (uram_rst),
  .hbm_controller_data  (HBM_bitmap_data),
  .hbm_data_valid       (HBM_bitmap_valid),
  .hbm_controller_full  (HBM_bitmap_read_full),

  .dispatcher_data      (bitmap),
  .dispatcher_counter   (bitmap_loader_counter),
  .dispatcher_valid     (bitmap_valid),
  .hbm_controller_addr  (HBM_bitmap_read_addr),
  .hbm_addr_valid       (HBM_bitmap_read_valid)
);

loader #(
  .LOADER_ADDR_WIDTH    (VTX_NUM_WIDTH - CORE_NUM_WIDTH + 1)
) inst_first_edge_loader (
  .clk                  (clk),
  .bram_rst             (uram_rst),
  .hbm_controller_data  (HBM_first_edge_data),
  .hbm_data_valid       (HBM_first_edge_valid),
  .hbm_controller_full  (HBM_first_edge_read_full),

  .dispatcher_data      (first_edge),
  .dispatcher_counter   (first_edge_loader_counter),
  .dispatcher_valid     (first_edge_valid),
  .hbm_controller_addr  (HBM_first_edge_read_addr),
  .hbm_addr_valid       (HBM_first_edge_read_valid)
);

// kernel
rd_active_vertex  RD_ACTIVE_VERTEX (
  .clk                (clk),
  .rst                (rst),
  .vis_bitmap_rst     (uram_rst),
  .root_id            (root_id),
  .bitmap_compressed_num  (bitmap_compressed_num),
  .bitmap             (bitmap),
  .loader_counter     (bitmap_loader_counter),
  .bitmap_valid       (bitmap_valid),
  .backend_active_v_id        (P8_active_v_id),
  .backend_active_v_updated   (P8_active_v_updated),
  .backend_active_v_pull_first_flag (P8_active_v_pull_first_flag),
  .backend_active_v_id_valid  (P8_active_v_valid),
  .backend_iteration_end      (P8_iteration_end),
  .backend_iteration_end_valid(P8_iteration_end_valid),
  .next_stage_full            (P2_stage_full),

  .transfer_complete          (P1_transfer_complete),
  .next_rst                   (P1_next_rst),
  .iteration_done             (P1_iteration_done),
  .push_flag                  (P1_push_flag),
  .active_v_id                (P1_active_v_id),
  .active_v_value             (P1_active_v_value),
  .active_v_pull_first_flag   (P1_active_v_pull_first_flag),
  .active_v_id_valid          (P1_active_v_valid),
  .iteration_end              (P1_iteration_end),
  .iteration_end_valid        (P1_iteration_end_valid),
  .global_iteration_id        (P1_global_iteration_id),
  .global_root_id             (P1_global_root_id)
);

assign init_vertex_not_read = {powerlaw_vertex_id_31, powerlaw_vertex_id_30, powerlaw_vertex_id_29, powerlaw_vertex_id_28, powerlaw_vertex_id_27, powerlaw_vertex_id_26, powerlaw_vertex_id_25, powerlaw_vertex_id_24,
                                powerlaw_vertex_id_23, powerlaw_vertex_id_22, powerlaw_vertex_id_21, powerlaw_vertex_id_20, powerlaw_vertex_id_19, powerlaw_vertex_id_18, powerlaw_vertex_id_17, powerlaw_vertex_id_16,
                                powerlaw_vertex_id_15, powerlaw_vertex_id_14, powerlaw_vertex_id_13, powerlaw_vertex_id_12, powerlaw_vertex_id_11, powerlaw_vertex_id_10, powerlaw_vertex_id_09, powerlaw_vertex_id_08,
                                powerlaw_vertex_id_07, powerlaw_vertex_id_06, powerlaw_vertex_id_05, powerlaw_vertex_id_04, powerlaw_vertex_id_03, powerlaw_vertex_id_02, powerlaw_vertex_id_01, powerlaw_vertex_id_00};
rd_active_vertex_global_signal RD_ACTIVE_VERTEX_GLOBAL_SIGNAL (
  .clk                        (clk),
  .rst                        (rst),
  .vertex_not_read            (init_vertex_not_read),
  .backend_active_v_id        (P8_active_v_id),
  .backend_active_v_updated   (P8_active_v_updated),
  .backend_active_v_id_valid  (P8_active_v_valid),

  .next_vertex_not_read       (P1_vertex_not_read),
  .global_powerlaw_v_visit    (P1_global_powerlaw_v_visit)
);

rd_active_vertex_offset RD_ACTIVE_VERTEX_OFFSET (
  .clk                        (clk),
  .rst                        (P1_next_rst),
  .front_push_flag            (P1_push_flag),
  .front_active_v_id          (P1_active_v_id),
  .front_active_v_value       (P1_active_v_value),
  .front_active_v_pull_first_flag (P1_active_v_pull_first_flag),
  .front_active_v_valid       (P1_active_v_valid),
  .front_iteration_end        (P1_iteration_end),
  .front_iteration_end_valid  (P1_iteration_end_valid),
  .next_stage_full            (P4_stage_full),

  .next_rst                   (P2_next_rst),
  .stage_full                 (P2_stage_full),
  .push_flag                  (P2_push_flag),
  .active_v_id                (P2_active_v_id),
  .active_v_value             (P2_active_v_value),
  .rd_active_v_offset_addr    (P2_rd_active_v_offset_addr),
  .active_v_pull_first_flag   (P2_active_v_pull_first_flag),
  .active_v_id_valid          (P2_active_v_valid),
  .iteration_end              (P2_iteration_end),
  .iteration_end_valid        (P2_iteration_end_valid)
);

global_signal_transfer P2_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (P1_next_rst[0]),
  .front_vertex_not_read      (P1_vertex_not_read),
  .front_global_iteration_id  (P1_global_iteration_id),
  .front_global_powerlaw_v_visit  (P1_global_powerlaw_v_visit),
  .front_global_root_id              (P1_global_root_id),

  .next_vertex_not_read       (P2_vertex_not_read),
  .global_iteration_id        (P2_global_iteration_id),
  .global_powerlaw_v_visit    (P2_global_powerlaw_v_visit),
  .global_root_id                    (P2_global_root_id)
);

offset_uram OFFSET_URAM (
  .clk                        (clk),
  .uram_rst                   (uram_rst),
  .hbm_controller_data        (HBM_controller_edge),
  .hbm_data_valid             (transfer_uram ? HBM_controller_valid : 0),
  .hbm_controller_full        (HBM_controller_read_full),
  .rst                        (P2_next_rst),
  .front_rd_active_v_offset_addr  (P2_rd_active_v_offset_addr),
  .front_active_v_valid       (P2_active_v_valid),

  .hbm_controller_addr        (P3_hbm_controller_addr),
  .hbm_addr_valid             (P3_hbm_addr_valid),
  .transfer_complete          (P3_transfer_complete),
  .next_rst                   (P3_next_rst),
  .uram_loffset               (P3_active_v_loffset),
  .uram_roffset               (P3_active_v_roffset),
  .uram_dvalid                (P3_active_v_valid)
);

rd_active_vertex_edge RD_ACTIVE_VERTEX_EDGE (
  .clk                        (clk),
  .rst                        (P2_next_rst),
  .front_push_flag            (P2_push_flag),
  .front_active_v_id          (P2_active_v_id),
  .front_active_v_value       (P2_active_v_value),
  .front_active_v_pull_first_flag (P2_active_v_pull_first_flag),
  .front_active_v_valid       (P2_active_v_valid),
  .front_active_v_loffset     (P3_active_v_loffset),
  .front_active_v_roffset     (P3_active_v_roffset),
  .front_offset_valid         (P3_active_v_valid),
  .front_iteration_end        (P2_iteration_end),
  .front_iteration_end_valid  (P2_iteration_end_valid),
  .combine_stage_full         (P5_stage_full),
  .bram_stage_full            (P5_2_stage_full),

  .next_rst                   (P4_next_rst),
  .stage_full                 (P4_stage_full),
  .rd_hbm_edge_addr           (P4_rd_hbm_edge_addr),
  .rd_hbm_edge_mask           (P4_rd_hbm_edge_mask),
  .hbm_push_flag              (P4_hbm_push_flag),
  .hbm_active_v_id            (P4_hbm_active_v_id),
  .hbm_active_v_value         (P4_hbm_active_v_value),
  .rd_hbm_edge_valid          (P4_rd_hbm_edge_valid),
  .rd_bram_edge_addr          (P4_rd_bram_edge_addr),
  .bram_push_flag             (P4_bram_push_flag),
  .bram_active_v_id           (P4_bram_active_v_id),
  .bram_active_v_value        (P4_bram_active_v_value),
  .rd_bram_edge_valid         (P4_rd_bram_edge_valid),
  .iteration_end              (P4_iteration_end),
  .iteration_end_valid        (P4_iteration_end_valid)
);

global_signal_transfer P4_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (P2_next_rst[0]),
  .front_vertex_not_read      (P2_vertex_not_read),
  .front_global_iteration_id  (P2_global_iteration_id),
  .front_global_powerlaw_v_visit  (P2_global_powerlaw_v_visit),
  .front_global_root_id              (P2_global_root_id),

  .next_vertex_not_read       (P4_vertex_not_read),
  .global_iteration_id        (P4_global_iteration_id),
  .global_powerlaw_v_visit    (P4_global_powerlaw_v_visit),
  .global_root_id                    (P4_global_root_id)
);

generate_hbm_edge_rqst GENERATE_HBM_EDGE_RQST (
  .clk                        (clk),
  .rst                        (P4_next_rst),
  .front_rd_hbm_edge_addr     (P4_rd_hbm_edge_addr),
  .front_rd_hbm_edge_mask     (P4_rd_hbm_edge_mask),
  .front_push_flag            (P4_hbm_push_flag),
  .front_active_v_id          (P4_hbm_active_v_id),
  .front_active_v_value       (P4_hbm_active_v_value),
  .front_rd_hbm_edge_valid    (P4_rd_hbm_edge_valid),
  .front_iteration_end        (P4_iteration_end),
  .front_iteration_end_valid  (P4_iteration_end_valid),
  .hbm_full                   (HBM_controller_read_full),
  .next_stage_full            (P6_stage_full1),

  .next_rst                   (P5_next_rst),
  .stage_full                 (P5_stage_full),
  .rd_hbm_edge_addr           (P5_rd_hbm_edge_addr),
  .rd_hbm_edge_valid          (P5_rd_hbm_edge_valid),
  .push_flag                  (P5_push_flag),
  .active_v_id                (P5_active_v_id),
  .active_v_value             (P5_active_v_value),
  .active_v_id_valid          (P5_active_v_valid),
  .iteration_end              (P5_iteration_end),
  .iteration_end_valid        (P5_iteration_end_valid)
);

global_signal_transfer P5_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (P4_next_rst[0]),
  .front_vertex_not_read      (P4_vertex_not_read),
  .front_global_iteration_id  (P4_global_iteration_id),
  .front_global_powerlaw_v_visit  (P4_global_powerlaw_v_visit),
  .front_global_root_id              (P4_global_root_id),

  .next_vertex_not_read       (P5_vertex_not_read),
  .global_iteration_id        (P5_global_iteration_id),
  .global_powerlaw_v_visit    (P5_global_powerlaw_v_visit),
  .global_root_id                    (P5_global_root_id)
);

rd_first_edge_bram RD_FIRST_EDGE_BRAM (
  .clk                        (clk),
  .rst                        (P4_next_rst),
  .first_edge_rst             (uram_rst),
  .first_edge                 (first_edge),
  .loader_counter             (first_edge_loader_counter),
  .first_edge_valid           (first_edge_valid),
  .front_rd_edge_addr         (P4_rd_bram_edge_addr),
  .front_push_flag            (P4_bram_push_flag),
  .front_active_v_id          (P4_bram_active_v_id),
  .front_active_v_value       (P4_bram_active_v_value),
  .front_rd_edge_valid        (P4_rd_bram_edge_valid),
  .front_iteration_end        (P4_iteration_end),
  .front_iteration_end_valid  (P4_iteration_end_valid),
  .next_stage_full            (P6_stage_full2),

  .transfer_complete          (P5_2_transfer_complete),
  .stage_full                 (P5_2_stage_full),
  .push_flag                  (P5_2_push_flag),
  .active_v_id                (P5_2_active_v_id),
  .active_v_value             (P5_2_active_v_value),
  .active_v_edge              (P5_2_active_v_edge),
  .active_v_valid             (P5_2_active_v_valid),
  .iteration_end              (P5_2_iteration_end),
  .iteration_end_valid        (P5_2_iteration_end_valid)
);

hbm_interface HBM_INTERFACE (
  .clk                        (clk),
  .rst                        (P5_next_rst),
  .front_rd_hbm_edge_addr     (P5_rd_hbm_edge_addr),
  .front_rd_hbm_edge_valid    (P5_rd_hbm_edge_valid),
  .hbm_controller_edge        (HBM_controller_edge),
  .hbm_controller_valid       (HBM_controller_valid),
  .hbm_controller_full        (HBM_controller_read_full),

  .stage_full                 (HBM_interface_full),
  .rd_hbm_edge_addr           (HBM_interface_rd_hbm_edge_addr),
  .rd_hbm_edge_valid          (HBM_interface_rd_hbm_edge_valid),
  .active_v_edge              (HBM_interface_active_v_edge),
  .active_v_edge_valid        (HBM_interface_active_v_edge_valid)
);

scheduler SCHEDULER (
  .clk                        (clk),
  .rst                        (P5_next_rst),
  .VERTEX_NOT_READ            (P5_vertex_not_read),
  .front_push_flag            (P5_push_flag),
  .front_active_v_id          (P5_active_v_id),
  .front_active_v_value       (P5_active_v_value),
  .front_active_v_valid       (P5_active_v_valid),
  .front_iteration_end        (P5_iteration_end),
  .front_iteration_end_valid  (P5_iteration_end_valid),
  .hbm_interface_active_v_edge  (HBM_interface_active_v_edge),
  .hbm_interface_active_v_edge_valid  (HBM_interface_active_v_edge_valid),
  .front2_push_flag           (P5_2_push_flag),
  .front2_active_v_id         (P5_2_active_v_id),
  .front2_active_v_value      (P5_2_active_v_value),
  .front2_active_v_edge       (P5_2_active_v_edge),
  .front2_active_v_valid      (P5_2_active_v_valid),
  .front2_iteration_end       (P5_2_iteration_end),
  .front2_iteration_end_valid (P5_2_iteration_end_valid),
  .front_global_powerlaw_v_visit  (P5_global_powerlaw_v_visit),
  .next_stage_full            (OM1_stage_full),

  .next_rst                   (P6_next_rst),
  .stage_full1                (P6_stage_full1),
  .stage_full2                (P6_stage_full2),
  .push_flag                  (P6_push_flag),
  .update_v_id                (P6_update_v_id),
  .update_v_value             (P6_update_v_value),
  .pull_first_flag            (P6_pull_first_flag),
  .update_v_valid             (P6_update_v_valid),
  .iteration_end              (P6_iteration_end),
  .iteration_end_valid        (P6_iteration_end_valid)
);

global_signal_transfer P6_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (P5_next_rst[0]),
  .front_global_iteration_id  (P5_global_iteration_id),
  .front_global_powerlaw_v_visit  (P5_global_powerlaw_v_visit),
  .front_global_root_id              (P5_global_root_id),

  .global_iteration_id        (P6_global_iteration_id),
  .global_powerlaw_v_visit    (P6_global_powerlaw_v_visit),
  .global_root_id                    (P6_global_root_id)
);

// omega_network OMEGA_NETWORK (
//   .clk                        (clk),
//   .om1_front_rst              (P6_next_rst),
//   .om1_front_push_flag        (P6_push_flag),
//   .om1_front_update_v_id      (P6_update_v_id),
//   .om1_front_update_v_value   (P6_update_v_value),
//   .om1_front_pull_first_flag  (P6_pull_first_flag),
//   .om1_front_update_v_valid   (P6_update_v_valid),
//   .om1_front_iteration_end    (P6_iteration_end),
//   .om1_front_iteration_end_valid  (P6_iteration_end_valid),
//   .om2_front_rst              (P7_next_rst1),
//   .om2_front_push_flag        (P7_om2_send_push_flag),
//   .om2_front_update_v_id      (P7_om2_send_update_v_id),
//   .om2_front_update_v_value   (P7_om2_send_update_v_value),
//   .om2_front_pull_first_flag  (P7_om2_send_update_v_pull_first_flag),
//   .om2_front_update_v_valid   (P7_om2_send_update_v_valid),
//   .om2_front_iteration_end    (P7_om2_send_iteration_end),
//   .om2_front_iteration_end_valid  (P7_om2_send_iteration_end_valid),
//   .source_core_full           (P7_source_core_full),

//   .om1_rst                (OM1_next_rst),
//   .om2_rst                (OM2_next_rst),
//   .om1_stage_full         (OM1_stage_full),
//   .om2_stage_full         (OM2_stage_full),
//   .om1_push_flag          (OM1_push_flag),
//   .om1_update_v_id        (OM1_update_v_id),
//   .om1_update_v_value     (OM1_update_v_value),
//   .om1_pull_first_flag    (OM1_pull_first_flag),
//   .om1_update_v_valid     (OM1_update_v_valid),
//   .om1_iteration_end      (OM1_iteration_end),
//   .om1_iteration_end_valid(OM1_iteration_end_valid),
//   .om2_push_flag          (OM2_push_flag),
//   .om2_update_v_id        (OM2_update_v_id),
//   .om2_update_v_value     (OM2_update_v_value),
//   .om2_pull_first_flag    (OM2_pull_first_flag),
//   .om2_update_v_valid     (OM2_update_v_valid),
//   .om2_iteration_end      (OM2_iteration_end),
//   .om2_iteration_end_valid(OM2_iteration_end_valid)
// );
HyperX_Network OMEGA_NETWORK (
  .clk                        (clk),
  .hy1_front_rst              (P6_next_rst),
  .hy1_front_push_flag        (P6_push_flag),
  .hy1_front_update_v_id      (P6_update_v_id),
  .hy1_front_update_v_value   (P6_update_v_value),
  .hy1_front_pull_first_flag  (P6_pull_first_flag),
  .hy1_front_update_v_valid   (P6_update_v_valid),
  .hy1_front_iteration_end    (P6_iteration_end),
  .hy1_front_iteration_end_valid  (P6_iteration_end_valid),
  .hy2_front_rst              (P7_next_rst1),
  .hy2_front_push_flag        (P7_om2_send_push_flag),
  .hy2_front_update_v_id      (P7_om2_send_update_v_id),
  .hy2_front_update_v_value   (P7_om2_send_update_v_value),
  .hy2_front_pull_first_flag  (P7_om2_send_update_v_pull_first_flag),
  .hy2_front_update_v_valid   (P7_om2_send_update_v_valid),
  .hy2_front_iteration_end    (P7_om2_send_iteration_end),
  .hy2_front_iteration_end_valid  (P7_om2_send_iteration_end_valid),
  .source_core_full           (P7_source_core_full),

  .hy1_rst                (OM1_next_rst),
  .hy2_rst                (OM2_next_rst),
  .hy1_stage_full         (OM1_stage_full),
  .hy2_stage_full         (OM2_stage_full),
  .hy1_push_flag          (OM1_push_flag),
  .hy1_update_v_id        (OM1_update_v_id),
  .hy1_update_v_value     (OM1_update_v_value),
  .hy1_pull_first_flag    (OM1_pull_first_flag),
  .hy1_update_v_valid     (OM1_update_v_valid),
  .hy1_iteration_end      (OM1_iteration_end),
  .hy1_iteration_end_valid(OM1_iteration_end_valid),
  .hy2_push_flag          (OM2_push_flag),
  .hy2_update_v_id        (OM2_update_v_id),
  .hy2_update_v_value     (OM2_update_v_value),
  .hy2_pull_first_flag    (OM2_pull_first_flag),
  .hy2_update_v_valid     (OM2_update_v_valid),
  .hy2_iteration_end      (OM2_iteration_end),
  .hy2_iteration_end_valid(OM2_iteration_end_valid)
);

global_signal_transfer OM_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (P6_next_rst[0]),
  .front_global_iteration_id  (P6_global_iteration_id),
  .front_global_powerlaw_v_visit  (P6_global_powerlaw_v_visit),
  .front_global_root_id              (P6_global_root_id),

  .global_iteration_id        (OM_global_iteration_id),
  .global_powerlaw_v_visit    (OM_global_powerlaw_v_visit),
  .global_root_id                    (OM_global_root_id)
);

backend_core BACKEND_CORE (
  .clk                        (clk),
  .om1_rst                    (OM1_next_rst),
  .om1_recv_push_flag         (OM1_push_flag),
  .om1_recv_update_v_id       (OM1_update_v_id),
  .om1_recv_update_v_value    (OM1_update_v_value),
  .om1_recv_update_v_pull_first_flag  (OM1_pull_first_flag),
  .om1_recv_update_v_valid    (OM1_update_v_valid),
  .om1_recv_iteration_end     (OM1_iteration_end),
  .om1_recv_iteration_end_valid (OM1_iteration_end_valid),
  .om2_rst                    (OM2_next_rst),
  .om2_stage_full             (OM2_stage_full),
  .om2_recv_push_flag         (OM2_push_flag),
  .om2_recv_update_v_id       (OM2_update_v_id),
  .om2_recv_update_v_value    (OM2_update_v_value),
  .om2_recv_update_v_pull_first_flag  (OM2_pull_first_flag),
  .om2_recv_update_v_valid    (OM2_update_v_valid),
  .om2_recv_iteration_end     (OM2_iteration_end),
  .om2_recv_iteration_end_valid (OM2_iteration_end_valid),
  .vertex_bram_data           (VTX_BRAM_src_recv_update_v_value),
  .vertex_bram_valid          (VTX_BRAM_src_recv_update_v_valid),
  .om_global_iteration_id     (OM_global_iteration_id),

  .next_rst1                  (P7_next_rst1),
  .next_rst2                  (P7_next_rst2),
  .source_core_full           (P7_source_core_full),
  .rd_vertex_bram_addr        (P7_rd_vertex_bram_addr),
  .rd_vertex_bram_valid       (P7_rd_vertex_bram_valid),
  .wr_vertex_bram_push_flag   (P7_wr_vertex_bram_push_flag),
  .wr_vertex_bram_addr        (P7_wr_vertex_bram_addr),
  .wr_vertex_bram_data        (P7_wr_vertex_bram_data),
  .wr_vertex_bram_pull_first_flag (P7_wr_vertex_bram_pull_first_flag),
  .wr_vertex_bram_valid       (P7_wr_vertex_bram_valid),
  .wr_vertex_bram_iteration_end  (P7_wr_vertex_bram_iteration_end),
  .wr_vertex_bram_iteration_end_valid  (P7_wr_vertex_bram_iteration_end_valid),
  .om2_send_push_flag         (P7_om2_send_push_flag),
  .om2_send_update_v_id       (P7_om2_send_update_v_id),
  .om2_send_update_v_value    (P7_om2_send_update_v_value),
  .om2_send_update_v_pull_first_flag  (P7_om2_send_update_v_pull_first_flag),
  .om2_send_update_v_valid    (P7_om2_send_update_v_valid),
  .om2_send_iteration_end     (P7_om2_send_iteration_end),
  .om2_send_iteration_end_valid (P7_om2_send_iteration_end_valid)
);

global_signal_transfer P7_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (OM1_next_rst[0]),
  .front_global_iteration_id  (OM_global_iteration_id),
  .front_global_powerlaw_v_visit  (OM_global_powerlaw_v_visit),
  .front_global_root_id              (OM_global_root_id),

  .global_iteration_id        (P7_global_iteration_id),
  .global_powerlaw_v_visit    (P7_global_powerlaw_v_visit),
  .global_root_id                    (P7_global_root_id)
);

vtx_bram VTX_BRAM (
  .clk                        (clk),
  .rst                        (transfer_bram ? {CORE_NUM{1'b0}} : P7_next_rst2 ),
  .transfer_bram              (transfer_bram),
  .hbm_write_full             (HBM_controller_write_full),
  .rd_addr_src                (P7_rd_vertex_bram_addr),
  .rd_valid_src               (P7_rd_vertex_bram_valid),
  .wr_push_flag_dst           (P7_wr_vertex_bram_push_flag),
  .wr_addr_dst                (P7_wr_vertex_bram_addr),
  .wr_v_value_dst             (P7_wr_vertex_bram_data),
  .wr_pull_first_flag_dst     (P7_wr_vertex_bram_pull_first_flag),
  .wr_valid_dst               (P7_wr_vertex_bram_valid),
  .front_iteration_end        (P7_wr_vertex_bram_iteration_end),
  .front_iteration_end_valid  (P7_wr_vertex_bram_iteration_end_valid),
  .front_iteration_id         (P7_global_iteration_id),
  .front_root_id              (P7_global_root_id),
  .acc_state                  (acc_state),
  
  .next_rst                   (VTX_BRAM_next_rst),
  .transfer_done              (VTX_BRAM_transfer_done),
  .wb_bfs_data                (VTX_BRAM_wb_bfs_data),
  .wb_bfs_valid               (VTX_BRAM_wb_bfs_valid),
  .src_recv_update_v_value    (VTX_BRAM_src_recv_update_v_value),
  .src_recv_update_v_valid    (VTX_BRAM_src_recv_update_v_valid),
  .backend_active_v_id        (VTX_BRAM_backend_active_v_id),
  .backend_active_v_updated   (VTX_BRAM_backend_active_v_updated),
  .backend_active_v_pull_first_flag (VTX_BRAM_backend_active_v_pull_first_flag),
  .backend_active_v_valid     (VTX_BRAM_backend_active_v_id_valid),
  .iteration_end              (VTX_BRAM_iteration_end),
  .iteration_end_valid        (VTX_BRAM_iteration_end_valid)
);

global_signal_transfer VTX_BRAM_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (P7_next_rst2[0]),
  .front_global_iteration_id  (P7_global_iteration_id),
  .front_global_powerlaw_v_visit  (P7_global_powerlaw_v_visit),
  .front_global_root_id              (P7_global_root_id),

  .global_iteration_id        (VTX_BRAM_global_iteration_id),
  .global_powerlaw_v_visit    (VTX_BRAM_global_powerlaw_v_visit),
  .global_root_id                    (VTX_BRAM_global_root_id)
);

apply_iteration_end APPLY_ITERATION_END (
  .clk                        (clk),
  .rst                        (VTX_BRAM_next_rst),
  .front_active_v_id          (VTX_BRAM_backend_active_v_id),
  .front_active_v_updated     (VTX_BRAM_backend_active_v_updated),
  .front_active_v_pull_first_flag (VTX_BRAM_backend_active_v_pull_first_flag),
  .front_active_v_valid       (VTX_BRAM_backend_active_v_id_valid),
  .front_iteration_end        (VTX_BRAM_iteration_end),
  .front_iteration_end_valid  (VTX_BRAM_iteration_end_valid),

  .active_v_id                (P8_active_v_id),
  .active_v_updated           (P8_active_v_updated),
  .active_v_pull_first_flag   (P8_active_v_pull_first_flag),
  .active_v_valid             (P8_active_v_valid),
  .iteration_end              (P8_iteration_end),
  .iteration_end_valid        (P8_iteration_end_valid)
);

global_signal_transfer P8_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (VTX_BRAM_next_rst[0]),
  .front_global_iteration_id  (VTX_BRAM_global_iteration_id),
  .front_global_powerlaw_v_visit  (VTX_BRAM_global_powerlaw_v_visit),
  .front_global_root_id              (VTX_BRAM_global_root_id),

  .global_iteration_id        (P8_global_iteration_id),
  .global_powerlaw_v_visit    (P8_global_powerlaw_v_visit),
  .global_root_id                    (P8_global_root_id)
);

endmodule : acc_kernel_axi_top
`default_nettype wire