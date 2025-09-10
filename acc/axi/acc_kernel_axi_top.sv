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
  parameter integer C_M04_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M04_AXI_DATA_WIDTH = 512,
  parameter integer C_M05_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M05_AXI_DATA_WIDTH = 512,
  parameter integer C_M06_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M06_AXI_DATA_WIDTH = 512,
  parameter integer C_M07_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M07_AXI_DATA_WIDTH = 512,
  parameter integer C_M08_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M08_AXI_DATA_WIDTH = 512,
  parameter integer C_M09_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M09_AXI_DATA_WIDTH = 512,
  parameter integer C_M10_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M10_AXI_DATA_WIDTH = 512,
  parameter integer C_M11_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M11_AXI_DATA_WIDTH = 512,
  parameter integer C_M12_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M12_AXI_DATA_WIDTH = 512,
  parameter integer C_M13_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M13_AXI_DATA_WIDTH = 512,
  parameter integer C_M14_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M14_AXI_DATA_WIDTH = 512,
  parameter integer C_M15_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M15_AXI_DATA_WIDTH = 512,
  parameter integer C_M16_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M16_AXI_DATA_WIDTH = 512,
  parameter integer C_M17_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M17_AXI_DATA_WIDTH = 512,
  parameter integer C_M18_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M18_AXI_DATA_WIDTH = 512,
  parameter integer C_M19_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M19_AXI_DATA_WIDTH = 512,
  parameter integer C_M20_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M20_AXI_DATA_WIDTH = 512,
  parameter integer C_M21_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M21_AXI_DATA_WIDTH = 512,
  parameter integer C_M22_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M22_AXI_DATA_WIDTH = 512,
  parameter integer C_M23_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M23_AXI_DATA_WIDTH = 512,
  parameter integer C_M24_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M24_AXI_DATA_WIDTH = 512,
  parameter integer C_M25_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M25_AXI_DATA_WIDTH = 512,
  parameter integer C_M26_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M26_AXI_DATA_WIDTH = 512,
  parameter integer C_M27_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M27_AXI_DATA_WIDTH = 512,
  parameter integer C_M28_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M28_AXI_DATA_WIDTH = 512,
  parameter integer C_M29_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M29_AXI_DATA_WIDTH = 512,
  parameter integer C_M30_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M30_AXI_DATA_WIDTH = 512,
  parameter integer C_M31_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M31_AXI_DATA_WIDTH = 512,
  // acc parameter
  parameter integer V_ID_WIDTH = `V_ID_WIDTH,
  parameter integer V_OFF_AWIDTH = `V_OFF_AWIDTH,
  parameter integer V_OFF_DWIDTH = `V_OFF_DWIDTH,
  parameter integer V_VALUE_WIDTH = `V_VALUE_WIDTH,
  parameter integer CORE_NUM = `CORE_NUM,
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
  parameter integer VTX_BRAM_DWIDTH = `VTX_BRAM_DWIDTH
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
  // AXI4 master interface m04_axi
  output wire                              m04_axi_awvalid,
  input  wire                              m04_axi_awready,
  output wire [C_M04_AXI_ADDR_WIDTH-1:0]   m04_axi_awaddr ,
  output wire [8-1:0]                      m04_axi_awlen  ,
  output wire                              m04_axi_wvalid ,
  input  wire                              m04_axi_wready ,
  output wire [C_M04_AXI_DATA_WIDTH-1:0]   m04_axi_wdata  ,
  output wire [C_M04_AXI_DATA_WIDTH/8-1:0] m04_axi_wstrb  ,
  output wire                              m04_axi_wlast  ,
  input  wire                              m04_axi_bvalid ,
  output wire                              m04_axi_bready ,
  output wire                              m04_axi_arvalid,
  input  wire                              m04_axi_arready,
  output wire [C_M04_AXI_ADDR_WIDTH-1:0]   m04_axi_araddr ,
  output wire [8-1:0]                      m04_axi_arlen  ,
  input  wire                              m04_axi_rvalid ,
  output wire                              m04_axi_rready ,
  input  wire [C_M04_AXI_DATA_WIDTH-1:0]   m04_axi_rdata  ,
  input  wire                              m04_axi_rlast  ,
  // AXI4 master interface m05_axi
  output wire                              m05_axi_awvalid,
  input  wire                              m05_axi_awready,
  output wire [C_M05_AXI_ADDR_WIDTH-1:0]   m05_axi_awaddr ,
  output wire [8-1:0]                      m05_axi_awlen  ,
  output wire                              m05_axi_wvalid ,
  input  wire                              m05_axi_wready ,
  output wire [C_M05_AXI_DATA_WIDTH-1:0]   m05_axi_wdata  ,
  output wire [C_M05_AXI_DATA_WIDTH/8-1:0] m05_axi_wstrb  ,
  output wire                              m05_axi_wlast  ,
  input  wire                              m05_axi_bvalid ,
  output wire                              m05_axi_bready ,
  output wire                              m05_axi_arvalid,
  input  wire                              m05_axi_arready,
  output wire [C_M05_AXI_ADDR_WIDTH-1:0]   m05_axi_araddr ,
  output wire [8-1:0]                      m05_axi_arlen  ,
  input  wire                              m05_axi_rvalid ,
  output wire                              m05_axi_rready ,
  input  wire [C_M05_AXI_DATA_WIDTH-1:0]   m05_axi_rdata  ,
  input  wire                              m05_axi_rlast  ,
  // AXI4 master interface m06_axi
  output wire                              m06_axi_awvalid,
  input  wire                              m06_axi_awready,
  output wire [C_M06_AXI_ADDR_WIDTH-1:0]   m06_axi_awaddr ,
  output wire [8-1:0]                      m06_axi_awlen  ,
  output wire                              m06_axi_wvalid ,
  input  wire                              m06_axi_wready ,
  output wire [C_M06_AXI_DATA_WIDTH-1:0]   m06_axi_wdata  ,
  output wire [C_M06_AXI_DATA_WIDTH/8-1:0] m06_axi_wstrb  ,
  output wire                              m06_axi_wlast  ,
  input  wire                              m06_axi_bvalid ,
  output wire                              m06_axi_bready ,
  output wire                              m06_axi_arvalid,
  input  wire                              m06_axi_arready,
  output wire [C_M06_AXI_ADDR_WIDTH-1:0]   m06_axi_araddr ,
  output wire [8-1:0]                      m06_axi_arlen  ,
  input  wire                              m06_axi_rvalid ,
  output wire                              m06_axi_rready ,
  input  wire [C_M06_AXI_DATA_WIDTH-1:0]   m06_axi_rdata  ,
  input  wire                              m06_axi_rlast  ,
  // AXI4 master interface m07_axi
  output wire                              m07_axi_awvalid,
  input  wire                              m07_axi_awready,
  output wire [C_M07_AXI_ADDR_WIDTH-1:0]   m07_axi_awaddr ,
  output wire [8-1:0]                      m07_axi_awlen  ,
  output wire                              m07_axi_wvalid ,
  input  wire                              m07_axi_wready ,
  output wire [C_M07_AXI_DATA_WIDTH-1:0]   m07_axi_wdata  ,
  output wire [C_M07_AXI_DATA_WIDTH/8-1:0] m07_axi_wstrb  ,
  output wire                              m07_axi_wlast  ,
  input  wire                              m07_axi_bvalid ,
  output wire                              m07_axi_bready ,
  output wire                              m07_axi_arvalid,
  input  wire                              m07_axi_arready,
  output wire [C_M07_AXI_ADDR_WIDTH-1:0]   m07_axi_araddr ,
  output wire [8-1:0]                      m07_axi_arlen  ,
  input  wire                              m07_axi_rvalid ,
  output wire                              m07_axi_rready ,
  input  wire [C_M07_AXI_DATA_WIDTH-1:0]   m07_axi_rdata  ,
  input  wire                              m07_axi_rlast  ,
  // AXI4 master interface m08_axi
  output wire                              m08_axi_awvalid,
  input  wire                              m08_axi_awready,
  output wire [C_M08_AXI_ADDR_WIDTH-1:0]   m08_axi_awaddr ,
  output wire [8-1:0]                      m08_axi_awlen  ,
  output wire                              m08_axi_wvalid ,
  input  wire                              m08_axi_wready ,
  output wire [C_M08_AXI_DATA_WIDTH-1:0]   m08_axi_wdata  ,
  output wire [C_M08_AXI_DATA_WIDTH/8-1:0] m08_axi_wstrb  ,
  output wire                              m08_axi_wlast  ,
  input  wire                              m08_axi_bvalid ,
  output wire                              m08_axi_bready ,
  output wire                              m08_axi_arvalid,
  input  wire                              m08_axi_arready,
  output wire [C_M08_AXI_ADDR_WIDTH-1:0]   m08_axi_araddr ,
  output wire [8-1:0]                      m08_axi_arlen  ,
  input  wire                              m08_axi_rvalid ,
  output wire                              m08_axi_rready ,
  input  wire [C_M08_AXI_DATA_WIDTH-1:0]   m08_axi_rdata  ,
  input  wire                              m08_axi_rlast  ,
  // AXI4 master interface m09_axi
  output wire                              m09_axi_awvalid,
  input  wire                              m09_axi_awready,
  output wire [C_M09_AXI_ADDR_WIDTH-1:0]   m09_axi_awaddr ,
  output wire [8-1:0]                      m09_axi_awlen  ,
  output wire                              m09_axi_wvalid ,
  input  wire                              m09_axi_wready ,
  output wire [C_M09_AXI_DATA_WIDTH-1:0]   m09_axi_wdata  ,
  output wire [C_M09_AXI_DATA_WIDTH/8-1:0] m09_axi_wstrb  ,
  output wire                              m09_axi_wlast  ,
  input  wire                              m09_axi_bvalid ,
  output wire                              m09_axi_bready ,
  output wire                              m09_axi_arvalid,
  input  wire                              m09_axi_arready,
  output wire [C_M09_AXI_ADDR_WIDTH-1:0]   m09_axi_araddr ,
  output wire [8-1:0]                      m09_axi_arlen  ,
  input  wire                              m09_axi_rvalid ,
  output wire                              m09_axi_rready ,
  input  wire [C_M09_AXI_DATA_WIDTH-1:0]   m09_axi_rdata  ,
  input  wire                              m09_axi_rlast  ,
  // AXI4 master interface m10_axi
  output wire                              m10_axi_awvalid,
  input  wire                              m10_axi_awready,
  output wire [C_M10_AXI_ADDR_WIDTH-1:0]   m10_axi_awaddr ,
  output wire [8-1:0]                      m10_axi_awlen  ,
  output wire                              m10_axi_wvalid ,
  input  wire                              m10_axi_wready ,
  output wire [C_M10_AXI_DATA_WIDTH-1:0]   m10_axi_wdata  ,
  output wire [C_M10_AXI_DATA_WIDTH/8-1:0] m10_axi_wstrb  ,
  output wire                              m10_axi_wlast  ,
  input  wire                              m10_axi_bvalid ,
  output wire                              m10_axi_bready ,
  output wire                              m10_axi_arvalid,
  input  wire                              m10_axi_arready,
  output wire [C_M10_AXI_ADDR_WIDTH-1:0]   m10_axi_araddr ,
  output wire [8-1:0]                      m10_axi_arlen  ,
  input  wire                              m10_axi_rvalid ,
  output wire                              m10_axi_rready ,
  input  wire [C_M10_AXI_DATA_WIDTH-1:0]   m10_axi_rdata  ,
  input  wire                              m10_axi_rlast  ,
  // AXI4 master interface m11_axi
  output wire                              m11_axi_awvalid,
  input  wire                              m11_axi_awready,
  output wire [C_M11_AXI_ADDR_WIDTH-1:0]   m11_axi_awaddr ,
  output wire [8-1:0]                      m11_axi_awlen  ,
  output wire                              m11_axi_wvalid ,
  input  wire                              m11_axi_wready ,
  output wire [C_M11_AXI_DATA_WIDTH-1:0]   m11_axi_wdata  ,
  output wire [C_M11_AXI_DATA_WIDTH/8-1:0] m11_axi_wstrb  ,
  output wire                              m11_axi_wlast  ,
  input  wire                              m11_axi_bvalid ,
  output wire                              m11_axi_bready ,
  output wire                              m11_axi_arvalid,
  input  wire                              m11_axi_arready,
  output wire [C_M11_AXI_ADDR_WIDTH-1:0]   m11_axi_araddr ,
  output wire [8-1:0]                      m11_axi_arlen  ,
  input  wire                              m11_axi_rvalid ,
  output wire                              m11_axi_rready ,
  input  wire [C_M11_AXI_DATA_WIDTH-1:0]   m11_axi_rdata  ,
  input  wire                              m11_axi_rlast  ,
  // AXI4 master interface m12_axi
  output wire                              m12_axi_awvalid,
  input  wire                              m12_axi_awready,
  output wire [C_M12_AXI_ADDR_WIDTH-1:0]   m12_axi_awaddr ,
  output wire [8-1:0]                      m12_axi_awlen  ,
  output wire                              m12_axi_wvalid ,
  input  wire                              m12_axi_wready ,
  output wire [C_M12_AXI_DATA_WIDTH-1:0]   m12_axi_wdata  ,
  output wire [C_M12_AXI_DATA_WIDTH/8-1:0] m12_axi_wstrb  ,
  output wire                              m12_axi_wlast  ,
  input  wire                              m12_axi_bvalid ,
  output wire                              m12_axi_bready ,
  output wire                              m12_axi_arvalid,
  input  wire                              m12_axi_arready,
  output wire [C_M12_AXI_ADDR_WIDTH-1:0]   m12_axi_araddr ,
  output wire [8-1:0]                      m12_axi_arlen  ,
  input  wire                              m12_axi_rvalid ,
  output wire                              m12_axi_rready ,
  input  wire [C_M12_AXI_DATA_WIDTH-1:0]   m12_axi_rdata  ,
  input  wire                              m12_axi_rlast  ,
  // AXI4 master interface m13_axi
  output wire                              m13_axi_awvalid,
  input  wire                              m13_axi_awready,
  output wire [C_M13_AXI_ADDR_WIDTH-1:0]   m13_axi_awaddr ,
  output wire [8-1:0]                      m13_axi_awlen  ,
  output wire                              m13_axi_wvalid ,
  input  wire                              m13_axi_wready ,
  output wire [C_M13_AXI_DATA_WIDTH-1:0]   m13_axi_wdata  ,
  output wire [C_M13_AXI_DATA_WIDTH/8-1:0] m13_axi_wstrb  ,
  output wire                              m13_axi_wlast  ,
  input  wire                              m13_axi_bvalid ,
  output wire                              m13_axi_bready ,
  output wire                              m13_axi_arvalid,
  input  wire                              m13_axi_arready,
  output wire [C_M13_AXI_ADDR_WIDTH-1:0]   m13_axi_araddr ,
  output wire [8-1:0]                      m13_axi_arlen  ,
  input  wire                              m13_axi_rvalid ,
  output wire                              m13_axi_rready ,
  input  wire [C_M13_AXI_DATA_WIDTH-1:0]   m13_axi_rdata  ,
  input  wire                              m13_axi_rlast  ,
  // AXI4 master interface m14_axi
  output wire                              m14_axi_awvalid,
  input  wire                              m14_axi_awready,
  output wire [C_M14_AXI_ADDR_WIDTH-1:0]   m14_axi_awaddr ,
  output wire [8-1:0]                      m14_axi_awlen  ,
  output wire                              m14_axi_wvalid ,
  input  wire                              m14_axi_wready ,
  output wire [C_M14_AXI_DATA_WIDTH-1:0]   m14_axi_wdata  ,
  output wire [C_M14_AXI_DATA_WIDTH/8-1:0] m14_axi_wstrb  ,
  output wire                              m14_axi_wlast  ,
  input  wire                              m14_axi_bvalid ,
  output wire                              m14_axi_bready ,
  output wire                              m14_axi_arvalid,
  input  wire                              m14_axi_arready,
  output wire [C_M14_AXI_ADDR_WIDTH-1:0]   m14_axi_araddr ,
  output wire [8-1:0]                      m14_axi_arlen  ,
  input  wire                              m14_axi_rvalid ,
  output wire                              m14_axi_rready ,
  input  wire [C_M14_AXI_DATA_WIDTH-1:0]   m14_axi_rdata  ,
  input  wire                              m14_axi_rlast  ,
  // AXI4 master interface m15_axi
  output wire                              m15_axi_awvalid,
  input  wire                              m15_axi_awready,
  output wire [C_M15_AXI_ADDR_WIDTH-1:0]   m15_axi_awaddr ,
  output wire [8-1:0]                      m15_axi_awlen  ,
  output wire                              m15_axi_wvalid ,
  input  wire                              m15_axi_wready ,
  output wire [C_M15_AXI_DATA_WIDTH-1:0]   m15_axi_wdata  ,
  output wire [C_M15_AXI_DATA_WIDTH/8-1:0] m15_axi_wstrb  ,
  output wire                              m15_axi_wlast  ,
  input  wire                              m15_axi_bvalid ,
  output wire                              m15_axi_bready ,
  output wire                              m15_axi_arvalid,
  input  wire                              m15_axi_arready,
  output wire [C_M15_AXI_ADDR_WIDTH-1:0]   m15_axi_araddr ,
  output wire [8-1:0]                      m15_axi_arlen  ,
  input  wire                              m15_axi_rvalid ,
  output wire                              m15_axi_rready ,
  input  wire [C_M15_AXI_DATA_WIDTH-1:0]   m15_axi_rdata  ,
  input  wire                              m15_axi_rlast  ,
  // AXI4 master interface m16_axi
  output wire                              m16_axi_awvalid,
  input  wire                              m16_axi_awready,
  output wire [C_M16_AXI_ADDR_WIDTH-1:0]   m16_axi_awaddr ,
  output wire [8-1:0]                      m16_axi_awlen  ,
  output wire                              m16_axi_wvalid ,
  input  wire                              m16_axi_wready ,
  output wire [C_M16_AXI_DATA_WIDTH-1:0]   m16_axi_wdata  ,
  output wire [C_M16_AXI_DATA_WIDTH/8-1:0] m16_axi_wstrb  ,
  output wire                              m16_axi_wlast  ,
  input  wire                              m16_axi_bvalid ,
  output wire                              m16_axi_bready ,
  output wire                              m16_axi_arvalid,
  input  wire                              m16_axi_arready,
  output wire [C_M16_AXI_ADDR_WIDTH-1:0]   m16_axi_araddr ,
  output wire [8-1:0]                      m16_axi_arlen  ,
  input  wire                              m16_axi_rvalid ,
  output wire                              m16_axi_rready ,
  input  wire [C_M16_AXI_DATA_WIDTH-1:0]   m16_axi_rdata  ,
  input  wire                              m16_axi_rlast  ,
  // AXI4 master interface m17_axi
  output wire                              m17_axi_awvalid,
  input  wire                              m17_axi_awready,
  output wire [C_M17_AXI_ADDR_WIDTH-1:0]   m17_axi_awaddr ,
  output wire [8-1:0]                      m17_axi_awlen  ,
  output wire                              m17_axi_wvalid ,
  input  wire                              m17_axi_wready ,
  output wire [C_M17_AXI_DATA_WIDTH-1:0]   m17_axi_wdata  ,
  output wire [C_M17_AXI_DATA_WIDTH/8-1:0] m17_axi_wstrb  ,
  output wire                              m17_axi_wlast  ,
  input  wire                              m17_axi_bvalid ,
  output wire                              m17_axi_bready ,
  output wire                              m17_axi_arvalid,
  input  wire                              m17_axi_arready,
  output wire [C_M17_AXI_ADDR_WIDTH-1:0]   m17_axi_araddr ,
  output wire [8-1:0]                      m17_axi_arlen  ,
  input  wire                              m17_axi_rvalid ,
  output wire                              m17_axi_rready ,
  input  wire [C_M17_AXI_DATA_WIDTH-1:0]   m17_axi_rdata  ,
  input  wire                              m17_axi_rlast  ,
  // AXI4 master interface m18_axi
  output wire                              m18_axi_awvalid,
  input  wire                              m18_axi_awready,
  output wire [C_M18_AXI_ADDR_WIDTH-1:0]   m18_axi_awaddr ,
  output wire [8-1:0]                      m18_axi_awlen  ,
  output wire                              m18_axi_wvalid ,
  input  wire                              m18_axi_wready ,
  output wire [C_M18_AXI_DATA_WIDTH-1:0]   m18_axi_wdata  ,
  output wire [C_M18_AXI_DATA_WIDTH/8-1:0] m18_axi_wstrb  ,
  output wire                              m18_axi_wlast  ,
  input  wire                              m18_axi_bvalid ,
  output wire                              m18_axi_bready ,
  output wire                              m18_axi_arvalid,
  input  wire                              m18_axi_arready,
  output wire [C_M18_AXI_ADDR_WIDTH-1:0]   m18_axi_araddr ,
  output wire [8-1:0]                      m18_axi_arlen  ,
  input  wire                              m18_axi_rvalid ,
  output wire                              m18_axi_rready ,
  input  wire [C_M18_AXI_DATA_WIDTH-1:0]   m18_axi_rdata  ,
  input  wire                              m18_axi_rlast  ,
  // AXI4 master interface m19_axi
  output wire                              m19_axi_awvalid,
  input  wire                              m19_axi_awready,
  output wire [C_M19_AXI_ADDR_WIDTH-1:0]   m19_axi_awaddr ,
  output wire [8-1:0]                      m19_axi_awlen  ,
  output wire                              m19_axi_wvalid ,
  input  wire                              m19_axi_wready ,
  output wire [C_M19_AXI_DATA_WIDTH-1:0]   m19_axi_wdata  ,
  output wire [C_M19_AXI_DATA_WIDTH/8-1:0] m19_axi_wstrb  ,
  output wire                              m19_axi_wlast  ,
  input  wire                              m19_axi_bvalid ,
  output wire                              m19_axi_bready ,
  output wire                              m19_axi_arvalid,
  input  wire                              m19_axi_arready,
  output wire [C_M19_AXI_ADDR_WIDTH-1:0]   m19_axi_araddr ,
  output wire [8-1:0]                      m19_axi_arlen  ,
  input  wire                              m19_axi_rvalid ,
  output wire                              m19_axi_rready ,
  input  wire [C_M19_AXI_DATA_WIDTH-1:0]   m19_axi_rdata  ,
  input  wire                              m19_axi_rlast  ,
  // AXI4 master interface m20_axi
  output wire                              m20_axi_awvalid,
  input  wire                              m20_axi_awready,
  output wire [C_M20_AXI_ADDR_WIDTH-1:0]   m20_axi_awaddr ,
  output wire [8-1:0]                      m20_axi_awlen  ,
  output wire                              m20_axi_wvalid ,
  input  wire                              m20_axi_wready ,
  output wire [C_M20_AXI_DATA_WIDTH-1:0]   m20_axi_wdata  ,
  output wire [C_M20_AXI_DATA_WIDTH/8-1:0] m20_axi_wstrb  ,
  output wire                              m20_axi_wlast  ,
  input  wire                              m20_axi_bvalid ,
  output wire                              m20_axi_bready ,
  output wire                              m20_axi_arvalid,
  input  wire                              m20_axi_arready,
  output wire [C_M20_AXI_ADDR_WIDTH-1:0]   m20_axi_araddr ,
  output wire [8-1:0]                      m20_axi_arlen  ,
  input  wire                              m20_axi_rvalid ,
  output wire                              m20_axi_rready ,
  input  wire [C_M20_AXI_DATA_WIDTH-1:0]   m20_axi_rdata  ,
  input  wire                              m20_axi_rlast  ,
  // AXI4 master interface m21_axi
  output wire                              m21_axi_awvalid,
  input  wire                              m21_axi_awready,
  output wire [C_M21_AXI_ADDR_WIDTH-1:0]   m21_axi_awaddr ,
  output wire [8-1:0]                      m21_axi_awlen  ,
  output wire                              m21_axi_wvalid ,
  input  wire                              m21_axi_wready ,
  output wire [C_M21_AXI_DATA_WIDTH-1:0]   m21_axi_wdata  ,
  output wire [C_M21_AXI_DATA_WIDTH/8-1:0] m21_axi_wstrb  ,
  output wire                              m21_axi_wlast  ,
  input  wire                              m21_axi_bvalid ,
  output wire                              m21_axi_bready ,
  output wire                              m21_axi_arvalid,
  input  wire                              m21_axi_arready,
  output wire [C_M21_AXI_ADDR_WIDTH-1:0]   m21_axi_araddr ,
  output wire [8-1:0]                      m21_axi_arlen  ,
  input  wire                              m21_axi_rvalid ,
  output wire                              m21_axi_rready ,
  input  wire [C_M21_AXI_DATA_WIDTH-1:0]   m21_axi_rdata  ,
  input  wire                              m21_axi_rlast  ,
  // AXI4 master interface m22_axi
  output wire                              m22_axi_awvalid,
  input  wire                              m22_axi_awready,
  output wire [C_M22_AXI_ADDR_WIDTH-1:0]   m22_axi_awaddr ,
  output wire [8-1:0]                      m22_axi_awlen  ,
  output wire                              m22_axi_wvalid ,
  input  wire                              m22_axi_wready ,
  output wire [C_M22_AXI_DATA_WIDTH-1:0]   m22_axi_wdata  ,
  output wire [C_M22_AXI_DATA_WIDTH/8-1:0] m22_axi_wstrb  ,
  output wire                              m22_axi_wlast  ,
  input  wire                              m22_axi_bvalid ,
  output wire                              m22_axi_bready ,
  output wire                              m22_axi_arvalid,
  input  wire                              m22_axi_arready,
  output wire [C_M22_AXI_ADDR_WIDTH-1:0]   m22_axi_araddr ,
  output wire [8-1:0]                      m22_axi_arlen  ,
  input  wire                              m22_axi_rvalid ,
  output wire                              m22_axi_rready ,
  input  wire [C_M22_AXI_DATA_WIDTH-1:0]   m22_axi_rdata  ,
  input  wire                              m22_axi_rlast  ,
  // AXI4 master interface m23_axi
  output wire                              m23_axi_awvalid,
  input  wire                              m23_axi_awready,
  output wire [C_M23_AXI_ADDR_WIDTH-1:0]   m23_axi_awaddr ,
  output wire [8-1:0]                      m23_axi_awlen  ,
  output wire                              m23_axi_wvalid ,
  input  wire                              m23_axi_wready ,
  output wire [C_M23_AXI_DATA_WIDTH-1:0]   m23_axi_wdata  ,
  output wire [C_M23_AXI_DATA_WIDTH/8-1:0] m23_axi_wstrb  ,
  output wire                              m23_axi_wlast  ,
  input  wire                              m23_axi_bvalid ,
  output wire                              m23_axi_bready ,
  output wire                              m23_axi_arvalid,
  input  wire                              m23_axi_arready,
  output wire [C_M23_AXI_ADDR_WIDTH-1:0]   m23_axi_araddr ,
  output wire [8-1:0]                      m23_axi_arlen  ,
  input  wire                              m23_axi_rvalid ,
  output wire                              m23_axi_rready ,
  input  wire [C_M23_AXI_DATA_WIDTH-1:0]   m23_axi_rdata  ,
  input  wire                              m23_axi_rlast  ,
  // AXI4 master interface m24_axi
  output wire                              m24_axi_awvalid,
  input  wire                              m24_axi_awready,
  output wire [C_M24_AXI_ADDR_WIDTH-1:0]   m24_axi_awaddr ,
  output wire [8-1:0]                      m24_axi_awlen  ,
  output wire                              m24_axi_wvalid ,
  input  wire                              m24_axi_wready ,
  output wire [C_M24_AXI_DATA_WIDTH-1:0]   m24_axi_wdata  ,
  output wire [C_M24_AXI_DATA_WIDTH/8-1:0] m24_axi_wstrb  ,
  output wire                              m24_axi_wlast  ,
  input  wire                              m24_axi_bvalid ,
  output wire                              m24_axi_bready ,
  output wire                              m24_axi_arvalid,
  input  wire                              m24_axi_arready,
  output wire [C_M24_AXI_ADDR_WIDTH-1:0]   m24_axi_araddr ,
  output wire [8-1:0]                      m24_axi_arlen  ,
  input  wire                              m24_axi_rvalid ,
  output wire                              m24_axi_rready ,
  input  wire [C_M24_AXI_DATA_WIDTH-1:0]   m24_axi_rdata  ,
  input  wire                              m24_axi_rlast  ,
  // AXI4 master interface m25_axi
  output wire                              m25_axi_awvalid,
  input  wire                              m25_axi_awready,
  output wire [C_M25_AXI_ADDR_WIDTH-1:0]   m25_axi_awaddr ,
  output wire [8-1:0]                      m25_axi_awlen  ,
  output wire                              m25_axi_wvalid ,
  input  wire                              m25_axi_wready ,
  output wire [C_M25_AXI_DATA_WIDTH-1:0]   m25_axi_wdata  ,
  output wire [C_M25_AXI_DATA_WIDTH/8-1:0] m25_axi_wstrb  ,
  output wire                              m25_axi_wlast  ,
  input  wire                              m25_axi_bvalid ,
  output wire                              m25_axi_bready ,
  output wire                              m25_axi_arvalid,
  input  wire                              m25_axi_arready,
  output wire [C_M25_AXI_ADDR_WIDTH-1:0]   m25_axi_araddr ,
  output wire [8-1:0]                      m25_axi_arlen  ,
  input  wire                              m25_axi_rvalid ,
  output wire                              m25_axi_rready ,
  input  wire [C_M25_AXI_DATA_WIDTH-1:0]   m25_axi_rdata  ,
  input  wire                              m25_axi_rlast  ,
  // AXI4 master interface m26_axi
  output wire                              m26_axi_awvalid,
  input  wire                              m26_axi_awready,
  output wire [C_M26_AXI_ADDR_WIDTH-1:0]   m26_axi_awaddr ,
  output wire [8-1:0]                      m26_axi_awlen  ,
  output wire                              m26_axi_wvalid ,
  input  wire                              m26_axi_wready ,
  output wire [C_M26_AXI_DATA_WIDTH-1:0]   m26_axi_wdata  ,
  output wire [C_M26_AXI_DATA_WIDTH/8-1:0] m26_axi_wstrb  ,
  output wire                              m26_axi_wlast  ,
  input  wire                              m26_axi_bvalid ,
  output wire                              m26_axi_bready ,
  output wire                              m26_axi_arvalid,
  input  wire                              m26_axi_arready,
  output wire [C_M26_AXI_ADDR_WIDTH-1:0]   m26_axi_araddr ,
  output wire [8-1:0]                      m26_axi_arlen  ,
  input  wire                              m26_axi_rvalid ,
  output wire                              m26_axi_rready ,
  input  wire [C_M26_AXI_DATA_WIDTH-1:0]   m26_axi_rdata  ,
  input  wire                              m26_axi_rlast  ,
  // AXI4 master interface m27_axi
  output wire                              m27_axi_awvalid,
  input  wire                              m27_axi_awready,
  output wire [C_M27_AXI_ADDR_WIDTH-1:0]   m27_axi_awaddr ,
  output wire [8-1:0]                      m27_axi_awlen  ,
  output wire                              m27_axi_wvalid ,
  input  wire                              m27_axi_wready ,
  output wire [C_M27_AXI_DATA_WIDTH-1:0]   m27_axi_wdata  ,
  output wire [C_M27_AXI_DATA_WIDTH/8-1:0] m27_axi_wstrb  ,
  output wire                              m27_axi_wlast  ,
  input  wire                              m27_axi_bvalid ,
  output wire                              m27_axi_bready ,
  output wire                              m27_axi_arvalid,
  input  wire                              m27_axi_arready,
  output wire [C_M27_AXI_ADDR_WIDTH-1:0]   m27_axi_araddr ,
  output wire [8-1:0]                      m27_axi_arlen  ,
  input  wire                              m27_axi_rvalid ,
  output wire                              m27_axi_rready ,
  input  wire [C_M27_AXI_DATA_WIDTH-1:0]   m27_axi_rdata  ,
  input  wire                              m27_axi_rlast  ,
  // AXI4 master interface m28_axi
  output wire                              m28_axi_awvalid,
  input  wire                              m28_axi_awready,
  output wire [C_M28_AXI_ADDR_WIDTH-1:0]   m28_axi_awaddr ,
  output wire [8-1:0]                      m28_axi_awlen  ,
  output wire                              m28_axi_wvalid ,
  input  wire                              m28_axi_wready ,
  output wire [C_M28_AXI_DATA_WIDTH-1:0]   m28_axi_wdata  ,
  output wire [C_M28_AXI_DATA_WIDTH/8-1:0] m28_axi_wstrb  ,
  output wire                              m28_axi_wlast  ,
  input  wire                              m28_axi_bvalid ,
  output wire                              m28_axi_bready ,
  output wire                              m28_axi_arvalid,
  input  wire                              m28_axi_arready,
  output wire [C_M28_AXI_ADDR_WIDTH-1:0]   m28_axi_araddr ,
  output wire [8-1:0]                      m28_axi_arlen  ,
  input  wire                              m28_axi_rvalid ,
  output wire                              m28_axi_rready ,
  input  wire [C_M28_AXI_DATA_WIDTH-1:0]   m28_axi_rdata  ,
  input  wire                              m28_axi_rlast  ,
  // AXI4 master interface m29_axi
  output wire                              m29_axi_awvalid,
  input  wire                              m29_axi_awready,
  output wire [C_M29_AXI_ADDR_WIDTH-1:0]   m29_axi_awaddr ,
  output wire [8-1:0]                      m29_axi_awlen  ,
  output wire                              m29_axi_wvalid ,
  input  wire                              m29_axi_wready ,
  output wire [C_M29_AXI_DATA_WIDTH-1:0]   m29_axi_wdata  ,
  output wire [C_M29_AXI_DATA_WIDTH/8-1:0] m29_axi_wstrb  ,
  output wire                              m29_axi_wlast  ,
  input  wire                              m29_axi_bvalid ,
  output wire                              m29_axi_bready ,
  output wire                              m29_axi_arvalid,
  input  wire                              m29_axi_arready,
  output wire [C_M29_AXI_ADDR_WIDTH-1:0]   m29_axi_araddr ,
  output wire [8-1:0]                      m29_axi_arlen  ,
  input  wire                              m29_axi_rvalid ,
  output wire                              m29_axi_rready ,
  input  wire [C_M29_AXI_DATA_WIDTH-1:0]   m29_axi_rdata  ,
  input  wire                              m29_axi_rlast  ,
  // AXI4 master interface m30_axi
  output wire                              m30_axi_awvalid,
  input  wire                              m30_axi_awready,
  output wire [C_M30_AXI_ADDR_WIDTH-1:0]   m30_axi_awaddr ,
  output wire [8-1:0]                      m30_axi_awlen  ,
  output wire                              m30_axi_wvalid ,
  input  wire                              m30_axi_wready ,
  output wire [C_M30_AXI_DATA_WIDTH-1:0]   m30_axi_wdata  ,
  output wire [C_M30_AXI_DATA_WIDTH/8-1:0] m30_axi_wstrb  ,
  output wire                              m30_axi_wlast  ,
  input  wire                              m30_axi_bvalid ,
  output wire                              m30_axi_bready ,
  output wire                              m30_axi_arvalid,
  input  wire                              m30_axi_arready,
  output wire [C_M30_AXI_ADDR_WIDTH-1:0]   m30_axi_araddr ,
  output wire [8-1:0]                      m30_axi_arlen  ,
  input  wire                              m30_axi_rvalid ,
  output wire                              m30_axi_rready ,
  input  wire [C_M30_AXI_DATA_WIDTH-1:0]   m30_axi_rdata  ,
  input  wire                              m30_axi_rlast  ,
  // AXI4 master interface m31_axi
  output wire                              m31_axi_awvalid,
  input  wire                              m31_axi_awready,
  output wire [C_M31_AXI_ADDR_WIDTH-1:0]   m31_axi_awaddr ,
  output wire [8-1:0]                      m31_axi_awlen  ,
  output wire                              m31_axi_wvalid ,
  input  wire                              m31_axi_wready ,
  output wire [C_M31_AXI_DATA_WIDTH-1:0]   m31_axi_wdata  ,
  output wire [C_M31_AXI_DATA_WIDTH/8-1:0] m31_axi_wstrb  ,
  output wire                              m31_axi_wlast  ,
  input  wire                              m31_axi_bvalid ,
  output wire                              m31_axi_bready ,
  output wire                              m31_axi_arvalid,
  input  wire                              m31_axi_arready,
  output wire [C_M31_AXI_ADDR_WIDTH-1:0]   m31_axi_araddr ,
  output wire [8-1:0]                      m31_axi_arlen  ,
  input  wire                              m31_axi_rvalid ,
  output wire                              m31_axi_rready ,
  input  wire [C_M31_AXI_DATA_WIDTH-1:0]   m31_axi_rdata  ,
  input  wire                              m31_axi_rlast  ,
  // Control Signals
  input  wire                              ap_start       ,
  output wire                              ap_idle        ,
  output wire                              ap_done        ,
  output wire                              ap_ready       ,
  input  wire [32-1:0]                     root_id        ,
  input  wire [64-1:0]                     axi00_ptr0     ,
  input  wire [64-1:0]                     axi01_ptr0     ,
  input  wire [64-1:0]                     axi02_ptr0     ,
  input  wire [64-1:0]                     axi03_ptr0     ,
  input  wire [64-1:0]                     axi04_ptr0     ,
  input  wire [64-1:0]                     axi05_ptr0     ,
  input  wire [64-1:0]                     axi06_ptr0     ,
  input  wire [64-1:0]                     axi07_ptr0     ,
  input  wire [64-1:0]                     axi08_ptr0     ,
  input  wire [64-1:0]                     axi09_ptr0     ,
  input  wire [64-1:0]                     axi10_ptr0     ,
  input  wire [64-1:0]                     axi11_ptr0     ,
  input  wire [64-1:0]                     axi12_ptr0     ,
  input  wire [64-1:0]                     axi13_ptr0     ,
  input  wire [64-1:0]                     axi14_ptr0     ,
  input  wire [64-1:0]                     axi15_ptr0     ,
  input  wire [64-1:0]                     axi16_ptr0     ,
  input  wire [64-1:0]                     axi17_ptr0     ,
  input  wire [64-1:0]                     axi18_ptr0     ,
  input  wire [64-1:0]                     axi19_ptr0     ,
  input  wire [64-1:0]                     axi20_ptr0     ,
  input  wire [64-1:0]                     axi21_ptr0     ,
  input  wire [64-1:0]                     axi22_ptr0     ,
  input  wire [64-1:0]                     axi23_ptr0     ,
  input  wire [64-1:0]                     axi24_ptr0     ,
  input  wire [64-1:0]                     axi25_ptr0     ,
  input  wire [64-1:0]                     axi26_ptr0     ,
  input  wire [64-1:0]                     axi27_ptr0     ,
  input  wire [64-1:0]                     axi28_ptr0     ,
  input  wire [64-1:0]                     axi29_ptr0     ,
  input  wire [64-1:0]                     axi30_ptr0     ,
  input  wire [64-1:0]                     axi31_ptr0     
);


timeunit 1ps;
timeprecision 1ps;

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
// Large enough for interesting traffic.
localparam integer  LP_DEFAULT_LENGTH_IN_BYTES = 16384;
localparam integer  LP_NUM_EXAMPLES    = 32;

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
wire                                  P1_iteration_done [0 : CORE_NUM - 1];
wire                                  P1_next_rst [0 : CORE_NUM - 1];
wire                                  P1_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P1_active_v_id [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          P1_active_v_value [0 : CORE_NUM - 1];
wire                                  P1_active_v_pull_first_flag [0 : CORE_NUM - 1];
wire                                  P1_active_v_valid [0 : CORE_NUM - 1];
wire                                  P1_iteration_end [0 : CORE_NUM - 1];
wire                                  P1_iteration_end_valid [0 : CORE_NUM - 1];
wire [ITERATION_DWIDTH - 1 : 0]       P1_global_iteration_id [0 : CORE_NUM - 1];
wire [POWERLAW_VTX_NUM - 1 : 0]       P1_global_powerlaw_v_visit [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P1_global_root_id;

wire                                  P2_next_rst [0 : CORE_NUM - 1];
wire                                  P2_stage_full [0 : CORE_NUM - 1];
wire                                  P2_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P2_active_v_id [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          P2_active_v_value [0 : CORE_NUM - 1];
wire [V_OFF_AWIDTH - 1 : 0]           P2_rd_active_v_offset_addr [0 : CORE_NUM - 1];
wire                                  P2_active_v_pull_first_flag [0 : CORE_NUM - 1];
wire                                  P2_active_v_valid [0 : CORE_NUM - 1];
wire                                  P2_iteration_end [0 : CORE_NUM - 1];
wire                                  P2_iteration_end_valid [0 : CORE_NUM - 1];
wire [ITERATION_DWIDTH - 1 : 0]       P2_global_iteration_id [0 : CORE_NUM - 1];
wire [POWERLAW_VTX_NUM - 1 : 0]       P2_global_powerlaw_v_visit [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P2_global_root_id;

wire                                  P3_transfer_complete [0 : CORE_NUM - 1];
// wire [PSEUDO_CHANNEL_NUM * HBM_AWIDTH - 1 : 0]  P3_hbm_controller_addr;
// wire [PSEUDO_CHANNEL_NUM - 1 : 0]  P3_hbm_addr_valid;

wire [HBM_AWIDTH - 1 : 0]  P3_hbm_controller_addr [0 : 32 - 1];
wire                       P3_hbm_addr_valid [0 : 32 - 1];

wire                                  P3_next_rst [0 : CORE_NUM - 1];
wire [V_OFF_DWIDTH - 1 : 0]           P3_active_v_loffset [0 : CORE_NUM - 1];
wire [V_OFF_DWIDTH - 1 : 0]           P3_active_v_roffset [0 : CORE_NUM - 1];
wire                                  P3_active_v_valid [0 : CORE_NUM - 1];

wire                                  P4_next_rst [0 : CORE_NUM - 1];
wire                                  P4_stage_full [0 : CORE_NUM - 1];
wire [HBM_AWIDTH - 1 : 0]             P4_rd_hbm_edge_addr [0 : CORE_NUM - 1];
wire [HBM_EDGE_MASK - 1 : 0]          P4_rd_hbm_edge_mask [0 : CORE_NUM - 1];
wire                                  P4_hbm_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P4_hbm_active_v_id [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          P4_hbm_active_v_value [0 : CORE_NUM - 1];
wire                                  P4_rd_hbm_edge_valid [0 : CORE_NUM - 1];
wire [FIRST_EDGE_BRAM_AWIDTH - 1 : 0] P4_rd_bram_edge_addr [0 : CORE_NUM - 1];
wire                                  P4_bram_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P4_bram_active_v_id [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          P4_bram_active_v_value [0 : CORE_NUM - 1];
wire                                  P4_rd_bram_edge_valid [0 : CORE_NUM - 1];
wire                                  P4_iteration_end [0 : CORE_NUM - 1];
wire                                  P4_iteration_end_valid [0 : CORE_NUM - 1];
wire [ITERATION_DWIDTH - 1 : 0]       P4_global_iteration_id [0 : CORE_NUM - 1];
wire [POWERLAW_VTX_NUM - 1 : 0]       P4_global_powerlaw_v_visit [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P4_global_root_id;

wire                                  P5_next_rst [0 : CORE_NUM - 1];
wire                                  P5_stage_full [0 : CORE_NUM - 1];
wire [HBM_AWIDTH - 1 : 0]             P5_rd_hbm_edge_addr [0 : PSEUDO_CHANNEL_NUM - 1];
wire                                  P5_rd_hbm_edge_valid [0 : PSEUDO_CHANNEL_NUM - 1];
wire                                  P5_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P5_active_v_id [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          P5_active_v_value [0 : CORE_NUM - 1];
wire                                  P5_active_v_valid [0 : CORE_NUM - 1];
wire                                  P5_iteration_end [0 : CORE_NUM - 1];
wire                                  P5_iteration_end_valid [0 : CORE_NUM - 1];
wire [ITERATION_DWIDTH - 1 : 0]       P5_global_iteration_id [0 : CORE_NUM - 1];
wire [POWERLAW_VTX_NUM - 1 : 0]       P5_global_powerlaw_v_visit [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P5_global_root_id;

wire                                  P5_2_stage_full [0 : CORE_NUM - 1];
wire                                  P5_2_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P5_2_active_v_id [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          P5_2_active_v_value [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P5_2_active_v_edge [0 : CORE_NUM - 1];
wire                                  P5_2_active_v_valid [0 : CORE_NUM - 1];
wire                                  P5_2_iteration_end [0 : CORE_NUM - 1];
wire                                  P5_2_iteration_end_valid [0 : CORE_NUM - 1];

/*
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_interface_full;
wire [PSEUDO_CHANNEL_NUM * HBM_AWIDTH - 1 : 0]  HBM_interface_rd_hbm_edge_addr;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_interface_rd_hbm_edge_valid;
*/
wire                                  HBM_interface_full [0 : 32 - 1];
wire [HBM_AWIDTH - 1 : 0]             HBM_interface_rd_hbm_edge_addr [0 : 32 - 1];
wire                                  HBM_interface_rd_hbm_edge_valid [0 : 32 - 1];
wire [HBM_AWIDTH - 1 : 0]             HBM_interface_active_v_edge [0 : CORE_NUM - 1];
wire                                  HBM_interface_active_v_edge_valid [0 : CORE_NUM - 1];

/*
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_controller_read_full;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_controller_write_full;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_controller_write_empty;
wire [PSEUDO_CHANNEL_NUM * HBM_DWIDTH - 1 : 0]  HBM_controller_edge;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_controller_valid;
wire [PSEUDO_CHANNEL_NUM * HBM_AWIDTH - 1 : 0]  HBM_controller_recv_addr;
wire [PSEUDO_CHANNEL_NUM - 1 : 0]               HBM_controller_addr_valid;
*/
wire                                  HBM_controller_read_full [0 : 32 - 1];
wire                                  HBM_controller_write_full [0 : 32 - 1];
wire                                  HBM_controller_write_empty [0 : 32 - 1];
wire [HBM_DWIDTH - 1 : 0]             HBM_controller_edge [0 : 32 - 1];
wire                                  HBM_controller_valid [0 : 32 - 1];
wire [HBM_AWIDTH - 1 : 0]             HBM_controller_recv_addr [0 : 32 - 1];
wire                                  HBM_controller_addr_valid [0 : 32 - 1];

wire                                  P6_next_rst [0 : CORE_NUM - 1];
wire                                  P6_stage_full1 [0 : PSEUDO_CHANNEL_NUM - 1];
wire                                  P6_stage_full2 [0 : CORE_NUM - 1];
wire                                  P6_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P6_update_v_id [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          P6_update_v_value [0 : CORE_NUM - 1];
wire                                  P6_pull_first_flag [0 : CORE_NUM - 1];
wire                                  P6_update_v_valid [0 : CORE_NUM - 1];
wire                                  P6_iteration_end [0 : CORE_NUM - 1];
wire                                  P6_iteration_end_valid [0 : CORE_NUM - 1];
wire [ITERATION_DWIDTH - 1 : 0]       P6_global_iteration_id [0 : CORE_NUM - 1];
wire [POWERLAW_VTX_NUM - 1 : 0]       P6_global_powerlaw_v_visit [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P6_global_root_id;

wire                                  OM1_next_rst [0 : CORE_NUM - 1];
wire                                  OM2_next_rst [0 : CORE_NUM - 1];
wire                                  OM1_stage_full, OM2_stage_full [0 : CORE_NUM - 1];
wire                                  OM1_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             OM1_update_v_id [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          OM1_update_v_value [0 : CORE_NUM - 1];
wire                                  OM1_pull_first_flag [0 : CORE_NUM - 1];
wire                                  OM1_update_v_valid [0 : CORE_NUM - 1];
wire                                  OM1_iteration_end [0 : CORE_NUM - 1];
wire                                  OM1_iteration_end_valid [0 : CORE_NUM - 1];
wire                                  OM2_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             OM2_update_v_id [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          OM2_update_v_value [0 : CORE_NUM - 1];
wire                                  OM2_pull_first_flag [0 : CORE_NUM - 1];
wire                                  OM2_update_v_valid [0 : CORE_NUM - 1];
wire                                  OM2_iteration_end [0 : CORE_NUM - 1];
wire                                  OM2_iteration_end_valid [0 : CORE_NUM - 1];
wire [ITERATION_DWIDTH - 1 : 0]       OM_global_iteration_id [0 : CORE_NUM - 1];
wire [POWERLAW_VTX_NUM - 1 : 0]       OM_global_powerlaw_v_visit [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             OM_global_root_id;

wire                                  P7_next_rst1 [0 : CORE_NUM - 1];
wire                                  P7_next_rst2 [0 : CORE_NUM - 1];
wire                                  P7_source_core_full [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P7_rd_vertex_bram_addr [0 : CORE_NUM - 1];
wire                                  P7_rd_vertex_bram_valid [0 : CORE_NUM - 1];
wire                                  P7_wr_vertex_bram_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P7_wr_vertex_bram_addr [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          P7_wr_vertex_bram_data [0 : CORE_NUM - 1];
wire                                  P7_wr_vertex_bram_pull_first_flag [0 : CORE_NUM - 1];
wire                                  P7_wr_vertex_bram_valid [0 : CORE_NUM - 1];
wire                                  P7_wr_vertex_bram_iteration_end [0 : CORE_NUM - 1];
wire                                  P7_wr_vertex_bram_iteration_end_valid [0 : CORE_NUM - 1];
wire                                  P7_om2_send_push_flag [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P7_om2_send_update_v_id [0 : CORE_NUM - 1];
wire [V_VALUE_WIDTH - 1 : 0]          P7_om2_send_update_v_value [0 : CORE_NUM - 1];
wire                                  P7_om2_send_update_v_pull_first_flag [0 : CORE_NUM - 1];
wire                                  P7_om2_send_update_v_valid [0 : CORE_NUM - 1];
wire                                  P7_om2_send_iteration_end [0 : CORE_NUM - 1];
wire                                  P7_om2_send_iteration_end_valid [0 : CORE_NUM - 1];
wire [ITERATION_DWIDTH - 1 : 0]       P7_global_iteration_id [0 : CORE_NUM - 1];
wire [POWERLAW_VTX_NUM - 1 : 0]       P7_global_powerlaw_v_visit [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P7_global_root_id;

wire                                  VTX_BRAM_next_rst [0 : CORE_NUM - 1];
wire [VTX_BRAM_DWIDTH - 1 : 0]        VTX_BRAM_src_recv_update_v_value [0 : CORE_NUM - 1];
wire                                  VTX_BRAM_src_recv_update_v_valid [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             VTX_BRAM_backend_active_v_id [0 : CORE_NUM - 1];
wire                                  VTX_BRAM_backend_active_v_updated [0 : CORE_NUM - 1];
wire                                  VTX_BRAM_backend_active_v_pull_first_flag [0 : CORE_NUM - 1];
wire                                  VTX_BRAM_backend_active_v_id_valid [0 : CORE_NUM - 1];
wire                                  VTX_BRAM_iteration_end [0 : CORE_NUM - 1];
wire                                  VTX_BRAM_iteration_end_valid [0 : CORE_NUM - 1];
wire [ITERATION_DWIDTH - 1 : 0]       VTX_BRAM_global_iteration_id [0 : CORE_NUM - 1];
wire [POWERLAW_VTX_NUM - 1 : 0]       VTX_BRAM_global_powerlaw_v_visit [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             VTX_BRAM_global_root_id;
wire                                  VTX_BRAM_transfer_done;
wire [HBM_DWIDTH_PER_CORE - 1 : 0]    VTX_BRAM_wb_bfs_data [0 : CORE_NUM - 1];
wire                                  VTX_BRAM_wb_bfs_valid [0 : PSEUDO_CHANNEL_NUM - 1];

wire [V_ID_WIDTH - 1 : 0]             P8_active_v_id [0 : CORE_NUM - 1];
wire                                  P8_active_v_updated [0 : CORE_NUM - 1];
wire                                  P8_active_v_pull_first_flag [0 : CORE_NUM - 1];
wire                                  P8_active_v_valid [0 : CORE_NUM - 1];
wire                                  P8_iteration_end [0 : CORE_NUM - 1];
wire                                  P8_iteration_end_valid [0 : CORE_NUM - 1];
wire [ITERATION_DWIDTH - 1 : 0]       P8_global_iteration_id [0 : CORE_NUM - 1];
wire [POWERLAW_VTX_NUM - 1 : 0]       P8_global_powerlaw_v_visit [0 : CORE_NUM - 1];
wire [V_ID_WIDTH - 1 : 0]             P8_global_root_id;

// 16 vertex per channel, 32bit per vertex : 8 for value, 24 for id
wire [(8 + 24) * 16 - 1 : 0] WR_BACK_bfs_res [0 : PSEUDO_CHANNEL_NUM - 1];
wire WR_BACK_bfs_valid [0 : PSEUDO_CHANNEL_NUM - 1];

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
      2'b01: if (P3_transfer_complete == {CORE_NUM{1'b1}}) begin
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
  .controller_recv_update_data      (WR_BACK_bfs_res[1]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[1]),
  .write_stage_full                 (HBM_controller_write_full[1]),
  .write_stage_empty                (ap_done_i[1])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M02_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M02_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m02_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi02_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m02_axi_awvalid         ),
  .m_axi_awready           ( m02_axi_awready         ),
  .m_axi_awaddr            ( m02_axi_awaddr          ),
  .m_axi_awlen             ( m02_axi_awlen           ),
  .m_axi_wvalid            ( m02_axi_wvalid          ),
  .m_axi_wready            ( m02_axi_wready          ),
  .m_axi_wdata             ( m02_axi_wdata           ),
  .m_axi_wstrb             ( m02_axi_wstrb           ),
  .m_axi_wlast             ( m02_axi_wlast           ),
  .m_axi_bvalid            ( m02_axi_bvalid          ),
  .m_axi_bready            ( m02_axi_bready          ),
  .m_axi_arvalid           ( m02_axi_arvalid         ),
  .m_axi_arready           ( m02_axi_arready         ),
  .m_axi_araddr            ( m02_axi_araddr          ),
  .m_axi_arlen             ( m02_axi_arlen           ),
  .m_axi_rvalid            ( m02_axi_rvalid          ),
  .m_axi_rready            ( m02_axi_rready          ),
  .m_axi_rdata             ( m02_axi_rdata           ),
  .m_axi_rlast             ( m02_axi_rlast           ),
  // acc
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(2 + 1) * HBM_AWIDTH - 1 : 2 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[2]),
  .read_stage_full                  (HBM_controller_read_full[2]),
  .controller_send_edge             (HBM_controller_edge[(2 + 1) * HBM_DWIDTH - 1 : 2 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[2]),
  .controller_recv_update_data      (WR_BACK_bfs_res[2]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[2]),
  .write_stage_full                 (HBM_controller_write_full[2]),
  .write_stage_empty                (ap_done_i[2])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M03_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M03_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m03_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi03_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m03_axi_awvalid         ),
  .m_axi_awready           ( m03_axi_awready         ),
  .m_axi_awaddr            ( m03_axi_awaddr          ),
  .m_axi_awlen             ( m03_axi_awlen           ),
  .m_axi_wvalid            ( m03_axi_wvalid          ),
  .m_axi_wready            ( m03_axi_wready          ),
  .m_axi_wdata             ( m03_axi_wdata           ),
  .m_axi_wstrb             ( m03_axi_wstrb           ),
  .m_axi_wlast             ( m03_axi_wlast           ),
  .m_axi_bvalid            ( m03_axi_bvalid          ),
  .m_axi_bready            ( m03_axi_bready          ),
  .m_axi_arvalid           ( m03_axi_arvalid         ),
  .m_axi_arready           ( m03_axi_arready         ),
  .m_axi_araddr            ( m03_axi_araddr          ),
  .m_axi_arlen             ( m03_axi_arlen           ),
  .m_axi_rvalid            ( m03_axi_rvalid          ),
  .m_axi_rready            ( m03_axi_rready          ),
  .m_axi_rdata             ( m03_axi_rdata           ),
  .m_axi_rlast             ( m03_axi_rlast           ),
  // acc
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(3 + 1) * HBM_AWIDTH - 1 : 3 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[3]),
  .read_stage_full                  (HBM_controller_read_full[3]),
  .controller_send_edge             (HBM_controller_edge[(3 + 1) * HBM_DWIDTH - 1 : 3 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[3]),
  .controller_recv_update_data      (WR_BACK_bfs_res[3]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[3]),
  .write_stage_full                 (HBM_controller_write_full[3]),
  .write_stage_empty                (ap_done_i[3])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M04_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M04_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m04_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi04_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m04_axi_awvalid         ),
  .m_axi_awready           ( m04_axi_awready         ),
  .m_axi_awaddr            ( m04_axi_awaddr          ),
  .m_axi_awlen             ( m04_axi_awlen           ),
  .m_axi_wvalid            ( m04_axi_wvalid          ),
  .m_axi_wready            ( m04_axi_wready          ),
  .m_axi_wdata             ( m04_axi_wdata           ),
  .m_axi_wstrb             ( m04_axi_wstrb           ),
  .m_axi_wlast             ( m04_axi_wlast           ),
  .m_axi_bvalid            ( m04_axi_bvalid          ),
  .m_axi_bready            ( m04_axi_bready          ),
  .m_axi_arvalid           ( m04_axi_arvalid         ),
  .m_axi_arready           ( m04_axi_arready         ),
  .m_axi_araddr            ( m04_axi_araddr          ),
  .m_axi_arlen             ( m04_axi_arlen           ),
  .m_axi_rvalid            ( m04_axi_rvalid          ),
  .m_axi_rready            ( m04_axi_rready          ),
  .m_axi_rdata             ( m04_axi_rdata           ),
  .m_axi_rlast             ( m04_axi_rlast           ),
  // acc
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(4 + 1) * HBM_AWIDTH - 1 : 4 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[4]),
  .read_stage_full                  (HBM_controller_read_full[4]),
  .controller_send_edge             (HBM_controller_edge[(4 + 1) * HBM_DWIDTH - 1 : 4 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[4]),
  .controller_recv_update_data      (WR_BACK_bfs_res[4]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[4]),
  .write_stage_full                 (HBM_controller_write_full[4]),
  .write_stage_empty                (ap_done_i[4])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M05_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M05_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m05_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi05_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m05_axi_awvalid         ),
  .m_axi_awready           ( m05_axi_awready         ),
  .m_axi_awaddr            ( m05_axi_awaddr          ),
  .m_axi_awlen             ( m05_axi_awlen           ),
  .m_axi_wvalid            ( m05_axi_wvalid          ),
  .m_axi_wready            ( m05_axi_wready          ),
  .m_axi_wdata             ( m05_axi_wdata           ),
  .m_axi_wstrb             ( m05_axi_wstrb           ),
  .m_axi_wlast             ( m05_axi_wlast           ),
  .m_axi_bvalid            ( m05_axi_bvalid          ),
  .m_axi_bready            ( m05_axi_bready          ),
  .m_axi_arvalid           ( m05_axi_arvalid         ),
  .m_axi_arready           ( m05_axi_arready         ),
  .m_axi_araddr            ( m05_axi_araddr          ),
  .m_axi_arlen             ( m05_axi_arlen           ),
  .m_axi_rvalid            ( m05_axi_rvalid          ),
  .m_axi_rready            ( m05_axi_rready          ),
  .m_axi_rdata             ( m05_axi_rdata           ),
  .m_axi_rlast             ( m05_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(5 + 1) * HBM_AWIDTH - 1 : 5 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[5]),
  .read_stage_full                  (HBM_controller_read_full[5]),
  .controller_send_edge             (HBM_controller_edge[(5 + 1) * HBM_DWIDTH - 1 : 5 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[5]),
  .controller_recv_update_data      (WR_BACK_bfs_res[5]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[5]),
  .write_stage_full                 (HBM_controller_write_full[5]),
  .write_stage_empty                (ap_done_i[5])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M06_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M06_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m06_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi06_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m06_axi_awvalid         ),
  .m_axi_awready           ( m06_axi_awready         ),
  .m_axi_awaddr            ( m06_axi_awaddr          ),
  .m_axi_awlen             ( m06_axi_awlen           ),
  .m_axi_wvalid            ( m06_axi_wvalid          ),
  .m_axi_wready            ( m06_axi_wready          ),
  .m_axi_wdata             ( m06_axi_wdata           ),
  .m_axi_wstrb             ( m06_axi_wstrb           ),
  .m_axi_wlast             ( m06_axi_wlast           ),
  .m_axi_bvalid            ( m06_axi_bvalid          ),
  .m_axi_bready            ( m06_axi_bready          ),
  .m_axi_arvalid           ( m06_axi_arvalid         ),
  .m_axi_arready           ( m06_axi_arready         ),
  .m_axi_araddr            ( m06_axi_araddr          ),
  .m_axi_arlen             ( m06_axi_arlen           ),
  .m_axi_rvalid            ( m06_axi_rvalid          ),
  .m_axi_rready            ( m06_axi_rready          ),
  .m_axi_rdata             ( m06_axi_rdata           ),
  .m_axi_rlast             ( m06_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(6 + 1) * HBM_AWIDTH - 1 : 6 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[6]),
  .read_stage_full                  (HBM_controller_read_full[6]),
  .controller_send_edge             (HBM_controller_edge[(6 + 1) * HBM_DWIDTH - 1 : 6 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[6]),
  .controller_recv_update_data      (WR_BACK_bfs_res[6]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[6]),
  .write_stage_full                 (HBM_controller_write_full[6]),
  .write_stage_empty                (ap_done_i[6])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M07_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M07_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m07_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi07_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m07_axi_awvalid         ),
  .m_axi_awready           ( m07_axi_awready         ),
  .m_axi_awaddr            ( m07_axi_awaddr          ),
  .m_axi_awlen             ( m07_axi_awlen           ),
  .m_axi_wvalid            ( m07_axi_wvalid          ),
  .m_axi_wready            ( m07_axi_wready          ),
  .m_axi_wdata             ( m07_axi_wdata           ),
  .m_axi_wstrb             ( m07_axi_wstrb           ),
  .m_axi_wlast             ( m07_axi_wlast           ),
  .m_axi_bvalid            ( m07_axi_bvalid          ),
  .m_axi_bready            ( m07_axi_bready          ),
  .m_axi_arvalid           ( m07_axi_arvalid         ),
  .m_axi_arready           ( m07_axi_arready         ),
  .m_axi_araddr            ( m07_axi_araddr          ),
  .m_axi_arlen             ( m07_axi_arlen           ),
  .m_axi_rvalid            ( m07_axi_rvalid          ),
  .m_axi_rready            ( m07_axi_rready          ),
  .m_axi_rdata             ( m07_axi_rdata           ),
  .m_axi_rlast             ( m07_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(7 + 1) * HBM_AWIDTH - 1 : 7 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[7]),
  .read_stage_full                  (HBM_controller_read_full[7]),
  .controller_send_edge             (HBM_controller_edge[(7 + 1) * HBM_DWIDTH - 1 : 7 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[7]),
  .controller_recv_update_data      (WR_BACK_bfs_res[7]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[7]),
  .write_stage_full                 (HBM_controller_write_full[7]),
  .write_stage_empty                (ap_done_i[7])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M08_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M08_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m08_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi08_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m08_axi_awvalid         ),
  .m_axi_awready           ( m08_axi_awready         ),
  .m_axi_awaddr            ( m08_axi_awaddr          ),
  .m_axi_awlen             ( m08_axi_awlen           ),
  .m_axi_wvalid            ( m08_axi_wvalid          ),
  .m_axi_wready            ( m08_axi_wready          ),
  .m_axi_wdata             ( m08_axi_wdata           ),
  .m_axi_wstrb             ( m08_axi_wstrb           ),
  .m_axi_wlast             ( m08_axi_wlast           ),
  .m_axi_bvalid            ( m08_axi_bvalid          ),
  .m_axi_bready            ( m08_axi_bready          ),
  .m_axi_arvalid           ( m08_axi_arvalid         ),
  .m_axi_arready           ( m08_axi_arready         ),
  .m_axi_araddr            ( m08_axi_araddr          ),
  .m_axi_arlen             ( m08_axi_arlen           ),
  .m_axi_rvalid            ( m08_axi_rvalid          ),
  .m_axi_rready            ( m08_axi_rready          ),
  .m_axi_rdata             ( m08_axi_rdata           ),
  .m_axi_rlast             ( m08_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(8 + 1) * HBM_AWIDTH - 1 : 8 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[8]),
  .read_stage_full                  (HBM_controller_read_full[8]),
  .controller_send_edge             (HBM_controller_edge[(8 + 1) * HBM_DWIDTH - 1 : 8 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[8]),
  .controller_recv_update_data      (WR_BACK_bfs_res[8]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[8]),
  .write_stage_full                 (HBM_controller_write_full[8]),
  .write_stage_empty                (ap_done_i[8])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M09_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M09_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m09_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi09_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m09_axi_awvalid         ),
  .m_axi_awready           ( m09_axi_awready         ),
  .m_axi_awaddr            ( m09_axi_awaddr          ),
  .m_axi_awlen             ( m09_axi_awlen           ),
  .m_axi_wvalid            ( m09_axi_wvalid          ),
  .m_axi_wready            ( m09_axi_wready          ),
  .m_axi_wdata             ( m09_axi_wdata           ),
  .m_axi_wstrb             ( m09_axi_wstrb           ),
  .m_axi_wlast             ( m09_axi_wlast           ),
  .m_axi_bvalid            ( m09_axi_bvalid          ),
  .m_axi_bready            ( m09_axi_bready          ),
  .m_axi_arvalid           ( m09_axi_arvalid         ),
  .m_axi_arready           ( m09_axi_arready         ),
  .m_axi_araddr            ( m09_axi_araddr          ),
  .m_axi_arlen             ( m09_axi_arlen           ),
  .m_axi_rvalid            ( m09_axi_rvalid          ),
  .m_axi_rready            ( m09_axi_rready          ),
  .m_axi_rdata             ( m09_axi_rdata           ),
  .m_axi_rlast             ( m09_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(9 + 1) * HBM_AWIDTH - 1 : 9 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[9]),
  .read_stage_full                  (HBM_controller_read_full[9]),
  .controller_send_edge             (HBM_controller_edge[(9 + 1) * HBM_DWIDTH - 1 : 9 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[9]),
  .controller_recv_update_data      (WR_BACK_bfs_res[9]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[9]),
  .write_stage_full                 (HBM_controller_write_full[9]),
  .write_stage_empty                (ap_done_i[9])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M10_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M10_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m10_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi10_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m10_axi_awvalid         ),
  .m_axi_awready           ( m10_axi_awready         ),
  .m_axi_awaddr            ( m10_axi_awaddr          ),
  .m_axi_awlen             ( m10_axi_awlen           ),
  .m_axi_wvalid            ( m10_axi_wvalid          ),
  .m_axi_wready            ( m10_axi_wready          ),
  .m_axi_wdata             ( m10_axi_wdata           ),
  .m_axi_wstrb             ( m10_axi_wstrb           ),
  .m_axi_wlast             ( m10_axi_wlast           ),
  .m_axi_bvalid            ( m10_axi_bvalid          ),
  .m_axi_bready            ( m10_axi_bready          ),
  .m_axi_arvalid           ( m10_axi_arvalid         ),
  .m_axi_arready           ( m10_axi_arready         ),
  .m_axi_araddr            ( m10_axi_araddr          ),
  .m_axi_arlen             ( m10_axi_arlen           ),
  .m_axi_rvalid            ( m10_axi_rvalid          ),
  .m_axi_rready            ( m10_axi_rready          ),
  .m_axi_rdata             ( m10_axi_rdata           ),
  .m_axi_rlast             ( m10_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(10 + 1) * HBM_AWIDTH - 1 : 10 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[10]),
  .read_stage_full                  (HBM_controller_read_full[10]),
  .controller_send_edge             (HBM_controller_edge[(10 + 1) * HBM_DWIDTH - 1 : 10 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[10]),
  .controller_recv_update_data      (WR_BACK_bfs_res[10]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[10]),
  .write_stage_full                 (HBM_controller_write_full[10]),
  .write_stage_empty                (ap_done_i[10])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M11_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M11_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m11_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi11_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m11_axi_awvalid         ),
  .m_axi_awready           ( m11_axi_awready         ),
  .m_axi_awaddr            ( m11_axi_awaddr          ),
  .m_axi_awlen             ( m11_axi_awlen           ),
  .m_axi_wvalid            ( m11_axi_wvalid          ),
  .m_axi_wready            ( m11_axi_wready          ),
  .m_axi_wdata             ( m11_axi_wdata           ),
  .m_axi_wstrb             ( m11_axi_wstrb           ),
  .m_axi_wlast             ( m11_axi_wlast           ),
  .m_axi_bvalid            ( m11_axi_bvalid          ),
  .m_axi_bready            ( m11_axi_bready          ),
  .m_axi_arvalid           ( m11_axi_arvalid         ),
  .m_axi_arready           ( m11_axi_arready         ),
  .m_axi_araddr            ( m11_axi_araddr          ),
  .m_axi_arlen             ( m11_axi_arlen           ),
  .m_axi_rvalid            ( m11_axi_rvalid          ),
  .m_axi_rready            ( m11_axi_rready          ),
  .m_axi_rdata             ( m11_axi_rdata           ),
  .m_axi_rlast             ( m11_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(11 + 1) * HBM_AWIDTH - 1 : 11 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[11]),
  .read_stage_full                  (HBM_controller_read_full[11]),
  .controller_send_edge             (HBM_controller_edge[(11 + 1) * HBM_DWIDTH - 1 : 11 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[11]),
  .controller_recv_update_data      (WR_BACK_bfs_res[11]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[11]),
  .write_stage_full                 (HBM_controller_write_full[11]),
  .write_stage_empty                (ap_done_i[11])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M12_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M12_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m12_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi12_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m12_axi_awvalid         ),
  .m_axi_awready           ( m12_axi_awready         ),
  .m_axi_awaddr            ( m12_axi_awaddr          ),
  .m_axi_awlen             ( m12_axi_awlen           ),
  .m_axi_wvalid            ( m12_axi_wvalid          ),
  .m_axi_wready            ( m12_axi_wready          ),
  .m_axi_wdata             ( m12_axi_wdata           ),
  .m_axi_wstrb             ( m12_axi_wstrb           ),
  .m_axi_wlast             ( m12_axi_wlast           ),
  .m_axi_bvalid            ( m12_axi_bvalid          ),
  .m_axi_bready            ( m12_axi_bready          ),
  .m_axi_arvalid           ( m12_axi_arvalid         ),
  .m_axi_arready           ( m12_axi_arready         ),
  .m_axi_araddr            ( m12_axi_araddr          ),
  .m_axi_arlen             ( m12_axi_arlen           ),
  .m_axi_rvalid            ( m12_axi_rvalid          ),
  .m_axi_rready            ( m12_axi_rready          ),
  .m_axi_rdata             ( m12_axi_rdata           ),
  .m_axi_rlast             ( m12_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(12 + 1) * HBM_AWIDTH - 1 : 12 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[12]),
  .read_stage_full                  (HBM_controller_read_full[12]),
  .controller_send_edge             (HBM_controller_edge[(12 + 1) * HBM_DWIDTH - 1 : 12 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[12]),
  .controller_recv_update_data      (WR_BACK_bfs_res[12]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[12]),
  .write_stage_full                 (HBM_controller_write_full[12]),
  .write_stage_empty                (ap_done_i[12])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M13_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M13_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m13_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi13_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m13_axi_awvalid         ),
  .m_axi_awready           ( m13_axi_awready         ),
  .m_axi_awaddr            ( m13_axi_awaddr          ),
  .m_axi_awlen             ( m13_axi_awlen           ),
  .m_axi_wvalid            ( m13_axi_wvalid          ),
  .m_axi_wready            ( m13_axi_wready          ),
  .m_axi_wdata             ( m13_axi_wdata           ),
  .m_axi_wstrb             ( m13_axi_wstrb           ),
  .m_axi_wlast             ( m13_axi_wlast           ),
  .m_axi_bvalid            ( m13_axi_bvalid          ),
  .m_axi_bready            ( m13_axi_bready          ),
  .m_axi_arvalid           ( m13_axi_arvalid         ),
  .m_axi_arready           ( m13_axi_arready         ),
  .m_axi_araddr            ( m13_axi_araddr          ),
  .m_axi_arlen             ( m13_axi_arlen           ),
  .m_axi_rvalid            ( m13_axi_rvalid          ),
  .m_axi_rready            ( m13_axi_rready          ),
  .m_axi_rdata             ( m13_axi_rdata           ),
  .m_axi_rlast             ( m13_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(13 + 1) * HBM_AWIDTH - 1 : 13 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[13]),
  .read_stage_full                  (HBM_controller_read_full[13]),
  .controller_send_edge             (HBM_controller_edge[(13 + 1) * HBM_DWIDTH - 1 : 13 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[13]),
  .controller_recv_update_data      (WR_BACK_bfs_res[13]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[13]),
  .write_stage_full                 (HBM_controller_write_full[13]),
  .write_stage_empty                (ap_done_i[13])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M14_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M14_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m14_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi14_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m14_axi_awvalid         ),
  .m_axi_awready           ( m14_axi_awready         ),
  .m_axi_awaddr            ( m14_axi_awaddr          ),
  .m_axi_awlen             ( m14_axi_awlen           ),
  .m_axi_wvalid            ( m14_axi_wvalid          ),
  .m_axi_wready            ( m14_axi_wready          ),
  .m_axi_wdata             ( m14_axi_wdata           ),
  .m_axi_wstrb             ( m14_axi_wstrb           ),
  .m_axi_wlast             ( m14_axi_wlast           ),
  .m_axi_bvalid            ( m14_axi_bvalid          ),
  .m_axi_bready            ( m14_axi_bready          ),
  .m_axi_arvalid           ( m14_axi_arvalid         ),
  .m_axi_arready           ( m14_axi_arready         ),
  .m_axi_araddr            ( m14_axi_araddr          ),
  .m_axi_arlen             ( m14_axi_arlen           ),
  .m_axi_rvalid            ( m14_axi_rvalid          ),
  .m_axi_rready            ( m14_axi_rready          ),
  .m_axi_rdata             ( m14_axi_rdata           ),
  .m_axi_rlast             ( m14_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(14 + 1) * HBM_AWIDTH - 1 : 14 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[14]),
  .read_stage_full                  (HBM_controller_read_full[14]),
  .controller_send_edge             (HBM_controller_edge[(14 + 1) * HBM_DWIDTH - 1 : 14 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[14]),
  .controller_recv_update_data      (WR_BACK_bfs_res[14]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[14]),
  .write_stage_full                 (HBM_controller_write_full[14]),
  .write_stage_empty                (ap_done_i[14])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M15_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M15_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m15_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi15_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m15_axi_awvalid         ),
  .m_axi_awready           ( m15_axi_awready         ),
  .m_axi_awaddr            ( m15_axi_awaddr          ),
  .m_axi_awlen             ( m15_axi_awlen           ),
  .m_axi_wvalid            ( m15_axi_wvalid          ),
  .m_axi_wready            ( m15_axi_wready          ),
  .m_axi_wdata             ( m15_axi_wdata           ),
  .m_axi_wstrb             ( m15_axi_wstrb           ),
  .m_axi_wlast             ( m15_axi_wlast           ),
  .m_axi_bvalid            ( m15_axi_bvalid          ),
  .m_axi_bready            ( m15_axi_bready          ),
  .m_axi_arvalid           ( m15_axi_arvalid         ),
  .m_axi_arready           ( m15_axi_arready         ),
  .m_axi_araddr            ( m15_axi_araddr          ),
  .m_axi_arlen             ( m15_axi_arlen           ),
  .m_axi_rvalid            ( m15_axi_rvalid          ),
  .m_axi_rready            ( m15_axi_rready          ),
  .m_axi_rdata             ( m15_axi_rdata           ),
  .m_axi_rlast             ( m15_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(15 + 1) * HBM_AWIDTH - 1 : 15 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[15]),
  .read_stage_full                  (HBM_controller_read_full[15]),
  .controller_send_edge             (HBM_controller_edge[(15 + 1) * HBM_DWIDTH - 1 : 15 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[15]),
  .controller_recv_update_data      (WR_BACK_bfs_res[15]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[15]),
  .write_stage_full                 (HBM_controller_write_full[15]),
  .write_stage_empty                (ap_done_i[15])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M16_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M16_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m16_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi16_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m16_axi_awvalid         ),
  .m_axi_awready           ( m16_axi_awready         ),
  .m_axi_awaddr            ( m16_axi_awaddr          ),
  .m_axi_awlen             ( m16_axi_awlen           ),
  .m_axi_wvalid            ( m16_axi_wvalid          ),
  .m_axi_wready            ( m16_axi_wready          ),
  .m_axi_wdata             ( m16_axi_wdata           ),
  .m_axi_wstrb             ( m16_axi_wstrb           ),
  .m_axi_wlast             ( m16_axi_wlast           ),
  .m_axi_bvalid            ( m16_axi_bvalid          ),
  .m_axi_bready            ( m16_axi_bready          ),
  .m_axi_arvalid           ( m16_axi_arvalid         ),
  .m_axi_arready           ( m16_axi_arready         ),
  .m_axi_araddr            ( m16_axi_araddr          ),
  .m_axi_arlen             ( m16_axi_arlen           ),
  .m_axi_rvalid            ( m16_axi_rvalid          ),
  .m_axi_rready            ( m16_axi_rready          ),
  .m_axi_rdata             ( m16_axi_rdata           ),
  .m_axi_rlast             ( m16_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(16 + 1) * HBM_AWIDTH - 1 : 16 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[16]),
  .read_stage_full                  (HBM_controller_read_full[16]),
  .controller_send_edge             (HBM_controller_edge[(16 + 1) * HBM_DWIDTH - 1 : 16 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[16]),
  .controller_recv_update_data      (WR_BACK_bfs_res[16]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[16]),
  .write_stage_full                 (HBM_controller_write_full[16]),
  .write_stage_empty                (ap_done_i[16])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M17_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M17_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m17_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi17_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m17_axi_awvalid         ),
  .m_axi_awready           ( m17_axi_awready         ),
  .m_axi_awaddr            ( m17_axi_awaddr          ),
  .m_axi_awlen             ( m17_axi_awlen           ),
  .m_axi_wvalid            ( m17_axi_wvalid          ),
  .m_axi_wready            ( m17_axi_wready          ),
  .m_axi_wdata             ( m17_axi_wdata           ),
  .m_axi_wstrb             ( m17_axi_wstrb           ),
  .m_axi_wlast             ( m17_axi_wlast           ),
  .m_axi_bvalid            ( m17_axi_bvalid          ),
  .m_axi_bready            ( m17_axi_bready          ),
  .m_axi_arvalid           ( m17_axi_arvalid         ),
  .m_axi_arready           ( m17_axi_arready         ),
  .m_axi_araddr            ( m17_axi_araddr          ),
  .m_axi_arlen             ( m17_axi_arlen           ),
  .m_axi_rvalid            ( m17_axi_rvalid          ),
  .m_axi_rready            ( m17_axi_rready          ),
  .m_axi_rdata             ( m17_axi_rdata           ),
  .m_axi_rlast             ( m17_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(17 + 1) * HBM_AWIDTH - 1 : 17 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[17]),
  .read_stage_full                  (HBM_controller_read_full[17]),
  .controller_send_edge             (HBM_controller_edge[(17 + 1) * HBM_DWIDTH - 1 : 17 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[17]),
  .controller_recv_update_data      (WR_BACK_bfs_res[17]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[17]),
  .write_stage_full                 (HBM_controller_write_full[17]),
  .write_stage_empty                (ap_done_i[17])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M18_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M18_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m18_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi18_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m18_axi_awvalid         ),
  .m_axi_awready           ( m18_axi_awready         ),
  .m_axi_awaddr            ( m18_axi_awaddr          ),
  .m_axi_awlen             ( m18_axi_awlen           ),
  .m_axi_wvalid            ( m18_axi_wvalid          ),
  .m_axi_wready            ( m18_axi_wready          ),
  .m_axi_wdata             ( m18_axi_wdata           ),
  .m_axi_wstrb             ( m18_axi_wstrb           ),
  .m_axi_wlast             ( m18_axi_wlast           ),
  .m_axi_bvalid            ( m18_axi_bvalid          ),
  .m_axi_bready            ( m18_axi_bready          ),
  .m_axi_arvalid           ( m18_axi_arvalid         ),
  .m_axi_arready           ( m18_axi_arready         ),
  .m_axi_araddr            ( m18_axi_araddr          ),
  .m_axi_arlen             ( m18_axi_arlen           ),
  .m_axi_rvalid            ( m18_axi_rvalid          ),
  .m_axi_rready            ( m18_axi_rready          ),
  .m_axi_rdata             ( m18_axi_rdata           ),
  .m_axi_rlast             ( m18_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(18 + 1) * HBM_AWIDTH - 1 : 18 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[18]),
  .read_stage_full                  (HBM_controller_read_full[18]),
  .controller_send_edge             (HBM_controller_edge[(18 + 1) * HBM_DWIDTH - 1 : 18 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[18]),
  .controller_recv_update_data      (WR_BACK_bfs_res[18]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[18]),
  .write_stage_full                 (HBM_controller_write_full[18]),
  .write_stage_empty                (ap_done_i[18])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M19_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M19_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m19_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi19_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m19_axi_awvalid         ),
  .m_axi_awready           ( m19_axi_awready         ),
  .m_axi_awaddr            ( m19_axi_awaddr          ),
  .m_axi_awlen             ( m19_axi_awlen           ),
  .m_axi_wvalid            ( m19_axi_wvalid          ),
  .m_axi_wready            ( m19_axi_wready          ),
  .m_axi_wdata             ( m19_axi_wdata           ),
  .m_axi_wstrb             ( m19_axi_wstrb           ),
  .m_axi_wlast             ( m19_axi_wlast           ),
  .m_axi_bvalid            ( m19_axi_bvalid          ),
  .m_axi_bready            ( m19_axi_bready          ),
  .m_axi_arvalid           ( m19_axi_arvalid         ),
  .m_axi_arready           ( m19_axi_arready         ),
  .m_axi_araddr            ( m19_axi_araddr          ),
  .m_axi_arlen             ( m19_axi_arlen           ),
  .m_axi_rvalid            ( m19_axi_rvalid          ),
  .m_axi_rready            ( m19_axi_rready          ),
  .m_axi_rdata             ( m19_axi_rdata           ),
  .m_axi_rlast             ( m19_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(19 + 1) * HBM_AWIDTH - 1 : 19 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[19]),
  .read_stage_full                  (HBM_controller_read_full[19]),
  .controller_send_edge             (HBM_controller_edge[(19 + 1) * HBM_DWIDTH - 1 : 19 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[19]),
  .controller_recv_update_data      (WR_BACK_bfs_res[19]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[19]),
  .write_stage_full                 (HBM_controller_write_full[19]),
  .write_stage_empty                (ap_done_i[19])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M20_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M20_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m20_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi20_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m20_axi_awvalid         ),
  .m_axi_awready           ( m20_axi_awready         ),
  .m_axi_awaddr            ( m20_axi_awaddr          ),
  .m_axi_awlen             ( m20_axi_awlen           ),
  .m_axi_wvalid            ( m20_axi_wvalid          ),
  .m_axi_wready            ( m20_axi_wready          ),
  .m_axi_wdata             ( m20_axi_wdata           ),
  .m_axi_wstrb             ( m20_axi_wstrb           ),
  .m_axi_wlast             ( m20_axi_wlast           ),
  .m_axi_bvalid            ( m20_axi_bvalid          ),
  .m_axi_bready            ( m20_axi_bready          ),
  .m_axi_arvalid           ( m20_axi_arvalid         ),
  .m_axi_arready           ( m20_axi_arready         ),
  .m_axi_araddr            ( m20_axi_araddr          ),
  .m_axi_arlen             ( m20_axi_arlen           ),
  .m_axi_rvalid            ( m20_axi_rvalid          ),
  .m_axi_rready            ( m20_axi_rready          ),
  .m_axi_rdata             ( m20_axi_rdata           ),
  .m_axi_rlast             ( m20_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(20 + 1) * HBM_AWIDTH - 1 : 20 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[20]),
  .read_stage_full                  (HBM_controller_read_full[20]),
  .controller_send_edge             (HBM_controller_edge[(20 + 1) * HBM_DWIDTH - 1 : 20 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[20]),
  .controller_recv_update_data      (WR_BACK_bfs_res[20]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[20]),
  .write_stage_full                 (HBM_controller_write_full[20]),
  .write_stage_empty                (ap_done_i[20])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M21_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M21_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m21_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi21_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m21_axi_awvalid         ),
  .m_axi_awready           ( m21_axi_awready         ),
  .m_axi_awaddr            ( m21_axi_awaddr          ),
  .m_axi_awlen             ( m21_axi_awlen           ),
  .m_axi_wvalid            ( m21_axi_wvalid          ),
  .m_axi_wready            ( m21_axi_wready          ),
  .m_axi_wdata             ( m21_axi_wdata           ),
  .m_axi_wstrb             ( m21_axi_wstrb           ),
  .m_axi_wlast             ( m21_axi_wlast           ),
  .m_axi_bvalid            ( m21_axi_bvalid          ),
  .m_axi_bready            ( m21_axi_bready          ),
  .m_axi_arvalid           ( m21_axi_arvalid         ),
  .m_axi_arready           ( m21_axi_arready         ),
  .m_axi_araddr            ( m21_axi_araddr          ),
  .m_axi_arlen             ( m21_axi_arlen           ),
  .m_axi_rvalid            ( m21_axi_rvalid          ),
  .m_axi_rready            ( m21_axi_rready          ),
  .m_axi_rdata             ( m21_axi_rdata           ),
  .m_axi_rlast             ( m21_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(21 + 1) * HBM_AWIDTH - 1 : 21 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[21]),
  .read_stage_full                  (HBM_controller_read_full[21]),
  .controller_send_edge             (HBM_controller_edge[(21 + 1) * HBM_DWIDTH - 1 : 21 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[21]),
  .controller_recv_update_data      (WR_BACK_bfs_res[21]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[21]),
  .write_stage_full                 (HBM_controller_write_full[21]),
  .write_stage_empty                (ap_done_i[21])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M22_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M22_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m22_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi22_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m22_axi_awvalid         ),
  .m_axi_awready           ( m22_axi_awready         ),
  .m_axi_awaddr            ( m22_axi_awaddr          ),
  .m_axi_awlen             ( m22_axi_awlen           ),
  .m_axi_wvalid            ( m22_axi_wvalid          ),
  .m_axi_wready            ( m22_axi_wready          ),
  .m_axi_wdata             ( m22_axi_wdata           ),
  .m_axi_wstrb             ( m22_axi_wstrb           ),
  .m_axi_wlast             ( m22_axi_wlast           ),
  .m_axi_bvalid            ( m22_axi_bvalid          ),
  .m_axi_bready            ( m22_axi_bready          ),
  .m_axi_arvalid           ( m22_axi_arvalid         ),
  .m_axi_arready           ( m22_axi_arready         ),
  .m_axi_araddr            ( m22_axi_araddr          ),
  .m_axi_arlen             ( m22_axi_arlen           ),
  .m_axi_rvalid            ( m22_axi_rvalid          ),
  .m_axi_rready            ( m22_axi_rready          ),
  .m_axi_rdata             ( m22_axi_rdata           ),
  .m_axi_rlast             ( m22_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(22 + 1) * HBM_AWIDTH - 1 : 22 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[22]),
  .read_stage_full                  (HBM_controller_read_full[22]),
  .controller_send_edge             (HBM_controller_edge[(22 + 1) * HBM_DWIDTH - 1 : 22 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[22]),
  .controller_recv_update_data      (WR_BACK_bfs_res[22]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[22]),
  .write_stage_full                 (HBM_controller_write_full[22]),
  .write_stage_empty                (ap_done_i[22])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M23_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M23_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m23_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi23_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m23_axi_awvalid         ),
  .m_axi_awready           ( m23_axi_awready         ),
  .m_axi_awaddr            ( m23_axi_awaddr          ),
  .m_axi_awlen             ( m23_axi_awlen           ),
  .m_axi_wvalid            ( m23_axi_wvalid          ),
  .m_axi_wready            ( m23_axi_wready          ),
  .m_axi_wdata             ( m23_axi_wdata           ),
  .m_axi_wstrb             ( m23_axi_wstrb           ),
  .m_axi_wlast             ( m23_axi_wlast           ),
  .m_axi_bvalid            ( m23_axi_bvalid          ),
  .m_axi_bready            ( m23_axi_bready          ),
  .m_axi_arvalid           ( m23_axi_arvalid         ),
  .m_axi_arready           ( m23_axi_arready         ),
  .m_axi_araddr            ( m23_axi_araddr          ),
  .m_axi_arlen             ( m23_axi_arlen           ),
  .m_axi_rvalid            ( m23_axi_rvalid          ),
  .m_axi_rready            ( m23_axi_rready          ),
  .m_axi_rdata             ( m23_axi_rdata           ),
  .m_axi_rlast             ( m23_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(23 + 1) * HBM_AWIDTH - 1 : 23 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[23]),
  .read_stage_full                  (HBM_controller_read_full[23]),
  .controller_send_edge             (HBM_controller_edge[(23 + 1) * HBM_DWIDTH - 1 : 23 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[23]),
  .controller_recv_update_data      (WR_BACK_bfs_res[23]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[23]),
  .write_stage_full                 (HBM_controller_write_full[23]),
  .write_stage_empty                (ap_done_i[23])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M24_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M24_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m24_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi24_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m24_axi_awvalid         ),
  .m_axi_awready           ( m24_axi_awready         ),
  .m_axi_awaddr            ( m24_axi_awaddr          ),
  .m_axi_awlen             ( m24_axi_awlen           ),
  .m_axi_wvalid            ( m24_axi_wvalid          ),
  .m_axi_wready            ( m24_axi_wready          ),
  .m_axi_wdata             ( m24_axi_wdata           ),
  .m_axi_wstrb             ( m24_axi_wstrb           ),
  .m_axi_wlast             ( m24_axi_wlast           ),
  .m_axi_bvalid            ( m24_axi_bvalid          ),
  .m_axi_bready            ( m24_axi_bready          ),
  .m_axi_arvalid           ( m24_axi_arvalid         ),
  .m_axi_arready           ( m24_axi_arready         ),
  .m_axi_araddr            ( m24_axi_araddr          ),
  .m_axi_arlen             ( m24_axi_arlen           ),
  .m_axi_rvalid            ( m24_axi_rvalid          ),
  .m_axi_rready            ( m24_axi_rready          ),
  .m_axi_rdata             ( m24_axi_rdata           ),
  .m_axi_rlast             ( m24_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(24 + 1) * HBM_AWIDTH - 1 : 24 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[24]),
  .read_stage_full                  (HBM_controller_read_full[24]),
  .controller_send_edge             (HBM_controller_edge[(24 + 1) * HBM_DWIDTH - 1 : 24 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[24]),
  .controller_recv_update_data      (WR_BACK_bfs_res[24]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[24]),
  .write_stage_full                 (HBM_controller_write_full[24]),  
  .write_stage_empty                (ap_done_i[24])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M25_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M25_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m25_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi25_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m25_axi_awvalid         ),
  .m_axi_awready           ( m25_axi_awready         ),
  .m_axi_awaddr            ( m25_axi_awaddr          ),
  .m_axi_awlen             ( m25_axi_awlen           ),
  .m_axi_wvalid            ( m25_axi_wvalid          ),
  .m_axi_wready            ( m25_axi_wready          ),
  .m_axi_wdata             ( m25_axi_wdata           ),
  .m_axi_wstrb             ( m25_axi_wstrb           ),
  .m_axi_wlast             ( m25_axi_wlast           ),
  .m_axi_bvalid            ( m25_axi_bvalid          ),
  .m_axi_bready            ( m25_axi_bready          ),
  .m_axi_arvalid           ( m25_axi_arvalid         ),
  .m_axi_arready           ( m25_axi_arready         ),
  .m_axi_araddr            ( m25_axi_araddr          ),
  .m_axi_arlen             ( m25_axi_arlen           ),
  .m_axi_rvalid            ( m25_axi_rvalid          ),
  .m_axi_rready            ( m25_axi_rready          ),
  .m_axi_rdata             ( m25_axi_rdata           ),
  .m_axi_rlast             ( m25_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(25 + 1) * HBM_AWIDTH - 1 : 25 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[25]),
  .read_stage_full                  (HBM_controller_read_full[25]),
  .controller_send_edge             (HBM_controller_edge[(25 + 1) * HBM_DWIDTH - 1 : 25 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[25]),
  .controller_recv_update_data      (WR_BACK_bfs_res[25]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[25]),
  .write_stage_full                 (HBM_controller_write_full[25]),
  .write_stage_empty                (ap_done_i[25])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M26_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M26_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m26_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi26_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m26_axi_awvalid         ),
  .m_axi_awready           ( m26_axi_awready         ),
  .m_axi_awaddr            ( m26_axi_awaddr          ),
  .m_axi_awlen             ( m26_axi_awlen           ),
  .m_axi_wvalid            ( m26_axi_wvalid          ),
  .m_axi_wready            ( m26_axi_wready          ),
  .m_axi_wdata             ( m26_axi_wdata           ),
  .m_axi_wstrb             ( m26_axi_wstrb           ),
  .m_axi_wlast             ( m26_axi_wlast           ),
  .m_axi_bvalid            ( m26_axi_bvalid          ),
  .m_axi_bready            ( m26_axi_bready          ),
  .m_axi_arvalid           ( m26_axi_arvalid         ),
  .m_axi_arready           ( m26_axi_arready         ),
  .m_axi_araddr            ( m26_axi_araddr          ),
  .m_axi_arlen             ( m26_axi_arlen           ),
  .m_axi_rvalid            ( m26_axi_rvalid          ),
  .m_axi_rready            ( m26_axi_rready          ),
  .m_axi_rdata             ( m26_axi_rdata           ),
  .m_axi_rlast             ( m26_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(26 + 1) * HBM_AWIDTH - 1 : 26 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[26]),
  .read_stage_full                  (HBM_controller_read_full[26]),
  .controller_send_edge             (HBM_controller_edge[(26 + 1) * HBM_DWIDTH - 1 : 26 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[26]),
  .controller_recv_update_data      (WR_BACK_bfs_res[26]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[26]),
  .write_stage_full                 (HBM_controller_write_full[26]),
  .write_stage_empty                (ap_done_i[26])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M27_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M27_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m27_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi27_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m27_axi_awvalid         ),
  .m_axi_awready           ( m27_axi_awready         ),
  .m_axi_awaddr            ( m27_axi_awaddr          ),
  .m_axi_awlen             ( m27_axi_awlen           ),
  .m_axi_wvalid            ( m27_axi_wvalid          ),
  .m_axi_wready            ( m27_axi_wready          ),
  .m_axi_wdata             ( m27_axi_wdata           ),
  .m_axi_wstrb             ( m27_axi_wstrb           ),
  .m_axi_wlast             ( m27_axi_wlast           ),
  .m_axi_bvalid            ( m27_axi_bvalid          ),
  .m_axi_bready            ( m27_axi_bready          ),
  .m_axi_arvalid           ( m27_axi_arvalid         ),
  .m_axi_arready           ( m27_axi_arready         ),
  .m_axi_araddr            ( m27_axi_araddr          ),
  .m_axi_arlen             ( m27_axi_arlen           ),
  .m_axi_rvalid            ( m27_axi_rvalid          ),
  .m_axi_rready            ( m27_axi_rready          ),
  .m_axi_rdata             ( m27_axi_rdata           ),
  .m_axi_rlast             ( m27_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(27 + 1) * HBM_AWIDTH - 1 : 27 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[27]),
  .read_stage_full                  (HBM_controller_read_full[27]),
  .controller_send_edge             (HBM_controller_edge[(27 + 1) * HBM_DWIDTH - 1 : 27 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[27]),
  .controller_recv_update_data      (WR_BACK_bfs_res[27]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[27]),
  .write_stage_full                 (HBM_controller_write_full[27]),
  .write_stage_empty                (ap_done_i[27])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M28_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M28_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m28_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi28_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m28_axi_awvalid         ),
  .m_axi_awready           ( m28_axi_awready         ),
  .m_axi_awaddr            ( m28_axi_awaddr          ),
  .m_axi_awlen             ( m28_axi_awlen           ),
  .m_axi_wvalid            ( m28_axi_wvalid          ),
  .m_axi_wready            ( m28_axi_wready          ),
  .m_axi_wdata             ( m28_axi_wdata           ),
  .m_axi_wstrb             ( m28_axi_wstrb           ),
  .m_axi_wlast             ( m28_axi_wlast           ),
  .m_axi_bvalid            ( m28_axi_bvalid          ),
  .m_axi_bready            ( m28_axi_bready          ),
  .m_axi_arvalid           ( m28_axi_arvalid         ),
  .m_axi_arready           ( m28_axi_arready         ),
  .m_axi_araddr            ( m28_axi_araddr          ),
  .m_axi_arlen             ( m28_axi_arlen           ),
  .m_axi_rvalid            ( m28_axi_rvalid          ),
  .m_axi_rready            ( m28_axi_rready          ),
  .m_axi_rdata             ( m28_axi_rdata           ),
  .m_axi_rlast             ( m28_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(28 + 1) * HBM_AWIDTH - 1 : 28 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[28]),
  .read_stage_full                  (HBM_controller_read_full[28]),
  .controller_send_edge             (HBM_controller_edge[(28 + 1) * HBM_DWIDTH - 1 : 28 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[28]),
  .controller_recv_update_data      (WR_BACK_bfs_res[28]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[28]),
  .write_stage_full                 (HBM_controller_write_full[28]),
  .write_stage_empty                (ap_done_i[28])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M29_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M29_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m29_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi29_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m29_axi_awvalid         ),
  .m_axi_awready           ( m29_axi_awready         ),
  .m_axi_awaddr            ( m29_axi_awaddr          ),
  .m_axi_awlen             ( m29_axi_awlen           ),
  .m_axi_wvalid            ( m29_axi_wvalid          ),
  .m_axi_wready            ( m29_axi_wready          ),
  .m_axi_wdata             ( m29_axi_wdata           ),
  .m_axi_wstrb             ( m29_axi_wstrb           ),
  .m_axi_wlast             ( m29_axi_wlast           ),
  .m_axi_bvalid            ( m29_axi_bvalid          ),
  .m_axi_bready            ( m29_axi_bready          ),
  .m_axi_arvalid           ( m29_axi_arvalid         ),
  .m_axi_arready           ( m29_axi_arready         ),
  .m_axi_araddr            ( m29_axi_araddr          ),
  .m_axi_arlen             ( m29_axi_arlen           ),
  .m_axi_rvalid            ( m29_axi_rvalid          ),
  .m_axi_rready            ( m29_axi_rready          ),
  .m_axi_rdata             ( m29_axi_rdata           ),
  .m_axi_rlast             ( m29_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(29 + 1) * HBM_AWIDTH - 1 : 29 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[29]),
  .read_stage_full                  (HBM_controller_read_full[29]),
  .controller_send_edge             (HBM_controller_edge[(29 + 1) * HBM_DWIDTH - 1 : 29 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[29]),
  .controller_recv_update_data      (WR_BACK_bfs_res[29]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[29]),
  .write_stage_full                 (HBM_controller_write_full[29]),
  .write_stage_empty                (ap_done_i[29])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M30_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M30_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m30_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi30_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m30_axi_awvalid         ),
  .m_axi_awready           ( m30_axi_awready         ),
  .m_axi_awaddr            ( m30_axi_awaddr          ),
  .m_axi_awlen             ( m30_axi_awlen           ),
  .m_axi_wvalid            ( m30_axi_wvalid          ),
  .m_axi_wready            ( m30_axi_wready          ),
  .m_axi_wdata             ( m30_axi_wdata           ),
  .m_axi_wstrb             ( m30_axi_wstrb           ),
  .m_axi_wlast             ( m30_axi_wlast           ),
  .m_axi_bvalid            ( m30_axi_bvalid          ),
  .m_axi_bready            ( m30_axi_bready          ),
  .m_axi_arvalid           ( m30_axi_arvalid         ),
  .m_axi_arready           ( m30_axi_arready         ),
  .m_axi_araddr            ( m30_axi_araddr          ),
  .m_axi_arlen             ( m30_axi_arlen           ),
  .m_axi_rvalid            ( m30_axi_rvalid          ),
  .m_axi_rready            ( m30_axi_rready          ),
  .m_axi_rdata             ( m30_axi_rdata           ),
  .m_axi_rlast             ( m30_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(30 + 1) * HBM_AWIDTH - 1 : 30 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[30]),
  .read_stage_full                  (HBM_controller_read_full[30]),
  .controller_send_edge             (HBM_controller_edge[(30 + 1) * HBM_DWIDTH - 1 : 30 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[30]),
  .controller_recv_update_data      (WR_BACK_bfs_res[30]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[30]),
  .write_stage_full                 (HBM_controller_write_full[30]),
  .write_stage_empty                (ap_done_i[30])
);

hbm_channel_controller #(
  .C_M_AXI_ADDR_WIDTH ( C_M31_AXI_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M31_AXI_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                   )
)
hbm_channel_controller_inst_m31_axi (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi31_ptr0              ),
  .ctrl_constant           ( ctrl_constant           ),
  .ap_start                ( ap_start_pulse          ),
  .m_axi_awvalid           ( m31_axi_awvalid         ),
  .m_axi_awready           ( m31_axi_awready         ),
  .m_axi_awaddr            ( m31_axi_awaddr          ),
  .m_axi_awlen             ( m31_axi_awlen           ),
  .m_axi_wvalid            ( m31_axi_wvalid          ),
  .m_axi_wready            ( m31_axi_wready          ),
  .m_axi_wdata             ( m31_axi_wdata           ),
  .m_axi_wstrb             ( m31_axi_wstrb           ),
  .m_axi_wlast             ( m31_axi_wlast           ),
  .m_axi_bvalid            ( m31_axi_bvalid          ),
  .m_axi_bready            ( m31_axi_bready          ),
  .m_axi_arvalid           ( m31_axi_arvalid         ),
  .m_axi_arready           ( m31_axi_arready         ),
  .m_axi_araddr            ( m31_axi_araddr          ),
  .m_axi_arlen             ( m31_axi_arlen           ),
  .m_axi_rvalid            ( m31_axi_rvalid          ),
  .m_axi_rready            ( m31_axi_rready          ),
  .m_axi_rdata             ( m31_axi_rdata           ),
  .m_axi_rlast             ( m31_axi_rlast           ),
  .controller_recv_edge_addr        ({{32{1'b0}},HBM_controller_recv_addr[(31 + 1) * HBM_AWIDTH - 1 : 31 * HBM_AWIDTH]}<<6),
  .controller_recv_edge_addr_valid  (HBM_controller_addr_valid[31]),
  .read_stage_full                  (HBM_controller_read_full[31]),
  .controller_send_edge             (HBM_controller_edge[(31 + 1) * HBM_DWIDTH - 1 : 31 * HBM_DWIDTH]),
  .controller_send_edge_valid       (HBM_controller_valid[31]),
  .controller_recv_update_data      (WR_BACK_bfs_res[31]),
  .controller_recv_update_addr      (), // not use, should increment internal
  .controller_recv_update_valid     (|WR_BACK_bfs_valid[31]),
  .write_stage_full                 (HBM_controller_write_full[31]),
  .write_stage_empty                (ap_done_i[31])
);

  /*
// kernel
rd_active_vertex  RD_ACTIVE_VERTEX (
  .clk                (clk),
  .rst                (rst),
  .root_id            (root_id),
  .backend_active_v_id        (P8_active_v_id),
  .backend_active_v_updated   (P8_active_v_updated),
  .backend_active_v_pull_first_flag (P8_active_v_pull_first_flag),
  .backend_active_v_id_valid  (P8_active_v_valid),
  .backend_iteration_end      (P8_iteration_end),
  .backend_iteration_end_valid(P8_iteration_end_valid),
  .next_stage_full            (P2_stage_full),

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
*/
  generate
    for (i = 0; i < CORE_NUM; i = i + 1) begin
      always @ (posedge clk) begin
        P1_next_rst[i] <= rst;
      end
      rd_active_vertex_single #(.CORE_ID(i)) RD_ACTIVE_VERTEX_SINGLE (
        .clk                    (clk),
        .rst                    (rst),
        .root_id                (root_id),
        .backend_active_v_id    (P8_active_v_id[i]),
        .backend_active_v_updated   (P8_active_v_updated[i]),
        .backend_active_v_pull_first_flag   (P8_active_v_pull_first_flag[i]),
        .backend_active_v_id_valid  (P8_active_v_valid[i]),
        .backend_iteration_end      (P8_iteration_end[i]),
        .backend_iteration_end_valid    (P8_iteration_end_valid[i]),
        .next_stage_full            (P2_stage_full[i]),

        .iteration_done             (P1_iteration_done[i]),
        .push_flag                  (P1_push_flag[i]),
        .active_v_id                (P1_active_v_id[i]),
        .active_v_value             (P1_active_v_value[i]),
        .active_v_pull_first_flag   (P1_active_v_pull_first_flag[i]),
        .active_v_id_valid          (P1_active_v_valid[i]),
        .iteration_end              (P1_iteration_end[i]),
        .iteration_end_valid        (P1_iteration_end_valid[i]),
        .global_iteration_id        (P1_global_iteration_id[i])
      );
    end
  endgenerate
  assign P1_global_root_id = root_id;

rd_active_vertex_global_signal RD_ACTIVE_VERTEX_GLOBAL_SIGNAL (
  .clk                        (clk),
  .rst                        (rst),
  .backend_active_v_id        (P8_active_v_id),
  .backend_active_v_updated   (P8_active_v_updated),
  .backend_active_v_id_valid  (P8_active_v_valid),

  .global_powerlaw_v_visit    (P1_global_powerlaw_v_visit)
);

  /*
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
*/
  generate
    for (i = 0; i < CORE_NUM; i = i + 1) begin
      always @ (posedge clk) begin
        P2_next_rst[i] <= P1_next_rst[i];
      end
      rd_active_vertex_offset_single #(.CORE_ID(i)) RD_ACTIVE_VERTEX_OFFSET_SINGLE (
        .clk        (clk),
        .rst        (P1_next_rst[i]),
        .front_push_flag    (P1_push_flag[i]),
        .front_active_v_id  (P1_active_v_id[i]),
        .front_active_v_value   (P1_active_v_value[i]),
        .front_active_v_pull_first_flag (P1_active_v_pull_first_flag[i]),
        .front_active_v_valid   (P1_active_v_valid[i]),
        .front_iteration_end    (P1_iteration_end[i]),
        .front_iteration_end_valid  (P1_iteration_end_valid[i]),
        .next_stage_full        (P4_stage_full[i]),

        .stage_full             (P2_stage_full[i]),
        .push_flag              (P2_push_flag[i]),
        .active_v_id            (P2_active_v_id[i]),
        .active_v_value         (P2_active_v_value[i]),
        .rd_active_v_offset_addr    (P2_rd_active_v_offset_addr[i]),
        .active_v_pull_first_flag   (P2_active_v_pull_first_flag[i]),
        .active_v_id_valid      (P2_active_v_valid[i]),
        .iteration_end          (P2_iteration_end[i]),
        .iteration_end_valid    (P2_iteration_end_valid[i])
      );
    end
  endgenerate

global_signal_transfer P2_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (P1_next_rst[0]),
  .front_global_iteration_id  (P1_global_iteration_id),
  .front_global_powerlaw_v_visit  (P1_global_powerlaw_v_visit),
  .front_global_root_id              (P1_global_root_id),

  .global_iteration_id        (P2_global_iteration_id),
  .global_powerlaw_v_visit    (P2_global_powerlaw_v_visit),
  .global_root_id                    (P2_global_root_id)
);
/*
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
*/
  generate
    for (i = 0; i < PSEUDO_CHANNEL_NUM; i = i + 1) begin
      always @ (posedge clk) begin
        if (uram_rst) begin
          P3_hbm_controller_addr[i] <= {HBM_AWIDTH{1'b1}};
          P3_hbm_addr_valid[i] <= 0;
        end else if (HBM_controller_read_full[i] || P3_hbm_controller_addr[i] == (((1 << (VTX_NUM_WIDTH + 1)) >> CORE_NUM_WIDTH)-1)) begin
          P3_hbm_addr_valid[i] <= 0;
        end else begin
          P3_hbm_controller_addr[i] <= P3_hbm_controller_addr[i] + 1;
          P3_hbm_addr_valid[i] <= 1;
        end
      end
    end
    for (i = 0; i < CORE_NUM; i = i + 1) begin
      always @ (posedge clk) begin
        P3_next_rst[i] <= P2_next_rst[i];
      end
      offset_uram_single #(.CORE_ID(i)) OFFSET_URAM_SINGLE (
        .clk                            (clk),
        .rst                            (uram_rst),
        .hbm_controller_data            (HBM_controller_edge[i]),
        .hbm_data_valid                 (transfer_uram ? HBM_controller_valid[i >> 4] : 0),
        .front_rd_active_v_offset_addr  (P2_rd_active_v_offset_addr[i]),
        .front_active_v_valid           (P2_active_v_valid[i]),

        .transfer_complete              (P3_transfer_complete[i]),
        .uram_loffset                   (P3_active_v_loffset[i]),
        .uram_roffset                   (P3_active_v_roffset[i]),
        .uram_dvalid                    (P3_active_v_valid[i])
      );
    end
  endgenerate

assign P3_hbm_controller_addr[32 * HBM_AWIDTH -1 : 16 * HBM_AWIDTH] = 0;
assign P3_hbm_addr_valid[31:16] = 0;

  /*
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
*/

    generate
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                P4_next_rst[i] <= P2_next_rst[i];
            end
            rd_active_vertex_edge_single #(.CORE_ID(i)) RD_ACTIVE_VERTEX_EDGE_SINGLE (
                .clk                            (clk),
                .rst                            (rst[i]),
                .front_push_flag                (P2_push_flag[i]),
                .front_active_v_id              (P2_active_v_id[i]),
                .front_active_v_value           (P2_active_v_value[i]),
                .front_active_v_pull_first_flag (P2_active_v_pull_first_flag[i]),
                .front_active_v_valid           (P2_active_v_valid[i]),
                .front_active_v_loffset         (P3_active_v_loffset[i]),
                .front_active_v_roffset         (P3_active_v_roffset[i]),
                .front_offset_valid             (P3_active_v_valid[i]),
                .front_iteration_end            (P2_iteration_end[i]),
                .front_iteration_end_valid      (P2_iteration_end_valid[i]),
                .combine_stage_full             (P5_stage_full[i]),
                .bram_stage_full                (P5_2_stage_full[i]),

                .stage_full                     (P4_stage_full[i]),
                .rd_hbm_edge_addr               (P4_rd_hbm_edge_addr[i]),
                .rd_hbm_edge_mask               (P4_rd_hbm_edge_mask[i]),
                .hbm_push_flag                  (P4_hbm_push_flag[i]),
                .hbm_active_v_id                (P4_hbm_active_v_id[i]),
                .hbm_active_v_value             (P4_hbm_active_v_value[i]),
                .rd_hbm_edge_valid              (P4_rd_hbm_edge_valid[i]),
                .rd_bram_edge_addr              (P4_rd_bram_edge_addr[i]),
                .bram_push_flag                 (P4_bram_push_flag[i]),
                .bram_active_v_id               (P4_bram_active_v_id[i]),
                .bram_active_v_value            (P4_bram_active_v_value[i]),
                .rd_bram_edge_valid             (P4_rd_bram_edge_valid[i]),
                .iteration_end                  (P4_iteration_end[i]),
                .iteration_end_valid            (P4_iteration_end_valid[i])
            );
        end
    endgenerate

global_signal_transfer P4_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (P2_next_rst[0]),
  .front_global_iteration_id  (P2_global_iteration_id),
  .front_global_powerlaw_v_visit  (P2_global_powerlaw_v_visit),
  .front_global_root_id              (P2_global_root_id),

  .global_iteration_id        (P4_global_iteration_id),
  .global_powerlaw_v_visit    (P4_global_powerlaw_v_visit),
  .global_root_id                    (P4_global_root_id)
);
/*
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
*/
    generate
        for (i = 0; i < PSEUDO_CHANNEL_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                P5_next_rst[i * GROUP_CORE_NUM+: GROUP_CORE_NUM] <= P4_next_rst[i * GROUP_CORE_NUM+: GROUP_CORE_NUM];
            end
            generate_hbm_edge_rqst_single #(.CHANNEL_ID(i)) GENERATE_HBM_EDGE_RQST_SINGLE (
                .clk                    (clk),
                .rst                    (P4_next_rst[i]),
                .front_rd_hbm_edge_addr (P4_rd_hbm_edge_addr[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .front_rd_hbm_edge_mask (P4_rd_hbm_edge_mask[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .front_push_flag        (P4_hbm_push_flag[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .front_active_v_id      (P4_hbm_active_v_id[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .front_active_v_value   (P4_hbm_active_v_value[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .front_rd_hbm_edge_valid(P4_rd_hbm_edge_valid[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .front_iteration_end    (P4_iteration_end[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .front_iteration_end_valid    (P4_iteration_end_valid[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .hbm_full               (HBM_controller_read_full[i]),
                .next_stage_full        (P6_stage_full1[i]),

                .stage_full             (P5_stage_full[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .rd_hbm_edge_addr       (P5_rd_hbm_edge_addr[i]),
                .rd_hbm_edge_valid      (P5_rd_hbm_edge_valid[i]),
                .push_flag              (P5_push_flag[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .active_v_id            (P5_active_v_id[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .active_v_value         (P5_active_v_value[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .active_v_id_valid      (P5_active_v_valid[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .iteration_end          (P5_iteration_end[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .iteration_end_valid    (P5_iteration_end_valid[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM])
            );
        end
    endgenerate
global_signal_transfer P5_GLOBAL_SIGNAL_TRANSFER (
  .clk                        (clk),
  .rst                        (P4_next_rst[0]),
  .front_global_iteration_id  (P4_global_iteration_id),
  .front_global_powerlaw_v_visit  (P4_global_powerlaw_v_visit),
  .front_global_root_id              (P4_global_root_id),

  .global_iteration_id        (P5_global_iteration_id),
  .global_powerlaw_v_visit    (P5_global_powerlaw_v_visit),
  .global_root_id                    (P5_global_root_id)
);
/*
rd_first_edge_bram RD_FIRST_EDGE_BRAM (
  .clk                        (clk),
  .rst                        (P4_next_rst),
  .front_rd_edge_addr         (P4_rd_bram_edge_addr),
  .front_push_flag            (P4_bram_push_flag),
  .front_active_v_id          (P4_bram_active_v_id),
  .front_active_v_value       (P4_bram_active_v_value),
  .front_rd_edge_valid        (P4_rd_bram_edge_valid),
  .front_iteration_end        (P4_iteration_end),
  .front_iteration_end_valid  (P4_iteration_end_valid),
  .next_stage_full            (P6_stage_full2),

  .stage_full                 (P5_2_stage_full),
  .push_flag                  (P5_2_push_flag),
  .active_v_id                (P5_2_active_v_id),
  .active_v_value             (P5_2_active_v_value),
  .active_v_edge              (P5_2_active_v_edge),
  .active_v_valid             (P5_2_active_v_valid),
  .iteration_end              (P5_2_iteration_end),
  .iteration_end_valid        (P5_2_iteration_end_valid)
);
*/
    wire [FIRST_EDGE_BRAM_DWIDTH - 1 : 0] tmp_bram_data [0 : CORE_NUM - 1];
    reg [CORE_NUM - 1 : 0] tmp_bram_valid [0 : 1];

    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            rd_first_edge_bram_single RD_FIRST_EDGE_BRAM_SINGLE (
                .clk                        (clk),
                .rst                        (P4_next_rst[i]),
                .front_push_flag            (P4_bram_push_flag[i]),
                .front_active_v_id          (P4_bram_active_v_id[i]),
                .front_active_v_value       (P4_bram_active_v_value[i]),
                .front_rd_edge_valid        (P4_rd_bram_edge_valid[i]),
                .bram_data                  (tmp_bram_data[i]),
                .bram_valid                 (tmp_bram_valid[1][i]),
                .front_iteration_end        (P4_iteration_end[i]),
                .front_iteration_end_valid  (P4_iteration_end_valid[i]),
                .next_stage_full            (P6_stage_full2[i]),

                .stage_full                 (P5_2_stage_full[i]),
                .push_flag                  (P5_2_push_flag[i]),
                .active_v_id                (P5_2_active_v_id[i]),
                .active_v_value             (P5_2_active_v_value[i]),
                .active_v_edge              (P5_2_active_v_edge[i]),
                .active_v_valid             (P5_2_active_v_valid[i]),
                .iteration_end              (P5_2_iteration_end[i]),
                .iteration_end_valid        (P5_2_iteration_end_valid[i])
            );

            first_edge_rom_self #(.INIT_FILE($sformatf("/sdb/pancg/acc/data/first_edge_small_64_%0d.txt",i))) FIRST_EDGE_ROM_IP_SINGLE (
                .clka       (clk),
                .ena        (!P4_next_rst[i]),
                .addra      (P4_rd_bram_edge_addr[i]),
                .douta      (tmp_bram_data[i])
            );
        end
    endgenerate

    always @ (posedge clk) begin
        tmp_bram_valid[0] <= front_rd_edge_valid;
        tmp_bram_valid[1] <= tmp_bram_valid[0];
    end
/*
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
*/
    generate
        for (i = 0; i < PSEUDO_CHANNEL_NUM; i = i + 1) begin
            hbm_interface_send_rqst_single #(.PSEUDO_ID(i)) HBM_INTERFACE_SEND_RQST_SINGLE (
                .clk                    (clk),
                .rst                    (P5_next_rst[i]),
                .front_rd_hbm_edge_addr (P5_rd_hbm_edge_addr[i]),
                .front_rd_hbm_edge_valid(P5_rd_hbm_edge_valid[i]),
                .hbm_controller_full    (HBM_controller_read_full[i]),

                .stage_full             (HBM_interface_full[i]),
                .rd_hbm_edge_addr       (HBM_interface_rd_hbm_edge_addr[i]),
                .rd_hbm_edge_valid      (HBM_interface_rd_hbm_edge_valid[i])
            );

            hbm_interface_recv_edge_single #(.PSEUDO_ID(i)) HBM_INTERFACE_RECV_EDGE_SINGLE (
                .clk                    (clk),
                .rst                    (P5_next_rst[i]),
                .hbm_controller_edge    (HBM_controller_edge[i]),
                .hbm_controller_valid   (HBM_controller_read_full[i]),

                .active_v_edge          (HBM_interface_active_v_edge[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM]),
                .active_v_edge_valid    (HBM_interface_active_v_edge_valid[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM])
            );
        end
    endgenerate

assign HBM_interface_rd_hbm_edge_addr[32 * HBM_AWIDTH -1 : 16 * HBM_AWIDTH] = 0;
assign HBM_interface_rd_hbm_edge_valid[31:16] = 0;

    /*
scheduler SCHEDULER (
  .clk                        (clk),
  .rst                        (P5_next_rst),
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
*/
    wire [CORE_NUM - 1 : 0] local_stage_full1;

    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                P6_next_rst[i] <= P5_next_rst[i];
            end
            scheduler_single #(.CORE_ID(i)) SCHEDULER_SINGLE (
                .clk                    (clk),
                .rst                    (P5_next_rst[i]),
                .front_push_flag        (P5_push_flag[i]),
                .front_active_v_id      (P5_active_v_id[i]),
                .front_active_v_value   (P5_active_v_value[i]),
                .front_active_v_valid   (P5_active_v_valid[i]),
                .front_iteration_end    (P5_iteration_end[i]),
                .front_iteration_end_valid    (P5_iteration_end_valid[i]),
                .hbm_interface_active_v_edge    (HBM_interface_active_v_edge[i]),
                .hbm_interface_active_v_edge_valid  (HBM_interface_active_v_edge_valid[i]),
                .front2_push_flag       (P5_2_push_flag[i]),
                .front2_active_v_id     (P5_2_active_v_id[i]),
                .front2_active_v_value  (P5_2_active_v_value[i]),
                .front2_active_v_edge   (P5_2_active_v_edge[i]),
                .front2_active_v_valid  (P5_2_active_v_valid[i]),
                .front2_iteration_end   (P5_2_iteration_end[i]),
                .front2_iteration_end_valid (P5_2_iteration_end_valid[i]),
                .front_global_powerlaw_v_visit  (P5_global_powerlaw_v_visit[i]),
                .next_stage_full        (P7_source_core_full[i]),

                .stage_full1            (local_stage_full1[i]),
                .stage_full2            (P6_stage_full2[i]),
                .push_flag              (P6_push_flag[i]),
                .update_v_id            (P6_update_v_id[i]),
                .update_v_value         (P6_update_v_value[i]),
                .pull_first_flag        (P6_pull_first_flag[i]),
                .update_v_valid         (P6_update_v_valid[i]),
                .iteration_end          (P6_iteration_end[i]),
                .iteration_end_valid    (P6_iteration_end_valid[i])
            );
        end
        for (i = 0; i < PSEUDO_CHANNEL_NUM; i = i + 1) begin
            assign P6_stage_full1[i] = |local_stage_full1[(i + 1) * GROUP_CORE_NUM - 1 : i * GROUP_CORE_NUM];
        end
    endgenerate
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

/*
omega_network OMEGA_NETWORK (
  .clk                        (clk),
  .om1_front_rst              (P6_next_rst),
  .om1_front_push_flag        (P6_push_flag),
  .om1_front_update_v_id      (P6_update_v_id),
  .om1_front_update_v_value   (P6_update_v_value),
  .om1_front_pull_first_flag  (P6_pull_first_flag),
  .om1_front_update_v_valid   (P6_update_v_valid),
  .om1_front_iteration_end    (P6_iteration_end),
  .om1_front_iteration_end_valid  (P6_iteration_end_valid),
  .om2_front_rst              (P7_next_rst1),
  .om2_front_push_flag        (P7_om2_send_push_flag),
  .om2_front_update_v_id      (P7_om2_send_update_v_id),
  .om2_front_update_v_value   (P7_om2_send_update_v_value),
  .om2_front_pull_first_flag  (P7_om2_send_update_v_pull_first_flag),
  .om2_front_update_v_valid   (P7_om2_send_update_v_valid),
  .om2_front_iteration_end    (P7_om2_send_iteration_end),
  .om2_front_iteration_end_valid  (P7_om2_send_iteration_end_valid),
  .source_core_full           (P7_source_core_full),

  .om1_rst                (OM1_next_rst),
  .om2_rst                (OM2_next_rst),
  .om1_stage_full         (OM1_stage_full),
  .om2_stage_full         (OM2_stage_full),
  .om1_push_flag          (OM1_push_flag),
  .om1_update_v_id        (OM1_update_v_id),
  .om1_update_v_value     (OM1_update_v_value),
  .om1_pull_first_flag    (OM1_pull_first_flag),
  .om1_update_v_valid     (OM1_update_v_valid),
  .om1_iteration_end      (OM1_iteration_end),
  .om1_iteration_end_valid(OM1_iteration_end_valid),
  .om2_push_flag          (OM2_push_flag),
  .om2_update_v_id        (OM2_update_v_id),
  .om2_update_v_value     (OM2_update_v_value),
  .om2_pull_first_flag    (OM2_pull_first_flag),
  .om2_update_v_valid     (OM2_update_v_valid),
  .om2_iteration_end      (OM2_iteration_end),
  .om2_iteration_end_valid(OM2_iteration_end_valid)
);
*/

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

/*
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
*/
/* for test with no omega
backend_core BACKEND_CORE (
  .clk                        (clk),
  .om1_rst                    (P6_next_rst),
  .om1_recv_push_flag         (P6_push_flag),
  .om1_recv_update_v_id       (P6_update_v_id),
  .om1_recv_update_v_value    (P6_update_v_value),
  .om1_recv_update_v_pull_first_flag  (P6_pull_first_flag),
  .om1_recv_update_v_valid    (P6_update_v_valid),
  .om1_recv_iteration_end     (P6_iteration_end),
  .om1_recv_iteration_end_valid (P6_iteration_end_valid),
  .om2_rst                    (P6_next_rst),
  .om2_stage_full             (0),
  .om2_recv_push_flag         (P6_push_flag),
  .om2_recv_update_v_id       (P6_update_v_id),
  .om2_recv_update_v_value    (P6_update_v_value),
  .om2_recv_update_v_pull_first_flag  (P6_pull_first_flag),
  .om2_recv_update_v_valid    (P6_update_v_valid),
  .om2_recv_iteration_end     (P6_iteration_end),
  .om2_recv_iteration_end_valid (P6_iteration_end_valid),
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
*/

    generate
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                P7_next_rst1[i] <= P6_next_rst[i];
                P7_next_rst2[i] <= P6_next_rst[i];
            end
            backend_source_core_single #(.CORE_ID(i)) BACKEND_SOURCE_CORE_SINGLE (
                .clk                    (clk),
                .rst                    (P6_next_rst[i]),
                .om1_recv_push_flag     (P6_push_flag[i]),
                .om1_recv_update_v_id   (P6_update_v_id[i]),
                .om1_recv_update_v_value(P6_update_v_value[i]),
                .om1_recv_update_v_pull_first_flag  (P6_pull_first_flag[i]),
                .om1_recv_update_v_valid(P6_update_v_valid[i]),
                .om1_recv_iteration_end (P6_iteration_end[i]),
                .om1_recv_iteration_end_valid (P6_iteration_end_valid[i]),
                .vertex_bram_data       (VTX_BRAM_src_recv_update_v_value[i]),
                .vertex_bram_valid      (VTX_BRAM_src_recv_update_v_valid[i]),
                .om_global_iteration_id (OM_global_iteration_id[i]),
                .om2_stage_full         (0),

                .source_core_full           (P7_source_core_full[i]),
                .rd_vertex_bram_addr        (P7_rd_vertex_bram_addr[i]),
                .rd_vertex_bram_valid       (P7_rd_vertex_bram_valid[i]),
                .om2_send_push_flag         (P7_om2_send_push_flag[i]),
                .om2_send_update_v_id       (P7_om2_send_update_v_id[i]),
                .om2_send_update_v_value    (P7_om2_send_update_v_value[i]),
                .om2_send_update_v_pull_first_flag  (P7_om2_send_update_v_pull_first_flag[i]),
                .om2_send_update_v_valid    (P7_om2_send_update_v_valid[i]),
                .om2_send_iteration_end     (P7_om2_send_iteration_end[i]),
                .om2_send_iteration_end_valid   (P7_om2_send_iteration_end_valid[i])
            );

            backend_destination_core_single #(.CORE_ID(i)) BACKEND_DESTINATION_CORE_SINGLE (
                .clk                    (clk),
                .rst                    (P6_next_rst[i]),
                .om2_recv_push_flag     (P6_push_flag[i]),
                .om2_recv_update_v_id   (P6_update_v_id[i]),
                .om2_recv_update_v_value(P6_update_v_value[i]),
                .om2_recv_update_v_pull_first_flag  (P6_pull_first_flag[i]),
                .om2_recv_update_v_valid(P6_update_v_valid[i]),
                .om2_recv_iteration_end (P6_iteration_end[i]),
                .om2_recv_iteration_end_valid   (P6_iteration_end_valid[i]),

                .wr_vertex_bram_push_flag   (P7_wr_vertex_bram_push_flag[i]),
                .wr_vertex_bram_addr    (P7_wr_vertex_bram_addr[i]),
                .wr_vertex_bram_data    (P7_wr_vertex_bram_data[i]),
                .wr_vertex_bram_pull_first_flag (P7_wr_vertex_bram_pull_first_flag[i]),
                .wr_vertex_bram_valid   (P7_wr_vertex_bram_valid[i]),
                .wr_vertex_bram_iteration_end   (P7_wr_vertex_bram_iteration_end[i]),
                .wr_vertex_bram_iteration_end_valid   (P7_wr_vertex_bram_iteration_end_valid[i])
            );
        end
    endgenerate

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
/*
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
*/
    wire [VTX_BRAM_AWIDTH : 0] tmp_rd_addr [0 : CORE_NUM - 1];
    wire [CORE_NUM - 1 : 0] tmp_rd_addr_valid;
    wire [VTX_BRAM_AWIDTH - 1 : 0] tmp_wr_addr [0 : CORE_NUM - 1];
    wire [VTX_BRAM_DWIDTH - 1 : 0] tmp_wr_data [0 : CORE_NUM - 1];
    wire [CORE_NUM - 1 : 0] tmp_wr_addr_valid;
    wire [VTX_BRAM_DWIDTH - 1 : 0] tmp_bram_data [0 : CORE_NUM - 1];
    reg [CORE_NUM - 1 : 0] tmp_bram_data_valid [0 : 1];
    reg [CORE_NUM - 1 : 0] tmp_bram_addr_check [0 : 1];
    reg [VTX_BRAM_AWIDTH - 1 : 0] local_transfer_addr [0 : 2];
    reg local_transfer_valid [0 : 2];
    reg local_lock;
    reg [CORE_NUM - 1 : 0] write_root;
    integer j;

    assign VTX_BRAM_transfer_done = (local_transfer_addr[2] == {VTX_BRAM_AWIDTH{1'b1}});
    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            assign VTX_BRAM_wb_bfs_data[(i + 1) * HBM_DWIDTH_PER_CORE - 1 : i * HBM_DWIDTH_PER_CORE] =
                {tmp_bram_data[i], local_transfer_addr[2], {CORE_NUM_WIDTH{1'b0}}} + i;
        end
        for (i = 0; i < PSEUDO_CHANNEL_NUM; i = i + 1) begin
            assign VTX_BRAM_wb_bfs_valid[i] = local_transfer_valid[2];
        end
    endgenerate

    always @ (posedge clk) begin
        VTX_BRAM_next_rst <= transfer_bram ? {CORE_NUM{1'b0}} : P7_next_rst2;
    end

    wire hbm_write = !HBM_controller_write_full[0] && !HBM_controller_write_full[1] && !HBM_controller_write_full[2] && !HBM_controller_write_full[3];

    always @ (posedge clk) begin
        if (rst) begin
            local_transfer_addr[0] <= 0;
            local_transfer_valid[0] <= 0;
            local_lock <= 1;
        end else begin
            if (transfer_bram && local_lock) begin
                local_transfer_addr[0] <= 0;
                local_transfer_valid[0] <= 1'b1;
                local_lock <= 0;
            end
            else if (transfer_bram && local_transfer_addr[0] < {VTX_BRAM_AWIDTH{1'b1}} && hbm_write) begin
                local_transfer_addr[0] <= local_transfer_addr[0] + 1;
                local_transfer_valid[0] <= 1'b1;
            end else begin
                local_transfer_valid[0] <= 0;
            end
        end
        local_transfer_addr[2] <= local_transfer_addr[1];
        local_transfer_addr[1] <= local_transfer_addr[0];
        local_transfer_valid[2] <= local_transfer_valid[1];
        local_transfer_valid[1] <= local_transfer_valid[0];
    end

    generate
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            vtx_bram_single VTX_BRAM_SINGLE (
                .clk                (clk),
                .rst                (transfer_bram ? 0 : P7_next_rst2[i]),
                .rd_addr_src        (P7_rd_vertex_bram_addr[i]),
                .rd_valid_src       (P7_rd_vertex_bram_valid[i]),
                .wr_push_flag_dst   (P7_wr_vertex_bram_push_flag[i]),
                .wr_addr_dst        (P7_wr_vertex_bram_addr[i]),
                .wr_v_value_dst     (P7_wr_vertex_bram_data[i]),
                .wr_pull_first_flag_dst (P7_wr_vertex_bram_pull_first_flag[i]),
                .wr_valid_dst       (P7_wr_vertex_bram_valid[i]),
                .front_iteration_end(P7_wr_vertex_bram_iteration_end[i]),
                .front_iteration_end_valid  (P7_wr_vertex_bram_iteration_end_valid[i]),
                .front_iteration_id (P7_global_iteration_id[i]),
                .tmp_bram_data                  (tmp_bram_addr_check[1][i] ? INVALID_PULL_VALUE : tmp_bram_data[i]),
                .tmp_bram_data_valid            (tmp_bram_data_valid[1][i]),

                .tmp_rd_addr                    (tmp_rd_addr[i]),
                .tmp_rd_addr_valid              (tmp_rd_addr_valid[i]),
                .tmp_wr_addr                    (tmp_wr_addr[i]),
                .tmp_wr_data                    (tmp_wr_data[i]),
                .tmp_wr_addr_valid              (tmp_wr_addr_valid[i]),
                .src_recv_update_v_value        (VTX_BRAM_src_recv_update_v_value[i]),
                .src_recv_update_v_valid        (VTX_BRAM_src_recv_update_v_valid[i]),
                .backend_active_v_id            (VTX_BRAM_backend_active_v_id[i]),
                .backend_active_v_updated       (VTX_BRAM_backend_active_v_updated[i]),
                .backend_active_v_pull_first_flag   (VTX_BRAM_backend_active_v_pull_first_flag[i]),
                .backend_active_v_valid         (VTX_BRAM_backend_active_v_id_valid[i]),
                .iteration_end                  (VTX_BRAM_iteration_end[i]),
                .iteration_end_valid            (VTX_BRAM_iteration_end_valid[i])
            );

            vtx_bram_ip_single VTX_BRAM_IP_SINGLE (
                .clka       (clk),
                .ena        (transfer_bram ? 1 : !P7_next_rst2[i]),
                .wea        (tmp_wr_addr_valid[i] || write_root[i]),
                .addra      (write_root[i] ? {{4{1'b0}},P7_global_root_id >> CORE_NUM_WIDTH} :{{4{1'b0}},tmp_wr_addr[i]}),
                .dina       (tmp_wr_data[i]),
                .clkb       (clk),
                .enb        (transfer_bram ? 1 : !P7_next_rst2[i]),
                .addrb      (transfer_bram ? {{4{1'b0}},local_transfer_addr[0]} : {{4{1'b0}},tmp_rd_addr[i]}),
                .doutb      (tmp_bram_data[i])
            );
        end
    endgenerate

    always @ (posedge clk) begin
        tmp_bram_data_valid[0] <= tmp_rd_addr_valid;
        tmp_bram_data_valid[1] <= tmp_bram_data_valid[0];
    end

    always @ (posedge clk) begin
        for (j = 0; j < CORE_NUM; j = j + 1) begin
            tmp_bram_addr_check[0][j] <= (tmp_rd_addr[j] == {(VTX_BRAM_AWIDTH + 1){1'b1}});
            tmp_bram_addr_check[1][j] <= tmp_bram_addr_check[0][j];
        end
    end

    always @ (posedge clk) begin
        if(rst) begin
            for(j = 0; j < CORE_NUM; j = j + 1) begin
                if(front_root_id[CORE_NUM_WIDTH - 1 : 0] == j)begin
                    write_root [j] <= 1;
                end else begin
                    write_root [j] <= 0;
                end
            end
        end
        else  begin
            write_root <= 0;
        end
    end
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
/*
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
*/
  wire iteration_end_combined;

  generate
    if (CORE_NUM == 32) begin
      btree_combine_iteration_end_32 BTREE_COMBINE_ITERATION_END (
        .front_iteration_end        (VTX_BRAM_iteration_end),

        .iteration_end_combined     (VTX_BRAM_iteration_end_valid)
      );
    end else if (CORE_NUM == 64) begin
      btree_combine_iteration_end_64 BTREE_COMBINE_ITERATION_END (
        .front_iteration_end        (VTX_BRAM_iteration_end),

        .iteration_end_combined     (VTX_BRAM_iteration_end_valid)
      );
    end else if (CORE_NUM == 128) begin
      btree_combine_iteration_end_128 BTREE_COMBINE_ITERATION_END (
        .front_iteration_end        (VTX_BRAM_iteration_end),

        .iteration_end_combined     (VTX_BRAM_iteration_end_valid)
      );
    end else if (CORE_NUM == 256) begin
      btree_combine_iteration_end_256 BTREE_COMBINE_ITERATION_END (
        .front_iteration_end        (VTX_BRAM_iteration_end),

        .iteration_end_combined     (VTX_BRAM_iteration_end_valid)
      );
    end else begin
      btree_combine_iteration_end BTREE_COMBINE_ITERATION_END (
        .front_iteration_end        (VTX_BRAM_iteration_end),

        .iteration_end_combined     (VTX_BRAM_iteration_end_valid)
      );
    end
  endgenerate

  generate
    for (i = 0; i < CORE_NUM; i = i + 1) begin
      apply_iteration_end_single APPLY_ITERATION_END_SINGLE (
        .clk                        (clk),
        .rst                        (VTX_BRAM_next_rst[i]),
        .front_active_v_id          (VTX_BRAM_backend_active_v_id[i]),
        .front_active_v_updated     (VTX_BRAM_backend_active_v_updated[i]),
        .front_active_v_pull_first_flag (VTX_BRAM_backend_active_v_pull_first_flag[i]),
        .front_active_v_valid       (VTX_BRAM_backend_active_v_id_valid[i]),
        .front_iteration_end        (iteration_end_combined),
        .front_iteration_end_valid  (VTX_BRAM_iteration_end_valid[i]),

        .active_v_id                (P8_active_v_id[i]),
        .active_v_updated           (P8_active_v_updated[i]),
        .active_v_pull_first_flag   (P8_active_v_pull_first_flag[i]),
        .active_v_valid             (P8_active_v_valid[i]),
        .iteration_end              (P8_iteration_end[i]),
        .iteration_end_valid        (P8_iteration_end_valid[i])
      );
    end
  endgenerate
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