`timescale 1ns / 1ps

`include "data_width.vh"

module processor #(parameter
    EDGE_PIPELINE_NUM = `EDGE_PIPELINE_NUM,
    VERTEX_DWIDTH = `VERTEX_DWIDTH,
    VERTEX_ID_WIDTH = `VERTEX_ID_WIDTH,
    VERTEX_AWIDTH = `VERTEX_AWIDTH,
    OMEGA_ARRAY_X = `OMEGA_ARRAY_X,
    LATENCY = 1
) (
    input clk,
    input rst,
    input [EDGE_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] prev_src_id,
    input [EDGE_PIPELINE_NUM * VERTEX_ID_WIDTH - 1 : 0] prev_dst_id,
    input [EDGE_PIPELINE_NUM - 1 : 0] prev_valid,
    input [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] from_omega1_src_id,
    input [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] from_omega1_dst_id,
    input [2 * OMEGA_ARRAY_X - 1 : 0] from_omega1_valid,
    input [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] from_omega2_dst_v,
    input [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] from_omega2_dst_id,
    input [2 * OMEGA_ARRAY_X - 1 : 0] from_omega2_valid,
    
    output reg [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] to_omega1_src_id,
    output reg [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] to_omega1_dst_id,
    output reg [2 * OMEGA_ARRAY_X - 1 : 0] to_omega1_valid,
    output [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] to_omega2_dst_v,
    output [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] to_omega2_dst_id,
    output [2 * OMEGA_ARRAY_X - 1 : 0] to_omega2_valid,

    output [EDGE_PIPELINE_NUM * VERTEX_AWIDTH - 1 : 0] addr_to_hbm,
    output [EDGE_PIPELINE_NUM * VERTEX_DWIDTH - 1 : 0] data_to_hbm,
    output [EDGE_PIPELINE_NUM - 1 : 0] to_hbm_valid
);
    wire [VERTEX_ID_WIDTH * EDGE_PIPELINE_NUM - 1 : 0] bram_src_v;
    reg [VERTEX_ID_WIDTH * EDGE_PIPELINE_NUM - 1 : 0] bram_dst_id [0 : LATENCY];
    reg [EDGE_PIPELINE_NUM - 1 : 0] bram_valid [0 : LATENCY];

    always @ (posedge clk) begin
        if (rst) begin
            to_omega1_src_id <= 0;
            to_omega1_dst_id <= 0;
            to_omega1_valid <= 0;
        end else begin
            to_omega1_src_id <= prev_src_id;
            to_omega1_dst_id <= prev_dst_id;
            to_omega1_valid <= prev_valid;
        end
    end

    integer j;
    always @ (posedge clk) begin
        bram_dst_id[0] <= from_omega1_dst_id;
        bram_valid[0] <= from_omega1_valid;
        for (j = 0; j < LATENCY; j = j + 1) begin
            bram_dst_id[j + 1] <= bram_dst_id[j];
            bram_valid[j + 1] <= bram_valid[j];
        end
    end

    generate
        genvar i;
        for (i = 0; i < EDGE_PIPELINE_NUM; i = i + 1) begin : PROCESSOR_BLOCK_0
            bram_single_node BRAM_SINGLE_NODE (
                .clka       (clk),
                .ena        (!rst),
                .wea        (from_omega2_valid[i]),
                .addra      (from_omega2_dst_id[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH]),
                .dina       (from_omega2_dst_v[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH]),
                .clkb       (clk),
                .enb        (!rst),
                .addrb      (from_omega1_src_id[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH]),
                .doutb      (bram_src_v[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH])
            );
            processor_single PROCESSOR_SINGLE (
                .clk    (clk),
                .rst    (rst),
                .prev_src_v (bram_src_v[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH]),
                .prev_dst_id    (bram_dst_id[LATENCY][(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH]),
                .prev_valid     (bram_valid[LATENCY][i]),

                .dst_v      (to_omega2_dst_v[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH]),
                .dst_id     (to_omega2_dst_id[(i + 1) * VERTEX_ID_WIDTH - 1 : i * VERTEX_ID_WIDTH]),
                .dst_valid  (to_omega2_valid[i]),
                .addr_to_hbm    (addr_to_hbm[(i + 1) * VERTEX_AWIDTH - 1 : i * VERTEX_AWIDTH]),
                .data_to_hbm    (data_to_hbm[(i + 1) * VERTEX_DWIDTH - 1 : i * VERTEX_DWIDTH]),
                .to_hbm_valid   (to_hbm_valid[i])
            );
        end
    endgenerate

endmodule

module processor_single #(parameter
    VERTEX_AWIDTH = `VERTEX_AWIDTH,
    VERTEX_DWIDTH = `VERTEX_DWIDTH,
    VERTEX_ID_WIDTH = `VERTEX_ID_WIDTH
) (
    input clk,
    input rst,
    input [VERTEX_DWIDTH - 1 : 0] prev_src_v,
    input [VERTEX_ID_WIDTH - 1 : 0] prev_dst_id,
    input prev_valid,

    output reg [VERTEX_DWIDTH - 1 : 0] dst_v,
    output reg [VERTEX_ID_WIDTH - 1 : 0] dst_id,
    output reg dst_valid,
    output [VERTEX_AWIDTH - 1 : 0] addr_to_hbm,
    output [VERTEX_DWIDTH - 1 : 0] data_to_hbm,
    output to_hbm_valid 
);
    assign addr_to_hbm = dst_id;
    assign data_to_hbm = dst_v;
    assign to_hbm_valid = dst_valid;
    always @ (posedge clk) begin
        if (rst) begin
            dst_v <= 0;
            dst_id <= 0;
            dst_valid <= 1'b0;
        end else begin
            if (prev_valid) begin
                dst_v <= prev_src_v + 1;
                dst_id <= prev_dst_id;
                dst_valid <= 1'b1;
            end else begin
                dst_v <= 0;
                dst_id <= 0;
                dst_valid <= 1'b0;
            end
        end
    end

endmodule