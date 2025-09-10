`timescale 1ns / 1ps

`include "data_width.vh"

module mem_controller_single #(parameter
    VERTEX_DWIDTH = `VERTEX_DWIDTH,
    HBM_AWIDTH_PER_CHANNEL = `HBM_AWIDTH_PER_CHANNEL,
    HBM_DWIDTH_PER_CHANNEL = `HBM_DWIDTH_PER_CHANNEL
) (
    input axi_clk,
    input acc_clk,
    input rst,

    // from accelerator
    input [HBM_AWIDTH_PER_CHANNEL - 1 : 0] hbm_read_addr,
    input hbm_read_addr_valid,
    input [HBM_AWIDTH_PER_CHANNEL - 1 : 0] hbm_write_addr,
    input [HBM_DWIDTH_PER_CHANNEL - 1 : 0] hbm_write_data,
    input hbm_write_valid,

    // to accelerator
    output [HBM_DWIDTH_PER_CHANNEL - 1 : 0] hbm_read_data,
    output hbm_read_data_valid,

    // to hbm
    output [32 : 0] axi_araddr,
    output reg [1 : 0] axi_arburst,
    output reg [5 : 0] axi_arid,
    output reg [7 : 0] axi_arlen,
    output reg [2 : 0] axi_arsize,
    output axi_arvalid,
    output [32 : 0] axi_awaddr,
    output reg [1 : 0] axi_awburst,
    output reg [5 : 0] axi_awid,
    output reg [7 : 0] axi_awlen,
    output reg [2 : 0] axi_awsize,
    output axi_awvalid,
    output axi_rready,
    output reg axi_bready,
    output [255 : 0] axi_wdata,
    output reg axi_wlast,
    output reg [31 : 0] axi_wstrb,
    output [31 : 0] axi_wdata_parity_i,
    output reg [31 : 0] axi_wdata_parity,
    output axi_wvalid,
    output reg [3 : 0] axi_arcache,
    output reg [3 : 0] axi_awcache,
    output reg [2 : 0] axi_awprot,

    // from hbm
    input axi_arready,
    input axi_awready,
    input [31 : 0] axi_rdata_parity,
    input [255 : 0] axi_rdata,
    input [5 : 0] axi_rid,
    input axi_rlast,
    input [1 : 0] axi_rresp,
    input axi_rvalid,
    input axi_wready,
    input [5 : 0] axi_bid,
    input [1 : 0] axi_bresp,
    input axi_bvalid
);

    // hbm read signal
    always @ (posedge axi_clk) begin
        if (rst) begin
            axi_arburst <= 0;
            axi_arid <= 0;
            axi_arlen <= 0;
            axi_arsize <= 0;
            axi_arcache <= 0;
        end
        else begin
            axi_arburst <= 1;
            axi_arid <= 1;
            axi_arlen <= 1;
            axi_arsize <= 1;
            axi_arcache <= 1;

        end
    end

    // hbm write signal
    always @ (posedge axi_clk) begin
        if (rst) begin
            axi_awburst <= 0;
            axi_awid <= 0;
            axi_awlen <= 0;
            axi_awsize <= 0;
            axi_bready <= 0;
            axi_wlast <= 0;
            axi_wstrb <= 0;
            axi_awcache <= 0;
            axi_awprot <= 0;
            axi_wdata_parity <= 0;
        end
        else begin
            axi_awburst <= 1;
            axi_awid <= 1;
            axi_awlen <= 1;
            axi_awsize <= 1;
            axi_bready <= 1;
            axi_wlast <= 1;
            axi_wstrb <= 1;
            axi_awcache <= 1;
            axi_awprot <= 1;
            axi_wdata_parity <= axi_wdata_parity_i;
        end
    end

    assign axi_wdata_parity_i = {{^(axi_wdata[255:248])},{^(axi_wdata[247:240])},{^(axi_wdata[239:232])},{^(axi_wdata[231:224])},
                              {^(axi_wdata[223:216])},{^(axi_wdata[215:208])},{^(axi_wdata[207:200])},{^(axi_wdata[199:192])},
                              {^(axi_wdata[191:184])},{^(axi_wdata[183:176])},{^(axi_wdata[175:168])},{^(axi_wdata[167:160])},
                              {^(axi_wdata[159:152])},{^(axi_wdata[151:144])},{^(axi_wdata[143:136])},{^(axi_wdata[135:128])},
                              {^(axi_wdata[127:120])},{^(axi_wdata[119:112])},{^(axi_wdata[111:104])},{^(axi_wdata[103:96])},
                              {^(axi_wdata[95:88])},  {^(axi_wdata[87:80])},  {^(axi_wdata[79:72])},  {^(axi_wdata[71:64])},
                              {^(axi_wdata[63:56])},  {^(axi_wdata[55:48])},  {^(axi_wdata[47:40])},  {^(axi_wdata[39:32])},
                              {^(axi_wdata[31:24])},  {^(axi_wdata[23:16])},  {^(axi_wdata[15:8])},   {^(axi_wdata[7:0])}};

    mem_controller_32bit_async_fifo TO_HBM_READ_ADDR_FIFO (
        .rst        (rst),
        .wr_clk     (acc_clk),
        .rd_clk     (axi_clk),
        .din        (hbm_read_addr),
        .wr_en      (hbm_read_addr_valid),
        .rd_en      (axi_arready),
        .dout       (axi_araddr),
        .full       (),
        .empty      (),
        .valid      (axi_arvalid)
    );

    wire to_acc_read_data_fifo_full;
    mem_controller_256bit_async_fifo TO_ACC_READ_DATA_FIFO (
        .rst        (rst),
        .wr_clk     (axi_clk),
        .rd_clk     (acc_clk),
        .din        (axi_rdata),
        .wr_en      (axi_rvalid),
        .rd_en      (1'b1),
        .dout       (hbm_read_data),
        .full       (to_acc_read_data_fifo_full),
        .empty      (),
        .valid      (hbm_read_data_valid)
    );
    assign axi_rready = !to_acc_read_data_fifo_full;

    mem_controller_32bit_async_fifo TO_HBM_WRITE_ADDR_FIFO (
        .rst        (rst),
        .wr_clk     (acc_clk),
        .rd_clk     (axi_clk),
        .din        (hbm_write_addr),
        .wr_en      (hbm_write_valid),
        .rd_en      (axi_awready),
        .dout       (axi_awaddr),
        .full       (),
        .empty      (),
        .valid      (axi_awvalid)
    );

    mem_controller_256bit_async_fifo TO_HBM_WRITE_DATA_FIFO (
        .rst        (rst),
        .wr_clk     (acc_clk),
        .rd_clk     (axi_clk),
        .din        (hbm_write_data),
        .wr_en      (hbm_write_valid),
        .rd_en      (axi_wready),
        .dout       (axi_wdata),
        .full       (),
        .empty      (),
        .valid      (axi_wvalid)
    );

endmodule