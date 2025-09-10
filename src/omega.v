`timescale 1ns / 1ps

`include "data_width.vh"

module omega #(parameter
    OMEGA_ARRAY_X = `OMEGA_ARRAY_X,
    OMEGA_ARRAY_Y = `OMEGA_ARRAY_Y,
    VERTEX_ID_WIDTH = `VERTEX_ID_WIDTH
) (
    input clk,
    input rst,
    input [OMEGA_ARRAY_X * 2 * VERTEX_ID_WIDTH - 1 : 0] omega1_src_id_in,
    input [OMEGA_ARRAY_X * 2 * VERTEX_ID_WIDTH - 1 : 0] omega1_dst_id_in,
    input [2 * OMEGA_ARRAY_X - 1 : 0] omega1_valid_in,
    input [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_v_in,
    input [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_id_in,
    input [2 * OMEGA_ARRAY_X - 1 : 0] omega2_valid_in,
    
    output [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega1_src_id_out,
    output [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega1_dst_id_out,
    output [2 * OMEGA_ARRAY_X - 1 : 0] omega1_valid_out,
    output [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_v_out,
    output [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_id_out,
    output [2 * OMEGA_ARRAY_X - 1 : 0] omega2_valid_out
);

    wire [OMEGA_ARRAY_X * 2 * VERTEX_ID_WIDTH - 1 : 0] omega1_src_id_level [0 : OMEGA_ARRAY_Y];
    wire [OMEGA_ARRAY_X * 2 * VERTEX_ID_WIDTH - 1 : 0] omega1_dst_id_level [0 : OMEGA_ARRAY_Y];
    wire [OMEGA_ARRAY_X * 2 - 1 : 0] omega1_valid_level [0 : OMEGA_ARRAY_Y];
    wire [OMEGA_ARRAY_X * 2 * VERTEX_ID_WIDTH - 1 : 0] omega2_dst_v_level [0 : OMEGA_ARRAY_Y];
    wire [OMEGA_ARRAY_X * 2 * VERTEX_ID_WIDTH - 1 : 0] omega2_dst_id_level [0 : OMEGA_ARRAY_Y];
    wire [OMEGA_ARRAY_X * 2 - 1 : 0] omega2_valid_level [0 : OMEGA_ARRAY_Y];

    assign omega1_src_id_level[0] = omega1_src_id_in;
    assign omega1_dst_id_level[0] = omega1_dst_id_in;
    assign omega1_valid_level[0] = omega1_valid_in;
    assign omega2_dst_v_level[0] = omega2_dst_v_in;
    assign omega2_dst_id_level[0] = omega2_dst_id_in;
    assign omega2_valid_level[0] = omega2_valid_in;
    assign omega1_src_id_out = omega1_src_id_level[OMEGA_ARRAY_Y];
    assign omega1_dst_id_out = omega1_dst_id_level[OMEGA_ARRAY_Y];
    assign omega1_valid_out = omega1_valid_level[OMEGA_ARRAY_Y];
    assign omega2_dst_v_out = omega2_dst_v_level[OMEGA_ARRAY_Y];
    assign omega2_dst_id_out = omega2_dst_id_level[OMEGA_ARRAY_Y];
    assign omega2_valid_out = omega2_valid_level[OMEGA_ARRAY_Y];

    generate
        genvar i;
        for (i = 0; i < OMEGA_ARRAY_Y; i = i + 1) begin : OMEGA_BLOCK_0
            omega_single_level OMEGA_SINGLE_LEVEL (
                .clk                (clk),
                .rst                (rst),
                .omega1_src_id_in   (omega1_src_id_level[i]),
                .omega1_dst_id_in   (omega1_dst_id_level[i]),
                .omega1_valid_in    (omega1_valid_level[i]),
                .omega2_dst_v_in    (omega2_dst_v_level[i]),
                .omega2_dst_id_in   (omega2_dst_id_level[i]),
                .omega2_valid_in    (omega2_valid_level[i]),

                .omega1_src_id_out  (omega1_src_id_level[i + 1]),
                .omega1_dst_id_out  (omega1_dst_id_level[i + 1]),
                .omega1_valid_out   (omega1_valid_level[i + 1]),
                .omega2_dst_v_out   (omega2_dst_v_level[i + 1]),
                .omega2_dst_id_out  (omega2_dst_id_level[i + 1]),
                .omega2_valid_out   (omega2_valid_level[i + 1])
            );
        end
    endgenerate

endmodule

module omega_single_level #(parameter
    OMEGA_ARRAY_X = `OMEGA_ARRAY_X,
    OMEGA_ARRAY_Y = `OMEGA_ARRAY_Y,
    VERTEX_ID_WIDTH = `VERTEX_ID_WIDTH
) (
    input clk,
    input rst,
    input [OMEGA_ARRAY_X * 2 * VERTEX_ID_WIDTH - 1 : 0] omega1_src_id_in,
    input [OMEGA_ARRAY_X * 2 * VERTEX_ID_WIDTH - 1 : 0] omega1_dst_id_in,
    input [2 * OMEGA_ARRAY_X - 1 : 0] omega1_valid_in,
    input [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_v_in,
    input [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_id_in,
    input [2 * OMEGA_ARRAY_X - 1 : 0] omega2_valid_in,
    
    output [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega1_src_id_out,
    output [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega1_dst_id_out,
    output [2 * OMEGA_ARRAY_X - 1 : 0] omega1_valid_out,
    output [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_v_out,
    output [VERTEX_ID_WIDTH * 2 * OMEGA_ARRAY_X - 1 : 0] omega2_dst_id_out,
    output [2 * OMEGA_ARRAY_X - 1 : 0] omega2_valid_out
);

    generate
        genvar i;
        for (i = 0; i < OMEGA_ARRAY_X; i = i + 1) begin : OMEGA_SINGLE_LEVEL_BLOCK_0
            omega_single_node OMEGA_SINGLE_NODE (
                .clk            (clk),
                .rst            (rst),
                .omega1_src_id_in1  (omega1_src_id_in[((((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * VERTEX_ID_WIDTH - 1 : (((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) * VERTEX_ID_WIDTH]),
                .omega1_dst_id_in1  (omega1_dst_id_in[((((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * VERTEX_ID_WIDTH - 1 : (((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) * VERTEX_ID_WIDTH]),
                .omega1_valid_in1   (omega1_valid_in[((((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * 1 - 1 : (((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) * 1]),
                .omega1_src_id_in2  (omega1_src_id_in[((((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * VERTEX_ID_WIDTH - 1 : (((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) * VERTEX_ID_WIDTH]),
                .omega1_dst_id_in2  (omega1_dst_id_in[((((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * VERTEX_ID_WIDTH - 1 : (((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) * VERTEX_ID_WIDTH]),
                .omega1_valid_in2   (omega1_valid_in[((((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * 1 - 1 : (((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) * 1]),

                .omega2_dst_v_in1   (omega2_dst_v_in[((((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * VERTEX_ID_WIDTH - 1 : (((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) * VERTEX_ID_WIDTH]),
                .omega2_dst_id_in1  (omega2_dst_id_in[((((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * VERTEX_ID_WIDTH - 1 : (((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) * VERTEX_ID_WIDTH]),
                .omega2_valid_in1   (omega2_valid_in[((((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * 1 - 1 : (((2 * i) >> 1) | (((2 * i) & 1) << (OMEGA_ARRAY_Y - 1))) * 1]),
                .omega2_dst_v_in2   (omega2_dst_v_in[((((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * VERTEX_ID_WIDTH - 1 : (((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) * VERTEX_ID_WIDTH]),
                .omega2_dst_id_in2  (omega2_dst_id_in[((((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * VERTEX_ID_WIDTH - 1 : (((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) * VERTEX_ID_WIDTH]),
                .omega2_valid_in2   (omega2_valid_in[((((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) + 1) * 1 - 1 : (((2 * i + 1) >> 1) | (((2 * i + 1) & 1) << (OMEGA_ARRAY_Y - 1))) * 1]),

                .omega1_src_id_out1 (omega1_src_id_out[(2 * i + 1) * VERTEX_ID_WIDTH - 1 : 2 * i * VERTEX_ID_WIDTH]),
                .omega1_dst_id_out1 (omega1_dst_id_out[(2 * i + 1) * VERTEX_ID_WIDTH - 1 : 2 * i * VERTEX_ID_WIDTH]),
                .omega1_valid_out1  (omega1_valid_out[(2 * i + 1) * 1 - 1 : 2 * i * 1]),
                .omega1_src_id_out2 (omega1_src_id_out[(2 * i + 2) * VERTEX_ID_WIDTH - 1 : (2 * i + 1) * VERTEX_ID_WIDTH]),
                .omega1_dst_id_out2 (omega1_dst_id_out[(2 * i + 2) * VERTEX_ID_WIDTH - 1 : (2 * i + 1) * VERTEX_ID_WIDTH]),
                .omega1_valid_out2  (omega1_valid_out[(2 * i + 2) * 1 - 1 : (2 * i + 1) * 1]),

                .omega2_dst_v_out1  (omega2_dst_v_out[(2 * i + 1) * VERTEX_ID_WIDTH - 1 : 2 * i * VERTEX_ID_WIDTH]),
                .omega2_dst_id_out1 (omega2_dst_id_out[(2 * i + 1) * VERTEX_ID_WIDTH - 1 : 2 * i * VERTEX_ID_WIDTH]),
                .omega2_valid_out1  (omega2_valid_out[(2 * i + 1) * 1 - 1 : 2 * i * 1]),
                .omega2_dst_v_out2  (omega2_dst_v_out[(2 * i + 2) * VERTEX_ID_WIDTH - 1 : (2 * i + 1) * VERTEX_ID_WIDTH]),
                .omega2_dst_id_out2 (omega2_dst_id_out[(2 * i + 2) * VERTEX_ID_WIDTH - 1 : (2 * i + 1) * VERTEX_ID_WIDTH]),
                .omega2_valid_out2  (omega2_valid_out[(2 * i + 2) * 1 - 1 : (2 * i + 1) * 1])
            );
        end
    endgenerate

endmodule

module omega_single_node #(parameter
    VERTEX_ID_WIDTH = `VERTEX_ID_WIDTH
) (
    input clk,
    input rst,
    input [VERTEX_ID_WIDTH - 1 : 0] omega1_src_id_in1,
    input [VERTEX_ID_WIDTH - 1 : 0] omega1_dst_id_in1,
    input omega1_valid_in1,
    input [VERTEX_ID_WIDTH - 1 : 0] omega1_src_id_in2,
    input [VERTEX_ID_WIDTH - 1 : 0] omega1_dst_id_in2,
    input omega1_valid_in2,
    input [VERTEX_ID_WIDTH - 1 : 0] omega2_dst_v_in1,
    input [VERTEX_ID_WIDTH - 1 : 0] omega2_dst_id_in1,
    input omega2_valid_in1,
    input [VERTEX_ID_WIDTH - 1 : 0] omega2_dst_v_in2,
    input [VERTEX_ID_WIDTH - 1 : 0] omega2_dst_id_in2,
    input omega2_valid_in2,

    output reg [VERTEX_ID_WIDTH - 1 : 0] omega1_src_id_out1,
    output reg [VERTEX_ID_WIDTH - 1 : 0] omega1_dst_id_out1,
    output reg omega1_valid_out1,
    output reg [VERTEX_ID_WIDTH - 1 : 0] omega1_src_id_out2,
    output reg [VERTEX_ID_WIDTH - 1 : 0] omega1_dst_id_out2,
    output reg omega1_valid_out2,
    output reg [VERTEX_ID_WIDTH - 1 : 0] omega2_dst_v_out1,
    output reg [VERTEX_ID_WIDTH - 1 : 0] omega2_dst_id_out1,
    output reg omega2_valid_out1,
    output reg [VERTEX_ID_WIDTH - 1 : 0] omega2_dst_v_out2,
    output reg [VERTEX_ID_WIDTH - 1 : 0] omega2_dst_id_out2,
    output reg omega2_valid_out2
);

    always @ (posedge clk) begin
        if (rst) begin
            omega1_src_id_out1 <= 0;
            omega1_dst_id_out1 <= 0;
            omega1_src_id_out2 <= 0;
            omega1_dst_id_out2 <= 0;
            omega1_valid_out1 <= 0;
            omega1_valid_out2 <= 0;
        end
        else begin
            if (omega1_src_id_in1 > omega1_src_id_in2) begin
                omega1_src_id_out1 <= omega1_src_id_in1;
                omega1_dst_id_out1 <= omega1_dst_id_in1;
                omega1_valid_out1 <= omega1_valid_in1;
                omega1_src_id_out2 <= omega1_src_id_in2;
                omega1_dst_id_out2 <= omega1_dst_id_in2;
                omega1_valid_out2 <= omega1_valid_in2;
            end
            else begin
                omega1_src_id_out1 <= omega1_src_id_in2;
                omega1_dst_id_out1 <= omega1_dst_id_in2;
                omega1_valid_out1 <= omega1_valid_in2;
                omega1_src_id_out2 <= omega1_src_id_in1;
                omega1_dst_id_out2 <= omega1_dst_id_in1;
                omega1_valid_out2 <= omega1_valid_in1;
            end
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            omega2_dst_v_out1 <= 0;
            omega2_dst_id_out1 <= 0;
            omega2_dst_v_out2 <= 0;
            omega2_dst_id_out2 <= 0;
            omega2_valid_out1 <= 0;
            omega2_valid_out2 <= 0;
        end
        else begin
            if (omega2_dst_id_in1 > omega2_dst_id_in2) begin
                omega2_dst_v_out1 <= omega2_dst_v_in1;
                omega2_dst_id_out1 <= omega2_dst_id_in1;
                omega2_valid_out1 <= omega2_valid_in1;
                omega2_dst_v_out2 <= omega2_dst_v_in2;
                omega2_dst_id_out2 <= omega2_dst_id_in2;
                omega2_valid_out2 <= omega2_valid_in2;
            end
            else begin
                omega2_dst_v_out1 <= omega2_dst_v_in2;
                omega2_dst_id_out1 <= omega2_dst_id_in2;
                omega2_valid_out1 <= omega2_valid_in2;
                omega2_dst_v_out2 <= omega2_dst_v_in1;
                omega2_dst_id_out2 <= omega2_dst_id_in1;
                omega2_valid_out2 <= omega2_valid_in1;
            end
        end
    end

endmodule