`timescale 1ns / 1ps

`include "accelerator.vh"

module omega_network #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    CORE_NUM = `CORE_NUM
) (
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    om1_front_rst,
    input [CORE_NUM - 1 : 0]                    om1_front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       om1_front_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    om1_front_update_v_value,
    input [CORE_NUM - 1 : 0]                    om1_front_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    om1_front_update_v_valid,
    input [CORE_NUM - 1 : 0]                    om1_front_iteration_end,
    input [CORE_NUM - 1 : 0]                    om1_front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    om2_front_rst,
    input [CORE_NUM - 1 : 0]                    om2_front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       om2_front_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    om2_front_update_v_value,
    input [CORE_NUM - 1 : 0]                    om2_front_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    om2_front_update_v_valid,
    input [CORE_NUM - 1 : 0]                    om2_front_iteration_end,
    input [CORE_NUM - 1 : 0]                    om2_front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    source_core_full,

    output [CORE_NUM - 1 : 0]                   om1_rst,
    output [CORE_NUM - 1 : 0]                   om2_rst,
    output [CORE_NUM - 1 : 0]                   om1_stage_full,
    output [CORE_NUM - 1 : 0]                   om2_stage_full,
    output [CORE_NUM - 1 : 0]                   om1_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      om1_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   om1_update_v_value,
    output [CORE_NUM - 1 : 0]                   om1_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   om1_update_v_valid,
    output [CORE_NUM - 1 : 0]                   om1_iteration_end,
    output [CORE_NUM - 1 : 0]                   om1_iteration_end_valid,
    output [CORE_NUM - 1 : 0]                   om2_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      om2_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   om2_update_v_value,
    output [CORE_NUM - 1 : 0]                   om2_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   om2_update_v_valid,
    output [CORE_NUM - 1 : 0]                   om2_iteration_end,
    output [CORE_NUM - 1 : 0]                   om2_iteration_end_valid
);

/*
    generate
        genvar i;
        for (i = 0; i < CORE_NUM; i = i + 1) begin
            always @ (posedge clk) begin
                next_rst[i] <= rst[i];
                if (rst[i]) begin
                    om1_stage_full[i] <= 0;
                    om1_push_flag[i] <= 0;
                    om1_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH] <= 0;
                    om1_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH] <= 0;
                    om1_update_v_valid[i] <= 0;
                    om1_iteration_end[i] <= 0;
                    om1_iteration_end_valid[i] <= 0;

                    om2_stage_full[i] <= 0;
                    om2_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH] <= 0;
                    om2_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH] <= 0;
                    om2_update_v_valid[i] <= 0;
                    om2_iteration_end[i] <= 0;
                    om2_iteration_end_valid[i] <= 0;
                end else begin
                    om1_stage_full[i] <= 0;
                    om1_push_flag[i] <= om1_front_push_flag[i];
                    om1_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH] <= om1_front_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH];
                    om1_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH] <= om1_front_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH];
                    om1_update_v_valid[i] <= om1_front_update_v_valid[i];
                    om1_iteration_end[i] <= om1_front_iteration_end[i];
                    om1_iteration_end_valid[i] <= om1_front_iteration_end_valid[i];

                    om2_stage_full[i] <= 0;
                    om2_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH] <= om2_front_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH];
                    om2_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH] <= om2_front_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH];
                    om2_update_v_valid[i] <= om2_front_update_v_valid[i];
                    om2_iteration_end[i] <= om2_front_iteration_end[i];
                    om2_iteration_end_valid[i] <= om2_front_iteration_end_valid[i];
                end
            end
        end
    endgenerate
*/
    omega1_network_single OMEGA_NETWORK_1 (
        .clk                            (clk),
        .rst                            (om1_front_rst),
        .om_front_push_flag             (om1_front_push_flag),
        .om_front_update_v_id           (om1_front_update_v_id),
        .om_front_update_v_value        (om1_front_update_v_value),
        .om_front_pull_first_flag       (om1_front_pull_first_flag),
        .om_front_update_v_valid        (om1_front_update_v_valid),
        .om_front_iteration_end         (om1_front_iteration_end),
        .om_front_iteration_end_valid   (om1_front_iteration_end_valid),
        .source_core_full               (source_core_full),

        .om_rst                         (om1_rst),
        .om_stage_full                  (om1_stage_full),
        .om_push_flag                   (om1_push_flag),
        .om_update_v_id                 (om1_update_v_id),
        .om_update_v_value              (om1_update_v_value),
        .om_pull_first_flag             (om1_pull_first_flag),
        .om_update_v_valid              (om1_update_v_valid),
        .om_iteration_end               (om1_iteration_end),
        .om_iteration_end_valid         (om1_iteration_end_valid)
    );

    omega2_network_single OMEGA_NETWORK_2 (
        .clk                            (clk),
        .rst                            (om2_front_rst),
        .om_front_push_flag             (om2_front_push_flag),
        .om_front_update_v_id           (om2_front_update_v_id),
        .om_front_update_v_value        (om2_front_update_v_value),
        .om_front_pull_first_flag       (om2_front_pull_first_flag),
        .om_front_update_v_valid        (om2_front_update_v_valid),
        .om_front_iteration_end         (om2_front_iteration_end),
        .om_front_iteration_end_valid   (om2_front_iteration_end_valid),

        .om_rst                 (om2_rst),
        .om_stage_full          (om2_stage_full),
        .om_push_flag           (om2_push_flag),
        .om_update_v_id         (om2_update_v_id),
        .om_update_v_value      (om2_update_v_value),
        .om_pull_first_flag     (om2_pull_first_flag),
        .om_update_v_valid      (om2_update_v_valid),
        .om_iteration_end       (om2_iteration_end),
        .om_iteration_end_valid (om2_iteration_end_valid)
    );

endmodule

module omega1_network_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    OMEGA_DEPTH = `OMEGA_DEPTH,
    OMEGA_SWITCH_NUM = `OMEGA_SWITCH_NUM,
    CORE_NUM = `CORE_NUM
) (
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    rst,
    input [CORE_NUM - 1 : 0]                    om_front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       om_front_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    om_front_update_v_value,
    input [CORE_NUM - 1 : 0]                    om_front_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    om_front_update_v_valid,
    input [CORE_NUM - 1 : 0]                    om_front_iteration_end,
    input [CORE_NUM - 1 : 0]                    om_front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    source_core_full,

    output [CORE_NUM - 1 : 0]                   om_rst,
    output [CORE_NUM - 1 : 0]                   om_stage_full,
    output [CORE_NUM - 1 : 0]                   om_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      om_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   om_update_v_value,
    output [CORE_NUM - 1 : 0]                   om_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   om_update_v_valid,
    output [CORE_NUM - 1 : 0]                   om_iteration_end,
    output [CORE_NUM - 1 : 0]                   om_iteration_end_valid
);

    wire [CORE_NUM - 1 : 0] om_push_flag_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0] om_update_v_id_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] om_update_v_value_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_pull_first_flag_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_update_v_valid_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_iteration_end_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_iteration_end_valid_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_next_stage_full_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_rst_level [0 : OMEGA_DEPTH];

    assign om_push_flag_level[0] = om_front_push_flag;
    assign om_update_v_id_level[0] = om_front_update_v_id;
    assign om_update_v_value_level[0] = om_front_update_v_value;
    assign om_pull_first_flag_level[0] = om_front_pull_first_flag;
    assign om_update_v_valid_level[0] = om_front_update_v_valid;
    assign om_iteration_end_level[0] = om_front_iteration_end;
    assign om_iteration_end_valid_level[0] = om_front_iteration_end_valid;
    assign om_next_stage_full_level[OMEGA_DEPTH] = source_core_full;
    assign om_rst_level[0] = rst;

    assign om_stage_full = om_next_stage_full_level[0];
    assign om_push_flag = om_push_flag_level[OMEGA_DEPTH];
    assign om_update_v_id = om_update_v_id_level[OMEGA_DEPTH];
    assign om_update_v_value = om_update_v_value_level[OMEGA_DEPTH];
    assign om_pull_first_flag = om_pull_first_flag_level[OMEGA_DEPTH];
    assign om_update_v_valid = om_update_v_valid_level[OMEGA_DEPTH];
    assign om_iteration_end = om_iteration_end_level[OMEGA_DEPTH];
    assign om_iteration_end_valid = om_iteration_end_valid_level[OMEGA_DEPTH];
    assign om_rst = om_rst_level[OMEGA_DEPTH];

    generate
        genvar i;
        for (i = 0; i < OMEGA_DEPTH; i = i + 1) begin
            omega1_network_level_single #(.LEVEL_ID(i)) OMEGA_NETWORK_LEVEL_SINGLE (
                .clk                        (clk),
                .rst                        (om_rst_level[i]),
                .om_front_push_flag         (om_push_flag_level[i]),
                .om_front_update_v_id       (om_update_v_id_level[i]),
                .om_front_update_v_value    (om_update_v_value_level[i]),
                .om_front_pull_first_flag   (om_pull_first_flag_level[i]),
                .om_front_update_v_valid    (om_update_v_valid_level[i]),
                .om_front_iteration_end     (om_iteration_end_level[i]),
                .om_front_iteration_end_valid (om_iteration_end_valid_level[i]),
                .om_next_stage_full         (om_next_stage_full_level[i + 1]),
                
                .om_rst             (om_rst_level[i + 1]),
                .om_stage_full      (om_next_stage_full_level[i]),
                .om_push_flag       (om_push_flag_level[i + 1]),
                .om_update_v_id     (om_update_v_id_level[i + 1]),
                .om_update_v_value  (om_update_v_value_level[i + 1]),
                .om_pull_first_flag (om_pull_first_flag_level[i + 1]),
                .om_update_v_valid  (om_update_v_valid_level[i + 1]),
                .om_iteration_end   (om_iteration_end_level[i + 1]),
                .om_iteration_end_valid   (om_iteration_end_valid_level[i + 1])
            );
        end
    endgenerate

endmodule

module omega1_network_level_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    OMEGA_DEPTH = `OMEGA_DEPTH,
    OMEGA_SWITCH_NUM = `OMEGA_SWITCH_NUM,
    LEVEL_ID = 0,
    CORE_NUM = `CORE_NUM
) (
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    rst,
    input [CORE_NUM - 1 : 0]                    om_front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       om_front_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    om_front_update_v_value,
    input [CORE_NUM - 1 : 0]                    om_front_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    om_front_update_v_valid,
    input [CORE_NUM - 1 : 0]                    om_front_iteration_end,
    input [CORE_NUM - 1 : 0]                    om_front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    om_next_stage_full,

    output reg [CORE_NUM - 1 : 0]               om_rst,
    output [CORE_NUM - 1 : 0]                   om_stage_full,
    output [CORE_NUM - 1 : 0]                   om_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      om_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   om_update_v_value,
    output [CORE_NUM - 1 : 0]                   om_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   om_update_v_valid,
    output [CORE_NUM - 1 : 0]                   om_iteration_end,
    output [CORE_NUM - 1 : 0]                   om_iteration_end_valid
);

    always @ (posedge clk) begin
        om_rst <= rst;
    end

    generate
        genvar i;
        for (i = 0; i < OMEGA_SWITCH_NUM; i = i + 1) begin
            omega1_network_switcher_single #(.LEVEL_ID(LEVEL_ID), .SWITCHER_ID(i)) OMEGA_NETWORK_SWITCHER_SINGLE (
                .clk                    (clk),
                .rst                    (rst[i]),
                .front_push_flag_1      (om_front_push_flag[i]),
                .front_update_v_id_1    (om_front_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .front_update_v_value_1 (om_front_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .front_pull_first_flag_1(om_front_pull_first_flag[i]),
                .front_update_v_valid_1 (om_front_update_v_valid[i]),
                .front_iteration_end_1      (om_front_iteration_end[i]),
                .front_iteration_end_valid_1(om_front_iteration_end_valid[i]),
                .next_stage_full_1      (om_next_stage_full[i << 1]),
                .front_push_flag_2      (om_front_push_flag[i + OMEGA_SWITCH_NUM]),
                .front_update_v_id_2    (om_front_update_v_id[(i + OMEGA_SWITCH_NUM + 1) * V_ID_WIDTH - 1 : (i + OMEGA_SWITCH_NUM) * V_ID_WIDTH]),
                .front_update_v_value_2 (om_front_update_v_value[(i + OMEGA_SWITCH_NUM + 1) * V_VALUE_WIDTH - 1 : (i + OMEGA_SWITCH_NUM) * V_VALUE_WIDTH]),
                .front_pull_first_flag_2(om_front_pull_first_flag[i + OMEGA_SWITCH_NUM]),
                .front_update_v_valid_2 (om_front_update_v_valid[i + OMEGA_SWITCH_NUM]),
                .front_iteration_end_2      (om_front_iteration_end[i + OMEGA_SWITCH_NUM]),
                .front_iteration_end_valid_2(om_front_iteration_end_valid[i + OMEGA_SWITCH_NUM]),
                .next_stage_full_2      (om_next_stage_full[(i << 1) + 1]),

                .push_flag_1            (om_push_flag[2 * i]),
                .update_v_id_1          (om_update_v_id[(2 * i + 1) * V_ID_WIDTH - 1 : (2 * i) * V_ID_WIDTH]),
                .update_v_value_1       (om_update_v_value[(2 * i + 1) * V_VALUE_WIDTH - 1 : (2 * i) * V_VALUE_WIDTH]),
                .pull_first_flag_1      (om_pull_first_flag[2 * i]),
                .update_v_valid_1       (om_update_v_valid[2 * i]),
                .iteration_end_1        (om_iteration_end[2 * i]),
                .iteration_end_valid_1  (om_iteration_end_valid[2 * i]),
                .stage_full_1           (om_stage_full[i]),
                .push_flag_2            (om_push_flag[2 * i + 1]),
                .update_v_id_2          (om_update_v_id[(2 * i + 2) * V_ID_WIDTH - 1 : (2 * i + 1) * V_ID_WIDTH]),
                .update_v_value_2       (om_update_v_value[(2 * i + 2) * V_VALUE_WIDTH - 1 : (2 * i + 1) * V_VALUE_WIDTH]),
                .pull_first_flag_2      (om_pull_first_flag[2 * i + 1]),
                .update_v_valid_2       (om_update_v_valid[2 * i + 1]),
                .iteration_end_2        (om_iteration_end[2 * i + 1]),
                .iteration_end_valid_2  (om_iteration_end_valid[2 * i + 1]),
                .stage_full_2           (om_stage_full[i + OMEGA_SWITCH_NUM])
            );
        end
    endgenerate

endmodule

module omega1_network_switcher_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    OMEGA_DEPTH = `OMEGA_DEPTH,
    OMEGA_SWITCH_NUM = `OMEGA_SWITCH_NUM,
    LEVEL_ID = 0,
    SWITCHER_ID = 0,
    OM_FIFO_SIZE_WIDTH = `OM_FIFO_SIZE_WIDTH,
    CORE_NUM = `CORE_NUM
) (
    input                           clk,
    input                           rst,
    input                           front_push_flag_1,
    input [V_ID_WIDTH - 1 : 0]      front_update_v_id_1,
    input [V_VALUE_WIDTH - 1 : 0]   front_update_v_value_1,
    input                           front_pull_first_flag_1,
    input                           front_update_v_valid_1,
    input                           front_iteration_end_1,
    input                           front_iteration_end_valid_1,
    input                           next_stage_full_1,
    input                           front_push_flag_2,
    input [V_ID_WIDTH - 1 : 0]      front_update_v_id_2,
    input [V_VALUE_WIDTH - 1 : 0]   front_update_v_value_2,
    input                           front_pull_first_flag_2,
    input                           front_update_v_valid_2,
    input                           front_iteration_end_2,
    input                           front_iteration_end_valid_2,
    input                           next_stage_full_2,

    output reg                          push_flag_1,
    output reg [V_ID_WIDTH - 1 : 0]     update_v_id_1,
    output reg [V_VALUE_WIDTH - 1 : 0]  update_v_value_1,
    output reg                          pull_first_flag_1,
    output reg                          update_v_valid_1,
    output reg                          iteration_end_1,
    output reg                          iteration_end_valid_1,
    output                              stage_full_1,
    output reg                          push_flag_2,
    output reg [V_ID_WIDTH - 1 : 0]     update_v_id_2,
    output reg [V_VALUE_WIDTH - 1 : 0]  update_v_value_2,
    output reg                          pull_first_flag_2,
    output reg                          update_v_valid_2,
    output reg                          iteration_end_2,
    output reg                          iteration_end_valid_2,
    output                              stage_full_2
);

    wire in1_route_flag, in2_route_flag;
    wire buffer_empty_in1_out1, buffer_full_in1_out1;
    wire buffer_empty_in1_out2, buffer_full_in1_out2;
    wire buffer_empty_in2_out1, buffer_full_in2_out1;
    wire buffer_empty_in2_out2, buffer_full_in2_out2;
    wire [OM_FIFO_SIZE_WIDTH - 1 : 0] buffer_size_in1_out1, buffer_size_in1_out2, buffer_size_in2_out1, buffer_size_in2_out2;
    wire read_in1_out1, read_in1_out2, read_in2_out1, read_in2_out2;
    wire write_in1_out1, write_in1_out2, write_in2_out1, write_in2_out2;
    wire push_flag_in1_out1_top, push_flag_in1_out2_top, push_flag_in2_out1_top, push_flag_in2_out2_top;
    wire [V_ID_WIDTH - 1 : 0] v_id_in1_out1_top, v_id_in1_out2_top, v_id_in2_out1_top, v_id_in2_out2_top;
    wire [V_VALUE_WIDTH - 1 : 0] v_value_in1_out1_top, v_value_in1_out2_top, v_value_in2_out1_top, v_value_in2_out2_top;
    wire pull_first_flag_in1_out1_top, pull_first_flag_in1_out2_top, pull_first_flag_in2_out1_top, pull_first_flag_in2_out2_top;

    assign in1_route_flag = 0 ^ (front_push_flag_1 ? front_update_v_id_1[OMEGA_DEPTH - LEVEL_ID - 1] : front_update_v_value_1[OMEGA_DEPTH - LEVEL_ID - 1]);
    assign in2_route_flag = 1 ^ (front_push_flag_2 ? front_update_v_id_2[OMEGA_DEPTH - LEVEL_ID - 1] : front_update_v_value_2[OMEGA_DEPTH - LEVEL_ID - 1]);
    assign stage_full_1 = buffer_full_in1_out1 || buffer_full_in1_out2;
    assign stage_full_2 = buffer_full_in2_out1 || buffer_full_in2_out2;
    assign read_in1_out1 = !next_stage_full_1 && buffer_size_in1_out1 > buffer_size_in2_out1;
    assign read_in2_out1 = !next_stage_full_1 && !buffer_empty_in2_out1 && buffer_size_in2_out1 >= buffer_size_in1_out1;
    assign read_in1_out2 = !next_stage_full_2 && buffer_size_in1_out2 > buffer_size_in2_out2;
    assign read_in2_out2 = !next_stage_full_2 && !buffer_empty_in2_out2 && buffer_size_in2_out2 >= buffer_size_in1_out2;
    assign write_in1_out1 = front_update_v_valid_1 && !in1_route_flag;
    assign write_in1_out2 = front_update_v_valid_1 && in1_route_flag;
    assign write_in2_out1 = front_update_v_valid_2 && in2_route_flag;
    assign write_in2_out2 = front_update_v_valid_2 && !in2_route_flag;

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PUSH_FLAG_FIFO_FT_IN1_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag_1),
        .wr_en      (write_in1_out1),
        .rd_en      (read_in1_out1),
        .dout       (push_flag_in1_out1_top),
        .data_count (buffer_size_in1_out1),
        .prog_full(buffer_full_in1_out1),
        .full       (),
        .empty      (buffer_empty_in1_out1),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PUSH_FLAG_FIFO_FT_IN1_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag_1),
        .wr_en      (write_in1_out2),
        .rd_en      (read_in1_out2),
        .dout       (push_flag_in1_out2_top),
        .data_count (buffer_size_in1_out2),
        .prog_full(buffer_full_in1_out2),
        .full       (),
        .empty      (buffer_empty_in1_out2),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PUSH_FLAG_FIFO_FT_IN2_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag_2),
        .wr_en      (write_in2_out1),
        .rd_en      (read_in2_out1),
        .dout       (push_flag_in2_out1_top),
        .data_count (buffer_size_in2_out1),
        .prog_full(buffer_full_in2_out1),
        .full       (),
        .empty      (buffer_empty_in2_out1),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PUSH_FLAG_FIFO_FT_IN2_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag_2),
        .wr_en      (write_in2_out2),
        .rd_en      (read_in2_out2),
        .dout       (push_flag_in2_out2_top),
        .data_count (buffer_size_in2_out2),
        .prog_full(buffer_full_in2_out2),
        .full       (),
        .empty      (buffer_empty_in2_out2),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_ID_FIFO_FT_IN1_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_id_1),
        .wr_en      (write_in1_out1),
        .rd_en      (read_in1_out1),
        .dout       (v_id_in1_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_ID_FIFO_FT_IN1_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_id_1),
        .wr_en      (write_in1_out2),
        .rd_en      (read_in1_out2),
        .dout       (v_id_in1_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_ID_FIFO_FT_IN2_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_id_2),
        .wr_en      (write_in2_out1),
        .rd_en      (read_in2_out1),
        .dout       (v_id_in2_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_ID_FIFO_FT_IN2_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_id_2),
        .wr_en      (write_in2_out2),
        .rd_en      (read_in2_out2),
        .dout       (v_id_in2_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_VALUE_FIFO_FT_IN1_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_value_1),
        .wr_en      (write_in1_out1),
        .rd_en      (read_in1_out1),
        .dout       (v_value_in1_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_VALUE_FIFO_FT_IN1_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_value_1),
        .wr_en      (write_in1_out2),
        .rd_en      (read_in1_out2),
        .dout       (v_value_in1_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_VALUE_FIFO_FT_IN2_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_value_2),
        .wr_en      (write_in2_out1),
        .rd_en      (read_in2_out1),
        .dout       (v_value_in2_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_VALUE_FIFO_FT_IN2_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_value_2),
        .wr_en      (write_in2_out2),
        .rd_en      (read_in2_out2),
        .dout       (v_value_in2_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PULL_FIRST_FLAG_FIFO_IN1_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_pull_first_flag_1),
        .wr_en      (write_in1_out1),
        .rd_en      (read_in1_out1),
        .dout       (pull_first_flag_in1_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PULL_FIRST_FLAG_FIFO_IN1_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_pull_first_flag_1),
        .wr_en      (write_in1_out2),
        .rd_en      (read_in1_out2),
        .dout       (pull_first_flag_in1_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PULL_FIRST_FLAG_FIFO_IN2_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_pull_first_flag_2),
        .wr_en      (write_in2_out1),
        .rd_en      (read_in2_out1),
        .dout       (pull_first_flag_in2_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PULL_FIRST_FLAG_FIFO_IN2_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_pull_first_flag_2),
        .wr_en      (write_in2_out2),
        .rd_en      (read_in2_out2),
        .dout       (pull_first_flag_in2_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );
    
    always @ (posedge clk) begin
        if (rst || next_stage_full_1) begin
            push_flag_1 <= 0;
            update_v_id_1 <= 0;
            update_v_value_1 <= 0;
            update_v_valid_1 <= 0;
            pull_first_flag_1 <= 0;
        end else begin
            if (buffer_size_in1_out1 > buffer_size_in2_out1 && !buffer_empty_in1_out1) begin
                push_flag_1 <= push_flag_in1_out1_top;
                update_v_id_1 <= v_id_in1_out1_top;
                update_v_value_1 <= v_value_in1_out1_top;
                pull_first_flag_1 <= pull_first_flag_in1_out1_top;
                update_v_valid_1 <= 1;
            end else begin
                if (buffer_empty_in2_out1 || buffer_size_in1_out1 > buffer_size_in2_out1) begin
                    push_flag_1 <= 0;
                    update_v_id_1 <= 0;
                    update_v_value_1 <= 0;
                    update_v_valid_1 <= 0;
                    pull_first_flag_1 <= 0;
                end else begin
                    push_flag_1 <= push_flag_in2_out1_top;
                    update_v_id_1 <= v_id_in2_out1_top;
                    update_v_value_1 <= v_value_in2_out1_top;
                    pull_first_flag_1 <= pull_first_flag_in2_out1_top;
                    update_v_valid_1 <= 1;
                end
            end
        end
    end

    always @ (posedge clk) begin
        if (rst || next_stage_full_2) begin
            push_flag_2 <= 0;
            update_v_id_2 <= 0;
            update_v_value_2 <= 0;
            update_v_valid_2 <= 0;
            pull_first_flag_2 <= 0;
        end else begin
            if (buffer_size_in1_out2 > buffer_size_in2_out2 && !buffer_empty_in1_out2) begin
                push_flag_2 <= push_flag_in1_out2_top;
                update_v_id_2 <= v_id_in1_out2_top;
                update_v_value_2 <= v_value_in1_out2_top;
                pull_first_flag_2 <= pull_first_flag_in1_out2_top;
                update_v_valid_2 <= 1;
            end else begin
                if (buffer_empty_in2_out2 || buffer_size_in1_out2 > buffer_size_in2_out2) begin
                    push_flag_2 <= 0;
                    update_v_id_2 <= 0;
                    update_v_value_2 <= 0;
                    update_v_valid_2 <= 0;
                    pull_first_flag_2 <= 0;
                end else begin
                    push_flag_2 <= push_flag_in2_out2_top;
                    update_v_id_2 <= v_id_in2_out2_top;
                    update_v_value_2 <= v_value_in2_out2_top;
                    pull_first_flag_2 <= pull_first_flag_in2_out2_top;
                    update_v_valid_2 <= 1;
                end
            end
        end
    end
    
    always @ (posedge clk) begin
        if(!rst && front_iteration_end_1 && front_iteration_end_valid_1 && buffer_empty_in1_out1 && buffer_empty_in2_out1 && !buffer_size_in1_out1 && !buffer_size_in2_out1)begin
            iteration_end_1 <= 1;
            iteration_end_valid_1 <= 1;
        end
        else begin
            iteration_end_1 <= 0;
            iteration_end_valid_1 <= 0;
        end
        if(!rst && front_iteration_end_2 && front_iteration_end_valid_2 && buffer_empty_in1_out2 && buffer_empty_in2_out2 && !buffer_size_in1_out2 && !buffer_size_in2_out2)begin
            iteration_end_2 <= 1;
            iteration_end_valid_2 <= 1;
        end
        else begin
            iteration_end_2 <= 0;
            iteration_end_valid_2 <= 0;
        end
    end

endmodule

module omega2_network_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    OMEGA_DEPTH = `OMEGA_DEPTH,
    OMEGA_SWITCH_NUM = `OMEGA_SWITCH_NUM,
    CORE_NUM = `CORE_NUM
) (
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    rst,
    input [CORE_NUM - 1 : 0]                    om_front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       om_front_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    om_front_update_v_value,
    input [CORE_NUM - 1 : 0]                    om_front_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    om_front_update_v_valid,
    input [CORE_NUM - 1 : 0]                    om_front_iteration_end,
    input [CORE_NUM - 1 : 0]                    om_front_iteration_end_valid,

    output [CORE_NUM - 1 : 0]                   om_rst,
    output [CORE_NUM - 1 : 0]                   om_stage_full,
    output [CORE_NUM - 1 : 0]                   om_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      om_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   om_update_v_value,
    output [CORE_NUM - 1 : 0]                   om_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   om_update_v_valid,
    output [CORE_NUM - 1 : 0]                   om_iteration_end,
    output [CORE_NUM - 1 : 0]                   om_iteration_end_valid
);

    wire [CORE_NUM - 1 : 0] om_push_flag_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM * V_ID_WIDTH - 1 : 0] om_update_v_id_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM * V_VALUE_WIDTH - 1 : 0] om_update_v_value_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_pull_first_flag_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_update_v_valid_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_iteration_end_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_iteration_end_valid_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_next_stage_full_level [0 : OMEGA_DEPTH];
    wire [CORE_NUM - 1 : 0] om_rst_level [0 : OMEGA_DEPTH];

    assign om_push_flag_level[0] = om_front_push_flag;
    assign om_update_v_id_level[0] = om_front_update_v_id;
    assign om_update_v_value_level[0] = om_front_update_v_value;
    assign om_pull_first_flag_level[0] = om_front_pull_first_flag;
    assign om_update_v_valid_level[0] = om_front_update_v_valid;
    assign om_iteration_end_level[0] = om_front_iteration_end;
    assign om_iteration_end_valid_level[0] = om_front_iteration_end_valid;
    assign om_next_stage_full_level[OMEGA_DEPTH] = 0;
    assign om_rst_level[0] = rst;

    assign om_stage_full = om_next_stage_full_level[0];
    assign om_push_flag = om_push_flag_level[OMEGA_DEPTH];
    assign om_update_v_id = om_update_v_id_level[OMEGA_DEPTH];
    assign om_update_v_value = om_update_v_value_level[OMEGA_DEPTH];
    assign om_pull_first_flag = om_pull_first_flag_level[OMEGA_DEPTH];
    assign om_update_v_valid = om_update_v_valid_level[OMEGA_DEPTH];
    assign om_iteration_end = om_iteration_end_level[OMEGA_DEPTH];
    assign om_iteration_end_valid = om_iteration_end_valid_level[OMEGA_DEPTH];
    assign om_rst = om_rst_level[OMEGA_DEPTH];

    generate
        genvar i;
        for (i = 0; i < OMEGA_DEPTH; i = i + 1) begin
            omega2_network_level_single #(.LEVEL_ID(i)) OMEGA_NETWORK_LEVEL_SINGLE (
                .clk                    (clk),
                .rst                    (om_rst_level[i]),
                .om_front_push_flag     (om_push_flag_level[i]),
                .om_front_update_v_id   (om_update_v_id_level[i]),
                .om_front_update_v_value(om_update_v_value_level[i]),
                .om_front_pull_first_flag   (om_pull_first_flag_level[i]),
                .om_front_update_v_valid(om_update_v_valid_level[i]),
                .om_front_iteration_end (om_iteration_end_level[i]),
                .om_front_iteration_end_valid (om_iteration_end_valid_level[i]),
                .om_next_stage_full     (om_next_stage_full_level[i + 1]),
                
                .om_rst             (om_rst_level[i + 1]),
                .om_stage_full      (om_next_stage_full_level[i]),
                .om_push_flag       (om_push_flag_level[i + 1]),
                .om_update_v_id     (om_update_v_id_level[i + 1]),
                .om_update_v_value  (om_update_v_value_level[i + 1]),
                .om_pull_first_flag (om_pull_first_flag_level[i + 1]),
                .om_update_v_valid  (om_update_v_valid_level[i + 1]),
                .om_iteration_end   (om_iteration_end_level[i + 1]),
                .om_iteration_end_valid   (om_iteration_end_valid_level[i + 1])
            );
        end
    endgenerate

endmodule

module omega2_network_level_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    OMEGA_DEPTH = `OMEGA_DEPTH,
    OMEGA_SWITCH_NUM = `OMEGA_SWITCH_NUM,
    LEVEL_ID = 0,
    CORE_NUM = `CORE_NUM
) (
    input                                       clk,
    input [CORE_NUM - 1 : 0]                    rst,
    input [CORE_NUM - 1 : 0]                    om_front_push_flag,
    input [CORE_NUM * V_ID_WIDTH - 1 : 0]       om_front_update_v_id,
    input [CORE_NUM * V_VALUE_WIDTH - 1 : 0]    om_front_update_v_value,
    input [CORE_NUM - 1 : 0]                    om_front_pull_first_flag,
    input [CORE_NUM - 1 : 0]                    om_front_update_v_valid,
    input [CORE_NUM - 1 : 0]                    om_front_iteration_end,
    input [CORE_NUM - 1 : 0]                    om_front_iteration_end_valid,
    input [CORE_NUM - 1 : 0]                    om_next_stage_full,

    output reg [CORE_NUM - 1 : 0]               om_rst,
    output [CORE_NUM - 1 : 0]                   om_stage_full,
    output [CORE_NUM - 1 : 0]                   om_push_flag,
    output [CORE_NUM * V_ID_WIDTH - 1 : 0]      om_update_v_id,
    output [CORE_NUM * V_VALUE_WIDTH - 1 : 0]   om_update_v_value,
    output [CORE_NUM - 1 : 0]                   om_pull_first_flag,
    output [CORE_NUM - 1 : 0]                   om_update_v_valid,
    output [CORE_NUM - 1 : 0]                   om_iteration_end,
    output [CORE_NUM - 1 : 0]                   om_iteration_end_valid
);

    always @ (posedge clk) begin
        om_rst <= rst;
    end

    generate
        genvar i;
        for (i = 0; i < OMEGA_SWITCH_NUM; i = i + 1) begin
            omega2_network_switcher_single #(.LEVEL_ID(LEVEL_ID), .SWITCHER_ID(i)) OMEGA_NETWORK_SWITCHER_SINGLE (
                .clk                    (clk),
                .rst                    (rst[i]),
                .front_push_flag_1      (om_front_push_flag[i]),
                .front_update_v_id_1    (om_front_update_v_id[(i + 1) * V_ID_WIDTH - 1 : i * V_ID_WIDTH]),
                .front_update_v_value_1 (om_front_update_v_value[(i + 1) * V_VALUE_WIDTH - 1 : i * V_VALUE_WIDTH]),
                .front_pull_first_flag_1(om_front_pull_first_flag[i]),
                .front_update_v_valid_1 (om_front_update_v_valid[i]),
                .front_iteration_end_1      (om_front_iteration_end[i]),
                .front_iteration_end_valid_1(om_front_iteration_end_valid[i]),
                .next_stage_full_1      (om_next_stage_full[i << 1]),
                .front_push_flag_2      (om_front_push_flag[i + OMEGA_SWITCH_NUM]),
                .front_update_v_id_2    (om_front_update_v_id[(i + OMEGA_SWITCH_NUM + 1) * V_ID_WIDTH - 1 : (i + OMEGA_SWITCH_NUM) * V_ID_WIDTH]),
                .front_update_v_value_2 (om_front_update_v_value[(i + OMEGA_SWITCH_NUM + 1) * V_VALUE_WIDTH - 1 : (i + OMEGA_SWITCH_NUM) * V_VALUE_WIDTH]),
                .front_pull_first_flag_2(om_front_pull_first_flag[i + OMEGA_SWITCH_NUM]),
                .front_update_v_valid_2 (om_front_update_v_valid[i + OMEGA_SWITCH_NUM]),
                .front_iteration_end_2      (om_front_iteration_end[i + OMEGA_SWITCH_NUM]),
                .front_iteration_end_valid_2(om_front_iteration_end_valid[i + OMEGA_SWITCH_NUM]),
                .next_stage_full_2      (om_next_stage_full[(i << 1) + 1]),

                .push_flag_1            (om_push_flag[2 * i]),
                .update_v_id_1          (om_update_v_id[(2 * i + 1) * V_ID_WIDTH - 1 : (2 * i) * V_ID_WIDTH]),
                .update_v_value_1       (om_update_v_value[(2 * i + 1) * V_VALUE_WIDTH - 1 : (2 * i) * V_VALUE_WIDTH]),
                .pull_first_flag_1      (om_pull_first_flag[2 * i]),
                .update_v_valid_1       (om_update_v_valid[2 * i]),
                .iteration_end_1        (om_iteration_end[2 * i]),
                .iteration_end_valid_1  (om_iteration_end_valid[2 * i]),
                .stage_full_1           (om_stage_full[i]),
                .push_flag_2            (om_push_flag[2 * i + 1]),
                .update_v_id_2          (om_update_v_id[(2 * i + 2) * V_ID_WIDTH - 1 : (2 * i + 1) * V_ID_WIDTH]),
                .update_v_value_2       (om_update_v_value[(2 * i + 2) * V_VALUE_WIDTH - 1 : (2 * i + 1) * V_VALUE_WIDTH]),
                .pull_first_flag_2      (om_pull_first_flag[2 * i + 1]),
                .update_v_valid_2       (om_update_v_valid[2 * i + 1]),
                .iteration_end_2        (om_iteration_end[2 * i + 1]),
                .iteration_end_valid_2  (om_iteration_end_valid[2 * i + 1]),
                .stage_full_2           (om_stage_full[i + OMEGA_SWITCH_NUM])
            );
        end
    endgenerate

endmodule

module omega2_network_switcher_single #(parameter
    V_ID_WIDTH = `V_ID_WIDTH,
    V_VALUE_WIDTH = `V_VALUE_WIDTH,
    OMEGA_DEPTH = `OMEGA_DEPTH,
    OMEGA_SWITCH_NUM = `OMEGA_SWITCH_NUM,
    LEVEL_ID = 0,
    SWITCHER_ID = 0,
    OM_FIFO_SIZE_WIDTH = `OM_FIFO_SIZE_WIDTH,
    CORE_NUM = `CORE_NUM
) (
    input                           clk,
    input                           rst,
    input                           front_push_flag_1,
    input [V_ID_WIDTH - 1 : 0]      front_update_v_id_1,
    input [V_VALUE_WIDTH - 1 : 0]   front_update_v_value_1,
    input                           front_pull_first_flag_1,
    input                           front_update_v_valid_1,
    input                           front_iteration_end_1,
    input                           front_iteration_end_valid_1,
    input                           next_stage_full_1,
    input                           front_push_flag_2,
    input [V_ID_WIDTH - 1 : 0]      front_update_v_id_2,
    input [V_VALUE_WIDTH - 1 : 0]   front_update_v_value_2,
    input                           front_pull_first_flag_2,
    input                           front_update_v_valid_2,
    input                           front_iteration_end_2,
    input                           front_iteration_end_valid_2,
    input                           next_stage_full_2,

    output reg                          push_flag_1,
    output reg [V_ID_WIDTH - 1 : 0]     update_v_id_1,
    output reg [V_VALUE_WIDTH - 1 : 0]  update_v_value_1,
    output reg                          update_v_valid_1,
    output reg                          pull_first_flag_1,
    output reg                          iteration_end_1,
    output reg                          iteration_end_valid_1,
    output                              stage_full_1,
    output reg                          push_flag_2,
    output reg [V_ID_WIDTH - 1 : 0]     update_v_id_2,
    output reg [V_VALUE_WIDTH - 1 : 0]  update_v_value_2,
    output reg                          pull_first_flag_2,
    output reg                          update_v_valid_2,
    output reg                          iteration_end_2,
    output reg                          iteration_end_valid_2,
    output                              stage_full_2
);

    wire in1_route_flag, in2_route_flag;
    wire buffer_empty_in1_out1, buffer_full_in1_out1;
    wire buffer_empty_in1_out2, buffer_full_in1_out2;
    wire buffer_empty_in2_out1, buffer_full_in2_out1;
    wire buffer_empty_in2_out2, buffer_full_in2_out2;
    wire [OM_FIFO_SIZE_WIDTH - 1 : 0] buffer_size_in1_out1, buffer_size_in1_out2, buffer_size_in2_out1, buffer_size_in2_out2;
    wire read_in1_out1, read_in1_out2, read_in2_out1, read_in2_out2;
    wire write_in1_out1, write_in1_out2, write_in2_out1, write_in2_out2;
    wire push_flag_in1_out1_top, push_flag_in1_out2_top, push_flag_in2_out1_top, push_flag_in2_out2_top;
    wire [V_ID_WIDTH - 1 : 0] v_id_in1_out1_top, v_id_in1_out2_top, v_id_in2_out1_top, v_id_in2_out2_top;
    wire [V_VALUE_WIDTH - 1 : 0] v_value_in1_out1_top, v_value_in1_out2_top, v_value_in2_out1_top, v_value_in2_out2_top;
    wire pull_first_flag_in1_out1_top, pull_first_flag_in1_out2_top, pull_first_flag_in2_out1_top, pull_first_flag_in2_out2_top;

    assign in1_route_flag = 0 ^ front_update_v_id_1[OMEGA_DEPTH - LEVEL_ID - 1];
    assign in2_route_flag = 1 ^ front_update_v_id_2[OMEGA_DEPTH - LEVEL_ID - 1];
    assign stage_full_1 = buffer_full_in1_out1 || buffer_full_in1_out2;
    assign stage_full_2 = buffer_full_in2_out1 || buffer_full_in2_out2;
    assign read_in1_out1 = !next_stage_full_1 && buffer_size_in1_out1 > buffer_size_in2_out1;
    assign read_in2_out1 = !next_stage_full_1 && !buffer_empty_in2_out1 && buffer_size_in2_out1 >= buffer_size_in1_out1;
    assign read_in1_out2 = !next_stage_full_2 && buffer_size_in1_out2 > buffer_size_in2_out2;
    assign read_in2_out2 = !next_stage_full_2 && !buffer_empty_in2_out2 && buffer_size_in2_out2 >= buffer_size_in1_out2;
    assign write_in1_out1 = front_update_v_valid_1 && !in1_route_flag;
    assign write_in1_out2 = front_update_v_valid_1 && in1_route_flag;
    assign write_in2_out1 = front_update_v_valid_2 && in2_route_flag;
    assign write_in2_out2 = front_update_v_valid_2 && !in2_route_flag;

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PUSH_FLAG_FIFO_FT_IN1_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag_1),
        .wr_en      (write_in1_out1),
        .rd_en      (read_in1_out1),
        .dout       (push_flag_in1_out1_top),
        .data_count (buffer_size_in1_out1),
        .prog_full(buffer_full_in1_out1),
        .full       (),
        .empty      (buffer_empty_in1_out1),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PUSH_FLAG_FIFO_FT_IN1_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag_1),
        .wr_en      (write_in1_out2),
        .rd_en      (read_in1_out2),
        .dout       (push_flag_in1_out2_top),
        .data_count (buffer_size_in1_out2),
        .prog_full(buffer_full_in1_out2),
        .full       (),
        .empty      (buffer_empty_in1_out2),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PUSH_FLAG_FIFO_FT_IN2_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag_2),
        .wr_en      (write_in2_out1),
        .rd_en      (read_in2_out1),
        .dout       (push_flag_in2_out1_top),
        .data_count (buffer_size_in2_out1),
        .prog_full(buffer_full_in2_out1),
        .full       (),
        .empty      (buffer_empty_in2_out1),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PUSH_FLAG_FIFO_FT_IN2_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_push_flag_2),
        .wr_en      (write_in2_out2),
        .rd_en      (read_in2_out2),
        .dout       (push_flag_in2_out2_top),
        .data_count (buffer_size_in2_out2),
        .prog_full(buffer_full_in2_out2),
        .full       (),
        .empty      (buffer_empty_in2_out2),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_ID_FIFO_FT_IN1_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_id_1),
        .wr_en      (write_in1_out1),
        .rd_en      (read_in1_out1),
        .dout       (v_id_in1_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_ID_FIFO_FT_IN1_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_id_1),
        .wr_en      (write_in1_out2),
        .rd_en      (read_in1_out2),
        .dout       (v_id_in1_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_ID_FIFO_FT_IN2_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_id_2),
        .wr_en      (write_in2_out1),
        .rd_en      (read_in2_out1),
        .dout       (v_id_in2_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_ID_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_ID_FIFO_FT_IN2_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_id_2),
        .wr_en      (write_in2_out2),
        .rd_en      (read_in2_out2),
        .dout       (v_id_in2_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_VALUE_FIFO_FT_IN1_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_value_1),
        .wr_en      (write_in1_out1),
        .rd_en      (read_in1_out1),
        .dout       (v_value_in1_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_VALUE_FIFO_FT_IN1_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_value_1),
        .wr_en      (write_in1_out2),
        .rd_en      (read_in1_out2),
        .dout       (v_value_in1_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_VALUE_FIFO_FT_IN2_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_value_2),
        .wr_en      (write_in2_out1),
        .rd_en      (read_in2_out1),
        .dout       (v_value_in2_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(V_VALUE_WIDTH), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) ACTIVE_V_VALUE_FIFO_FT_IN2_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_update_v_value_2),
        .wr_en      (write_in2_out2),
        .rd_en      (read_in2_out2),
        .dout       (v_value_in2_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PULL_FIRST_FLAG_FIFO_IN1_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_pull_first_flag_1),
        .wr_en      (write_in1_out1),
        .rd_en      (read_in1_out1),
        .dout       (pull_first_flag_in1_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PULL_FIRST_FLAG_FIFO_IN1_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_pull_first_flag_1),
        .wr_en      (write_in1_out2),
        .rd_en      (read_in1_out2),
        .dout       (pull_first_flag_in1_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PULL_FIRST_FLAG_FIFO_IN2_OUT1 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_pull_first_flag_2),
        .wr_en      (write_in2_out1),
        .rd_en      (read_in2_out1),
        .dout       (pull_first_flag_in2_out1_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    custom_fifo_ft #(.FIFO_DWIDTH(1), .FIFO_AWIDTH(OM_FIFO_SIZE_WIDTH)) PULL_FIRST_FLAG_FIFO_IN2_OUT2 (
        .clk        (clk),
        .srst       (rst),
        .din        (front_pull_first_flag_2),
        .wr_en      (write_in2_out2),
        .rd_en      (read_in2_out2),
        .dout       (pull_first_flag_in2_out2_top),
        .full       (),
        .empty      (),
        .valid      ()
    );

    always @ (posedge clk) begin
        if (rst || next_stage_full_1) begin
            push_flag_1 <= 0;
            update_v_id_1 <= 0;
            update_v_value_1 <= 0;
            update_v_valid_1 <= 0;
            pull_first_flag_1 <= 0;
        end else begin
            if (buffer_size_in1_out1 > buffer_size_in2_out1 && !buffer_empty_in1_out1) begin
                push_flag_1 <= push_flag_in1_out1_top;
                update_v_id_1 <= v_id_in1_out1_top;
                update_v_value_1 <= v_value_in1_out1_top;
                pull_first_flag_1 <= pull_first_flag_in1_out1_top;
                update_v_valid_1 <= 1;
            end else begin
                if (buffer_empty_in2_out1 || buffer_size_in1_out1 > buffer_size_in2_out1) begin
                    push_flag_1 <= 0;
                    update_v_id_1 <= 0;
                    update_v_value_1 <= 0;
                    update_v_valid_1 <= 0;
                    pull_first_flag_1 <= 0;
                end else begin
                    push_flag_1 <= push_flag_in2_out1_top;
                    update_v_id_1 <= v_id_in2_out1_top;
                    update_v_value_1 <= v_value_in2_out1_top;
                    pull_first_flag_1 <= pull_first_flag_in2_out1_top;
                    update_v_valid_1 <= 1;
                end
            end
        end
    end

    always @ (posedge clk) begin
        if (rst || next_stage_full_2) begin
            push_flag_2 <= 0;
            update_v_id_2 <= 0;
            update_v_value_2 <= 0;
            update_v_valid_2 <= 0;
            pull_first_flag_2 <= 0;
        end else begin
            if (buffer_size_in1_out2 > buffer_size_in2_out2 && !buffer_empty_in1_out2) begin
                push_flag_2 <= push_flag_in1_out2_top;
                update_v_id_2 <= v_id_in1_out2_top;
                update_v_value_2 <= v_value_in1_out2_top;
                pull_first_flag_2 <= pull_first_flag_in1_out2_top;
                update_v_valid_2 <= 1;
            end else begin
                if (buffer_empty_in2_out2 || buffer_size_in1_out2 > buffer_size_in2_out2) begin
                    push_flag_2 <= 0;
                    update_v_id_2 <= 0;
                    update_v_value_2 <= 0;
                    update_v_valid_2 <= 0;
                    pull_first_flag_2 <= 0;
                end else begin
                    push_flag_2 <= push_flag_in2_out2_top;
                    update_v_id_2 <= v_id_in2_out2_top;
                    update_v_value_2 <= v_value_in2_out2_top;
                    pull_first_flag_2 <= pull_first_flag_in2_out2_top;
                    update_v_valid_2 <= 1;
                end
            end
        end
    end
    
    always @ (posedge clk) begin
        if(!rst && front_iteration_end_1 && front_iteration_end_valid_1 && buffer_empty_in1_out1 && buffer_empty_in2_out1 && !buffer_size_in1_out1 && !buffer_size_in2_out1)begin
            iteration_end_1 <= 1;
            iteration_end_valid_1 <= 1;
        end
        else begin
            iteration_end_1 <= 0;
            iteration_end_valid_1 <= 0;
        end
        if(!rst && front_iteration_end_2 && front_iteration_end_valid_2 && buffer_empty_in1_out2 && buffer_empty_in2_out2 && !buffer_size_in1_out2 && !buffer_size_in2_out2)begin
            iteration_end_2 <= 1;
            iteration_end_valid_2 <= 1;
        end
        else begin
            iteration_end_2 <= 0;
            iteration_end_valid_2 <= 0;
        end
    end

endmodule