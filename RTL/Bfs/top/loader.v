`timescale 1ns / 1ps

`include "accelerator.vh"

module loader #(parameter
    CORE_NUM = `CORE_NUM,
    CORE_NUM_WIDTH = `CORE_NUM_WIDTH,
    HBM_AWIDTH = `HBM_AWIDTH,
    HBM_DWIDTH = `HBM_DWIDTH,
    LOADER_PSEUDO_CHANNEL_NUM = `PSEUDO_CHANNEL_NUM / 2,
    LOADER_ADDR_WIDTH = `BITMAP_COMPRESSED_NUM_WIDTH + `BITMAP_COMPRESSED_LENGTH_WIDTH,
    LOADER_CORE_NUM = 16,   // for bitmap: 512 / BITMAP_COMPRESSED_LENGTH; for first_edge: 16 * LOADER_PSEUDO_CHANNEL_NUM = CORE_NUM / 2
    DISPATCHER_WIDTH = 1    // for bitmap: $clog(CORE_NUM / LOADER_CORE_NUM) = CORE_NUM_WIDTH + BITMAP_COMPRESSED_LENGTH_WIDTH - 9; for first_edge: $clog(CORE_NUM / LOADER_CORE_NUM) === 1
) (
    input clk,
    input bram_rst,
    input [LOADER_PSEUDO_CHANNEL_NUM * HBM_DWIDTH - 1 : 0]          hbm_controller_data,
    input [LOADER_PSEUDO_CHANNEL_NUM - 1 : 0]                       hbm_data_valid,
    input [LOADER_PSEUDO_CHANNEL_NUM - 1 : 0]                       hbm_controller_full,

    output [LOADER_PSEUDO_CHANNEL_NUM * HBM_DWIDTH - 1 : 0]         dispatcher_data,
    output [LOADER_PSEUDO_CHANNEL_NUM * DISPATCHER_WIDTH - 1 : 0]   dispatcher_counter,
    output [LOADER_PSEUDO_CHANNEL_NUM - 1 : 0]                      dispatcher_valid,
    output reg [LOADER_PSEUDO_CHANNEL_NUM * HBM_AWIDTH - 1 : 0]     hbm_controller_addr,
    output reg [LOADER_PSEUDO_CHANNEL_NUM - 1 : 0]                  hbm_addr_valid
);

    genvar i;

    // address generator
    generate
        for (i = 0; i < LOADER_PSEUDO_CHANNEL_NUM; i = i + 1) begin : addr_gen
            always @(posedge clk) begin
                if (bram_rst) begin
                    hbm_controller_addr[HBM_AWIDTH * i +: HBM_AWIDTH] <= {HBM_AWIDTH{1'b1}};
                    hbm_addr_valid[i] <= 1'b0;
                end
                else if (hbm_controller_full[i] || hbm_controller_addr[HBM_AWIDTH * i +: HBM_AWIDTH] == {LOADER_ADDR_WIDTH{1'b1}}) begin
                    hbm_addr_valid[i] <= 1'b0;
                end
                else begin
                    hbm_controller_addr[HBM_AWIDTH * i +: HBM_AWIDTH] <= hbm_controller_addr[HBM_AWIDTH * i +: HBM_AWIDTH] + 1'b1;
                    hbm_addr_valid[i] <= 1'b1;
                end
            end
        end
    endgenerate

    // data out
    generate
        for (i = 0; i < LOADER_PSEUDO_CHANNEL_NUM; i = i + 1) begin : dispatchers
            dispatcher #(
                .HBM_DWIDTH (HBM_DWIDTH),
                .DISPATCHER_WIDTH (DISPATCHER_WIDTH)
            ) inst_dispatcher (
                .clk        (clk),
                .bram_rst   (bram_rst),
                .hbm_data_single        (hbm_controller_data[HBM_DWIDTH * i +: HBM_DWIDTH]),
                .hbm_data_valid_single  (hbm_data_valid[i]),

                .dispatcher_data        (dispatcher_data[HBM_DWIDTH * i +: HBM_DWIDTH]),
                .dispatcher_counter     (dispatcher_counter[DISPATCHER_WIDTH * i +: DISPATCHER_WIDTH]),
                .dispatcher_valid       (dispatcher_valid[i])
            );
        end
    endgenerate

endmodule

module dispatcher #(parameter
    HBM_DWIDTH = `HBM_DWIDTH,
    DISPATCHER_WIDTH = 1    // for bitmap: $clog(CORE_NUM / LOADER_CORE_NUM); for first_edge: $clog(CORE_NUM / LOADER_CORE_NUM) === 1
) (
    input clk,
    input bram_rst,
    input [HBM_DWIDTH - 1 : 0]              hbm_data_single,
    input                                   hbm_data_valid_single,

    output reg [HBM_DWIDTH - 1 : 0]         dispatcher_data,
    output reg [DISPATCHER_WIDTH - 1 : 0]   dispatcher_counter,
    output reg                              dispatcher_valid
);

    always @(posedge clk) begin
        if (bram_rst) begin
            dispatcher_data <= 'h0;
            dispatcher_counter <= {DISPATCHER_WIDTH{1'b1}};
            dispatcher_valid <= 1'b0;
        end
        else if (hbm_data_valid_single) begin
            dispatcher_data <= hbm_data_single;
            dispatcher_counter <= dispatcher_counter + 1'b1;
            dispatcher_valid <= 1'b1;
        end
        else begin
            dispatcher_valid <= 1'b0;
        end
    end

endmodule