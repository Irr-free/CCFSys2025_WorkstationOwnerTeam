// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1ns/1ps
module acc_kernel_control_s_axi
#(parameter
    C_S_AXI_ADDR_WIDTH = 9,
    C_S_AXI_DATA_WIDTH = 32
)(
    input  wire                          ACLK,
    input  wire                          ARESET,
    input  wire                          ACLK_EN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] AWADDR,
    input  wire                          AWVALID,
    output wire                          AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0] WDATA,
    input  wire [C_S_AXI_DATA_WIDTH/8-1:0] WSTRB,
    input  wire                          WVALID,
    output wire                          WREADY,
    output wire [1:0]                    BRESP,
    output wire                          BVALID,
    input  wire                          BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] ARADDR,
    input  wire                          ARVALID,
    output wire                          ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0] RDATA,
    output wire [1:0]                    RRESP,
    output wire                          RVALID,
    input  wire                          RREADY,
    output wire                          interrupt,
    output wire [31:0]                   root_id,
    output wire [31:0]                   vertex_num,
    output wire [31:0]                   bitmap_compressed_num,
    output wire [31:0]                   iteration_num,
    output wire [31:0]                   powerlaw_vertex_id_00,
    output wire [31:0]                   powerlaw_vertex_id_01,
    output wire [31:0]                   powerlaw_vertex_id_02,
    output wire [31:0]                   powerlaw_vertex_id_03,
    output wire [31:0]                   powerlaw_vertex_id_04,
    output wire [31:0]                   powerlaw_vertex_id_05,
    output wire [31:0]                   powerlaw_vertex_id_06,
    output wire [31:0]                   powerlaw_vertex_id_07,
    output wire [31:0]                   powerlaw_vertex_id_08,
    output wire [31:0]                   powerlaw_vertex_id_09,
    output wire [31:0]                   powerlaw_vertex_id_10,
    output wire [31:0]                   powerlaw_vertex_id_11,
    output wire [31:0]                   powerlaw_vertex_id_12,
    output wire [31:0]                   powerlaw_vertex_id_13,
    output wire [31:0]                   powerlaw_vertex_id_14,
    output wire [31:0]                   powerlaw_vertex_id_15,
    output wire [31:0]                   powerlaw_vertex_id_16,
    output wire [31:0]                   powerlaw_vertex_id_17,
    output wire [31:0]                   powerlaw_vertex_id_18,
    output wire [31:0]                   powerlaw_vertex_id_19,
    output wire [31:0]                   powerlaw_vertex_id_20,
    output wire [31:0]                   powerlaw_vertex_id_21,
    output wire [31:0]                   powerlaw_vertex_id_22,
    output wire [31:0]                   powerlaw_vertex_id_23,
    output wire [31:0]                   powerlaw_vertex_id_24,
    output wire [31:0]                   powerlaw_vertex_id_25,
    output wire [31:0]                   powerlaw_vertex_id_26,
    output wire [31:0]                   powerlaw_vertex_id_27,
    output wire [31:0]                   powerlaw_vertex_id_28,
    output wire [31:0]                   powerlaw_vertex_id_29,
    output wire [31:0]                   powerlaw_vertex_id_30,
    output wire [31:0]                   powerlaw_vertex_id_31,
    output wire [63:0]                   axi00_ptr0,
    output wire [63:0]                   axi01_ptr0,
    output wire [63:0]                   axi02_ptr0,
    output wire [63:0]                   axi03_ptr0,
    output wire                          ap_start,
    input  wire                          ap_done,
    input  wire                          ap_ready,
    input  wire                          ap_idle
);
//------------------------Address Info-------------------
// 0x000 : Control signals
//         bit 0  - ap_start (Read/Write/COH)
//         bit 1  - ap_done (Read/COR)
//         bit 2  - ap_idle (Read)
//         bit 3  - ap_ready (Read/COR)
//         bit 7  - auto_restart (Read/Write)
//         bit 9  - interrupt (Read)
//         others - reserved
// 0x004 : Global Interrupt Enable Register
//         bit 0  - Global Interrupt Enable (Read/Write)
//         others - reserved
// 0x008 : IP Interrupt Enable Register (Read/Write)
//         bit 0 - enable ap_done interrupt (Read/Write)
//         bit 1 - enable ap_ready interrupt (Read/Write)
//         others - reserved
// 0x00c : IP Interrupt Status Register (Read/TOW)
//         bit 0 - ap_done (Read/TOW)
//         bit 1 - ap_ready (Read/TOW)
//         others - reserved
// 0x010 : Data signal of root_id
//         bit 31~0 - root_id[31:0] (Read/Write)
// 0x014 : reserved
// 0x018 : Data signal of vertex_num
//         bit 31~0 - vertex_num[31:0] (Read/Write)
// 0x01c : reserved
// 0x020 : Data signal of bitmap_compressed_num
//         bit 31~0 - bitmap_compressed_num[31:0] (Read/Write)
// 0x024 : reserved
// 0x028 : Data signal of iteration_num
//         bit 31~0 - iteration_num[31:0] (Read/Write)
// 0x02c : reserved
// 0x030 : Data signal of powerlaw_vertex_id_00
//         bit 31~0 - powerlaw_vertex_id_00[31:0] (Read/Write)
// 0x034 : reserved
// 0x038 : Data signal of powerlaw_vertex_id_01
//         bit 31~0 - powerlaw_vertex_id_01[31:0] (Read/Write)
// 0x03c : reserved
// 0x040 : Data signal of powerlaw_vertex_id_02
//         bit 31~0 - powerlaw_vertex_id_02[31:0] (Read/Write)
// 0x044 : reserved
// 0x048 : Data signal of powerlaw_vertex_id_03
//         bit 31~0 - powerlaw_vertex_id_03[31:0] (Read/Write)
// 0x04c : reserved
// 0x050 : Data signal of powerlaw_vertex_id_04
//         bit 31~0 - powerlaw_vertex_id_04[31:0] (Read/Write)
// 0x054 : reserved
// 0x058 : Data signal of powerlaw_vertex_id_05
//         bit 31~0 - powerlaw_vertex_id_05[31:0] (Read/Write)
// 0x05c : reserved
// 0x060 : Data signal of powerlaw_vertex_id_06
//         bit 31~0 - powerlaw_vertex_id_06[31:0] (Read/Write)
// 0x064 : reserved
// 0x068 : Data signal of powerlaw_vertex_id_07
//         bit 31~0 - powerlaw_vertex_id_07[31:0] (Read/Write)
// 0x06c : reserved
// 0x070 : Data signal of powerlaw_vertex_id_08
//         bit 31~0 - powerlaw_vertex_id_08[31:0] (Read/Write)
// 0x074 : reserved
// 0x078 : Data signal of powerlaw_vertex_id_09
//         bit 31~0 - powerlaw_vertex_id_09[31:0] (Read/Write)
// 0x07c : reserved
// 0x080 : Data signal of powerlaw_vertex_id_10
//         bit 31~0 - powerlaw_vertex_id_10[31:0] (Read/Write)
// 0x084 : reserved
// 0x088 : Data signal of powerlaw_vertex_id_11
//         bit 31~0 - powerlaw_vertex_id_11[31:0] (Read/Write)
// 0x08c : reserved
// 0x090 : Data signal of powerlaw_vertex_id_12
//         bit 31~0 - powerlaw_vertex_id_12[31:0] (Read/Write)
// 0x094 : reserved
// 0x098 : Data signal of powerlaw_vertex_id_13
//         bit 31~0 - powerlaw_vertex_id_13[31:0] (Read/Write)
// 0x09c : reserved
// 0x0a0 : Data signal of powerlaw_vertex_id_14
//         bit 31~0 - powerlaw_vertex_id_14[31:0] (Read/Write)
// 0x0a4 : reserved
// 0x0a8 : Data signal of powerlaw_vertex_id_15
//         bit 31~0 - powerlaw_vertex_id_15[31:0] (Read/Write)
// 0x0ac : reserved
// 0x0b0 : Data signal of powerlaw_vertex_id_16
//         bit 31~0 - powerlaw_vertex_id_16[31:0] (Read/Write)
// 0x0b4 : reserved
// 0x0b8 : Data signal of powerlaw_vertex_id_17
//         bit 31~0 - powerlaw_vertex_id_17[31:0] (Read/Write)
// 0x0bc : reserved
// 0x0c0 : Data signal of powerlaw_vertex_id_18
//         bit 31~0 - powerlaw_vertex_id_18[31:0] (Read/Write)
// 0x0c4 : reserved
// 0x0c8 : Data signal of powerlaw_vertex_id_19
//         bit 31~0 - powerlaw_vertex_id_19[31:0] (Read/Write)
// 0x0cc : reserved
// 0x0d0 : Data signal of powerlaw_vertex_id_20
//         bit 31~0 - powerlaw_vertex_id_20[31:0] (Read/Write)
// 0x0d4 : reserved
// 0x0d8 : Data signal of powerlaw_vertex_id_21
//         bit 31~0 - powerlaw_vertex_id_21[31:0] (Read/Write)
// 0x0dc : reserved
// 0x0e0 : Data signal of powerlaw_vertex_id_22
//         bit 31~0 - powerlaw_vertex_id_22[31:0] (Read/Write)
// 0x0e4 : reserved
// 0x0e8 : Data signal of powerlaw_vertex_id_23
//         bit 31~0 - powerlaw_vertex_id_23[31:0] (Read/Write)
// 0x0ec : reserved
// 0x0f0 : Data signal of powerlaw_vertex_id_24
//         bit 31~0 - powerlaw_vertex_id_24[31:0] (Read/Write)
// 0x0f4 : reserved
// 0x0f8 : Data signal of powerlaw_vertex_id_25
//         bit 31~0 - powerlaw_vertex_id_25[31:0] (Read/Write)
// 0x0fc : reserved
// 0x100 : Data signal of powerlaw_vertex_id_26
//         bit 31~0 - powerlaw_vertex_id_26[31:0] (Read/Write)
// 0x104 : reserved
// 0x108 : Data signal of powerlaw_vertex_id_27
//         bit 31~0 - powerlaw_vertex_id_27[31:0] (Read/Write)
// 0x10c : reserved
// 0x110 : Data signal of powerlaw_vertex_id_28
//         bit 31~0 - powerlaw_vertex_id_28[31:0] (Read/Write)
// 0x114 : reserved
// 0x118 : Data signal of powerlaw_vertex_id_29
//         bit 31~0 - powerlaw_vertex_id_29[31:0] (Read/Write)
// 0x11c : reserved
// 0x120 : Data signal of powerlaw_vertex_id_30
//         bit 31~0 - powerlaw_vertex_id_30[31:0] (Read/Write)
// 0x124 : reserved
// 0x128 : Data signal of powerlaw_vertex_id_31
//         bit 31~0 - powerlaw_vertex_id_31[31:0] (Read/Write)
// 0x12c : reserved
// 0x130 : Data signal of axi00_ptr0
//         bit 31~0 - axi00_ptr0[31:0] (Read/Write)
// 0x134 : Data signal of axi00_ptr0
//         bit 31~0 - axi00_ptr0[63:32] (Read/Write)
// 0x138 : reserved
// 0x13c : Data signal of axi01_ptr0
//         bit 31~0 - axi01_ptr0[31:0] (Read/Write)
// 0x140 : Data signal of axi01_ptr0
//         bit 31~0 - axi01_ptr0[63:32] (Read/Write)
// 0x144 : reserved
// 0x148 : Data signal of axi02_ptr0
//         bit 31~0 - axi02_ptr0[31:0] (Read/Write)
// 0x14c : Data signal of axi02_ptr0
//         bit 31~0 - axi02_ptr0[63:32] (Read/Write)
// 0x150 : reserved
// 0x154 : Data signal of axi03_ptr0
//         bit 31~0 - axi03_ptr0[31:0] (Read/Write)
// 0x158 : Data signal of axi03_ptr0
//         bit 31~0 - axi03_ptr0[63:32] (Read/Write)
// 0x15c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

//------------------------Parameter----------------------
localparam
    ADDR_AP_CTRL                      = 9'h000,
    ADDR_GIE                          = 9'h004,
    ADDR_IER                          = 9'h008,
    ADDR_ISR                          = 9'h00c,
    ADDR_ROOT_ID_DATA_0               = 9'h010,
    ADDR_ROOT_ID_CTRL                 = 9'h014,
    ADDR_VERTEX_NUM_DATA_0            = 9'h018,
    ADDR_VERTEX_NUM_CTRL              = 9'h01c,
    ADDR_BITMAP_COMPRESSED_NUM_DATA_0 = 9'h020,
    ADDR_BITMAP_COMPRESSED_NUM_CTRL   = 9'h024,
    ADDR_ITERATION_NUM_DATA_0         = 9'h028,
    ADDR_ITERATION_NUM_CTRL           = 9'h02c,
    ADDR_POWERLAW_VERTEX_ID_00_DATA_0 = 9'h030,
    ADDR_POWERLAW_VERTEX_ID_00_CTRL   = 9'h034,
    ADDR_POWERLAW_VERTEX_ID_01_DATA_0 = 9'h038,
    ADDR_POWERLAW_VERTEX_ID_01_CTRL   = 9'h03c,
    ADDR_POWERLAW_VERTEX_ID_02_DATA_0 = 9'h040,
    ADDR_POWERLAW_VERTEX_ID_02_CTRL   = 9'h044,
    ADDR_POWERLAW_VERTEX_ID_03_DATA_0 = 9'h048,
    ADDR_POWERLAW_VERTEX_ID_03_CTRL   = 9'h04c,
    ADDR_POWERLAW_VERTEX_ID_04_DATA_0 = 9'h050,
    ADDR_POWERLAW_VERTEX_ID_04_CTRL   = 9'h054,
    ADDR_POWERLAW_VERTEX_ID_05_DATA_0 = 9'h058,
    ADDR_POWERLAW_VERTEX_ID_05_CTRL   = 9'h05c,
    ADDR_POWERLAW_VERTEX_ID_06_DATA_0 = 9'h060,
    ADDR_POWERLAW_VERTEX_ID_06_CTRL   = 9'h064,
    ADDR_POWERLAW_VERTEX_ID_07_DATA_0 = 9'h068,
    ADDR_POWERLAW_VERTEX_ID_07_CTRL   = 9'h06c,
    ADDR_POWERLAW_VERTEX_ID_08_DATA_0 = 9'h070,
    ADDR_POWERLAW_VERTEX_ID_08_CTRL   = 9'h074,
    ADDR_POWERLAW_VERTEX_ID_09_DATA_0 = 9'h078,
    ADDR_POWERLAW_VERTEX_ID_09_CTRL   = 9'h07c,
    ADDR_POWERLAW_VERTEX_ID_10_DATA_0 = 9'h080,
    ADDR_POWERLAW_VERTEX_ID_10_CTRL   = 9'h084,
    ADDR_POWERLAW_VERTEX_ID_11_DATA_0 = 9'h088,
    ADDR_POWERLAW_VERTEX_ID_11_CTRL   = 9'h08c,
    ADDR_POWERLAW_VERTEX_ID_12_DATA_0 = 9'h090,
    ADDR_POWERLAW_VERTEX_ID_12_CTRL   = 9'h094,
    ADDR_POWERLAW_VERTEX_ID_13_DATA_0 = 9'h098,
    ADDR_POWERLAW_VERTEX_ID_13_CTRL   = 9'h09c,
    ADDR_POWERLAW_VERTEX_ID_14_DATA_0 = 9'h0a0,
    ADDR_POWERLAW_VERTEX_ID_14_CTRL   = 9'h0a4,
    ADDR_POWERLAW_VERTEX_ID_15_DATA_0 = 9'h0a8,
    ADDR_POWERLAW_VERTEX_ID_15_CTRL   = 9'h0ac,
    ADDR_POWERLAW_VERTEX_ID_16_DATA_0 = 9'h0b0,
    ADDR_POWERLAW_VERTEX_ID_16_CTRL   = 9'h0b4,
    ADDR_POWERLAW_VERTEX_ID_17_DATA_0 = 9'h0b8,
    ADDR_POWERLAW_VERTEX_ID_17_CTRL   = 9'h0bc,
    ADDR_POWERLAW_VERTEX_ID_18_DATA_0 = 9'h0c0,
    ADDR_POWERLAW_VERTEX_ID_18_CTRL   = 9'h0c4,
    ADDR_POWERLAW_VERTEX_ID_19_DATA_0 = 9'h0c8,
    ADDR_POWERLAW_VERTEX_ID_19_CTRL   = 9'h0cc,
    ADDR_POWERLAW_VERTEX_ID_20_DATA_0 = 9'h0d0,
    ADDR_POWERLAW_VERTEX_ID_20_CTRL   = 9'h0d4,
    ADDR_POWERLAW_VERTEX_ID_21_DATA_0 = 9'h0d8,
    ADDR_POWERLAW_VERTEX_ID_21_CTRL   = 9'h0dc,
    ADDR_POWERLAW_VERTEX_ID_22_DATA_0 = 9'h0e0,
    ADDR_POWERLAW_VERTEX_ID_22_CTRL   = 9'h0e4,
    ADDR_POWERLAW_VERTEX_ID_23_DATA_0 = 9'h0e8,
    ADDR_POWERLAW_VERTEX_ID_23_CTRL   = 9'h0ec,
    ADDR_POWERLAW_VERTEX_ID_24_DATA_0 = 9'h0f0,
    ADDR_POWERLAW_VERTEX_ID_24_CTRL   = 9'h0f4,
    ADDR_POWERLAW_VERTEX_ID_25_DATA_0 = 9'h0f8,
    ADDR_POWERLAW_VERTEX_ID_25_CTRL   = 9'h0fc,
    ADDR_POWERLAW_VERTEX_ID_26_DATA_0 = 9'h100,
    ADDR_POWERLAW_VERTEX_ID_26_CTRL   = 9'h104,
    ADDR_POWERLAW_VERTEX_ID_27_DATA_0 = 9'h108,
    ADDR_POWERLAW_VERTEX_ID_27_CTRL   = 9'h10c,
    ADDR_POWERLAW_VERTEX_ID_28_DATA_0 = 9'h110,
    ADDR_POWERLAW_VERTEX_ID_28_CTRL   = 9'h114,
    ADDR_POWERLAW_VERTEX_ID_29_DATA_0 = 9'h118,
    ADDR_POWERLAW_VERTEX_ID_29_CTRL   = 9'h11c,
    ADDR_POWERLAW_VERTEX_ID_30_DATA_0 = 9'h120,
    ADDR_POWERLAW_VERTEX_ID_30_CTRL   = 9'h124,
    ADDR_POWERLAW_VERTEX_ID_31_DATA_0 = 9'h128,
    ADDR_POWERLAW_VERTEX_ID_31_CTRL   = 9'h12c,
    ADDR_AXI00_PTR0_DATA_0            = 9'h130,
    ADDR_AXI00_PTR0_DATA_1            = 9'h134,
    ADDR_AXI00_PTR0_CTRL              = 9'h138,
    ADDR_AXI01_PTR0_DATA_0            = 9'h13c,
    ADDR_AXI01_PTR0_DATA_1            = 9'h140,
    ADDR_AXI01_PTR0_CTRL              = 9'h144,
    ADDR_AXI02_PTR0_DATA_0            = 9'h148,
    ADDR_AXI02_PTR0_DATA_1            = 9'h14c,
    ADDR_AXI02_PTR0_CTRL              = 9'h150,
    ADDR_AXI03_PTR0_DATA_0            = 9'h154,
    ADDR_AXI03_PTR0_DATA_1            = 9'h158,
    ADDR_AXI03_PTR0_CTRL              = 9'h15c,
    WRIDLE                            = 2'd0,
    WRDATA                            = 2'd1,
    WRRESP                            = 2'd2,
    WRRESET                           = 2'd3,
    RDIDLE                            = 2'd0,
    RDDATA                            = 2'd1,
    RDRESET                           = 2'd2,
    ADDR_BITS                = 9;

//------------------------Local signal-------------------
    reg  [1:0]                    wstate = WRRESET;
    reg  [1:0]                    wnext;
    reg  [ADDR_BITS-1:0]          waddr;
    wire [C_S_AXI_DATA_WIDTH-1:0] wmask;
    wire                          aw_hs;
    wire                          w_hs;
    reg  [1:0]                    rstate = RDRESET;
    reg  [1:0]                    rnext;
    reg  [C_S_AXI_DATA_WIDTH-1:0] rdata;
    wire                          ar_hs;
    wire [ADDR_BITS-1:0]          raddr;
    // internal registers
    reg                           int_ap_idle;
    reg                           int_ap_ready = 1'b0;
    wire                          task_ap_ready;
    reg                           int_ap_done = 1'b0;
    wire                          task_ap_done;
    reg                           int_task_ap_done = 1'b0;
    reg                           int_ap_start = 1'b0;
    reg                           int_interrupt = 1'b0;
    reg                           int_auto_restart = 1'b0;
    reg                           auto_restart_status = 1'b0;
    wire                          auto_restart_done;
    reg                           int_gie = 1'b0;
    reg  [1:0]                    int_ier = 2'b0;
    reg  [1:0]                    int_isr = 2'b0;
    reg  [31:0]                   int_root_id = 'b0;
    reg  [31:0]                   int_vertex_num = 'b0;
    reg  [31:0]                   int_bitmap_compressed_num = 'b0;
    reg  [31:0]                   int_iteration_num = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_00 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_01 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_02 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_03 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_04 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_05 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_06 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_07 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_08 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_09 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_10 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_11 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_12 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_13 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_14 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_15 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_16 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_17 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_18 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_19 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_20 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_21 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_22 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_23 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_24 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_25 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_26 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_27 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_28 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_29 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_30 = 'b0;
    reg  [31:0]                   int_powerlaw_vertex_id_31 = 'b0;
    reg  [63:0]                   int_axi00_ptr0 = 'b0;
    reg  [63:0]                   int_axi01_ptr0 = 'b0;
    reg  [63:0]                   int_axi02_ptr0 = 'b0;
    reg  [63:0]                   int_axi03_ptr0 = 'b0;

//------------------------Instantiation------------------


//------------------------AXI write fsm------------------
assign AWREADY = (wstate == WRIDLE);
assign WREADY  = (wstate == WRDATA);
assign BRESP   = 2'b00;  // OKAY
assign BVALID  = (wstate == WRRESP);
assign wmask   = { {8{WSTRB[3]}}, {8{WSTRB[2]}}, {8{WSTRB[1]}}, {8{WSTRB[0]}} };
assign aw_hs   = AWVALID & AWREADY;
assign w_hs    = WVALID & WREADY;

// wstate
always @(posedge ACLK) begin
    if (ARESET)
        wstate <= WRRESET;
    else if (ACLK_EN)
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (AWVALID)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (WVALID)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (BREADY)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (aw_hs)
            waddr <= AWADDR[ADDR_BITS-1:0];
    end
end

//------------------------AXI read fsm-------------------
assign ARREADY = (rstate == RDIDLE);
assign RDATA   = rdata;
assign RRESP   = 2'b00;  // OKAY
assign RVALID  = (rstate == RDDATA);
assign ar_hs   = ARVALID & ARREADY;
assign raddr   = ARADDR[ADDR_BITS-1:0];

// rstate
always @(posedge ACLK) begin
    if (ARESET)
        rstate <= RDRESET;
    else if (ACLK_EN)
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (ARVALID)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (RREADY & RVALID)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end

// rdata
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (ar_hs) begin
            rdata <= 'b0;
            case (raddr)
                ADDR_AP_CTRL: begin
                    rdata[0] <= int_ap_start;
                    rdata[1] <= int_task_ap_done;
                    rdata[2] <= int_ap_idle;
                    rdata[3] <= int_ap_ready;
                    rdata[7] <= int_auto_restart;
                    rdata[9] <= int_interrupt;
                end
                ADDR_GIE: begin
                    rdata <= int_gie;
                end
                ADDR_IER: begin
                    rdata <= int_ier;
                end
                ADDR_ISR: begin
                    rdata <= int_isr;
                end
                ADDR_ROOT_ID_DATA_0: begin
                    rdata <= int_root_id[31:0];
                end
                ADDR_VERTEX_NUM_DATA_0: begin
                    rdata <= int_vertex_num[31:0];
                end
                ADDR_BITMAP_COMPRESSED_NUM_DATA_0: begin
                    rdata <= int_bitmap_compressed_num[31:0];
                end
                ADDR_ITERATION_NUM_DATA_0: begin
                    rdata <= int_iteration_num[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_00_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_00[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_01_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_01[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_02_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_02[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_03_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_03[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_04_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_04[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_05_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_05[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_06_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_06[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_07_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_07[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_08_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_08[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_09_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_09[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_10_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_10[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_11_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_11[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_12_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_12[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_13_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_13[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_14_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_14[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_15_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_15[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_16_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_16[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_17_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_17[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_18_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_18[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_19_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_19[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_20_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_20[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_21_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_21[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_22_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_22[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_23_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_23[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_24_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_24[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_25_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_25[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_26_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_26[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_27_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_27[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_28_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_28[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_29_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_29[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_30_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_30[31:0];
                end
                ADDR_POWERLAW_VERTEX_ID_31_DATA_0: begin
                    rdata <= int_powerlaw_vertex_id_31[31:0];
                end
                ADDR_AXI00_PTR0_DATA_0: begin
                    rdata <= int_axi00_ptr0[31:0];
                end
                ADDR_AXI00_PTR0_DATA_1: begin
                    rdata <= int_axi00_ptr0[63:32];
                end
                ADDR_AXI01_PTR0_DATA_0: begin
                    rdata <= int_axi01_ptr0[31:0];
                end
                ADDR_AXI01_PTR0_DATA_1: begin
                    rdata <= int_axi01_ptr0[63:32];
                end
                ADDR_AXI02_PTR0_DATA_0: begin
                    rdata <= int_axi02_ptr0[31:0];
                end
                ADDR_AXI02_PTR0_DATA_1: begin
                    rdata <= int_axi02_ptr0[63:32];
                end
                ADDR_AXI03_PTR0_DATA_0: begin
                    rdata <= int_axi03_ptr0[31:0];
                end
                ADDR_AXI03_PTR0_DATA_1: begin
                    rdata <= int_axi03_ptr0[63:32];
                end
            endcase
        end
    end
end


//------------------------Register logic-----------------
assign interrupt             = int_interrupt;
assign ap_start              = int_ap_start;
assign task_ap_done          = (ap_done && !auto_restart_status) || auto_restart_done;
assign task_ap_ready         = ap_ready && !int_auto_restart;
assign auto_restart_done     = auto_restart_status && (ap_idle && !int_ap_idle);
assign root_id               = int_root_id;
assign vertex_num            = int_vertex_num;
assign bitmap_compressed_num = int_bitmap_compressed_num;
assign iteration_num         = int_iteration_num;
assign powerlaw_vertex_id_00 = int_powerlaw_vertex_id_00;
assign powerlaw_vertex_id_01 = int_powerlaw_vertex_id_01;
assign powerlaw_vertex_id_02 = int_powerlaw_vertex_id_02;
assign powerlaw_vertex_id_03 = int_powerlaw_vertex_id_03;
assign powerlaw_vertex_id_04 = int_powerlaw_vertex_id_04;
assign powerlaw_vertex_id_05 = int_powerlaw_vertex_id_05;
assign powerlaw_vertex_id_06 = int_powerlaw_vertex_id_06;
assign powerlaw_vertex_id_07 = int_powerlaw_vertex_id_07;
assign powerlaw_vertex_id_08 = int_powerlaw_vertex_id_08;
assign powerlaw_vertex_id_09 = int_powerlaw_vertex_id_09;
assign powerlaw_vertex_id_10 = int_powerlaw_vertex_id_10;
assign powerlaw_vertex_id_11 = int_powerlaw_vertex_id_11;
assign powerlaw_vertex_id_12 = int_powerlaw_vertex_id_12;
assign powerlaw_vertex_id_13 = int_powerlaw_vertex_id_13;
assign powerlaw_vertex_id_14 = int_powerlaw_vertex_id_14;
assign powerlaw_vertex_id_15 = int_powerlaw_vertex_id_15;
assign powerlaw_vertex_id_16 = int_powerlaw_vertex_id_16;
assign powerlaw_vertex_id_17 = int_powerlaw_vertex_id_17;
assign powerlaw_vertex_id_18 = int_powerlaw_vertex_id_18;
assign powerlaw_vertex_id_19 = int_powerlaw_vertex_id_19;
assign powerlaw_vertex_id_20 = int_powerlaw_vertex_id_20;
assign powerlaw_vertex_id_21 = int_powerlaw_vertex_id_21;
assign powerlaw_vertex_id_22 = int_powerlaw_vertex_id_22;
assign powerlaw_vertex_id_23 = int_powerlaw_vertex_id_23;
assign powerlaw_vertex_id_24 = int_powerlaw_vertex_id_24;
assign powerlaw_vertex_id_25 = int_powerlaw_vertex_id_25;
assign powerlaw_vertex_id_26 = int_powerlaw_vertex_id_26;
assign powerlaw_vertex_id_27 = int_powerlaw_vertex_id_27;
assign powerlaw_vertex_id_28 = int_powerlaw_vertex_id_28;
assign powerlaw_vertex_id_29 = int_powerlaw_vertex_id_29;
assign powerlaw_vertex_id_30 = int_powerlaw_vertex_id_30;
assign powerlaw_vertex_id_31 = int_powerlaw_vertex_id_31;
assign axi00_ptr0            = int_axi00_ptr0;
assign axi01_ptr0            = int_axi01_ptr0;
assign axi02_ptr0            = int_axi02_ptr0;
assign axi03_ptr0            = int_axi03_ptr0;
// int_interrupt
always @(posedge ACLK) begin
    if (ARESET)
        int_interrupt <= 1'b0;
    else if (ACLK_EN) begin
        if (int_gie && (|int_isr))
            int_interrupt <= 1'b1;
        else
            int_interrupt <= 1'b0;
    end
end

// int_ap_start
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_start <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AP_CTRL && WSTRB[0] && WDATA[0])
            int_ap_start <= 1'b1;
        else if (ap_ready)
            int_ap_start <= int_auto_restart; // clear on handshake/auto restart
    end
end

// int_ap_done
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_done <= 1'b0;
    else if (ACLK_EN) begin
            int_ap_done <= ap_done;
    end
end

// int_task_ap_done
always @(posedge ACLK) begin
    if (ARESET)
        int_task_ap_done <= 1'b0;
    else if (ACLK_EN) begin
        if (task_ap_done)
            int_task_ap_done <= 1'b1;
        else if (ar_hs && raddr == ADDR_AP_CTRL)
            int_task_ap_done <= 1'b0; // clear on read
    end
end

// int_ap_idle
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_idle <= 1'b0;
    else if (ACLK_EN) begin
            int_ap_idle <= ap_idle;
    end
end

// int_ap_ready
always @(posedge ACLK) begin
    if (ARESET)
        int_ap_ready <= 1'b0;
    else if (ACLK_EN) begin
        if (task_ap_ready)
            int_ap_ready <= 1'b1;
        else if (ar_hs && raddr == ADDR_AP_CTRL)
            int_ap_ready <= 1'b0;
    end
end

// int_auto_restart
always @(posedge ACLK) begin
    if (ARESET)
        int_auto_restart <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AP_CTRL && WSTRB[0])
            int_auto_restart <=  WDATA[7];
    end
end

// auto_restart_status
always @(posedge ACLK) begin
    if (ARESET)
        auto_restart_status <= 1'b0;
    else if (ACLK_EN) begin
        if (int_auto_restart)
            auto_restart_status <= 1'b1;
        else if (ap_idle)
            auto_restart_status <= 1'b0;
    end
end

// int_gie
always @(posedge ACLK) begin
    if (ARESET)
        int_gie <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_GIE && WSTRB[0])
            int_gie <= WDATA[0];
    end
end

// int_ier
always @(posedge ACLK) begin
    if (ARESET)
        int_ier <= 1'b0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_IER && WSTRB[0])
            int_ier <= WDATA[1:0];
    end
end

// int_isr[0]
always @(posedge ACLK) begin
    if (ARESET)
        int_isr[0] <= 1'b0;
    else if (ACLK_EN) begin
        if (int_ier[0] & ap_done)
            int_isr[0] <= 1'b1;
        else if (w_hs && waddr == ADDR_ISR && WSTRB[0])
            int_isr[0] <= int_isr[0] ^ WDATA[0]; // toggle on write
    end
end

// int_isr[1]
always @(posedge ACLK) begin
    if (ARESET)
        int_isr[1] <= 1'b0;
    else if (ACLK_EN) begin
        if (int_ier[1] & ap_ready)
            int_isr[1] <= 1'b1;
        else if (w_hs && waddr == ADDR_ISR && WSTRB[0])
            int_isr[1] <= int_isr[1] ^ WDATA[1]; // toggle on write
    end
end

// int_root_id[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_root_id[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_ROOT_ID_DATA_0)
            int_root_id[31:0] <= (WDATA[31:0] & wmask) | (int_root_id[31:0] & ~wmask);
    end
end

// int_vertex_num[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_vertex_num[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_VERTEX_NUM_DATA_0)
            int_vertex_num[31:0] <= (WDATA[31:0] & wmask) | (int_vertex_num[31:0] & ~wmask);
    end
end

// int_bitmap_compressed_num[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_bitmap_compressed_num[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_BITMAP_COMPRESSED_NUM_DATA_0)
            int_bitmap_compressed_num[31:0] <= (WDATA[31:0] & wmask) | (int_bitmap_compressed_num[31:0] & ~wmask);
    end
end

// int_iteration_num[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_iteration_num[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_ITERATION_NUM_DATA_0)
            int_iteration_num[31:0] <= (WDATA[31:0] & wmask) | (int_iteration_num[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_00[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_00[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_00_DATA_0)
            int_powerlaw_vertex_id_00[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_00[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_01[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_01[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_01_DATA_0)
            int_powerlaw_vertex_id_01[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_01[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_02[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_02[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_02_DATA_0)
            int_powerlaw_vertex_id_02[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_02[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_03[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_03[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_03_DATA_0)
            int_powerlaw_vertex_id_03[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_03[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_04[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_04[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_04_DATA_0)
            int_powerlaw_vertex_id_04[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_04[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_05[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_05[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_05_DATA_0)
            int_powerlaw_vertex_id_05[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_05[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_06[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_06[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_06_DATA_0)
            int_powerlaw_vertex_id_06[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_06[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_07[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_07[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_07_DATA_0)
            int_powerlaw_vertex_id_07[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_07[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_08[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_08[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_08_DATA_0)
            int_powerlaw_vertex_id_08[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_08[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_09[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_09[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_09_DATA_0)
            int_powerlaw_vertex_id_09[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_09[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_10[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_10[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_10_DATA_0)
            int_powerlaw_vertex_id_10[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_10[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_11[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_11[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_11_DATA_0)
            int_powerlaw_vertex_id_11[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_11[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_12[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_12[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_12_DATA_0)
            int_powerlaw_vertex_id_12[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_12[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_13[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_13[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_13_DATA_0)
            int_powerlaw_vertex_id_13[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_13[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_14[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_14[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_14_DATA_0)
            int_powerlaw_vertex_id_14[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_14[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_15[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_15[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_15_DATA_0)
            int_powerlaw_vertex_id_15[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_15[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_16[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_16[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_16_DATA_0)
            int_powerlaw_vertex_id_16[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_16[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_17[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_17[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_17_DATA_0)
            int_powerlaw_vertex_id_17[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_17[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_18[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_18[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_18_DATA_0)
            int_powerlaw_vertex_id_18[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_18[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_19[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_19[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_19_DATA_0)
            int_powerlaw_vertex_id_19[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_19[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_20[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_20[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_20_DATA_0)
            int_powerlaw_vertex_id_20[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_20[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_21[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_21[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_21_DATA_0)
            int_powerlaw_vertex_id_21[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_21[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_22[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_22[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_22_DATA_0)
            int_powerlaw_vertex_id_22[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_22[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_23[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_23[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_23_DATA_0)
            int_powerlaw_vertex_id_23[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_23[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_24[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_24[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_24_DATA_0)
            int_powerlaw_vertex_id_24[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_24[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_25[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_25[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_25_DATA_0)
            int_powerlaw_vertex_id_25[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_25[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_26[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_26[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_26_DATA_0)
            int_powerlaw_vertex_id_26[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_26[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_27[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_27[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_27_DATA_0)
            int_powerlaw_vertex_id_27[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_27[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_28[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_28[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_28_DATA_0)
            int_powerlaw_vertex_id_28[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_28[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_29[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_29[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_29_DATA_0)
            int_powerlaw_vertex_id_29[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_29[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_30[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_30[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_30_DATA_0)
            int_powerlaw_vertex_id_30[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_30[31:0] & ~wmask);
    end
end

// int_powerlaw_vertex_id_31[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_powerlaw_vertex_id_31[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_POWERLAW_VERTEX_ID_31_DATA_0)
            int_powerlaw_vertex_id_31[31:0] <= (WDATA[31:0] & wmask) | (int_powerlaw_vertex_id_31[31:0] & ~wmask);
    end
end

// int_axi00_ptr0[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_axi00_ptr0[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AXI00_PTR0_DATA_0)
            int_axi00_ptr0[31:0] <= (WDATA[31:0] & wmask) | (int_axi00_ptr0[31:0] & ~wmask);
    end
end

// int_axi00_ptr0[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_axi00_ptr0[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AXI00_PTR0_DATA_1)
            int_axi00_ptr0[63:32] <= (WDATA[31:0] & wmask) | (int_axi00_ptr0[63:32] & ~wmask);
    end
end

// int_axi01_ptr0[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_axi01_ptr0[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AXI01_PTR0_DATA_0)
            int_axi01_ptr0[31:0] <= (WDATA[31:0] & wmask) | (int_axi01_ptr0[31:0] & ~wmask);
    end
end

// int_axi01_ptr0[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_axi01_ptr0[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AXI01_PTR0_DATA_1)
            int_axi01_ptr0[63:32] <= (WDATA[31:0] & wmask) | (int_axi01_ptr0[63:32] & ~wmask);
    end
end

// int_axi02_ptr0[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_axi02_ptr0[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AXI02_PTR0_DATA_0)
            int_axi02_ptr0[31:0] <= (WDATA[31:0] & wmask) | (int_axi02_ptr0[31:0] & ~wmask);
    end
end

// int_axi02_ptr0[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_axi02_ptr0[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AXI02_PTR0_DATA_1)
            int_axi02_ptr0[63:32] <= (WDATA[31:0] & wmask) | (int_axi02_ptr0[63:32] & ~wmask);
    end
end

// int_axi03_ptr0[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_axi03_ptr0[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AXI03_PTR0_DATA_0)
            int_axi03_ptr0[31:0] <= (WDATA[31:0] & wmask) | (int_axi03_ptr0[31:0] & ~wmask);
    end
end

// int_axi03_ptr0[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_axi03_ptr0[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_AXI03_PTR0_DATA_1)
            int_axi03_ptr0[63:32] <= (WDATA[31:0] & wmask) | (int_axi03_ptr0[63:32] & ~wmask);
    end
end

//synthesis translate_off
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (int_gie & ~int_isr[0] & int_ier[0] & ap_done)
            $display ("// Interrupt Monitor : interrupt for ap_done detected @ \"%0t\"", $time);
        if (int_gie & ~int_isr[1] & int_ier[1] & ap_ready)
            $display ("// Interrupt Monitor : interrupt for ap_ready detected @ \"%0t\"", $time);
    end
end
//synthesis translate_on

//------------------------Memory logic-------------------

endmodule
