`timescale 1ns / 1ps

`include "data_width.vh"

module top #(parameter
    VERTEX_DWIDTH = `VERTEX_DWIDTH,
    VERTEX_ID_WIDTH = `VERTEX_ID_WIDTH,
    VERTEX_PIPELINE_NUM = `VERTEX_PIPELINE_NUM,
    HBM_DWIDTH_PER_CHANNEL = `HBM_DWIDTH_PER_CHANNEL,
    HBM_AWIDTH_PER_CHANNEL = `HBM_AWIDTH_PER_CHANNEL,
    HBM_CHANNEL_NUM = `HBM_CHANNEL_NUM,
    OMEGA_ARRAY_X = `OMEGA_ARRAY_X
) (
   input               APB_0_PCLK
  ,input               APB_0_PRESET_N
  ,input               AXI_ACLK_IN_0
  ,input               AXI_ARESET_N_0
  ,input               HBM_REF_CLK_0
  ,input               APB_1_PCLK
  ,input               APB_1_PRESET_N
  ,input               AXI_ACLK_IN_1
  ,input               AXI_ARESET_N_1
  ,input               HBM_REF_CLK_1
);

////////////////////////////////////////////////////////////////////////////////
// Localparams
////////////////////////////////////////////////////////////////////////////////
  localparam MMCM_CLKFBOUT_MULT_F  = 40;
  localparam MMCM_CLKOUT0_DIVIDE_F = 4;
  localparam MMCM_DIVCLK_DIVIDE    = 5;
  localparam MMCM_CLKIN1_PERIOD    = 5.000;
  
  localparam MMCM1_CLKFBOUT_MULT_F  = 40;
  localparam MMCM1_CLKOUT0_DIVIDE_F = 4;
  localparam MMCM1_DIVCLK_DIVIDE    = 5;
  localparam MMCM1_CLKIN1_PERIOD    = 5.000;

////////////////////////////////////////////////////////////////////////////////
// Wire Delcaration
////////////////////////////////////////////////////////////////////////////////
(* keep = "TRUE" *)   wire          AXI_ACLK_IN_0_buf;
(* keep = "TRUE" *)   wire          AXI_ACLK_IN_0_iobuf;
(* keep = "TRUE" *)   wire          AXI_ACLK_st0        [0 : 6];
(* keep = "TRUE" *)   wire          AXI_ACLK_st0_buf    [0 : 6];

(* keep = "TRUE" *)   wire          AXI_ACLK_IN_1_buf;
(* keep = "TRUE" *)   wire          AXI_ACLK_st1        [0 : 6];
(* keep = "TRUE" *)   wire          AXI_ACLK_st1_buf    [0 : 6];

////////////////////////////////////////////////////////////////////////////////
// Reg declaration
////////////////////////////////////////////////////////////////////////////////
(* keep = "TRUE" *) reg           axi_rst_st0_n         [0 : 6];
(* keep = "TRUE" *) reg           axi_rst_st1_n         [0 : 6];

// axi
  wire [ 32:0]  AXI_ARADDR   [0 : HBM_CHANNEL_NUM - 1];
  wire [  1:0]  AXI_ARBURST  [0 : HBM_CHANNEL_NUM - 1];
  wire [  5:0]  AXI_ARID     [0 : HBM_CHANNEL_NUM - 1];
  wire [  7:0]  AXI_ARLEN    [0 : HBM_CHANNEL_NUM - 1];
  wire [  2:0]  AXI_ARSIZE   [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_ARVALID  [0 : HBM_CHANNEL_NUM - 1];
  wire [ 32:0]  AXI_AWADDR   [0 : HBM_CHANNEL_NUM - 1];
  wire [  1:0]  AXI_AWBURST  [0 : HBM_CHANNEL_NUM - 1];
  wire [  5:0]  AXI_AWID     [0 : HBM_CHANNEL_NUM - 1];
  wire [  7:0]  AXI_AWLEN    [0 : HBM_CHANNEL_NUM - 1];
  wire [  2:0]  AXI_AWSIZE   [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_AWVALID  [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_RREADY   [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_BREADY   [0 : HBM_CHANNEL_NUM - 1];
  wire [255:0]  AXI_WDATA    [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_WLAST    [0 : HBM_CHANNEL_NUM - 1];
  wire [ 31:0]  AXI_WSTRB    [0 : HBM_CHANNEL_NUM - 1];
  wire [ 31:0]  AXI_WDATA_PARITY_i   [0 : HBM_CHANNEL_NUM - 1];
  wire [ 31:0]  AXI_WDATA_PARITY     [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_WVALID   [0 : HBM_CHANNEL_NUM - 1];
  wire [3:0]    AXI_ARCACHE  [0 : HBM_CHANNEL_NUM - 1];
  wire [3:0]    AXI_AWCACHE  [0 : HBM_CHANNEL_NUM - 1];
  wire [2:0]    AXI_AWPROT   [0 : HBM_CHANNEL_NUM - 1];

  wire          AXI_ARREADY  [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_AWREADY  [0 : HBM_CHANNEL_NUM - 1];
  wire [ 31:0]  AXI_RDATA_PARITY [0 : HBM_CHANNEL_NUM - 1];
  wire [255:0]  AXI_RDATA    [0 : HBM_CHANNEL_NUM - 1];
  wire [  5:0]  AXI_RID      [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_RLAST    [0 : HBM_CHANNEL_NUM - 1];
  wire [  1:0]  AXI_RRESP    [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_RVALID   [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_WREADY   [0 : HBM_CHANNEL_NUM - 1];
  wire [  5:0]  AXI_BID      [0 : HBM_CHANNEL_NUM - 1];
  wire [  1:0]  AXI_BRESP    [0 : HBM_CHANNEL_NUM - 1];
  wire          AXI_BVALID   [0 : HBM_CHANNEL_NUM - 1];

// clock
////////////////////////////////////////////////////////////////////////////////
// Instantiating MMCM for AXI clock generation
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Instantiating BUFG for AXI Clock
////////////////////////////////////////////////////////////////////////////////
(* keep = "TRUE" *) wire      APB_0_PCLK_IBUF;
(* keep = "TRUE" *) wire      APB_0_PCLK_BUF;

IBUF u_APB_0_PCLK_IBUF  ( .I (APB_0_PCLK), .O (APB_0_PCLK_IBUF) );
BUFG u_APB_0_PCLK_BUFG  ( .I (APB_0_PCLK_IBUF), .O (APB_0_PCLK_BUF) );
BUFG u_AXI_ACLK_IN_0  ( .I (AXI_ACLK_IN_0), .O (AXI_ACLK_IN_0_buf) );

(* keep = "TRUE" *) wire      APB_1_PCLK_IBUF;
(* keep = "TRUE" *) wire      APB_1_PCLK_BUF;

IBUF u_APB_1_PCLK_IBUF  ( .I (APB_1_PCLK), .O (APB_1_PCLK_IBUF) );
BUFG u_APB_1_PCLK_BUFG  ( .I (APB_1_PCLK_IBUF), .O (APB_1_PCLK_BUF) );
BUFG u_AXI_ACLK_IN_1  ( .I (AXI_ACLK_IN_1), .O (AXI_ACLK_IN_1_buf) );

MMCME4_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("INTERNAL"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (MMCM_DIVCLK_DIVIDE),
    .CLKFBOUT_MULT_F      (MMCM_CLKFBOUT_MULT_F),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKOUT1_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT2_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT3_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT4_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT5_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKOUT6_DIVIDE       (MMCM_CLKOUT0_DIVIDE_F),
    .CLKIN1_PERIOD        (MMCM_CLKIN1_PERIOD),
    .REF_JITTER1          (0.010))
  u_mmcm_0
    // Output clocks
   (
    .CLKFBOUT            (),
    .CLKFBOUTB           (),
    .CLKOUT0             (AXI_ACLK_st0[0]),

    .CLKOUT0B            (),
    .CLKOUT1             (AXI_ACLK_st0[1]),
    .CLKOUT1B            (),
    .CLKOUT2             (AXI_ACLK_st0[2]),
    .CLKOUT2B            (),
    .CLKOUT3             (AXI_ACLK_st0[3]),
    .CLKOUT3B            (),
    .CLKOUT4             (AXI_ACLK_st0[4]),
    .CLKOUT5             (AXI_ACLK_st0[5]),
    .CLKOUT6             (AXI_ACLK_st0[6]),
     // Input clock control
    .CLKFBIN             (), //mmcm_fb
    .CLKIN1              (AXI_ACLK_IN_0_buf),
    .CLKIN2              (1'b0),
    // Other control and status signals
    .LOCKED              (),
    .PWRDWN              (1'b0),
    .RST                 (1'b1),
  
    .CDDCDONE            (),
    .CLKFBSTOPPED        (),
    .CLKINSTOPPED        (),
    .DO                  (),
    .DRDY                (),
    .PSDONE              (),
    .CDDCREQ             (1'b0),
    .CLKINSEL            (1'b1),
    .DADDR               (7'b0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'b0),
    .DWE                 (1'b0),
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0)
  );

MMCME4_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("INTERNAL"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (MMCM1_DIVCLK_DIVIDE),
    .CLKFBOUT_MULT_F      (MMCM1_CLKFBOUT_MULT_F),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (MMCM1_CLKOUT0_DIVIDE_F),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKOUT1_DIVIDE       (MMCM1_CLKOUT0_DIVIDE_F),
    .CLKOUT2_DIVIDE       (MMCM1_CLKOUT0_DIVIDE_F),
    .CLKOUT3_DIVIDE       (MMCM1_CLKOUT0_DIVIDE_F),
    .CLKOUT4_DIVIDE       (MMCM1_CLKOUT0_DIVIDE_F),
    .CLKOUT5_DIVIDE       (MMCM1_CLKOUT0_DIVIDE_F),
    .CLKOUT6_DIVIDE       (MMCM1_CLKOUT0_DIVIDE_F),
    .CLKIN1_PERIOD        (MMCM1_CLKIN1_PERIOD),
    .REF_JITTER1          (0.010))
  u_mmcm_1
    // Output clocks
   (
    .CLKFBOUT            (),
    .CLKFBOUTB           (),

    .CLKOUT0             (AXI_ACLK_st1[0]),

    .CLKOUT0B            (),
    .CLKOUT1             (AXI_ACLK_st1[1]),
    .CLKOUT1B            (),
    .CLKOUT2             (AXI_ACLK_st1[2]),
    .CLKOUT2B            (),
    .CLKOUT3             (AXI_ACLK_st1[3]),
    .CLKOUT3B            (),
    .CLKOUT4             (AXI_ACLK_st1[4]),
    .CLKOUT5             (AXI_ACLK_st1[5]),
    .CLKOUT6             (AXI_ACLK_st1[6]),
     // Input clock control
    .CLKFBIN             (), //mmcm_fb
    .CLKIN1              (AXI_ACLK_IN_1_buf),
    .CLKIN2              (1'b0),
    // Other control and status signals
    .LOCKED              (),
    .PWRDWN              (1'b0),
    .RST                 (1'b1),
  
    .CDDCDONE            (),
    .CLKFBSTOPPED        (),
    .CLKINSTOPPED        (),
    .DO                  (),
    .DRDY                (),
    .PSDONE              (),
    .CDDCREQ             (1'b0),
    .CLKINSEL            (1'b1),
    .DADDR               (7'b0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'b0),
    .DWE                 (1'b0),
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0)
  );

    generate
        genvar i;
        for (i = 0; i <= 6; i = i + 1) begin : TOP_BLOCK_AXI
            BUFG u_AXI_ACLK_st0  ( .I (AXI_ACLK_st0[i]), .O (AXI_ACLK_st0_buf[i]) );
            BUFG u_AXI_ACLK_st1  ( .I (AXI_ACLK_st1[i]), .O (AXI_ACLK_st1_buf[i]) );
            always @ (posedge AXI_ACLK_st0_buf[i] or negedge AXI_ARESET_N_0) begin
                if (~AXI_ARESET_N_0) begin
                    axi_rst_st0_n[i] <= 1'b0;
                end else begin
                    axi_rst_st0_n[i] <= 1'b1;
                end
            end
            always @ (posedge AXI_ACLK_st1_buf[i] or negedge AXI_ARESET_N_1) begin
                if (~AXI_ARESET_N_1) begin
                    axi_rst_st1_n[i] <= 1'b0;
                end else begin
                    axi_rst_st1_n[i] <= 1'b1;
                end
            end
        end
    endgenerate

    wire [VERTEX_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] vtx_generator_vtx_id;
    wire [VERTEX_PIPELINE_NUM - 1 : 0] vtx_generator_vtx_id_valid;

    wire [VERTEX_ID_WIDTH * VERTEX_PIPELINE_NUM - 1 : 0] off_generator_vtx_id;
    wire [VERTEX_ID_WIDTH * VERTEX_PIPELINE_NUM - 1 : 0] off_generator_offset;
    wire [VERTEX_PIPELINE_NUM - 1 : 0] off_generator_vtx_id_valid;

    wire [VERTEX_ID_WIDTH * VERTEX_PIPELINE_NUM - 1 : 0] edge_generator_src_id;
    wire [VERTEX_ID_WIDTH * VERTEX_PIPELINE_NUM - 1 : 0] edge_generator_dst_id;
    wire [VERTEX_PIPELINE_NUM - 1 : 0] edge_generator_valid;

    wire [HBM_AWIDTH_PER_CHANNEL * HBM_CHANNEL_NUM - 1 : 0] hbm_read_addr;
    wire [HBM_CHANNEL_NUM - 1 : 0] hbm_read_addr_valid;

    wire [HBM_DWIDTH_PER_CHANNEL * HBM_CHANNEL_NUM - 1 : 0] hbm_read_data;
    wire [HBM_CHANNEL_NUM - 1 : 0] hbm_read_data_valid;

    wire [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega1_src_id_in;
    wire [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega1_dst_id_in;
    wire [2 * OMEGA_ARRAY_X - 1 : 0] omega1_valid_in;
    wire [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_v_in;
    wire [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_id_in;
    wire [2 * OMEGA_ARRAY_X - 1 : 0] omega2_valid_in;
    
    wire [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega1_src_id_out;
    wire [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega1_dst_id_out;
    wire [2 * OMEGA_ARRAY_X - 1 : 0] omega1_valid_out;
    wire [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_v_out;
    wire [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_id_out;
    wire [2 * OMEGA_ARRAY_X - 1 : 0] omega2_valid_out;

    wire [HBM_AWIDTH_PER_CHANNEL * HBM_CHANNEL_NUM - 1 : 0] hbm_write_addr;
    wire [HBM_DWIDTH_PER_CHANNEL * HBM_CHANNEL_NUM - 1 : 0] hbm_write_data;
    wire [HBM_CHANNEL_NUM - 1 : 0] hbm_write_valid;

    wire clk, rst;
    assign clk = AXI_ACLK_IN_0_buf;
    assign rst = AXI_ARESET_N_0;

    vtx_generator VTX_GENERATOR (
        .clk        (clk),
        .rst        (rst),

        .vtx_id     (vtx_generator_vtx_id),
        .vtx_id_valid   (vtx_generator_vtx_id_valid)
    );

    off_generator OFF_GENERATOR (
        .clk        (clk),
        .rst        (rst),
        .prev_vtx_id    (vtx_generator_vtx_id),
        .prev_vtx_id_valid  (vtx_generator_vtx_id_valid),

        .vtx_id     (off_generator_vtx_id),
        .offset (off_generator_offset),
        .vtx_id_valid (off_generator_vtx_id_valid)
    );
    assign hbm_read_addr = off_generator_offset;
    assign hbm_read_addr_valid = off_generator_vtx_id_valid;

    edge_generator EDGE_GENERATOR (
        .clk        (clk),
        .rst        (rst),
        .prev_vtx_id(off_generator_vtx_id),
        .prev_vtx_id_valid(off_generator_vtx_id_valid),
        .hbm_read_data  (hbm_read_data),
        .hbm_read_data_valid    (hbm_read_data_valid),

        .src_id     (edge_generator_src_id),
        .dst_id     (edge_generator_dst_id),
        .valid      (edge_generator_valid)
    );

    generate
        for (i = 0; i < 10; i = i + 1) begin : MEM_CONTROLLER_BLOCK_LOWWER
            mem_controller_single MEM_CONTROLLER_SINGLE_ST0_LOWWER (
                .axi_clk        (AXI_ACLK_st0_buf[i / 2]),
                .acc_clk        (clk),
                .rst            (rst),

                .hbm_read_addr  (hbm_read_addr[(i + 1) * HBM_AWIDTH_PER_CHANNEL - 1 : i * HBM_AWIDTH_PER_CHANNEL]),
                .hbm_read_addr_valid (hbm_read_addr_valid[i]),
                .hbm_write_addr (hbm_write_addr[(i + 1) * HBM_AWIDTH_PER_CHANNEL - 1 : i * HBM_AWIDTH_PER_CHANNEL]),
                .hbm_write_data (hbm_write_data[(i + 1) * HBM_DWIDTH_PER_CHANNEL - 1 : i * HBM_DWIDTH_PER_CHANNEL]),
                .hbm_write_valid(hbm_write_valid[i]),

                .hbm_read_data  (hbm_read_data[(i + 1) * HBM_DWIDTH_PER_CHANNEL - 1 : i * HBM_DWIDTH_PER_CHANNEL]),
                .hbm_read_data_valid(hbm_read_data_valid[i]),

                .axi_araddr     (AXI_ARADDR[i]),
                .axi_arburst    (AXI_ARBURST[i]),
                .axi_arid       (AXI_ARID[i]),
                .axi_arlen      (AXI_ARLEN[i]),
                .axi_arsize     (AXI_ARSIZE[i]),
                .axi_arvalid    (AXI_ARVALID[i]),
                .axi_awaddr     (AXI_AWADDR[i]),
                .axi_awburst    (AXI_AWBURST[i]),
                .axi_awid       (AXI_AWID[i]),
                .axi_awlen      (AXI_AWLEN[i]),
                .axi_awsize     (AXI_AWSIZE[i]),
                .axi_awvalid    (AXI_AWVALID[i]),
                .axi_rready     (AXI_RREADY[i]),
                .axi_bready     (AXI_BREADY[i]),
                .axi_wdata      (AXI_WDATA[i]),
                .axi_wlast      (AXI_WLAST[i]),
                .axi_wstrb      (AXI_WSTRB[i]),
                .axi_wdata_parity_i(AXI_WDATA_PARITY_i[i]),
                .axi_wdata_parity   (AXI_WDATA_PARITY[i]),
                .axi_wvalid     (AXI_WVALID[i]),
                .axi_arcache    (AXI_ARCACHE[i]),
                .axi_awcache    (AXI_AWCACHE[i]),
                .axi_awprot     (AXI_AWPROT[i]),

                .axi_arready    (AXI_ARREADY[i]),
                .axi_awready    (AXI_AWREADY[i]),
                .axi_rdata_parity (AXI_RDATA_PARITY[i]),
                .axi_rdata      (AXI_RDATA[i]),
                .axi_rid        (AXI_RID[i]),
                .axi_rlast      (AXI_RLAST[i]),
                .axi_rresp      (AXI_RRESP[i]),
                .axi_rvalid     (AXI_RVALID[i]),
                .axi_wready     (AXI_WREADY[i]),
                .axi_bid        (AXI_BID[i]),
                .axi_bresp      (AXI_BRESP[i]),
                .axi_bvalid     (AXI_BVALID[i])
            );
            mem_controller_single MEM_CONTROLLER_SINGLE_ST1_LOWWER (
                .axi_clk        (AXI_ACLK_st1_buf[i / 2]),
                .acc_clk        (clk),
                .rst            (rst),

                .hbm_read_addr  (hbm_read_addr[(i + 17) * HBM_AWIDTH_PER_CHANNEL - 1 : (i + 16) * HBM_AWIDTH_PER_CHANNEL]),
                .hbm_read_addr_valid (hbm_read_addr_valid[i + 16]),
                .hbm_write_addr (hbm_write_addr[(i + 17) * HBM_AWIDTH_PER_CHANNEL - 1 : (i + 16) * HBM_AWIDTH_PER_CHANNEL]),
                .hbm_write_data (hbm_write_data[(i + 17) * HBM_DWIDTH_PER_CHANNEL - 1 : (i + 16) * HBM_DWIDTH_PER_CHANNEL]),
                .hbm_write_valid(hbm_write_valid[i + 16]),

                .hbm_read_data  (hbm_read_data[(i + 17) * HBM_DWIDTH_PER_CHANNEL - 1 : (i + 16) * HBM_DWIDTH_PER_CHANNEL]),
                .hbm_read_data_valid(hbm_read_data_valid[i + 16]),

                .axi_araddr     (AXI_ARADDR[i + 16]),
                .axi_arburst    (AXI_ARBURST[i + 16]),
                .axi_arid       (AXI_ARID[i + 16]),
                .axi_arlen      (AXI_ARLEN[i + 16]),
                .axi_arsize     (AXI_ARSIZE[i + 16]),
                .axi_arvalid    (AXI_ARVALID[i + 16]),
                .axi_awaddr     (AXI_AWADDR[i + 16]),
                .axi_awburst    (AXI_AWBURST[i + 16]),
                .axi_awid       (AXI_AWID[i + 16]),
                .axi_awlen      (AXI_AWLEN[i + 16]),
                .axi_awsize     (AXI_AWSIZE[i + 16]),
                .axi_awvalid    (AXI_AWVALID[i + 16]),
                .axi_rready     (AXI_RREADY[i + 16]),
                .axi_bready     (AXI_BREADY[i + 16]),
                .axi_wdata      (AXI_WDATA[i + 16]),
                .axi_wlast      (AXI_WLAST[i + 16]),
                .axi_wstrb      (AXI_WSTRB[i + 16]),
                .axi_wdata_parity_i(AXI_WDATA_PARITY_i[i + 16]),
                .axi_wdata_parity   (AXI_WDATA_PARITY[i + 16]),
                .axi_wvalid     (AXI_WVALID[i + 16]),
                .axi_arcache    (AXI_ARCACHE[i + 16]),
                .axi_awcache    (AXI_AWCACHE[i + 16]),
                .axi_awprot     (AXI_AWPROT[i + 16]),

                .axi_arready    (AXI_ARREADY[i + 16]),
                .axi_awready    (AXI_AWREADY[i + 16]),
                .axi_rdata_parity (AXI_RDATA_PARITY[i + 16]),
                .axi_rdata      (AXI_RDATA[i + 16]),
                .axi_rid        (AXI_RID[i + 16]),
                .axi_rlast      (AXI_RLAST[i + 16]),
                .axi_rresp      (AXI_RRESP[i + 16]),
                .axi_rvalid     (AXI_RVALID[i + 16]),
                .axi_wready     (AXI_WREADY[i + 16]),
                .axi_bid        (AXI_BID[i + 16]),
                .axi_bresp      (AXI_BRESP[i + 16]),
                .axi_bvalid     (AXI_BVALID[i + 16])
            );
        end
        for (i = 10; i < 16; i = i + 1) begin : MEM_CONTROLLER_BLOCK_HIGHER
            mem_controller_single MEM_CONTROLLER_SINGLE_ST0_HIGHER (
                .axi_clk        (AXI_ACLK_st0_buf[(i - 1) / 3 + 2]),
                .acc_clk        (clk),
                .rst            (rst),

                .hbm_read_addr  (hbm_read_addr[(i + 1) * HBM_AWIDTH_PER_CHANNEL - 1 : i * HBM_AWIDTH_PER_CHANNEL]),
                .hbm_read_addr_valid (hbm_read_addr_valid[i]),
                .hbm_write_addr (hbm_write_addr[(i + 1) * HBM_AWIDTH_PER_CHANNEL - 1 : i * HBM_AWIDTH_PER_CHANNEL]),
                .hbm_write_data (hbm_write_data[(i + 1) * HBM_DWIDTH_PER_CHANNEL - 1 : i * HBM_DWIDTH_PER_CHANNEL]),
                .hbm_write_valid(hbm_write_valid[i]),

                .hbm_read_data  (hbm_read_data[(i + 1) * HBM_DWIDTH_PER_CHANNEL - 1 : i * HBM_DWIDTH_PER_CHANNEL]),
                .hbm_read_data_valid(hbm_read_data_valid[i]),

                .axi_araddr     (AXI_ARADDR[i]),
                .axi_arburst    (AXI_ARBURST[i]),
                .axi_arid       (AXI_ARID[i]),
                .axi_arlen      (AXI_ARLEN[i]),
                .axi_arsize     (AXI_ARSIZE[i]),
                .axi_arvalid    (AXI_ARVALID[i]),
                .axi_awaddr     (AXI_AWADDR[i]),
                .axi_awburst    (AXI_AWBURST[i]),
                .axi_awid       (AXI_AWID[i]),
                .axi_awlen      (AXI_AWLEN[i]),
                .axi_awsize     (AXI_AWSIZE[i]),
                .axi_awvalid    (AXI_AWVALID[i]),
                .axi_rready     (AXI_RREADY[i]),
                .axi_bready     (AXI_BREADY[i]),
                .axi_wdata      (AXI_WDATA[i]),
                .axi_wlast      (AXI_WLAST[i]),
                .axi_wstrb      (AXI_WSTRB[i]),
                .axi_wdata_parity_i(AXI_WDATA_PARITY_i[i]),
                .axi_wdata_parity   (AXI_WDATA_PARITY[i]),
                .axi_wvalid     (AXI_WVALID[i]),
                .axi_arcache    (AXI_ARCACHE[i]),
                .axi_awcache    (AXI_AWCACHE[i]),
                .axi_awprot     (AXI_AWPROT[i]),

                .axi_arready    (AXI_ARREADY[i]),
                .axi_awready    (AXI_AWREADY[i]),
                .axi_rdata_parity (AXI_RDATA_PARITY[i]),
                .axi_rdata      (AXI_RDATA[i]),
                .axi_rid        (AXI_RID[i]),
                .axi_rlast      (AXI_RLAST[i]),
                .axi_rresp      (AXI_RRESP[i]),
                .axi_rvalid     (AXI_RVALID[i]),
                .axi_wready     (AXI_WREADY[i]),
                .axi_bid        (AXI_BID[i]),
                .axi_bresp      (AXI_BRESP[i]),
                .axi_bvalid     (AXI_BVALID[i])
            );
            mem_controller_single MEM_CONTROLLER_SINGLE_ST1_HIGHER (
                .axi_clk        (AXI_ACLK_st1_buf[(i - 1) / 3 + 2]),
                .acc_clk        (clk),
                .rst            (rst),

                .hbm_read_addr  (hbm_read_addr[(i + 17) * HBM_AWIDTH_PER_CHANNEL - 1 : (i + 16) * HBM_AWIDTH_PER_CHANNEL]),
                .hbm_read_addr_valid (hbm_read_addr_valid[i + 16]),
                .hbm_write_addr (hbm_write_addr[(i + 17) * HBM_AWIDTH_PER_CHANNEL - 1 : (i + 16) * HBM_AWIDTH_PER_CHANNEL]),
                .hbm_write_data (hbm_write_data[(i + 17) * HBM_DWIDTH_PER_CHANNEL - 1 : (i + 16) * HBM_DWIDTH_PER_CHANNEL]),
                .hbm_write_valid(hbm_write_valid[i + 16]),

                .hbm_read_data  (hbm_read_data[(i + 17) * HBM_DWIDTH_PER_CHANNEL - 1 : (i + 16) * HBM_DWIDTH_PER_CHANNEL]),
                .hbm_read_data_valid(hbm_read_data_valid[i + 16]),

                .axi_araddr     (AXI_ARADDR[i + 16]),
                .axi_arburst    (AXI_ARBURST[i + 16]),
                .axi_arid       (AXI_ARID[i + 16]),
                .axi_arlen      (AXI_ARLEN[i + 16]),
                .axi_arsize     (AXI_ARSIZE[i + 16]),
                .axi_arvalid    (AXI_ARVALID[i + 16]),
                .axi_awaddr     (AXI_AWADDR[i + 16]),
                .axi_awburst    (AXI_AWBURST[i + 16]),
                .axi_awid       (AXI_AWID[i + 16]),
                .axi_awlen      (AXI_AWLEN[i + 16]),
                .axi_awsize     (AXI_AWSIZE[i + 16]),
                .axi_awvalid    (AXI_AWVALID[i + 16]),
                .axi_rready     (AXI_RREADY[i + 16]),
                .axi_bready     (AXI_BREADY[i + 16]),
                .axi_wdata      (AXI_WDATA[i + 16]),
                .axi_wlast      (AXI_WLAST[i + 16]),
                .axi_wstrb      (AXI_WSTRB[i + 16]),
                .axi_wdata_parity_i(AXI_WDATA_PARITY_i[i + 16]),
                .axi_wdata_parity   (AXI_WDATA_PARITY[i + 16]),
                .axi_wvalid     (AXI_WVALID[i + 16]),
                .axi_arcache    (AXI_ARCACHE[i + 16]),
                .axi_awcache    (AXI_AWCACHE[i + 16]),
                .axi_awprot     (AXI_AWPROT[i + 16]),

                .axi_arready    (AXI_ARREADY[i + 16]),
                .axi_awready    (AXI_AWREADY[i + 16]),
                .axi_rdata_parity (AXI_RDATA_PARITY[i + 16]),
                .axi_rdata      (AXI_RDATA[i + 16]),
                .axi_rid        (AXI_RID[i + 16]),
                .axi_rlast      (AXI_RLAST[i + 16]),
                .axi_rresp      (AXI_RRESP[i + 16]),
                .axi_rvalid     (AXI_RVALID[i + 16]),
                .axi_wready     (AXI_WREADY[i + 16]),
                .axi_bid        (AXI_BID[i + 16]),
                .axi_bresp      (AXI_BRESP[i + 16]),
                .axi_bvalid     (AXI_BVALID[i + 16])
            );
        end
    endgenerate

    wire     [ 31:0]  APB_0_PWDATA = 32'b0;
    wire     [ 21:0]  APB_0_PADDR  = 22'b0;
    wire              APB_0_PENABLE = 1'b0;
    wire              APB_0_PSEL = 1'b0;
    wire              APB_0_PWRITE = 1'b0;
    wire     [ 31:0]  APB_0_PRDATA;
    wire              APB_0_PREADY;
    wire              APB_0_PSLVERR;

    wire     [ 31:0]  APB_1_PWDATA = 32'b0;
    wire     [ 21:0]  APB_1_PADDR = 22'b0;
    wire              APB_1_PENABLE = 1'b0;
    wire              APB_1_PSEL = 1'b0;
    wire              APB_1_PWRITE = 1'b0;
    wire     [ 31:0]  APB_1_PRDATA;
    wire              APB_1_PREADY;
    wire              APB_1_PSLVERR;

    wire          DRAM_0_STAT_CATTRIP;
    wire [  6:0]  DRAM_0_STAT_TEMP;
  
    wire          DRAM_1_STAT_CATTRIP;
    wire [  6:0]  DRAM_1_STAT_TEMP;

    hbm_ip u_hbm_ip
(
  .HBM_REF_CLK_0                 (HBM_REF_CLK_0)
  ,.HBM_REF_CLK_1                (HBM_REF_CLK_1)
  
  ,.AXI_00_ACLK                  (AXI_ACLK_st0_buf[0]     )
  ,.AXI_00_ARESET_N              (axi_rst_st0_n[0]        )
  ,.AXI_00_ARADDR                (AXI_ARADDR[0]      )
  ,.AXI_00_ARBURST               (AXI_ARBURST[0]     )
  ,.AXI_00_ARID                  (AXI_ARID[0]        )
  ,.AXI_00_ARLEN                 (AXI_ARLEN[0][3:0]  )
  ,.AXI_00_ARSIZE                (AXI_ARSIZE[0]      )
  ,.AXI_00_ARVALID               (AXI_ARVALID[0]     )
  ,.AXI_00_AWADDR                (AXI_AWADDR[0]      )
  ,.AXI_00_AWBURST               (AXI_AWBURST[0]     )
  ,.AXI_00_AWID                  (AXI_AWID[0]        )
  ,.AXI_00_AWLEN                 (AXI_AWLEN[0][3:0]  )
  ,.AXI_00_AWSIZE                (AXI_AWSIZE[0]      )
  ,.AXI_00_AWVALID               (AXI_AWVALID[0]     )
  ,.AXI_00_RREADY                (AXI_RREADY[0]      )
  ,.AXI_00_BREADY                (AXI_BREADY[0]      )
  ,.AXI_00_WDATA                 (AXI_WDATA[0]       )
  ,.AXI_00_WLAST                 (AXI_WLAST[0]       )
  ,.AXI_00_WSTRB                 (AXI_WSTRB[0]       )
  ,.AXI_00_WDATA_PARITY          (AXI_WDATA_PARITY_i[0])
  ,.AXI_00_WVALID                (AXI_WVALID[0]      )
  
  ,.AXI_01_ACLK                  (AXI_ACLK_st0_buf[0]     )
  ,.AXI_01_ARESET_N              (axi_rst_st0_n[0]        )
  ,.AXI_01_ARADDR                (AXI_ARADDR[1]      )
  ,.AXI_01_ARBURST               (AXI_ARBURST[1]     )
  ,.AXI_01_ARID                  (AXI_ARID[1]        )
  ,.AXI_01_ARLEN                 (AXI_ARLEN[1][3:0]  )
  ,.AXI_01_ARSIZE                (AXI_ARSIZE[1]      )
  ,.AXI_01_ARVALID               (AXI_ARVALID[1]     )
  ,.AXI_01_AWADDR                (AXI_AWADDR[1]      )
  ,.AXI_01_AWBURST               (AXI_AWBURST[1]     )
  ,.AXI_01_AWID                  (AXI_AWID[1]        )
  ,.AXI_01_AWLEN                 (AXI_AWLEN[1][3:0]  )
  ,.AXI_01_AWSIZE                (AXI_AWSIZE[1]      )
  ,.AXI_01_AWVALID               (AXI_AWVALID[1]     )
  ,.AXI_01_RREADY                (AXI_RREADY[1]      )
  ,.AXI_01_BREADY                (AXI_BREADY[1]      )
  ,.AXI_01_WDATA                 (AXI_WDATA[1]       )
  ,.AXI_01_WLAST                 (AXI_WLAST[1]       )
  ,.AXI_01_WSTRB                 (AXI_WSTRB[1]       )
  ,.AXI_01_WDATA_PARITY          (AXI_WDATA_PARITY_i[1])
  ,.AXI_01_WVALID                (AXI_WVALID[1]      )
  
  ,.AXI_02_ACLK                  (AXI_ACLK_st0_buf[1]     )
  ,.AXI_02_ARESET_N              (axi_rst_st0_n[1]        )
  ,.AXI_02_ARADDR                (AXI_ARADDR[2]      )
  ,.AXI_02_ARBURST               (AXI_ARBURST[2]     )
  ,.AXI_02_ARID                  (AXI_ARID[2]        )
  ,.AXI_02_ARLEN                 (AXI_ARLEN[2][3:0]  )
  ,.AXI_02_ARSIZE                (AXI_ARSIZE[2]      )
  ,.AXI_02_ARVALID               (AXI_ARVALID[2]     )
  ,.AXI_02_AWADDR                (AXI_AWADDR[2]      )
  ,.AXI_02_AWBURST               (AXI_AWBURST[2]     )
  ,.AXI_02_AWID                  (AXI_AWID[2]        )
  ,.AXI_02_AWLEN                 (AXI_AWLEN[2][3:0]  )
  ,.AXI_02_AWSIZE                (AXI_AWSIZE[2]      )
  ,.AXI_02_AWVALID               (AXI_AWVALID[2]     )
  ,.AXI_02_RREADY                (AXI_RREADY[2]      )
  ,.AXI_02_BREADY                (AXI_BREADY[2]      )
  ,.AXI_02_WDATA                 (AXI_WDATA[2]       )
  ,.AXI_02_WLAST                 (AXI_WLAST[2]       )
  ,.AXI_02_WSTRB                 (AXI_WSTRB[2]       )
  ,.AXI_02_WDATA_PARITY          (AXI_WDATA_PARITY_i[2])
  ,.AXI_02_WVALID                (AXI_WVALID[2]      )
  ,.AXI_03_ACLK                  (AXI_ACLK_st0_buf[1]     )
  ,.AXI_03_ARESET_N              (axi_rst_st0_n[1]        )
  ,.AXI_03_ARADDR                (AXI_ARADDR[3]      )
  ,.AXI_03_ARBURST               (AXI_ARBURST[3]     )
  ,.AXI_03_ARID                  (AXI_ARID[3]        )
  ,.AXI_03_ARLEN                 (AXI_ARLEN[3][3:0]  )
  ,.AXI_03_ARSIZE                (AXI_ARSIZE[3]      )
  ,.AXI_03_ARVALID               (AXI_ARVALID[3]     )
  ,.AXI_03_AWADDR                (AXI_AWADDR[3]      )
  ,.AXI_03_AWBURST               (AXI_AWBURST[3]     )
  ,.AXI_03_AWID                  (AXI_AWID[3]        )
  ,.AXI_03_AWLEN                 (AXI_AWLEN[3][3:0]  )
  ,.AXI_03_AWSIZE                (AXI_AWSIZE[3]      )
  ,.AXI_03_AWVALID               (AXI_AWVALID[3]     )
  ,.AXI_03_RREADY                (AXI_RREADY[3]      )
  ,.AXI_03_BREADY                (AXI_BREADY[3]      )
  ,.AXI_03_WDATA                 (AXI_WDATA[3]       )
  ,.AXI_03_WLAST                 (AXI_WLAST[3]       )
  ,.AXI_03_WSTRB                 (AXI_WSTRB[3]       )
  ,.AXI_03_WDATA_PARITY          (AXI_WDATA_PARITY_i[3])
  ,.AXI_03_WVALID                (AXI_WVALID[3]      )
  ,.AXI_04_ACLK                  (AXI_ACLK_st0_buf[2]     )
  ,.AXI_04_ARESET_N              (axi_rst_st0_n[2]        )
  ,.AXI_04_ARADDR                (AXI_ARADDR[4]      )
  ,.AXI_04_ARBURST               (AXI_ARBURST[4]     )
  ,.AXI_04_ARID                  (AXI_ARID[4]        )
  ,.AXI_04_ARLEN                 (AXI_ARLEN[4][3:0]  )
  ,.AXI_04_ARSIZE                (AXI_ARSIZE[4]      )
  ,.AXI_04_ARVALID               (AXI_ARVALID[4]     )
  ,.AXI_04_AWADDR                (AXI_AWADDR[4]      )
  ,.AXI_04_AWBURST               (AXI_AWBURST[4]     )
  ,.AXI_04_AWID                  (AXI_AWID[4]        )
  ,.AXI_04_AWLEN                 (AXI_AWLEN[4][3:0]  )
  ,.AXI_04_AWSIZE                (AXI_AWSIZE[4]      )
  ,.AXI_04_AWVALID               (AXI_AWVALID[4]     )
  ,.AXI_04_RREADY                (AXI_RREADY[4]      )
  ,.AXI_04_BREADY                (AXI_BREADY[4]      )
  ,.AXI_04_WDATA                 (AXI_WDATA[4]       )
  ,.AXI_04_WLAST                 (AXI_WLAST[4]       )
  ,.AXI_04_WSTRB                 (AXI_WSTRB[4]       )
  ,.AXI_04_WDATA_PARITY          (AXI_WDATA_PARITY_i[4])
  ,.AXI_04_WVALID                (AXI_WVALID[4]      )
  ,.AXI_05_ACLK                  (AXI_ACLK_st0_buf[2]     )
  ,.AXI_05_ARESET_N              (axi_rst_st0_n[2]        )
  ,.AXI_05_ARADDR                (AXI_ARADDR[5]      )
  ,.AXI_05_ARBURST               (AXI_ARBURST[5]     )
  ,.AXI_05_ARID                  (AXI_ARID[5]        )
  ,.AXI_05_ARLEN                 (AXI_ARLEN[5][3:0]  )
  ,.AXI_05_ARSIZE                (AXI_ARSIZE[5]      )
  ,.AXI_05_ARVALID               (AXI_ARVALID[5]     )
  ,.AXI_05_AWADDR                (AXI_AWADDR[5]      )
  ,.AXI_05_AWBURST               (AXI_AWBURST[5]     )
  ,.AXI_05_AWID                  (AXI_AWID[5]        )
  ,.AXI_05_AWLEN                 (AXI_AWLEN[5][3:0]  )
  ,.AXI_05_AWSIZE                (AXI_AWSIZE[5]      )
  ,.AXI_05_AWVALID               (AXI_AWVALID[5]     )
  ,.AXI_05_RREADY                (AXI_RREADY[5]      )
  ,.AXI_05_BREADY                (AXI_BREADY[5]      )
  ,.AXI_05_WDATA                 (AXI_WDATA[5]       )
  ,.AXI_05_WLAST                 (AXI_WLAST[5]       )
  ,.AXI_05_WSTRB                 (AXI_WSTRB[5]       )
  ,.AXI_05_WDATA_PARITY          (AXI_WDATA_PARITY_i[5])
  ,.AXI_05_WVALID                (AXI_WVALID[5]      )
  ,.AXI_06_ACLK                  (AXI_ACLK_st0_buf[3]     )
  ,.AXI_06_ARESET_N              (axi_rst_st0_n[3]        )
  ,.AXI_06_ARADDR                (AXI_ARADDR[6]      )
  ,.AXI_06_ARBURST               (AXI_ARBURST[6]     )
  ,.AXI_06_ARID                  (AXI_ARID[6]        )
  ,.AXI_06_ARLEN                 (AXI_ARLEN[6][3:0]  )
  ,.AXI_06_ARSIZE                (AXI_ARSIZE[6]      )
  ,.AXI_06_ARVALID               (AXI_ARVALID[6]     )
  ,.AXI_06_AWADDR                (AXI_AWADDR[6]      )
  ,.AXI_06_AWBURST               (AXI_AWBURST[6]     )
  ,.AXI_06_AWID                  (AXI_AWID[6]        )
  ,.AXI_06_AWLEN                 (AXI_AWLEN[6][3:0]  )
  ,.AXI_06_AWSIZE                (AXI_AWSIZE[6]      )
  ,.AXI_06_AWVALID               (AXI_AWVALID[6]     )
  ,.AXI_06_RREADY                (AXI_RREADY[6]      )
  ,.AXI_06_BREADY                (AXI_BREADY[6]      )
  ,.AXI_06_WDATA                 (AXI_WDATA[6]       )
  ,.AXI_06_WLAST                 (AXI_WLAST[6]       )
  ,.AXI_06_WSTRB                 (AXI_WSTRB[6]       )
  ,.AXI_06_WDATA_PARITY          (AXI_WDATA_PARITY_i[6])
  ,.AXI_06_WVALID                (AXI_WVALID[6]      )
  ,.AXI_07_ACLK                  (AXI_ACLK_st0_buf[3]     )
  ,.AXI_07_ARESET_N              (axi_rst_st0_n[3]        )
  ,.AXI_07_ARADDR                (AXI_ARADDR[7]      )
  ,.AXI_07_ARBURST               (AXI_ARBURST[7]     )
  ,.AXI_07_ARID                  (AXI_ARID[7]        )
  ,.AXI_07_ARLEN                 (AXI_ARLEN[7][3:0]  )
  ,.AXI_07_ARSIZE                (AXI_ARSIZE[7]      )
  ,.AXI_07_ARVALID               (AXI_ARVALID[7]     )
  ,.AXI_07_AWADDR                (AXI_AWADDR[7]      )
  ,.AXI_07_AWBURST               (AXI_AWBURST[7]     )
  ,.AXI_07_AWID                  (AXI_AWID[7]        )
  ,.AXI_07_AWLEN                 (AXI_AWLEN[7][3:0]  )
  ,.AXI_07_AWSIZE                (AXI_AWSIZE[7]      )
  ,.AXI_07_AWVALID               (AXI_AWVALID[7]     )
  ,.AXI_07_RREADY                (AXI_RREADY[7]      )
  ,.AXI_07_BREADY                (AXI_BREADY[7]      )
  ,.AXI_07_WDATA                 (AXI_WDATA[7]       )
  ,.AXI_07_WLAST                 (AXI_WLAST[7]       )
  ,.AXI_07_WSTRB                 (AXI_WSTRB[7]       )
  ,.AXI_07_WDATA_PARITY          (AXI_WDATA_PARITY_i[7])
  ,.AXI_07_WVALID                (AXI_WVALID[7]      )
  ,.AXI_08_ACLK                  (AXI_ACLK_st0_buf[4]     )
  ,.AXI_08_ARESET_N              (axi_rst_st0_n[4]        )
  ,.AXI_08_ARADDR                (AXI_ARADDR[8]      )
  ,.AXI_08_ARBURST               (AXI_ARBURST[8]     )
  ,.AXI_08_ARID                  (AXI_ARID[8]        )
  ,.AXI_08_ARLEN                 (AXI_ARLEN[8][3:0]  )
  ,.AXI_08_ARSIZE                (AXI_ARSIZE[8]      )
  ,.AXI_08_ARVALID               (AXI_ARVALID[8]     )
  ,.AXI_08_AWADDR                (AXI_AWADDR[8]      )
  ,.AXI_08_AWBURST               (AXI_AWBURST[8]     )
  ,.AXI_08_AWID                  (AXI_AWID[8]        )
  ,.AXI_08_AWLEN                 (AXI_AWLEN[8][3:0]  )
  ,.AXI_08_AWSIZE                (AXI_AWSIZE[8]      )
  ,.AXI_08_AWVALID               (AXI_AWVALID[8]     )
  ,.AXI_08_RREADY                (AXI_RREADY[8]      )
  ,.AXI_08_BREADY                (AXI_BREADY[8]      )
  ,.AXI_08_WDATA                 (AXI_WDATA[8]       )
  ,.AXI_08_WLAST                 (AXI_WLAST[8]       )
  ,.AXI_08_WSTRB                 (AXI_WSTRB[8]       )
  ,.AXI_08_WDATA_PARITY          (AXI_WDATA_PARITY_i[8])
  ,.AXI_08_WVALID                (AXI_WVALID[8]      )
  ,.AXI_09_ACLK                  (AXI_ACLK_st0_buf[4]     )
  ,.AXI_09_ARESET_N              (axi_rst_st0_n[4]        )
  ,.AXI_09_ARADDR                (AXI_ARADDR[9]      )
  ,.AXI_09_ARBURST               (AXI_ARBURST[9]     )
  ,.AXI_09_ARID                  (AXI_ARID[9]        )
  ,.AXI_09_ARLEN                 (AXI_ARLEN[9][3:0]  )
  ,.AXI_09_ARSIZE                (AXI_ARSIZE[9]      )
  ,.AXI_09_ARVALID               (AXI_ARVALID[9]     )
  ,.AXI_09_AWADDR                (AXI_AWADDR[9]      )
  ,.AXI_09_AWBURST               (AXI_AWBURST[9]     )
  ,.AXI_09_AWID                  (AXI_AWID[9]        )
  ,.AXI_09_AWLEN                 (AXI_AWLEN[9][3:0]  )
  ,.AXI_09_AWSIZE                (AXI_AWSIZE[9]      )
  ,.AXI_09_AWVALID               (AXI_AWVALID[9]     )
  ,.AXI_09_RREADY                (AXI_RREADY[9]      )
  ,.AXI_09_BREADY                (AXI_BREADY[9]      )
  ,.AXI_09_WDATA                 (AXI_WDATA[9]       )
  ,.AXI_09_WLAST                 (AXI_WLAST[9]       )
  ,.AXI_09_WSTRB                 (AXI_WSTRB[9]       )
  ,.AXI_09_WDATA_PARITY          (AXI_WDATA_PARITY_i[9])
  ,.AXI_09_WVALID                (AXI_WVALID[9]      )
  ,.AXI_10_ACLK                  (AXI_ACLK_st0_buf[5]     )
  ,.AXI_10_ARESET_N              (axi_rst_st0_n[5]        )
  ,.AXI_10_ARADDR                (AXI_ARADDR[10]      )
  ,.AXI_10_ARBURST               (AXI_ARBURST[10]     )
  ,.AXI_10_ARID                  (AXI_ARID[10]        )
  ,.AXI_10_ARLEN                 (AXI_ARLEN[10][3:0]  )
  ,.AXI_10_ARSIZE                (AXI_ARSIZE[10]      )
  ,.AXI_10_ARVALID               (AXI_ARVALID[10]     )
  ,.AXI_10_AWADDR                (AXI_AWADDR[10]      )
  ,.AXI_10_AWBURST               (AXI_AWBURST[10]     )
  ,.AXI_10_AWID                  (AXI_AWID[10]        )
  ,.AXI_10_AWLEN                 (AXI_AWLEN[10][3:0]  )
  ,.AXI_10_AWSIZE                (AXI_AWSIZE[10]      )
  ,.AXI_10_AWVALID               (AXI_AWVALID[10]     )
  ,.AXI_10_RREADY                (AXI_RREADY[10]      )
  ,.AXI_10_BREADY                (AXI_BREADY[10]      )
  ,.AXI_10_WDATA                 (AXI_WDATA[10]       )
  ,.AXI_10_WLAST                 (AXI_WLAST[10]       )
  ,.AXI_10_WSTRB                 (AXI_WSTRB[10]       )
  ,.AXI_10_WDATA_PARITY          (AXI_WDATA_PARITY_i[10])
  ,.AXI_10_WVALID                (AXI_WVALID[10]      )
  ,.AXI_11_ACLK                  (AXI_ACLK_st0_buf[5]     )
  ,.AXI_11_ARESET_N              (axi_rst_st0_n[5]        )
  ,.AXI_11_ARADDR                (AXI_ARADDR[11]      )
  ,.AXI_11_ARBURST               (AXI_ARBURST[11]     )
  ,.AXI_11_ARID                  (AXI_ARID[11]        )
  ,.AXI_11_ARLEN                 (AXI_ARLEN[11][3:0]  )
  ,.AXI_11_ARSIZE                (AXI_ARSIZE[11]      )
  ,.AXI_11_ARVALID               (AXI_ARVALID[11]     )
  ,.AXI_11_AWADDR                (AXI_AWADDR[11]      )
  ,.AXI_11_AWBURST               (AXI_AWBURST[11]     )
  ,.AXI_11_AWID                  (AXI_AWID[11]        )
  ,.AXI_11_AWLEN                 (AXI_AWLEN[11][3:0]  )
  ,.AXI_11_AWSIZE                (AXI_AWSIZE[11]      )
  ,.AXI_11_AWVALID               (AXI_AWVALID[11]     )
  ,.AXI_11_RREADY                (AXI_RREADY[11]      )
  ,.AXI_11_BREADY                (AXI_BREADY[11]      )
  ,.AXI_11_WDATA                 (AXI_WDATA[11]       )
  ,.AXI_11_WLAST                 (AXI_WLAST[11]       )
  ,.AXI_11_WSTRB                 (AXI_WSTRB[11]       )
  ,.AXI_11_WDATA_PARITY          (AXI_WDATA_PARITY_i[11])
  ,.AXI_11_WVALID                (AXI_WVALID[11]      )
  ,.AXI_12_ACLK                  (AXI_ACLK_st0_buf[5]     )
  ,.AXI_12_ARESET_N              (axi_rst_st0_n[5]        )
  ,.AXI_12_ARADDR                (AXI_ARADDR[12]      )
  ,.AXI_12_ARBURST               (AXI_ARBURST[12]     )
  ,.AXI_12_ARID                  (AXI_ARID[12]        )
  ,.AXI_12_ARLEN                 (AXI_ARLEN[12][3:0]  )
  ,.AXI_12_ARSIZE                (AXI_ARSIZE[12]      )
  ,.AXI_12_ARVALID               (AXI_ARVALID[12]     )
  ,.AXI_12_AWADDR                (AXI_AWADDR[12]      )
  ,.AXI_12_AWBURST               (AXI_AWBURST[12]     )
  ,.AXI_12_AWID                  (AXI_AWID[12]        )
  ,.AXI_12_AWLEN                 (AXI_AWLEN[12][3:0]  )
  ,.AXI_12_AWSIZE                (AXI_AWSIZE[12]      )
  ,.AXI_12_AWVALID               (AXI_AWVALID[12]     )
  ,.AXI_12_RREADY                (AXI_RREADY[12]      )
  ,.AXI_12_BREADY                (AXI_BREADY[12]      )
  ,.AXI_12_WDATA                 (AXI_WDATA[12]       )
  ,.AXI_12_WLAST                 (AXI_WLAST[12]       )
  ,.AXI_12_WSTRB                 (AXI_WSTRB[12]       )
  ,.AXI_12_WDATA_PARITY          (AXI_WDATA_PARITY_i[12])
  ,.AXI_12_WVALID                (AXI_WVALID[12]      )
  ,.AXI_13_ACLK                  (AXI_ACLK_st0_buf[6]     )
  ,.AXI_13_ARESET_N              (axi_rst_st0_n[6]        )
  ,.AXI_13_ARADDR                (AXI_ARADDR[13]      )
  ,.AXI_13_ARBURST               (AXI_ARBURST[13]     )
  ,.AXI_13_ARID                  (AXI_ARID[13]        )
  ,.AXI_13_ARLEN                 (AXI_ARLEN[13][3:0]  )
  ,.AXI_13_ARSIZE                (AXI_ARSIZE[13]      )
  ,.AXI_13_ARVALID               (AXI_ARVALID[13]     )
  ,.AXI_13_AWADDR                (AXI_AWADDR[13]      )
  ,.AXI_13_AWBURST               (AXI_AWBURST[13]     )
  ,.AXI_13_AWID                  (AXI_AWID[13]        )
  ,.AXI_13_AWLEN                 (AXI_AWLEN[13][3:0]  )
  ,.AXI_13_AWSIZE                (AXI_AWSIZE[13]      )
  ,.AXI_13_AWVALID               (AXI_AWVALID[13]     )
  ,.AXI_13_RREADY                (AXI_RREADY[13]      )
  ,.AXI_13_BREADY                (AXI_BREADY[13]      )
  ,.AXI_13_WDATA                 (AXI_WDATA[13]       )
  ,.AXI_13_WLAST                 (AXI_WLAST[13]       )
  ,.AXI_13_WSTRB                 (AXI_WSTRB[13]       )
  ,.AXI_13_WDATA_PARITY          (AXI_WDATA_PARITY_i[13])
  ,.AXI_13_WVALID                (AXI_WVALID[13]      )
  ,.AXI_14_ACLK                  (AXI_ACLK_st0_buf[6]     )
  ,.AXI_14_ARESET_N              (axi_rst_st0_n[6]        )
  ,.AXI_14_ARADDR                (AXI_ARADDR[14]      )
  ,.AXI_14_ARBURST               (AXI_ARBURST[14]     )
  ,.AXI_14_ARID                  (AXI_ARID[14]        )
  ,.AXI_14_ARLEN                 (AXI_ARLEN[14][3:0]  )
  ,.AXI_14_ARSIZE                (AXI_ARSIZE[14]      )
  ,.AXI_14_ARVALID               (AXI_ARVALID[14]     )
  ,.AXI_14_AWADDR                (AXI_AWADDR[14]      )
  ,.AXI_14_AWBURST               (AXI_AWBURST[14]     )
  ,.AXI_14_AWID                  (AXI_AWID[14]        )
  ,.AXI_14_AWLEN                 (AXI_AWLEN[14][3:0]  )
  ,.AXI_14_AWSIZE                (AXI_AWSIZE[14]      )
  ,.AXI_14_AWVALID               (AXI_AWVALID[14]     )
  ,.AXI_14_RREADY                (AXI_RREADY[14]      )
  ,.AXI_14_BREADY                (AXI_BREADY[14]      )
  ,.AXI_14_WDATA                 (AXI_WDATA[14]       )
  ,.AXI_14_WLAST                 (AXI_WLAST[14]       )
  ,.AXI_14_WSTRB                 (AXI_WSTRB[14]       )
  ,.AXI_14_WDATA_PARITY          (AXI_WDATA_PARITY_i[14])
  ,.AXI_14_WVALID                (AXI_WVALID[14]      )
  ,.AXI_15_ACLK                  (AXI_ACLK_st0_buf[6]     )
  ,.AXI_15_ARESET_N              (axi_rst_st0_n[6]        )
  ,.AXI_15_ARADDR                (AXI_ARADDR[15]      )
  ,.AXI_15_ARBURST               (AXI_ARBURST[15]     )
  ,.AXI_15_ARID                  (AXI_ARID[15]        )
  ,.AXI_15_ARLEN                 (AXI_ARLEN[15][3:0]  )
  ,.AXI_15_ARSIZE                (AXI_ARSIZE[15]      )
  ,.AXI_15_ARVALID               (AXI_ARVALID[15]     )
  ,.AXI_15_AWADDR                (AXI_AWADDR[15]      )
  ,.AXI_15_AWBURST               (AXI_AWBURST[15]     )
  ,.AXI_15_AWID                  (AXI_AWID[15]        )
  ,.AXI_15_AWLEN                 (AXI_AWLEN[15][3:0]  )
  ,.AXI_15_AWSIZE                (AXI_AWSIZE[15]      )
  ,.AXI_15_AWVALID               (AXI_AWVALID[15]     )
  ,.AXI_15_RREADY                (AXI_RREADY[15]      )
  ,.AXI_15_BREADY                (AXI_BREADY[15]      )
  ,.AXI_15_WDATA                 (AXI_WDATA[15]       )
  ,.AXI_15_WLAST                 (AXI_WLAST[15]       )
  ,.AXI_15_WSTRB                 (AXI_WSTRB[15]       )
  ,.AXI_15_WDATA_PARITY          (AXI_WDATA_PARITY_i[15])
  ,.AXI_15_WVALID                (AXI_WVALID[15]      )
  ,.AXI_16_ACLK                  (AXI_ACLK_st1_buf[0]     )
  ,.AXI_16_ARESET_N              (axi_rst_st1_n[0]        )
  ,.AXI_16_ARADDR                (AXI_ARADDR[16]      )
  ,.AXI_16_ARBURST               (AXI_ARBURST[16]     )
  ,.AXI_16_ARID                  (AXI_ARID[16]        )
  ,.AXI_16_ARLEN                 (AXI_ARLEN[16][3:0]  )
  ,.AXI_16_ARSIZE                (AXI_ARSIZE[16]      )
  ,.AXI_16_ARVALID               (AXI_ARVALID[16]     )
  ,.AXI_16_AWADDR                (AXI_AWADDR[16]      )
  ,.AXI_16_AWBURST               (AXI_AWBURST[16]     )
  ,.AXI_16_AWID                  (AXI_AWID[16]        )
  ,.AXI_16_AWLEN                 (AXI_AWLEN[16][3:0]  )
  ,.AXI_16_AWSIZE                (AXI_AWSIZE[16]      )
  ,.AXI_16_AWVALID               (AXI_AWVALID[16]     )
  ,.AXI_16_RREADY                (AXI_RREADY[16]      )
  ,.AXI_16_BREADY                (AXI_BREADY[16]      )
  ,.AXI_16_WDATA                 (AXI_WDATA[16]       )
  ,.AXI_16_WLAST                 (AXI_WLAST[16]       )
  ,.AXI_16_WSTRB                 (AXI_WSTRB[16]       )
  ,.AXI_16_WDATA_PARITY          (AXI_WDATA_PARITY_i[16])
  ,.AXI_16_WVALID                (AXI_WVALID[16]      )
  ,.AXI_17_ACLK                  (AXI_ACLK_st1_buf[0]     )
  ,.AXI_17_ARESET_N              (axi_rst_st1_n[0]        )
  ,.AXI_17_ARADDR                (AXI_ARADDR[17]      )
  ,.AXI_17_ARBURST               (AXI_ARBURST[17]     )
  ,.AXI_17_ARID                  (AXI_ARID[17]        )
  ,.AXI_17_ARLEN                 (AXI_ARLEN[17][3:0]  )
  ,.AXI_17_ARSIZE                (AXI_ARSIZE[17]      )
  ,.AXI_17_ARVALID               (AXI_ARVALID[17]     )
  ,.AXI_17_AWADDR                (AXI_AWADDR[17]      )
  ,.AXI_17_AWBURST               (AXI_AWBURST[17]     )
  ,.AXI_17_AWID                  (AXI_AWID[17]        )
  ,.AXI_17_AWLEN                 (AXI_AWLEN[17][3:0]  )
  ,.AXI_17_AWSIZE                (AXI_AWSIZE[17]      )
  ,.AXI_17_AWVALID               (AXI_AWVALID[17]     )
  ,.AXI_17_RREADY                (AXI_RREADY[17]      )
  ,.AXI_17_BREADY                (AXI_BREADY[17]      )
  ,.AXI_17_WDATA                 (AXI_WDATA[17]       )
  ,.AXI_17_WLAST                 (AXI_WLAST[17]       )
  ,.AXI_17_WSTRB                 (AXI_WSTRB[17]       )
  ,.AXI_17_WDATA_PARITY          (AXI_WDATA_PARITY_i[17])
  ,.AXI_17_WVALID                (AXI_WVALID[17]      )
  ,.AXI_18_ACLK                  (AXI_ACLK_st1_buf[1]     )
  ,.AXI_18_ARESET_N              (axi_rst_st1_n[1]        )
  ,.AXI_18_ARADDR                (AXI_ARADDR[18]      )
  ,.AXI_18_ARBURST               (AXI_ARBURST[18]     )
  ,.AXI_18_ARID                  (AXI_ARID[18]        )
  ,.AXI_18_ARLEN                 (AXI_ARLEN[18][3:0]  )
  ,.AXI_18_ARSIZE                (AXI_ARSIZE[18]      )
  ,.AXI_18_ARVALID               (AXI_ARVALID[18]     )
  ,.AXI_18_AWADDR                (AXI_AWADDR[18]      )
  ,.AXI_18_AWBURST               (AXI_AWBURST[18]     )
  ,.AXI_18_AWID                  (AXI_AWID[18]        )
  ,.AXI_18_AWLEN                 (AXI_AWLEN[18][3:0]  )
  ,.AXI_18_AWSIZE                (AXI_AWSIZE[18]      )
  ,.AXI_18_AWVALID               (AXI_AWVALID[18]     )
  ,.AXI_18_RREADY                (AXI_RREADY[18]      )
  ,.AXI_18_BREADY                (AXI_BREADY[18]      )
  ,.AXI_18_WDATA                 (AXI_WDATA[18]       )
  ,.AXI_18_WLAST                 (AXI_WLAST[18]       )
  ,.AXI_18_WSTRB                 (AXI_WSTRB[18]       )
  ,.AXI_18_WDATA_PARITY          (AXI_WDATA_PARITY_i[18])
  ,.AXI_18_WVALID                (AXI_WVALID[18]      )
  ,.AXI_19_ACLK                  (AXI_ACLK_st1_buf[1]     )
  ,.AXI_19_ARESET_N              (axi_rst_st1_n[1]        )
  ,.AXI_19_ARADDR                (AXI_ARADDR[19]      )
  ,.AXI_19_ARBURST               (AXI_ARBURST[19]     )
  ,.AXI_19_ARID                  (AXI_ARID[19]        )
  ,.AXI_19_ARLEN                 (AXI_ARLEN[19][3:0]  )
  ,.AXI_19_ARSIZE                (AXI_ARSIZE[19]      )
  ,.AXI_19_ARVALID               (AXI_ARVALID[19]     )
  ,.AXI_19_AWADDR                (AXI_AWADDR[19]      )
  ,.AXI_19_AWBURST               (AXI_AWBURST[19]     )
  ,.AXI_19_AWID                  (AXI_AWID[19]        )
  ,.AXI_19_AWLEN                 (AXI_AWLEN[19][3:0]  )
  ,.AXI_19_AWSIZE                (AXI_AWSIZE[19]      )
  ,.AXI_19_AWVALID               (AXI_AWVALID[19]     )
  ,.AXI_19_RREADY                (AXI_RREADY[19]      )
  ,.AXI_19_BREADY                (AXI_BREADY[19]      )
  ,.AXI_19_WDATA                 (AXI_WDATA[19]       )
  ,.AXI_19_WLAST                 (AXI_WLAST[19]       )
  ,.AXI_19_WSTRB                 (AXI_WSTRB[19]       )
  ,.AXI_19_WDATA_PARITY          (AXI_WDATA_PARITY_i[19])
  ,.AXI_19_WVALID                (AXI_WVALID[19]      )
  ,.AXI_20_ACLK                  (AXI_ACLK_st1_buf[2]     )
  ,.AXI_20_ARESET_N              (axi_rst_st1_n[2]        )
  ,.AXI_20_ARADDR                (AXI_ARADDR[20]      )
  ,.AXI_20_ARBURST               (AXI_ARBURST[20]     )
  ,.AXI_20_ARID                  (AXI_ARID[20]        )
  ,.AXI_20_ARLEN                 (AXI_ARLEN[20][3:0]  )
  ,.AXI_20_ARSIZE                (AXI_ARSIZE[20]      )
  ,.AXI_20_ARVALID               (AXI_ARVALID[20]     )
  ,.AXI_20_AWADDR                (AXI_AWADDR[20]      )
  ,.AXI_20_AWBURST               (AXI_AWBURST[20]     )
  ,.AXI_20_AWID                  (AXI_AWID[20]        )
  ,.AXI_20_AWLEN                 (AXI_AWLEN[20][3:0]  )
  ,.AXI_20_AWSIZE                (AXI_AWSIZE[20]      )
  ,.AXI_20_AWVALID               (AXI_AWVALID[20]     )
  ,.AXI_20_RREADY                (AXI_RREADY[20]      )
  ,.AXI_20_BREADY                (AXI_BREADY[20]      )
  ,.AXI_20_WDATA                 (AXI_WDATA[20]       )
  ,.AXI_20_WLAST                 (AXI_WLAST[20]       )
  ,.AXI_20_WSTRB                 (AXI_WSTRB[20]       )
  ,.AXI_20_WDATA_PARITY          (AXI_WDATA_PARITY_i[20])
  ,.AXI_20_WVALID                (AXI_WVALID[20]      )
  ,.AXI_21_ACLK                  (AXI_ACLK_st1_buf[2]     )
  ,.AXI_21_ARESET_N              (axi_rst_st1_n[2]        )
  ,.AXI_21_ARADDR                (AXI_ARADDR[21]      )
  ,.AXI_21_ARBURST               (AXI_ARBURST[21]     )
  ,.AXI_21_ARID                  (AXI_ARID[21]        )
  ,.AXI_21_ARLEN                 (AXI_ARLEN[21][3:0]  )
  ,.AXI_21_ARSIZE                (AXI_ARSIZE[21]      )
  ,.AXI_21_ARVALID               (AXI_ARVALID[21]     )
  ,.AXI_21_AWADDR                (AXI_AWADDR[21]      )
  ,.AXI_21_AWBURST               (AXI_AWBURST[21]     )
  ,.AXI_21_AWID                  (AXI_AWID[21]        )
  ,.AXI_21_AWLEN                 (AXI_AWLEN[21][3:0]  )
  ,.AXI_21_AWSIZE                (AXI_AWSIZE[21]      )
  ,.AXI_21_AWVALID               (AXI_AWVALID[21]     )
  ,.AXI_21_RREADY                (AXI_RREADY[21]      )
  ,.AXI_21_BREADY                (AXI_BREADY[21]      )
  ,.AXI_21_WDATA                 (AXI_WDATA[21]       )
  ,.AXI_21_WLAST                 (AXI_WLAST[21]       )
  ,.AXI_21_WSTRB                 (AXI_WSTRB[21]       )
  ,.AXI_21_WDATA_PARITY          (AXI_WDATA_PARITY_i[21])
  ,.AXI_21_WVALID                (AXI_WVALID[21]      )
  ,.AXI_22_ACLK                  (AXI_ACLK_st1_buf[3]     )
  ,.AXI_22_ARESET_N              (axi_rst_st1_n[3]        )
  ,.AXI_22_ARADDR                (AXI_ARADDR[22]      )
  ,.AXI_22_ARBURST               (AXI_ARBURST[22]     )
  ,.AXI_22_ARID                  (AXI_ARID[22]        )
  ,.AXI_22_ARLEN                 (AXI_ARLEN[22][3:0]  )
  ,.AXI_22_ARSIZE                (AXI_ARSIZE[22]      )
  ,.AXI_22_ARVALID               (AXI_ARVALID[22]     )
  ,.AXI_22_AWADDR                (AXI_AWADDR[22]      )
  ,.AXI_22_AWBURST               (AXI_AWBURST[22]     )
  ,.AXI_22_AWID                  (AXI_AWID[22]        )
  ,.AXI_22_AWLEN                 (AXI_AWLEN[22][3:0]  )
  ,.AXI_22_AWSIZE                (AXI_AWSIZE[22]      )
  ,.AXI_22_AWVALID               (AXI_AWVALID[22]     )
  ,.AXI_22_RREADY                (AXI_RREADY[22]      )
  ,.AXI_22_BREADY                (AXI_BREADY[22]      )
  ,.AXI_22_WDATA                 (AXI_WDATA[22]       )
  ,.AXI_22_WLAST                 (AXI_WLAST[22]       )
  ,.AXI_22_WSTRB                 (AXI_WSTRB[22]       )
  ,.AXI_22_WDATA_PARITY          (AXI_WDATA_PARITY_i[22])
  ,.AXI_22_WVALID                (AXI_WVALID[22]      )
  ,.AXI_23_ACLK                  (AXI_ACLK_st1_buf[3]     )
  ,.AXI_23_ARESET_N              (axi_rst_st1_n[3]        )
  ,.AXI_23_ARADDR                (AXI_ARADDR[23]      )
  ,.AXI_23_ARBURST               (AXI_ARBURST[23]     )
  ,.AXI_23_ARID                  (AXI_ARID[23]        )
  ,.AXI_23_ARLEN                 (AXI_ARLEN[23][3:0]  )
  ,.AXI_23_ARSIZE                (AXI_ARSIZE[23]      )
  ,.AXI_23_ARVALID               (AXI_ARVALID[23]     )
  ,.AXI_23_AWADDR                (AXI_AWADDR[23]      )
  ,.AXI_23_AWBURST               (AXI_AWBURST[23]     )
  ,.AXI_23_AWID                  (AXI_AWID[23]        )
  ,.AXI_23_AWLEN                 (AXI_AWLEN[23][3:0]  )
  ,.AXI_23_AWSIZE                (AXI_AWSIZE[23]      )
  ,.AXI_23_AWVALID               (AXI_AWVALID[23]     )
  ,.AXI_23_RREADY                (AXI_RREADY[23]      )
  ,.AXI_23_BREADY                (AXI_BREADY[23]      )
  ,.AXI_23_WDATA                 (AXI_WDATA[23]       )
  ,.AXI_23_WLAST                 (AXI_WLAST[23]       )
  ,.AXI_23_WSTRB                 (AXI_WSTRB[23]       )
  ,.AXI_23_WDATA_PARITY          (AXI_WDATA_PARITY_i[23])
  ,.AXI_23_WVALID                (AXI_WVALID[23]      )
  ,.AXI_24_ACLK                  (AXI_ACLK_st1_buf[4]     )
  ,.AXI_24_ARESET_N              (axi_rst_st1_n[4]        )
  ,.AXI_24_ARADDR                (AXI_ARADDR[24]      )
  ,.AXI_24_ARBURST               (AXI_ARBURST[24]     )
  ,.AXI_24_ARID                  (AXI_ARID[24]        )
  ,.AXI_24_ARLEN                 (AXI_ARLEN[24][3:0]  )
  ,.AXI_24_ARSIZE                (AXI_ARSIZE[24]      )
  ,.AXI_24_ARVALID               (AXI_ARVALID[24]     )
  ,.AXI_24_AWADDR                (AXI_AWADDR[24]      )
  ,.AXI_24_AWBURST               (AXI_AWBURST[24]     )
  ,.AXI_24_AWID                  (AXI_AWID[24]        )
  ,.AXI_24_AWLEN                 (AXI_AWLEN[24][3:0]  )
  ,.AXI_24_AWSIZE                (AXI_AWSIZE[24]      )
  ,.AXI_24_AWVALID               (AXI_AWVALID[24]     )
  ,.AXI_24_RREADY                (AXI_RREADY[24]      )
  ,.AXI_24_BREADY                (AXI_BREADY[24]      )
  ,.AXI_24_WDATA                 (AXI_WDATA[24]       )
  ,.AXI_24_WLAST                 (AXI_WLAST[24]       )
  ,.AXI_24_WSTRB                 (AXI_WSTRB[24]       )
  ,.AXI_24_WDATA_PARITY          (AXI_WDATA_PARITY_i[24])
  ,.AXI_24_WVALID                (AXI_WVALID[24]      )
  ,.AXI_25_ACLK                  (AXI_ACLK_st1_buf[4]     )
  ,.AXI_25_ARESET_N              (axi_rst_st1_n[4]        )
  ,.AXI_25_ARADDR                (AXI_ARADDR[25]      )
  ,.AXI_25_ARBURST               (AXI_ARBURST[25]     )
  ,.AXI_25_ARID                  (AXI_ARID[25]        )
  ,.AXI_25_ARLEN                 (AXI_ARLEN[25][3:0]  )
  ,.AXI_25_ARSIZE                (AXI_ARSIZE[25]      )
  ,.AXI_25_ARVALID               (AXI_ARVALID[25]     )
  ,.AXI_25_AWADDR                (AXI_AWADDR[25]      )
  ,.AXI_25_AWBURST               (AXI_AWBURST[25]     )
  ,.AXI_25_AWID                  (AXI_AWID[25]        )
  ,.AXI_25_AWLEN                 (AXI_AWLEN[25][3:0]  )
  ,.AXI_25_AWSIZE                (AXI_AWSIZE[25]      )
  ,.AXI_25_AWVALID               (AXI_AWVALID[25]     )
  ,.AXI_25_RREADY                (AXI_RREADY[25]      )
  ,.AXI_25_BREADY                (AXI_BREADY[25]      )
  ,.AXI_25_WDATA                 (AXI_WDATA[25]       )
  ,.AXI_25_WLAST                 (AXI_WLAST[25]       )
  ,.AXI_25_WSTRB                 (AXI_WSTRB[25]       )
  ,.AXI_25_WDATA_PARITY          (AXI_WDATA_PARITY_i[25])
  ,.AXI_25_WVALID                (AXI_WVALID[25]      )
  ,.AXI_26_ACLK                  (AXI_ACLK_st1_buf[5]     )
  ,.AXI_26_ARESET_N              (axi_rst_st1_n[5]        )
  ,.AXI_26_ARADDR                (AXI_ARADDR[26]      )
  ,.AXI_26_ARBURST               (AXI_ARBURST[26]     )
  ,.AXI_26_ARID                  (AXI_ARID[26]        )
  ,.AXI_26_ARLEN                 (AXI_ARLEN[26][3:0]  )
  ,.AXI_26_ARSIZE                (AXI_ARSIZE[26]      )
  ,.AXI_26_ARVALID               (AXI_ARVALID[26]     )
  ,.AXI_26_AWADDR                (AXI_AWADDR[26]      )
  ,.AXI_26_AWBURST               (AXI_AWBURST[26]     )
  ,.AXI_26_AWID                  (AXI_AWID[26]        )
  ,.AXI_26_AWLEN                 (AXI_AWLEN[26][3:0]  )
  ,.AXI_26_AWSIZE                (AXI_AWSIZE[26]      )
  ,.AXI_26_AWVALID               (AXI_AWVALID[26]     )
  ,.AXI_26_RREADY                (AXI_RREADY[26]      )
  ,.AXI_26_BREADY                (AXI_BREADY[26]      )
  ,.AXI_26_WDATA                 (AXI_WDATA[26]       )
  ,.AXI_26_WLAST                 (AXI_WLAST[26]       )
  ,.AXI_26_WSTRB                 (AXI_WSTRB[26]       )
  ,.AXI_26_WDATA_PARITY          (AXI_WDATA_PARITY_i[26])
  ,.AXI_26_WVALID                (AXI_WVALID[26]      )
  ,.AXI_27_ACLK                  (AXI_ACLK_st1_buf[5]     )
  ,.AXI_27_ARESET_N              (axi_rst_st1_n[5]        )
  ,.AXI_27_ARADDR                (AXI_ARADDR[27]      )
  ,.AXI_27_ARBURST               (AXI_ARBURST[27]     )
  ,.AXI_27_ARID                  (AXI_ARID[27]        )
  ,.AXI_27_ARLEN                 (AXI_ARLEN[27][3:0]  )
  ,.AXI_27_ARSIZE                (AXI_ARSIZE[27]      )
  ,.AXI_27_ARVALID               (AXI_ARVALID[27]     )
  ,.AXI_27_AWADDR                (AXI_AWADDR[27]      )
  ,.AXI_27_AWBURST               (AXI_AWBURST[27]     )
  ,.AXI_27_AWID                  (AXI_AWID[27]        )
  ,.AXI_27_AWLEN                 (AXI_AWLEN[27][3:0]  )
  ,.AXI_27_AWSIZE                (AXI_AWSIZE[27]      )
  ,.AXI_27_AWVALID               (AXI_AWVALID[27]     )
  ,.AXI_27_RREADY                (AXI_RREADY[27]      )
  ,.AXI_27_BREADY                (AXI_BREADY[27]      )
  ,.AXI_27_WDATA                 (AXI_WDATA[27]       )
  ,.AXI_27_WLAST                 (AXI_WLAST[27]       )
  ,.AXI_27_WSTRB                 (AXI_WSTRB[27]       )
  ,.AXI_27_WDATA_PARITY          (AXI_WDATA_PARITY_i[27])
  ,.AXI_27_WVALID                (AXI_WVALID[27]      )
  ,.AXI_28_ACLK                  (AXI_ACLK_st1_buf[5]     )
  ,.AXI_28_ARESET_N              (axi_rst_st1_n[5]        )
  ,.AXI_28_ARADDR                (AXI_ARADDR[28]      )
  ,.AXI_28_ARBURST               (AXI_ARBURST[28]     )
  ,.AXI_28_ARID                  (AXI_ARID[28]        )
  ,.AXI_28_ARLEN                 (AXI_ARLEN[28][3:0]  )
  ,.AXI_28_ARSIZE                (AXI_ARSIZE[28]      )
  ,.AXI_28_ARVALID               (AXI_ARVALID[28]     )
  ,.AXI_28_AWADDR                (AXI_AWADDR[28]      )
  ,.AXI_28_AWBURST               (AXI_AWBURST[28]     )
  ,.AXI_28_AWID                  (AXI_AWID[28]        )
  ,.AXI_28_AWLEN                 (AXI_AWLEN[28][3:0]  )
  ,.AXI_28_AWSIZE                (AXI_AWSIZE[28]      )
  ,.AXI_28_AWVALID               (AXI_AWVALID[28]     )
  ,.AXI_28_RREADY                (AXI_RREADY[28]      )
  ,.AXI_28_BREADY                (AXI_BREADY[28]      )
  ,.AXI_28_WDATA                 (AXI_WDATA[28]       )
  ,.AXI_28_WLAST                 (AXI_WLAST[28]       )
  ,.AXI_28_WSTRB                 (AXI_WSTRB[28]       )
  ,.AXI_28_WDATA_PARITY          (AXI_WDATA_PARITY_i[28])
  ,.AXI_28_WVALID                (AXI_WVALID[28]      )
  ,.AXI_29_ACLK                  (AXI_ACLK_st1_buf[6]     )
  ,.AXI_29_ARESET_N              (axi_rst_st1_n[6]        )
  ,.AXI_29_ARADDR                (AXI_ARADDR[29]      )
  ,.AXI_29_ARBURST               (AXI_ARBURST[29]     )
  ,.AXI_29_ARID                  (AXI_ARID[29]        )
  ,.AXI_29_ARLEN                 (AXI_ARLEN[29][3:0]  )
  ,.AXI_29_ARSIZE                (AXI_ARSIZE[29]      )
  ,.AXI_29_ARVALID               (AXI_ARVALID[29]     )
  ,.AXI_29_AWADDR                (AXI_AWADDR[29]      )
  ,.AXI_29_AWBURST               (AXI_AWBURST[29]     )
  ,.AXI_29_AWID                  (AXI_AWID[29]        )
  ,.AXI_29_AWLEN                 (AXI_AWLEN[29][3:0]  )
  ,.AXI_29_AWSIZE                (AXI_AWSIZE[29]      )
  ,.AXI_29_AWVALID               (AXI_AWVALID[29]     )
  ,.AXI_29_RREADY                (AXI_RREADY[29]      )
  ,.AXI_29_BREADY                (AXI_BREADY[29]      )
  ,.AXI_29_WDATA                 (AXI_WDATA[29]       )
  ,.AXI_29_WLAST                 (AXI_WLAST[29]       )
  ,.AXI_29_WSTRB                 (AXI_WSTRB[29]       )
  ,.AXI_29_WDATA_PARITY          (AXI_WDATA_PARITY_i[29])
  ,.AXI_29_WVALID                (AXI_WVALID[29]      )
  
  ,.AXI_30_ACLK                  (AXI_ACLK_st1_buf[6]     )
  ,.AXI_30_ARESET_N              (axi_rst_st1_n[6]        )
  ,.AXI_30_ARADDR                (AXI_ARADDR[30]      )
  ,.AXI_30_ARBURST               (AXI_ARBURST[30]     )
  ,.AXI_30_ARID                  (AXI_ARID[30]        )
  ,.AXI_30_ARLEN                 (AXI_ARLEN[30][3:0]  )
  ,.AXI_30_ARSIZE                (AXI_ARSIZE[30]      )
  ,.AXI_30_ARVALID               (AXI_ARVALID[30]     )
  ,.AXI_30_AWADDR                (AXI_AWADDR[30]      )
  ,.AXI_30_AWBURST               (AXI_AWBURST[30]     )
  ,.AXI_30_AWID                  (AXI_AWID[30]        )
  ,.AXI_30_AWLEN                 (AXI_AWLEN[30][3:0]  )
  ,.AXI_30_AWSIZE                (AXI_AWSIZE[30]      )
  ,.AXI_30_AWVALID               (AXI_AWVALID[30]     )
  ,.AXI_30_RREADY                (AXI_RREADY[30]      )
  ,.AXI_30_BREADY                (AXI_BREADY[30]      )
  ,.AXI_30_WDATA                 (AXI_WDATA[30]       )
  ,.AXI_30_WLAST                 (AXI_WLAST[30]       )
  ,.AXI_30_WSTRB                 (AXI_WSTRB[30]       )
  ,.AXI_30_WDATA_PARITY          (AXI_WDATA_PARITY_i[30])
  ,.AXI_30_WVALID                (AXI_WVALID[30]      )
  ,.AXI_31_ACLK                  (AXI_ACLK_st1_buf[6]     )
  ,.AXI_31_ARESET_N              (axi_rst_st1_n[6]        )
  ,.AXI_31_ARADDR                (AXI_ARADDR[31]      )
  ,.AXI_31_ARBURST               (AXI_ARBURST[31]     )
  ,.AXI_31_ARID                  (AXI_ARID[31]        )
  ,.AXI_31_ARLEN                 (AXI_ARLEN[31][3:0]  )
  ,.AXI_31_ARSIZE                (AXI_ARSIZE[31]      )
  ,.AXI_31_ARVALID               (AXI_ARVALID[31]     )
  ,.AXI_31_AWADDR                (AXI_AWADDR[31]      )
  ,.AXI_31_AWBURST               (AXI_AWBURST[31]     )
  ,.AXI_31_AWID                  (AXI_AWID[31]        )
  ,.AXI_31_AWLEN                 (AXI_AWLEN[31][3:0]  )
  ,.AXI_31_AWSIZE                (AXI_AWSIZE[31]      )
  ,.AXI_31_AWVALID               (AXI_AWVALID[31]     )
  ,.AXI_31_RREADY                (AXI_RREADY[31]      )
  ,.AXI_31_BREADY                (AXI_BREADY[31]      )
  ,.AXI_31_WDATA                 (AXI_WDATA[31]       )
  ,.AXI_31_WLAST                 (AXI_WLAST[31]       )
  ,.AXI_31_WSTRB                 (AXI_WSTRB[31]       )
  ,.AXI_31_WDATA_PARITY          (AXI_WDATA_PARITY_i[31])
  ,.AXI_31_WVALID                (AXI_WVALID[31]      )

  ,.APB_0_PWDATA                 (APB_0_PWDATA)
  ,.APB_0_PADDR                  (APB_0_PADDR)
  ,.APB_0_PCLK                   (APB_0_PCLK_BUF)
  ,.APB_0_PENABLE                (APB_0_PENABLE)
  ,.APB_0_PRESET_N               (APB_0_PRESET_N)
  ,.APB_0_PSEL                   (APB_0_PSEL)
  ,.APB_0_PWRITE                 (APB_0_PWRITE)
  ,.APB_1_PWDATA                 (APB_1_PWDATA)
  ,.APB_1_PADDR                  (APB_1_PADDR)
  ,.APB_1_PCLK                   (APB_1_PCLK_BUF)
  ,.APB_1_PENABLE                (APB_1_PENABLE)
  ,.APB_1_PRESET_N               (APB_1_PRESET_N)
  ,.APB_1_PSEL                   (APB_1_PSEL)
  ,.APB_1_PWRITE                 (APB_1_PWRITE)

  ,.AXI_00_ARREADY               (AXI_ARREADY[0]     )
  ,.AXI_00_AWREADY               (AXI_AWREADY[0]     )
  ,.AXI_00_RDATA_PARITY          (AXI_RDATA_PARITY[0])
  ,.AXI_00_RDATA                 (AXI_RDATA[0]       )
  ,.AXI_00_RID                   (AXI_RID[0]         )
  ,.AXI_00_RLAST                 (AXI_RLAST[0]       )
  ,.AXI_00_RRESP                 (AXI_RRESP[0]       )
  ,.AXI_00_RVALID                (AXI_RVALID[0]      )
  ,.AXI_00_WREADY                (AXI_WREADY[0]      )
  ,.AXI_00_BID                   (AXI_BID[0]         )
  ,.AXI_00_BRESP                 (AXI_BRESP[0]       )
  ,.AXI_00_BVALID                (AXI_BVALID[0]      )
  ,.AXI_01_ARREADY               (AXI_ARREADY[1]     )
  ,.AXI_01_AWREADY               (AXI_AWREADY[1]     )
  ,.AXI_01_RDATA_PARITY          (AXI_RDATA_PARITY[1])
  ,.AXI_01_RDATA                 (AXI_RDATA[1]       )
  ,.AXI_01_RID                   (AXI_RID[1]         )
  ,.AXI_01_RLAST                 (AXI_RLAST[1]       )
  ,.AXI_01_RRESP                 (AXI_RRESP[1]       )
  ,.AXI_01_RVALID                (AXI_RVALID[1]      )
  ,.AXI_01_WREADY                (AXI_WREADY[1]      )
  ,.AXI_01_BID                   (AXI_BID[1]         )
  ,.AXI_01_BRESP                 (AXI_BRESP[1]       )
  ,.AXI_01_BVALID                (AXI_BVALID[1]      )
  ,.AXI_02_ARREADY               (AXI_ARREADY[2]     )
  ,.AXI_02_AWREADY               (AXI_AWREADY[2]     )
  ,.AXI_02_RDATA_PARITY          (AXI_RDATA_PARITY[2])
  ,.AXI_02_RDATA                 (AXI_RDATA[2]       )
  ,.AXI_02_RID                   (AXI_RID[2]         )
  ,.AXI_02_RLAST                 (AXI_RLAST[2]       )
  ,.AXI_02_RRESP                 (AXI_RRESP[2]       )
  ,.AXI_02_RVALID                (AXI_RVALID[2]      )
  ,.AXI_02_WREADY                (AXI_WREADY[2]      )
  ,.AXI_02_BID                   (AXI_BID[2]         )
  ,.AXI_02_BRESP                 (AXI_BRESP[2]       )
  ,.AXI_02_BVALID                (AXI_BVALID[2]      )
  ,.AXI_03_ARREADY               (AXI_ARREADY[3]     )
  ,.AXI_03_AWREADY               (AXI_AWREADY[3]     )
  ,.AXI_03_RDATA_PARITY          (AXI_RDATA_PARITY[3])
  ,.AXI_03_RDATA                 (AXI_RDATA[3]       )
  ,.AXI_03_RID                   (AXI_RID[3]         )
  ,.AXI_03_RLAST                 (AXI_RLAST[3]       )
  ,.AXI_03_RRESP                 (AXI_RRESP[3]       )
  ,.AXI_03_RVALID                (AXI_RVALID[3]      )
  ,.AXI_03_WREADY                (AXI_WREADY[3]      )
  ,.AXI_03_BID                   (AXI_BID[3]         )
  ,.AXI_03_BRESP                 (AXI_BRESP[3]       )
  ,.AXI_03_BVALID                (AXI_BVALID[3]      )
  ,.AXI_04_ARREADY               (AXI_ARREADY[4]     )
  ,.AXI_04_AWREADY               (AXI_AWREADY[4]     )
  ,.AXI_04_RDATA_PARITY          (AXI_RDATA_PARITY[4])
  ,.AXI_04_RDATA                 (AXI_RDATA[4]       )
  ,.AXI_04_RID                   (AXI_RID[4]         )
  ,.AXI_04_RLAST                 (AXI_RLAST[4]       )
  ,.AXI_04_RRESP                 (AXI_RRESP[4]       )
  ,.AXI_04_RVALID                (AXI_RVALID[4]      )
  ,.AXI_04_WREADY                (AXI_WREADY[4]      )
  ,.AXI_04_BID                   (AXI_BID[4]         )
  ,.AXI_04_BRESP                 (AXI_BRESP[4]       )
  ,.AXI_04_BVALID                (AXI_BVALID[4]      )
  ,.AXI_05_ARREADY               (AXI_ARREADY[5]     )
  ,.AXI_05_AWREADY               (AXI_AWREADY[5]     )
  ,.AXI_05_RDATA_PARITY          (AXI_RDATA_PARITY[5])
  ,.AXI_05_RDATA                 (AXI_RDATA[5]       )
  ,.AXI_05_RID                   (AXI_RID[5]         )
  ,.AXI_05_RLAST                 (AXI_RLAST[5]       )
  ,.AXI_05_RRESP                 (AXI_RRESP[5]       )
  ,.AXI_05_RVALID                (AXI_RVALID[5]      )
  ,.AXI_05_WREADY                (AXI_WREADY[5]      )
  ,.AXI_05_BID                   (AXI_BID[5]         )
  ,.AXI_05_BRESP                 (AXI_BRESP[5]       )
  ,.AXI_05_BVALID                (AXI_BVALID[5]      )
  ,.AXI_06_ARREADY               (AXI_ARREADY[6]     )
  ,.AXI_06_AWREADY               (AXI_AWREADY[6]     )
  ,.AXI_06_RDATA_PARITY          (AXI_RDATA_PARITY[6])
  ,.AXI_06_RDATA                 (AXI_RDATA[6]       )
  ,.AXI_06_RID                   (AXI_RID[6]         )
  ,.AXI_06_RLAST                 (AXI_RLAST[6]       )
  ,.AXI_06_RRESP                 (AXI_RRESP[6]       )
  ,.AXI_06_RVALID                (AXI_RVALID[6]      )
  ,.AXI_06_WREADY                (AXI_WREADY[6]      )
  ,.AXI_06_BID                   (AXI_BID[6]         )
  ,.AXI_06_BRESP                 (AXI_BRESP[6]       )
  ,.AXI_06_BVALID                (AXI_BVALID[6]      )
  ,.AXI_07_ARREADY               (AXI_ARREADY[7]     )
  ,.AXI_07_AWREADY               (AXI_AWREADY[7]     )
  ,.AXI_07_RDATA_PARITY          (AXI_RDATA_PARITY[7])
  ,.AXI_07_RDATA                 (AXI_RDATA[7]       )
  ,.AXI_07_RID                   (AXI_RID[7]         )
  ,.AXI_07_RLAST                 (AXI_RLAST[7]       )
  ,.AXI_07_RRESP                 (AXI_RRESP[7]       )
  ,.AXI_07_RVALID                (AXI_RVALID[7]      )
  ,.AXI_07_WREADY                (AXI_WREADY[7]      )
  ,.AXI_07_BID                   (AXI_BID[7]         )
  ,.AXI_07_BRESP                 (AXI_BRESP[7]       )
  ,.AXI_07_BVALID                (AXI_BVALID[7]      )
  ,.AXI_08_ARREADY               (AXI_ARREADY[8]     )
  ,.AXI_08_AWREADY               (AXI_AWREADY[8]     )
  ,.AXI_08_RDATA_PARITY          (AXI_RDATA_PARITY[8])
  ,.AXI_08_RDATA                 (AXI_RDATA[8]       )
  ,.AXI_08_RID                   (AXI_RID[8]         )
  ,.AXI_08_RLAST                 (AXI_RLAST[8]       )
  ,.AXI_08_RRESP                 (AXI_RRESP[8]       )
  ,.AXI_08_RVALID                (AXI_RVALID[8]      )
  ,.AXI_08_WREADY                (AXI_WREADY[8]      )
  ,.AXI_08_BID                   (AXI_BID[8]         )
  ,.AXI_08_BRESP                 (AXI_BRESP[8]       )
  ,.AXI_08_BVALID                (AXI_BVALID[8]      )
  ,.AXI_09_ARREADY               (AXI_ARREADY[9]     )
  ,.AXI_09_AWREADY               (AXI_AWREADY[9]     )
  ,.AXI_09_RDATA_PARITY          (AXI_RDATA_PARITY[9])
  ,.AXI_09_RDATA                 (AXI_RDATA[9]       )
  ,.AXI_09_RID                   (AXI_RID[9]         )
  ,.AXI_09_RLAST                 (AXI_RLAST[9]       )
  ,.AXI_09_RRESP                 (AXI_RRESP[9]       )
  ,.AXI_09_RVALID                (AXI_RVALID[9]      )
  ,.AXI_09_WREADY                (AXI_WREADY[9]      )
  ,.AXI_09_BID                   (AXI_BID[9]         )
  ,.AXI_09_BRESP                 (AXI_BRESP[9]       )
  ,.AXI_09_BVALID                (AXI_BVALID[9]      )
  ,.AXI_10_ARREADY               (AXI_ARREADY[10]     )
  ,.AXI_10_AWREADY               (AXI_AWREADY[10]     )
  ,.AXI_10_RDATA_PARITY          (AXI_RDATA_PARITY[10])
  ,.AXI_10_RDATA                 (AXI_RDATA[10]       )
  ,.AXI_10_RID                   (AXI_RID[10]         )
  ,.AXI_10_RLAST                 (AXI_RLAST[10]       )
  ,.AXI_10_RRESP                 (AXI_RRESP[10]       )
  ,.AXI_10_RVALID                (AXI_RVALID[10]      )
  ,.AXI_10_WREADY                (AXI_WREADY[10]      )
  ,.AXI_10_BID                   (AXI_BID[10]         )
  ,.AXI_10_BRESP                 (AXI_BRESP[10]       )
  ,.AXI_10_BVALID                (AXI_BVALID[10]      )
  ,.AXI_11_ARREADY               (AXI_ARREADY[11]     )
  ,.AXI_11_AWREADY               (AXI_AWREADY[11]     )
  ,.AXI_11_RDATA_PARITY          (AXI_RDATA_PARITY[11])
  ,.AXI_11_RDATA                 (AXI_RDATA[11]       )
  ,.AXI_11_RID                   (AXI_RID[11]         )
  ,.AXI_11_RLAST                 (AXI_RLAST[11]       )
  ,.AXI_11_RRESP                 (AXI_RRESP[11]       )
  ,.AXI_11_RVALID                (AXI_RVALID[11]      )
  ,.AXI_11_WREADY                (AXI_WREADY[11]      )
  ,.AXI_11_BID                   (AXI_BID[11]         )
  ,.AXI_11_BRESP                 (AXI_BRESP[11]       )
  ,.AXI_11_BVALID                (AXI_BVALID[11]      )
  ,.AXI_12_ARREADY               (AXI_ARREADY[12]     )
  ,.AXI_12_AWREADY               (AXI_AWREADY[12]     )
  ,.AXI_12_RDATA_PARITY          (AXI_RDATA_PARITY[12])
  ,.AXI_12_RDATA                 (AXI_RDATA[12]       )
  ,.AXI_12_RID                   (AXI_RID[12]         )
  ,.AXI_12_RLAST                 (AXI_RLAST[12]       )
  ,.AXI_12_RRESP                 (AXI_RRESP[12]       )
  ,.AXI_12_RVALID                (AXI_RVALID[12]      )
  ,.AXI_12_WREADY                (AXI_WREADY[12]      )
  ,.AXI_12_BID                   (AXI_BID[12]         )
  ,.AXI_12_BRESP                 (AXI_BRESP[12]       )
  ,.AXI_12_BVALID                (AXI_BVALID[12]      )
  ,.AXI_13_ARREADY               (AXI_ARREADY[13]     )
  ,.AXI_13_AWREADY               (AXI_AWREADY[13]     )
  ,.AXI_13_RDATA_PARITY          (AXI_RDATA_PARITY[13])
  ,.AXI_13_RDATA                 (AXI_RDATA[13]       )
  ,.AXI_13_RID                   (AXI_RID[13]         )
  ,.AXI_13_RLAST                 (AXI_RLAST[13]       )
  ,.AXI_13_RRESP                 (AXI_RRESP[13]       )
  ,.AXI_13_RVALID                (AXI_RVALID[13]      )
  ,.AXI_13_WREADY                (AXI_WREADY[13]      )
  ,.AXI_13_BID                   (AXI_BID[13]         )
  ,.AXI_13_BRESP                 (AXI_BRESP[13]       )
  ,.AXI_13_BVALID                (AXI_BVALID[13]      )
  ,.AXI_14_ARREADY               (AXI_ARREADY[14]     )
  ,.AXI_14_AWREADY               (AXI_AWREADY[14]     )
  ,.AXI_14_RDATA_PARITY          (AXI_RDATA_PARITY[14])
  ,.AXI_14_RDATA                 (AXI_RDATA[14]       )
  ,.AXI_14_RID                   (AXI_RID[14]         )
  ,.AXI_14_RLAST                 (AXI_RLAST[14]       )
  ,.AXI_14_RRESP                 (AXI_RRESP[14]       )
  ,.AXI_14_RVALID                (AXI_RVALID[14]      )
  ,.AXI_14_WREADY                (AXI_WREADY[14]      )
  ,.AXI_14_BID                   (AXI_BID[14]         )
  ,.AXI_14_BRESP                 (AXI_BRESP[14]       )
  ,.AXI_14_BVALID                (AXI_BVALID[14]      )
  ,.AXI_15_ARREADY               (AXI_ARREADY[15]     )
  ,.AXI_15_AWREADY               (AXI_AWREADY[15]     )
  ,.AXI_15_RDATA_PARITY          (AXI_RDATA_PARITY[15])
  ,.AXI_15_RDATA                 (AXI_RDATA[15]       )
  ,.AXI_15_RID                   (AXI_RID[15]         )
  ,.AXI_15_RLAST                 (AXI_RLAST[15]       )
  ,.AXI_15_RRESP                 (AXI_RRESP[15]       )
  ,.AXI_15_RVALID                (AXI_RVALID[15]      )
  ,.AXI_15_WREADY                (AXI_WREADY[15]      )
  ,.AXI_15_BID                   (AXI_BID[15]         )
  ,.AXI_15_BRESP                 (AXI_BRESP[15]       )
  ,.AXI_15_BVALID                (AXI_BVALID[15]      )
  ,.AXI_16_ARREADY               (AXI_ARREADY[16]     )
  ,.AXI_16_AWREADY               (AXI_AWREADY[16]     )
  ,.AXI_16_RDATA_PARITY          (AXI_RDATA_PARITY[16])
  ,.AXI_16_RDATA                 (AXI_RDATA[16]       )
  ,.AXI_16_RID                   (AXI_RID[16]         )
  ,.AXI_16_RLAST                 (AXI_RLAST[16]       )
  ,.AXI_16_RRESP                 (AXI_RRESP[16]       )
  ,.AXI_16_RVALID                (AXI_RVALID[16]      )
  ,.AXI_16_WREADY                (AXI_WREADY[16]      )
  ,.AXI_16_BID                   (AXI_BID[16]         )
  ,.AXI_16_BRESP                 (AXI_BRESP[16]       )
  ,.AXI_16_BVALID                (AXI_BVALID[16]      )
  ,.AXI_17_ARREADY               (AXI_ARREADY[17]     )
  ,.AXI_17_AWREADY               (AXI_AWREADY[17]     )
  ,.AXI_17_RDATA_PARITY          (AXI_RDATA_PARITY[17])
  ,.AXI_17_RDATA                 (AXI_RDATA[17]       )
  ,.AXI_17_RID                   (AXI_RID[17]         )
  ,.AXI_17_RLAST                 (AXI_RLAST[17]       )
  ,.AXI_17_RRESP                 (AXI_RRESP[17]       )
  ,.AXI_17_RVALID                (AXI_RVALID[17]      )
  ,.AXI_17_WREADY                (AXI_WREADY[17]      )
  ,.AXI_17_BID                   (AXI_BID[17]         )
  ,.AXI_17_BRESP                 (AXI_BRESP[17]       )
  ,.AXI_17_BVALID                (AXI_BVALID[17]      )
  ,.AXI_18_ARREADY               (AXI_ARREADY[18]     )
  ,.AXI_18_AWREADY               (AXI_AWREADY[18]     )
  ,.AXI_18_RDATA_PARITY          (AXI_RDATA_PARITY[18])
  ,.AXI_18_RDATA                 (AXI_RDATA[18]       )
  ,.AXI_18_RID                   (AXI_RID[18]         )
  ,.AXI_18_RLAST                 (AXI_RLAST[18]       )
  ,.AXI_18_RRESP                 (AXI_RRESP[18]       )
  ,.AXI_18_RVALID                (AXI_RVALID[18]      )
  ,.AXI_18_WREADY                (AXI_WREADY[18]      )
  ,.AXI_18_BID                   (AXI_BID[18]         )
  ,.AXI_18_BRESP                 (AXI_BRESP[18]       )
  ,.AXI_18_BVALID                (AXI_BVALID[18]      )
  ,.AXI_19_ARREADY               (AXI_ARREADY[19]     )
  ,.AXI_19_AWREADY               (AXI_AWREADY[19]     )
  ,.AXI_19_RDATA_PARITY          (AXI_RDATA_PARITY[19])
  ,.AXI_19_RDATA                 (AXI_RDATA[19]       )
  ,.AXI_19_RID                   (AXI_RID[19]         )
  ,.AXI_19_RLAST                 (AXI_RLAST[19]       )
  ,.AXI_19_RRESP                 (AXI_RRESP[19]       )
  ,.AXI_19_RVALID                (AXI_RVALID[19]      )
  ,.AXI_19_WREADY                (AXI_WREADY[19]      )
  ,.AXI_19_BID                   (AXI_BID[19]         )
  ,.AXI_19_BRESP                 (AXI_BRESP[19]       )
  ,.AXI_19_BVALID                (AXI_BVALID[19]      )
  ,.AXI_20_ARREADY               (AXI_ARREADY[20]     )
  ,.AXI_20_AWREADY               (AXI_AWREADY[20]     )
  ,.AXI_20_RDATA_PARITY          (AXI_RDATA_PARITY[20])
  ,.AXI_20_RDATA                 (AXI_RDATA[20]       )
  ,.AXI_20_RID                   (AXI_RID[20]         )
  ,.AXI_20_RLAST                 (AXI_RLAST[20]       )
  ,.AXI_20_RRESP                 (AXI_RRESP[20]       )
  ,.AXI_20_RVALID                (AXI_RVALID[20]      )
  ,.AXI_20_WREADY                (AXI_WREADY[20]      )
  ,.AXI_20_BID                   (AXI_BID[20]         )
  ,.AXI_20_BRESP                 (AXI_BRESP[20]       )
  ,.AXI_20_BVALID                (AXI_BVALID[20]      )
  ,.AXI_21_ARREADY               (AXI_ARREADY[21]     )
  ,.AXI_21_AWREADY               (AXI_AWREADY[21]     )
  ,.AXI_21_RDATA_PARITY          (AXI_RDATA_PARITY[21])
  ,.AXI_21_RDATA                 (AXI_RDATA[21]       )
  ,.AXI_21_RID                   (AXI_RID[21]         )
  ,.AXI_21_RLAST                 (AXI_RLAST[21]       )
  ,.AXI_21_RRESP                 (AXI_RRESP[21]       )
  ,.AXI_21_RVALID                (AXI_RVALID[21]      )
  ,.AXI_21_WREADY                (AXI_WREADY[21]      )
  ,.AXI_21_BID                   (AXI_BID[21]         )
  ,.AXI_21_BRESP                 (AXI_BRESP[21]       )
  ,.AXI_21_BVALID                (AXI_BVALID[21]      )
  ,.AXI_22_ARREADY               (AXI_ARREADY[22]     )
  ,.AXI_22_AWREADY               (AXI_AWREADY[22]     )
  ,.AXI_22_RDATA_PARITY          (AXI_RDATA_PARITY[22])
  ,.AXI_22_RDATA                 (AXI_RDATA[22]       )
  ,.AXI_22_RID                   (AXI_RID[22]         )
  ,.AXI_22_RLAST                 (AXI_RLAST[22]       )
  ,.AXI_22_RRESP                 (AXI_RRESP[22]       )
  ,.AXI_22_RVALID                (AXI_RVALID[22]      )
  ,.AXI_22_WREADY                (AXI_WREADY[22]      )
  ,.AXI_22_BID                   (AXI_BID[22]         )
  ,.AXI_22_BRESP                 (AXI_BRESP[22]       )
  ,.AXI_22_BVALID                (AXI_BVALID[22]      )
  ,.AXI_23_ARREADY               (AXI_ARREADY[23]     )
  ,.AXI_23_AWREADY               (AXI_AWREADY[23]     )
  ,.AXI_23_RDATA_PARITY          (AXI_RDATA_PARITY[23])
  ,.AXI_23_RDATA                 (AXI_RDATA[23]       )
  ,.AXI_23_RID                   (AXI_RID[23]         )
  ,.AXI_23_RLAST                 (AXI_RLAST[23]       )
  ,.AXI_23_RRESP                 (AXI_RRESP[23]       )
  ,.AXI_23_RVALID                (AXI_RVALID[23]      )
  ,.AXI_23_WREADY                (AXI_WREADY[23]      )
  ,.AXI_23_BID                   (AXI_BID[23]         )
  ,.AXI_23_BRESP                 (AXI_BRESP[23]       )
  ,.AXI_23_BVALID                (AXI_BVALID[23]      )
  ,.AXI_24_ARREADY               (AXI_ARREADY[24]     )
  ,.AXI_24_AWREADY               (AXI_AWREADY[24]     )
  ,.AXI_24_RDATA_PARITY          (AXI_RDATA_PARITY[24])
  ,.AXI_24_RDATA                 (AXI_RDATA[24]       )
  ,.AXI_24_RID                   (AXI_RID[24]         )
  ,.AXI_24_RLAST                 (AXI_RLAST[24]       )
  ,.AXI_24_RRESP                 (AXI_RRESP[24]       )
  ,.AXI_24_RVALID                (AXI_RVALID[24]      )
  ,.AXI_24_WREADY                (AXI_WREADY[24]      )
  ,.AXI_24_BID                   (AXI_BID[24]         )
  ,.AXI_24_BRESP                 (AXI_BRESP[24]       )
  ,.AXI_24_BVALID                (AXI_BVALID[24]      )
  ,.AXI_25_ARREADY               (AXI_ARREADY[25]     )
  ,.AXI_25_AWREADY               (AXI_AWREADY[25]     )
  ,.AXI_25_RDATA_PARITY          (AXI_RDATA_PARITY[25])
  ,.AXI_25_RDATA                 (AXI_RDATA[25]       )
  ,.AXI_25_RID                   (AXI_RID[25]         )
  ,.AXI_25_RLAST                 (AXI_RLAST[25]       )
  ,.AXI_25_RRESP                 (AXI_RRESP[25]       )
  ,.AXI_25_RVALID                (AXI_RVALID[25]      )
  ,.AXI_25_WREADY                (AXI_WREADY[25]      )
  ,.AXI_25_BID                   (AXI_BID[25]         )
  ,.AXI_25_BRESP                 (AXI_BRESP[25]       )
  ,.AXI_25_BVALID                (AXI_BVALID[25]      )
  ,.AXI_26_ARREADY               (AXI_ARREADY[26]     )
  ,.AXI_26_AWREADY               (AXI_AWREADY[26]     )
  ,.AXI_26_RDATA_PARITY          (AXI_RDATA_PARITY[26])
  ,.AXI_26_RDATA                 (AXI_RDATA[26]       )
  ,.AXI_26_RID                   (AXI_RID[26]         )
  ,.AXI_26_RLAST                 (AXI_RLAST[26]       )
  ,.AXI_26_RRESP                 (AXI_RRESP[26]       )
  ,.AXI_26_RVALID                (AXI_RVALID[26]      )
  ,.AXI_26_WREADY                (AXI_WREADY[26]      )
  ,.AXI_26_BID                   (AXI_BID[26]         )
  ,.AXI_26_BRESP                 (AXI_BRESP[26]       )
  ,.AXI_26_BVALID                (AXI_BVALID[26]      )
  ,.AXI_27_ARREADY               (AXI_ARREADY[27]     )
  ,.AXI_27_AWREADY               (AXI_AWREADY[27]     )
  ,.AXI_27_RDATA_PARITY          (AXI_RDATA_PARITY[27])
  ,.AXI_27_RDATA                 (AXI_RDATA[27]       )
  ,.AXI_27_RID                   (AXI_RID[27]         )
  ,.AXI_27_RLAST                 (AXI_RLAST[27]       )
  ,.AXI_27_RRESP                 (AXI_RRESP[27]       )
  ,.AXI_27_RVALID                (AXI_RVALID[27]      )
  ,.AXI_27_WREADY                (AXI_WREADY[27]      )
  ,.AXI_27_BID                   (AXI_BID[27]         )
  ,.AXI_27_BRESP                 (AXI_BRESP[27]       )
  ,.AXI_27_BVALID                (AXI_BVALID[27]      )
  ,.AXI_28_ARREADY               (AXI_ARREADY[28]     )
  ,.AXI_28_AWREADY               (AXI_AWREADY[28]     )
  ,.AXI_28_RDATA_PARITY          (AXI_RDATA_PARITY[28])
  ,.AXI_28_RDATA                 (AXI_RDATA[28]       )
  ,.AXI_28_RID                   (AXI_RID[28]         )
  ,.AXI_28_RLAST                 (AXI_RLAST[28]       )
  ,.AXI_28_RRESP                 (AXI_RRESP[28]       )
  ,.AXI_28_RVALID                (AXI_RVALID[28]      )
  ,.AXI_28_WREADY                (AXI_WREADY[28]      )
  ,.AXI_28_BID                   (AXI_BID[28]         )
  ,.AXI_28_BRESP                 (AXI_BRESP[28]       )
  ,.AXI_28_BVALID                (AXI_BVALID[28]      )
  ,.AXI_29_ARREADY               (AXI_ARREADY[29]     )
  ,.AXI_29_AWREADY               (AXI_AWREADY[29]     )
  ,.AXI_29_RDATA_PARITY          (AXI_RDATA_PARITY[29])
  ,.AXI_29_RDATA                 (AXI_RDATA[29]       )
  ,.AXI_29_RID                   (AXI_RID[29]         )
  ,.AXI_29_RLAST                 (AXI_RLAST[29]       )
  ,.AXI_29_RRESP                 (AXI_RRESP[29]       )
  ,.AXI_29_RVALID                (AXI_RVALID[29]      )
  ,.AXI_29_WREADY                (AXI_WREADY[29]      )
  ,.AXI_29_BID                   (AXI_BID[29]         )
  ,.AXI_29_BRESP                 (AXI_BRESP[29]       )
  ,.AXI_29_BVALID                (AXI_BVALID[29]      )
  ,.AXI_30_ARREADY               (AXI_ARREADY[30]     )
  ,.AXI_30_AWREADY               (AXI_AWREADY[30]     )
  ,.AXI_30_RDATA_PARITY          (AXI_RDATA_PARITY[30])
  ,.AXI_30_RDATA                 (AXI_RDATA[30]       )
  ,.AXI_30_RID                   (AXI_RID[30]         )
  ,.AXI_30_RLAST                 (AXI_RLAST[30]       )
  ,.AXI_30_RRESP                 (AXI_RRESP[30]       )
  ,.AXI_30_RVALID                (AXI_RVALID[30]      )
  ,.AXI_30_WREADY                (AXI_WREADY[30]      )
  ,.AXI_30_BID                   (AXI_BID[30]         )
  ,.AXI_30_BRESP                 (AXI_BRESP[30]       )
  ,.AXI_30_BVALID                (AXI_BVALID[30]      )
  ,.AXI_31_ARREADY               (AXI_ARREADY[31]     )
  ,.AXI_31_AWREADY               (AXI_AWREADY[31]     )
  ,.AXI_31_RDATA_PARITY          (AXI_RDATA_PARITY[31])
  ,.AXI_31_RDATA                 (AXI_RDATA[31]       )
  ,.AXI_31_RID                   (AXI_RID[31]         )
  ,.AXI_31_RLAST                 (AXI_RLAST[31]       )
  ,.AXI_31_RRESP                 (AXI_RRESP[31]       )
  ,.AXI_31_RVALID                (AXI_RVALID[31]      )
  ,.AXI_31_WREADY                (AXI_WREADY[31]      )
  ,.AXI_31_BID                   (AXI_BID[31]         )
  ,.AXI_31_BRESP                 (AXI_BRESP[31]       )
  ,.AXI_31_BVALID                (AXI_BVALID[31]      )
  ,.apb_complete_0               (apb_seq_complete_0_s)
  ,.APB_0_PRDATA                 (APB_0_PRDATA)
  ,.APB_0_PREADY                 (APB_0_PREADY)
  ,.APB_0_PSLVERR                (APB_0_PSLVERR)
  
  ,.apb_complete_1               (apb_seq_complete_1_s)
  ,.APB_1_PRDATA                 (APB_1_PRDATA)
  ,.APB_1_PREADY                 (APB_1_PREADY)
  ,.APB_1_PSLVERR                (APB_1_PSLVERR)
  
  ,.DRAM_0_STAT_CATTRIP          (DRAM_0_STAT_CATTRIP)
  ,.DRAM_0_STAT_TEMP             (DRAM_0_STAT_TEMP)
  
  ,.DRAM_1_STAT_CATTRIP          (DRAM_1_STAT_CATTRIP)
  ,.DRAM_1_STAT_TEMP             (DRAM_1_STAT_TEMP)
);

    omega OMEGA (
        .clk            (clk),
        .rst            (rst),
        .omega1_src_id_in   (omega1_src_id_in),
        .omega1_dst_id_in   (omega1_dst_id_in),
        .omega1_valid_in    (omega1_valid_in),
        .omega2_dst_v_in    (omega2_dst_v_in),
        .omega2_dst_id_in   (omega2_dst_id_in),
        .omega2_valid_in    (omega2_valid_in),

        .omega1_src_id_out  (omega1_src_id_out),
        .omega1_dst_id_out  (omega1_dst_id_out),
        .omega1_valid_out   (omega1_valid_out),
        .omega2_dst_v_out   (omega2_dst_v_out),
        .omega2_dst_id_out  (omega2_dst_id_out),
        .omega2_valid_out   (omega2_valid_out)
    );

    processor PROCESSOR (
        .clk                        (clk),
        .rst                        (rst),
        .prev_src_id                (edge_generator_src_id),
        .prev_dst_id                (edge_generator_dst_id),
        .prev_valid             (edge_generator_valid),
        .from_omega1_src_id     (omega1_src_id_out),
        .from_omega1_dst_id     (omega1_dst_id_out),
        .from_omega1_valid      (omega1_valid_out),
        .from_omega2_dst_v      (omega2_dst_v_out),
        .from_omega2_dst_id     (omega2_dst_id_out),
        .from_omega2_valid      (omega2_valid_out),
        
        .to_omega1_src_id       (omega1_src_id_in),
        .to_omega1_dst_id       (omega1_dst_id_in),
        .to_omega1_valid        (omega1_valid_in),
        .to_omega2_dst_v        (omega2_dst_v_in),
        .to_omega2_dst_id       (omega2_dst_id_in),
        .to_omega2_valid        (omega2_valid_in),

        .addr_to_hbm                (hbm_write_addr),
        .data_to_hbm                (hbm_write_data),
        .to_hbm_valid               (hbm_write_valid)
    );

endmodule